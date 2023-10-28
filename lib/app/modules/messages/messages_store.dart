import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_store.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
part 'messages_store.g.dart';

class MessagesStore = _MessagesStoreBase with _$MessagesStore;

abstract class _MessagesStoreBase with Store {
  final MainStore mainStore = Modular.get();
  final AuthStore authStore = Modular.get();

  _MessagesStoreBase() {
    if (mainStore.consultChat) {
      if (mainStore.hasChat == false) {
        chatId = null;
        chatTitle = mainStore.chatName;
      }
      if (mainStore.profileChat == null) {
        chatId = null;
      } else {
        chatTitle = mainStore.chatName;

        chatId = mainStore.profileChat.id;
      }
    }
  }

  @observable
  FilePickerResult result;
  @observable
  String chatId;
  @observable
  ObservableList userChats = [].asObservable();
  @observable
  Map doctor = {};
  @observable
  String text;
  @observable
  File file;
  @observable
  TextEditingController txtcontrol = TextEditingController();
  @observable
  TextEditingController srch = TextEditingController();
  @observable
  ItemScrollController chatScroll = ItemScrollController();
  @observable
  bool emojisShow = false;
  @observable
  ObservableList chat = [].asObservable();
  @observable
  String chatTitle = 'Chat';
  @observable
  bool uploadSpin = false;
  @observable
  bool downloadSpin = false;
  @observable
  String photo;
  @observable
  DocumentSnapshot chatDoc;
  @observable
  QuerySnapshot messagesDocs;
  @observable
  Directory appDir;
  @observable
  String localPath;
  @observable
  Future<Uint8List> bytes;
  @observable
  File fileBytes;
  @observable
  String fileName;
  @observable
  bool emptyChat = false;
  @observable
  ObservableList searchResult = [].asObservable();
  @observable
  Stream<QuerySnapshot> searchStream;
  @observable
  String userAvatar;
  @observable
  String drAvatar;
  @observable
  bool scrollJump = false;
  @observable
  QuerySnapshot searchedQuery;
  @observable
  String searchedText;
  @observable
  int searchPos;
  @observable
  String searchString;

  @action
  setJump(bool j) => scrollJump = j;
  @action
  setPos(int p) => searchPos = p;
  @action
  setDrAvatar(String a) => drAvatar = a;
  @action
  setEmojisShow(bool sh) => emojisShow = sh;
  @action
  setText(String tx) => text = tx;
  @action
  setEmptyChat(bool ec) => emptyChat = ec;
  @action
  setChatId(String id) => chatId = id;
  @action
  setUploadSpin(bool sh) => uploadSpin = sh;

