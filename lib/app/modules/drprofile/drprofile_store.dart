import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_store.dart';
import 'package:encontrarCuidado/app/modules/feed/feed_store.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'drprofile_store.g.dart';

class DrProfileStore = _DrprofileStoreBase with _$DrProfileStore;

abstract class _DrprofileStoreBase with Store {
  final MainStore mainStore = Modular.get();
  final AuthStore authStore = Modular.get();
  final FeedStore feedStore = Modular.get();

  @observable
  int index = 0;
  @observable
  String ratingsAverage = '0.0';
  @observable
  int ratingsLength = 0;
  @observable
  bool moreReviews = true;
  @observable
  int limit = 5;
  @observable
  int maxDocs = 0;
  @observable
  bool setCards = false;
  @observable
  ObservableMap mapReport = ObservableMap();

  @action
  setCardDialog(bool c) => setCards = c;

  @action
  toLike(String feedId, String doctorId) async {
    DocumentSnapshot feed =
        await FirebaseFirestore.instance.collection('posts').doc(feedId).get();

    QuerySnapshot doctorFeedQuery = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .collection('feed')
        .where('id', isEqualTo: feedId)
        .get();

    QuerySnapshot patientFeedQuery = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .collection('feed')
        .where('id', isEqualTo: feedId)
        .get();

    DocumentSnapshot doctorDocFeed = doctorFeedQuery.docs.first;

    DocumentSnapshot patientDocFeed = patientFeedQuery.docs.first;

    int likes = feed['like_count'];

    bool liked = patientDocFeed['liked'];

    if (liked) {
      await patientDocFeed.reference
          .update({'liked': false, 'like_count': likes - 1});
      await doctorDocFeed.reference.update({'like_count': likes - 1});
      await feed.reference.update({'like_count': likes - 1});
    } else {
      await patientDocFeed.reference
          .update({'liked': true, 'like_count': likes + 1});
      await doctorDocFeed.reference.update({'like_count': likes + 1});
      await feed.reference.update({'like_count': likes + 1});
    }
  }

  @action
  reportPost(String report, String postId) async {
    Modular.to.pop();
    mapReport[postId] = true;

    Timer(Duration(seconds: 3), () {
      print(
          'xxxxxxxxxxxxx timer ${feedStore.feedList.length} $postId xxxxxxxxxx');

      for (var i = 0; i < feedStore.feedList.length; i++) {
        var feed = feedStore.feedList[i];
        print('xxxxxxxxxxxxx for ${feed['id']} $i xxxxxxxxxx');

        if (feed['id'] == postId) {
          feedStore.feedList.removeAt(i);
          break;
        }
      }

      FirebaseFirestore.instance
          .collection('patients')
          .doc(mainStore.authStore.user.uid)
          .collection('feed')
          .where('id', isEqualTo: postId)
          .get()
          .then((feed) {
        feed.docs.first.reference.update(
            {'status': 'REPORTED', 'report': 'reported for being $report'});
      });

      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get()
          .then((value2) {
        value2.reference.collection('reports').add({
          'status': 'REPORTED',
          'id': postId,
          'reported_at': FieldValue.serverTimestamp(),
          'report': 'reported for being $report',
          'user_id': mainStore.authStore.user.uid,
        });
      });
    });
  }

  @action
  getMoreOpinion() async {
    limit += 5;

    if (limit >= maxDocs) {
      moreReviews = false;
    }
  }

  @action
  String converterDateToString(Timestamp date) {
    return date.toDate().day.toString().padLeft(2, '0') +
        '/' +
        date.toDate().month.toString().padLeft(2, '0') +
        '/' +
        date.toDate().year.toString();
  }

  @action
  Future<List> getOpinions({int index, String doctorId}) async {
    List newList = [];

    DocumentSnapshot _doctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();

    switch (index) {
      case 0:
        QuerySnapshot ratings = await _doctor.reference
            .collection('ratings')
            .limit(limit)
            .orderBy('created_at', descending: true)
            .get();

        ratings.docs.forEach((element) {
          if (element['status'] != 'INACTIVE') {
            newList.add(element);
          }
        });

        maxDocs = ratings.docs.length;
        moreReviews = limit == maxDocs;

        return newList;
        break;

      case 1:
        QuerySnapshot ratings = await _doctor.reference
            .collection('ratings')
            .where('avaliation', isGreaterThan: 3.0)
            .limit(limit)
            .get();

        ratings.docs.forEach((element) {
          if (element['status'] != 'INACTIVE') {
            newList.add(element);
          }
        });

        newList.sort((a, b) {
          return b['created_at'].compareTo(a['created_at']);
        });

        maxDocs = newList.length;
        moreReviews = limit == maxDocs;

        return newList;
        break;

      case 2:
        QuerySnapshot ratings = await _doctor.reference
            .collection('ratings')
            .where('avaliation', isEqualTo: 3.0)
            .limit(limit)
            .get();

        ratings.docs.forEach((element) {
          if (element['status'] != 'INACTIVE') {
            newList.add(element);
          }
        });

        newList.sort((a, b) {
          return b['created_at'].compareTo(a['created_at']);
        });

        maxDocs = newList.length;
        moreReviews = limit == maxDocs;

        return newList;
        break;

      case 3:
        QuerySnapshot ratings = await _doctor.reference
            .collection('ratings')
            .where('avaliation', isLessThan: 3.0)
            .limit(limit)
            .get();

        ratings.docs.forEach((element) {
          if (element['status'] != 'INACTIVE') {
            newList.add(element);
          }
        });

        newList.sort((a, b) {
          return b['created_at'].compareTo(a['created_at']);
        });

        maxDocs = newList.length;
        moreReviews = limit == maxDocs;

        return newList;
        break;

      default:
        return null;
        break;
    }
  }

  @action
  getRatings(String doctorId) async {
    QuerySnapshot ratings = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .collection('ratings')
        .where('status', isNotEqualTo: 'INACTIVE')
        .get();

    if (ratings.docs.isNotEmpty) {
      double average = 0.0;
      ratingsLength = ratings.docs.length;
      ratings.docs.forEach((rating) {
        average += rating['avaliation'];
      });

      average = average / ratings.docs.length;

      ratingsAverage = average.toStringAsFixed(1);
    }
  }

  @action
  String getTime(Timestamp time) {
    String since;

    if (time != null) {
      DateTime dateTimeNow = DateTime.now();
      DateTime dateTimePost = time.toDate();

      print(
          'xxxxxxxxxxxx now $dateTimeNow -- timePost $dateTimePost xxxxxxxxxxxx');

      int differenceDays = dateTimeNow.difference(dateTimePost).inDays;

      int differenceHours = dateTimeNow.difference(dateTimePost).inHours;

      int differenceMinutes = dateTimeNow.difference(dateTimePost).inMinutes;

      print('xxxxxxxxxxxxxxx diferenceDays $differenceDays xxxxxxxxxxxxxx');
      print('xxxxxxxxxxxxxxx differenceHours $differenceHours xxxxxxxxxxxxxx');
      print(
          'xxxxxxxxxxxxxxx differenceMinutes $differenceMinutes xxxxxxxxxxxxxx');

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

    print('xxxxxxxxxxxx getTime $since xxxxxxxxxxxxx');
    return since;
  }
}
