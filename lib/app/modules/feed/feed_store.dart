import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:encontrarCuidado/app/core/models/doctor_model.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'feed_store.g.dart';

class FeedStore = _FeedStoreBase with _$FeedStore;

abstract class _FeedStoreBase with Store {
  final AuthStore authStore = Modular.get();

  @observable
  ObservableList feedList;
  @observable
  List feedListComplete = [];
  @observable
  ObservableMap feedMapReporting = ObservableMap();
  @observable
  bool hasNext = false;
  @observable
  int feedLimit = 10, maxDocs = 0;
  @observable
  bool setCards = false, addPosts = false, reportingPost = false;
  @observable
  bool loadCircularDialogCard = false;
  @observable
  bool connected = false;
  @observable
  bool liking = false;

  @action
  bool getLiking() => liking;
  @action
  setCardDialog(bool c) => setCards = c;

  Future<void> setLoadCircular(bool c) async {
    loadCircularDialogCard = c;
  }

  @action
  viewDrProfile(String doctorId) async {
    if (authStore.user.uid != doctorId) {
      DocumentSnapshot doctor = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .get();

      DoctorModel doctorModel = DoctorModel.fromDocument(doctor);

      Modular.to.pushNamed('/drprofile', arguments: doctorModel);
    }
  }

  reportPost(String stringReport, String feedId) async {
    // print('xxxxxxxx reportPost xxxxxxxxxxxx');

    QuerySnapshot userPost = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .collection('feed')
        .where('id', isEqualTo: feedId)
        .get();

    await userPost.docs.first.reference.update(
        {'status': 'REPORTED', 'report': 'reported for being $stringReport'});

    DocumentSnapshot postDocument =
        await FirebaseFirestore.instance.collection('posts').doc(feedId).get();

    await postDocument.reference.update({
      'status': 'REPORTED',
      'report': 'reported for being $stringReport',
      'reported_at': FieldValue.serverTimestamp(),
      'user_id': authStore.user.uid,
    });
  }