  Future<void> getConsultChat() async {
    if (mainStore.hasChat == false) {
      chatId = null;
      chatTitle = mainStore.chatName;
    } else if (mainStore.profileChat == null) {
      chatId = null;
    } else if (mainStore.profileChat != null) {
      chatId = mainStore.profileChat.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getMessages(chatId, mainStore.chatName);
      });
      mainStore.hasChat = true;
      // mainStore.profileChat = null;
      // mainStore.chatName = null;
    }
    chatTitle = mainStore.chatName;
    mainStore.consultChat = true;
    await getChats();
  }

  @action
  onBackspacePressed() {
    txtcontrol
      ..text = txtcontrol.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: txtcontrol.text.length));
  }

  getDownloaded(String name) async {
    appDir = await getExternalStorageDirectory();
    localPath = '${appDir.path}/$name';
  }

  String getSearched(QuerySnapshot chats, String txt) {
    String result;

    for (var i = 0; i < chats.docs.length; i++) {
      if (chats.docs[i]
          .get('text')
          .toString()
          .toUpperCase()
          .contains(txt.toUpperCase())) {
        result = chats.docs[i].get('text');
      }
    }
    return result;
  }

  int getIndex(QuerySnapshot chats, String txt) {
    int result = 0;

    for (var i = 0; i < chats.docs.length; i++) {
      if (chats.docs[i]
          .get('text')
          .toString()
          .toUpperCase()
          .contains(txt.toUpperCase())) {
        result = i;
      }
    }
    return result;
  }

  search(String searchString) {
    mainStore.chatStream =
        FirebaseFirestore.instance.collection('chats').snapshots();
    if (searchString.length >= 1) {
      searchResult.clear();
      userChats.forEach((elementX) {
        String name =
            doctor[elementX['doctor_id']]['username'].toString().toUpperCase();

        if (name.contains(searchString)) {
          searchResult.add(elementX);
        }
        FirebaseFirestore.instance
            .collection('chats')
            .doc(elementX['id'])
            .collection('messages')
            .orderBy('created_at', descending: true)
            .get()
            .then((value) {
          value.docs.forEach((element2) {
            String text = element2.get('text').toString().toUpperCase();
            if (text.contains(searchString.toUpperCase())) {
              if (searchResult == null || !searchResult.contains(elementX)) {
                searchResult.add(elementX);
              }
            }
          });
        });
      });
    } else {}
  }

  @action
  handleNotifications(String chatId, bool increase) {
    if (chatId == null) {
    } else {
      int drnotf = 0;
      if (increase) {
        FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .get()
            .then((value) {
          if (value.get('dr_notifications') != null) {
            drnotf = value.get('dr_notifications') + 1;
          }

          value.reference.update({
            'dr_notifications': drnotf,
            'updated_at': FieldValue.serverTimestamp(),
          });
        });
      } else {
        FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .get()
            .then((value) {
          value.reference.update({
            'pt_notifications': 0,
          });
        });
      }
    }
  }

  @action
  downloadFiles(String url, String name, String chatId, String message) async {
    DocumentSnapshot messageDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message)
        .get();

    await messageDoc.reference.update({'pt_download': 'await'});

    HttpClient httpClient = new HttpClient();

    appDir = await getExternalStorageDirectory();
    localPath = '${appDir.path}/$name';

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();

      if (response.statusCode == 200) {
        bytes = consolidateHttpClientResponseBytes(response);
        file = File(localPath);

        bytes.then((value) {
          file.writeAsBytes(value);
        });
      } else {
        localPath = 'Error code: ' + response.statusCode.toString();
      }
    } catch (ex) {
      localPath = 'Can not fetch url';
    }

    await messageDoc.reference.update({'pt_download': 'true'});
  }

  uploadFiles() async {
    result = await FilePicker.platform.pickFiles(
        withData: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpeg', 'jpg']);
    DocumentSnapshot _chat =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
    if (result != null) {
      result.files.forEach((element) async {
        fileName = element.name;
        fileBytes = File(element.path);

        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('chat/$chatId/files/$fileName');

        UploadTask uploadTask = firebaseStorageRef.putFile(fileBytes);

        TaskSnapshot taskSnapshot = await uploadTask;

        taskSnapshot.ref.getDownloadURL().then((downloadURL) async {
          await FirebaseFirestore.instance
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .add({
            "author": authStore.user.uid,
            "file": element.name,
            "image": null,
            "text": null,
            "id": null,
            "pt_download": 'false',
            "dr_download": 'false',
            "data": downloadURL,
            "extension": element.extension,
            "created_at": FieldValue.serverTimestamp(),
          }).then((value) async {
            await value.update({'id': value.id});
          });
        });
        await _chat.reference.update({
          'updated_at': FieldValue.serverTimestamp(),
        });
      });
      DocumentSnapshot _patDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(_chat['patient_id'])
          .get();
      // FirebaseFunctions functions = FirebaseFunctions.instance;

      HttpsCallable messageNotification =
          FirebaseFunctions.instance.httpsCallable('messageNotification');
      String _drId = _chat['doctor_id'];
      String _text = '${_patDoc['username']}: [arquivo]';
      print('text $_text');
      print('drId $_drId');
      try {
        print('no try');
        messageNotification.call({
          'senderId': _patDoc.id,
          'text': _text,
          'receiverId': _drId,
          'receiverCollection': 'doctors',
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
      handleNotifications(chatId, true);
    }
  }

  @action
  getMessages(String id, String name) async {
    if (id != null) {
      chatTitle = name;
      chatDoc = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .get();

      messagesDocs = await chatDoc.reference.collection('messages').get();

      Stream<QuerySnapshot> msgs = FirebaseFirestore.instance
          .collection('chats')
          .doc(id)
          .collection('messages')
          .orderBy('created_at', descending: false)
          .snapshots();
      msgs.listen((event) {
        event.docs.forEach((element) {
          chat.add(element);
          // print('chat                                        ${element.data()}');
        });
      });
    }
  }

  @action
  pickImage(String chtId) async {
    if (await Permission.storage.request().isGranted) {
      setUploadSpin(true);

      File _imageFile;
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(
          source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);

      if (pickedFile != null) _imageFile = File(pickedFile.path);

      DocumentSnapshot _chat = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .get();

      if (_imageFile != null) {
        String now = DateFormat('yyyyMMdd_kkmm').format(DateTime.now());

        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('chat/$chtId/images/$now/${_imageFile.path[0]}');

        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);

        TaskSnapshot taskSnapshot = await uploadTask;

        taskSnapshot.ref.getDownloadURL().then((downloadURL) async {
          await _chat.reference.collection('messages').add({
            "author": authStore.user.uid,
            "image": '$now.jpeg',
            "data": downloadURL,
            "pt_download": 'false',
            "dr_download": 'false',
            "extension": null,
            "id": null,
            "text": null,
            "file": null,
            "created_at": FieldValue.serverTimestamp(),
          }).then((value) async {
            await value.update({'id': value.id});
          });
          await FirebaseFirestore.instance
              .collection('chats')
              .doc(chatId)
              .update({
            'updated_at': FieldValue.serverTimestamp(),
          });

          photo = downloadURL;
          setUploadSpin(false);
        });
        DocumentSnapshot _patDoc = await FirebaseFirestore.instance
            .collection('patients')
            .doc(_chat['patient_id'])
            .get();

        HttpsCallable messageNotification =
            FirebaseFunctions.instance.httpsCallable('messageNotification');
        String _drId = _chat['doctor_id'];
        String _text = '${_patDoc['username']}: [imagem]';
        print('text $_text');
        print('drId $_drId');
        try {
          print('no try');
          messageNotification.call({
            'senderId': _patDoc.id,
            'text': _text,
            'receiverId': _drId,
            'receiverCollection': 'doctors',
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
      } else {
        setUploadSpin(false);
      }
      handleNotifications(chatId, true);
    }
  }

  @action
  String messageTimer(Timestamp timer) {
    int now = Timestamp.now().millisecondsSinceEpoch;
    int sinceMillis = now - timer.millisecondsSinceEpoch;
    String time;

    if (sinceMillis <= 86400000) {
      time = 'Hoje';
    }

    if (sinceMillis >= 86400000 && sinceMillis <= 172800000) {
      time = 'Ontem';
    }
    if (sinceMillis > 172800000) {
      time = DateFormat('dd MMM', "pt_BR").format(timer.toDate());
    }
    return time;
  }

  @action
  getChats() {
    mainStore.chatStream = FirebaseFirestore.instance
        .collection('chats')
        .where('patient_id', isEqualTo: authStore.user.uid)
        .snapshots();
    print('KOOOOOOOOOOOO: ${mainStore.userSnap}');
    userAvatar = mainStore.userSnap.get('avatar');

    mainStore.chatStream.listen((event1) {
      userChats.clear();
      event1.docs.forEach((element) {
        if (!userChats.contains(element.id)) {
          userChats.add(element.data());
        }
        Stream<DocumentSnapshot> doctors = FirebaseFirestore.instance
            .collection('doctors')
            .doc(element.get('doctor_id'))
            .snapshots();

        doctors.listen((event3) {
          if (!doctor.keys.contains(event3.id)) {
            doctor.addAll({event3.id: event3.data()});
          }
        });
      });
    });
  }

  @action
  chatsDispose() async {
    if (mainStore.consultChat != true) {
      chat.clear();
      searchResult.clear();
      chatId = '';
      srch.clear();
      chatTitle = "Chat";
      searchStream = null;
      text = null;
      file = null;
      emojisShow = false;
      uploadSpin = false;
      photo = null;
    }
    await getChats();
  }

  @action
  sendMessage(String texto) async {
    if (chatId == null) {
      chatId = mainStore.profileChat.id;
    }

    DocumentSnapshot patDoc = await FirebaseFirestore.instance
        .collection('patients')
        .doc(authStore.user.uid)
        .get();

    DocumentSnapshot _chat =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();

    await _chat.reference.update({'updated_at': FieldValue.serverTimestamp()});

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      "author": authStore.user.uid,
      "text": texto,
      "pt_download": 'false',
      "dr_download": 'false',
      "extension": null,
      "data": null,
      "id": null,
      "file": null,
      "image": null,
      "created_at": FieldValue.serverTimestamp(),
    }).then((value) {
      value.update({'id': value.id});
    });

    handleNotifications(chatId, true);

    // FirebaseFunctions functions = FirebaseFunctions.instance;
    // functions.useFunctionsEmulator("localhost", 5001);
    HttpsCallable messageNotification =
        FirebaseFunctions.instance.httpsCallable('messageNotification');
    String _drId = _chat['doctor_id'];
    String _text = '${patDoc['username']}: $texto';
    print('text $_text');
    print('drId $_drId');
    try {
      print('no try');
      messageNotification.call({
        'senderId': authStore.user.uid,
        'text': _text,
        'receiverId': _drId,
        'receiverCollection': 'doctors',
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
    text = null;
  }

  @action
  startChat(String drID, String texto) async {
    DocumentSnapshot dr =
        await FirebaseFirestore.instance.collection('doctors').doc(drID).get();

    DocumentReference chat =
        await FirebaseFirestore.instance.collection('chats').add({
      'doctor_id': drID,
      'patient_id': authStore.user.uid,
      'pt_notifications': 0,
      'dr_notifications': 0,
      'updated_at': FieldValue.serverTimestamp(),
      'created_at': FieldValue.serverTimestamp(),
    });

    chatId = chat.id;
    await getMessages(chatId, dr.get('username'));
    await chat.update({'id': chatId});

    DocumentReference message = await chat.collection('messages').add({
      'text': texto,
      "pt_download": 'false',
      "dr_download": 'false',
      "extension": null,
      'image': null,
      "id": null,
      'file': null,
      "data": null,
      'author': authStore.user.uid,
      'created_at': FieldValue.serverTimestamp(),
    });

    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection("patients")
        .doc(authStore.user.uid)
        .get();
    HttpsCallable messageNotification =
        FirebaseFunctions.instance.httpsCallable('messageNotification');
    String _drId = drID;
    String _text = '${_user['username']}: $texto';
    print('text $_text');
    print('drId $_drId');

    try {
      print('no try');
      messageNotification.call({
        'senderId': authStore.user.uid,
        'text': _text,
        'receiverId': _drId,
        'receiverCollection': 'doctors',
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

    await message.update({'id': message.id});
    handleNotifications(chatId, true);
    await mainStore.hasChatWith(drID);
    ////////////// don't remove this print ///////////////
    print('${mainStore.profileChat.id}');
    ////////////// don't remove this print ///////////////
    mainStore.hasChat = true;
  }
}