  void reportingToReported(String stringReport, String feedId, context) async {
    // print('xxxxxxxx reportingToReported $feedId xxxxxxxxxxxx');
    feedMapReporting[feedId] = true;
    // reportingPost = true;

    Timer(
      Duration(seconds: 3),
      () async {
        // print('xxxxxxxx timer xxxxxxxxxxxx');

        for (var i = 0; i < feedList.length; i++) {
          var feed = feedList[i];
          // print('xxxxxxxx for ${feed['id']} xxxxxxxxxxxx');

          if (feed['id'] == feedId) {
            reportingPost = false;
            await feedList.removeAt(i);
            await reportPost(stringReport, feedId);
            await feedMapReporting.remove(feedId);

            // print('xxxxxxxx break xxxxxxxxxxxx');

            break;
          }
        }
      },
    );

    String getReport(String _report) {
      String portReport = '';
      switch (_report) {
        case 'offensive':
          portReport = 'é ofensiva';
          break;
        case 'spam':
          portReport = 'é um spam';
          break;
        case 'sexually inappropriate':
          portReport = 'contém conteúdo sexual inapropriado';
          break;
        case 'a scheme':
          portReport = 'é um golpe ou enganosa';
          break;
        case 'violent or forbidden':
          portReport = 'possui conteúdo violento ou proíbido';
          break;
        default:
          portReport = 'Report error';
      }
      return portReport;
    }

    // FirebaseFunctions functions = FirebaseFunctions.instance;
    DocumentSnapshot patient = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .get();
    DocumentSnapshot postDocument =
        await FirebaseFirestore.instance.collection('posts').doc(feedId).get();

    HttpsCallable notifyUser =
        FirebaseFunctions.instance.httpsCallable('notifyUser');
    String _drId = postDocument['dr_id'];
    String _text =
        'O paciente ${patient['username']} reportou sua publicação dizendo que esta ${getReport(stringReport)}!';
    // print('text $_text');
    // print('drId $_drId');

    try {
      print('no try');
      notifyUser.call({
        'text': _text,
        'receiverId': _drId,
        'senderId': patient.id,
        'collection': 'doctors',
      });
      print('Notificação enviada');
    } on FirebaseFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e);
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }

    // feedIdReport = null;
    Modular.to.pop();
  }

  @action
  String getTime(Timestamp time) {
    String since;

    if (time != null) {
      DateTime dateTimeNow = DateTime.now();
      DateTime dateTimePost = time.toDate();

      int differenceDays = dateTimeNow.difference(dateTimePost).inDays;
      int differenceHours = dateTimeNow.difference(dateTimePost).inHours;
      int differenceMinutes = dateTimeNow.difference(dateTimePost).inMinutes;

      if (differenceDays > 0) {
        if (differenceDays == 1) {
          since = 'ontem';
        } else {
          since = dateTimePost.day.toString().padLeft(2, '0') +
              '/' +
              dateTimePost.month.toString().padLeft(2, '0');
        }
      } else if (differenceHours > 0) {
        if (differenceHours == 1) {
          since = '1 hora';
        } else {
          since = '$differenceHours horas';
        }
      } else if (differenceMinutes > 4) {
        since = '$differenceMinutes minutos';
      } else {
        since = 'agora';
      }
    } else {
      since = 'agora';
    }
    return since;
  }

  @action
  toLike(String feedId, String doctorId) async {
    liking = true;
    DocumentSnapshot postDoc =
        await FirebaseFirestore.instance.collection('posts').doc(feedId).get();

    DocumentSnapshot patientFeedDoc = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .collection('feed')
        .doc(feedId)
        .get();

    DocumentSnapshot drFeedDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .collection('feed')
        .doc(feedId)
        .get();

    int likes = postDoc['like_count'];

    bool liked = patientFeedDoc['liked'];

    if (liked) {
      await patientFeedDoc.reference
          .update({'liked': false, 'like_count': likes - 1});
      await drFeedDoc.reference.update({'like_count': likes - 1});
      await postDoc.reference.update({'like_count': likes - 1});
    } else {
      await patientFeedDoc.reference
          .update({'liked': true, 'like_count': likes + 1});
      await drFeedDoc.reference.update({'like_count': likes + 1});
      await postDoc.reference.update({'like_count': likes + 1});
    }
    liking = false;
  }

  void getHasNext() async {
    QuerySnapshot feedsQuery = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .collection('feed')
        .where('status', isEqualTo: 'VISIBLE')
        .get();

    maxDocs = feedsQuery.docs.length;

    // print('xxxxxxxxxxxxxxxx getHasNext $maxDocs $feedLimit xxxxxxxxxxxxxx');

    hasNext = maxDocs > feedLimit;
  }

  void getMoreFeed({int seconds}) {
    Timer(Duration(seconds: seconds), () {
      feedLimit += 10;
      getLimit();
      getHasNext();
    });
  }

  void clearFeed() {
    if (feedList != null) {
      feedList.clear();
    }
    feedMapReporting.clear();
  }

  void getLimit() {
    // print('xxxxxxxx getLimit xxxxxxxxxxxx');

    addPosts = true;
    if (feedListComplete.isNotEmpty) {
      for (var i = 0; i < feedLimit; i++) {
        if (i < feedListComplete.length) {
          DocumentSnapshot feedDoc = feedListComplete[i];

          if (feedList == null) {
            feedList = [].asObservable();
          }

          // print('xxxxxxxxx feedId ${feedDoc['id']} xxxxxxxxxxx');

          if (!feedMapReporting.containsKey(feedDoc['id'])) {
            feedList.add(feedDoc);
            feedMapReporting.putIfAbsent(feedDoc['id'], () => false);
          }
        }
      }
    } else {
      feedList = [].asObservable();
    }
  }

  void getFeed(QuerySnapshot feedQuery) {
    // print(
    //     'xxxxxxxx getFeed $addPosts $reportingPost ${feedQuery.docs.length} xxxxxxxxxxxx');

    feedListComplete = feedQuery.docs.toList();
    if ((!addPosts || feedListComplete.length < 4) && !reportingPost) {
      clearFeed();
      getLimit();
    }
  }
}
