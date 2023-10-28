import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/modules/suport/suport_store.dart';
import 'package:encontrarCuidado/app/modules/suport/widgets/message_bubble.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'widgets/message_bar.dart';

class SuportPage extends StatefulWidget {
  @override
  _SuportPageState createState() => _SuportPageState();
}

class _SuportPageState extends State<SuportPage> {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  final SuportStore store = Modular.get();
  final MainStore mainStore = Modular.get();

  @override
  void initState() {
    // store.getSuportChat(mainStore.supportId);
    super.initState();
  }

  _onEmojiSelected(Emoji emoji) {
    store.txtcontrol
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: store.txtcontrol.text.length));
    store.setText(store.txtcontrol.text);
  }

  @override
  void dispose() {
    store.supportDispose();
    store.supNotifications(mainStore.supportId, false);
    // mainStore.setSupportId('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    // if (1 == 1) {
    return WillPopScope(
      onWillPop: () async {
        print("pop pop pop pop");
        store.clearSupportNotifications();
        // Modular.to.pop();
        return true;
      },
      child: Scaffold(
        body: SafeArea(child: Observer(
          builder: (context) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: wXD(70, context),
                  child: SvgPicture.asset(
                    "./assets/svg/chatcomunication.svg",
                    semanticsLabel: 'Acme Logo',
                    height: wXD(196, context),
                    width: wXD(292, context),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                mainStore.supportId != null && mainStore.supportId != ''
                    ? Container(
                        height: maxHeight(context),
                        width: maxWidth(context),
                        alignment: Alignment.topCenter,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('support')
                              .doc(mainStore.supportId)
                              .collection('messages')
                              .orderBy('created_at', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            QuerySnapshot messages = snapshot.data;
                            String id;

                            if (!snapshot.hasData) {
                              return Container();
                            }
                            if (snapshot.hasData) {
                              messages = snapshot.data;
                            }

                            return GestureDetector(
                              onTap: () {
                                if (store.emojisShow == true) {
                                  store.setEmojisShow(false);
                                }
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
                              child: SingleChildScrollView(
                                dragStartBehavior: DragStartBehavior.down,
                                reverse: true,
                                child: Column(
                                  verticalDirection: VerticalDirection.up,
                                  children: [
                                    SizedBox(height: wXD(70, context)),
                                    ...List.generate(
                                      messages.docs.length,
                                      (index) {
                                        id = messages.docs[index].get('id');
                                        return MessageBubble(
                                          store: store,
                                          author: messages.docs[index]
                                              .get('author'),
                                          text: messages.docs[index]
                                                      .get('text') !=
                                                  null
                                              ? messages.docs[index].get('text')
                                              : null,
                                          isImage: messages.docs[index]
                                                      .get('image') !=
                                                  null
                                              ? messages.docs[index]
                                                  .get('image')
                                              : null,
                                          downloaded: messages.docs[index]
                                              .get('user_download'),
                                          message: id,
                                          fileName: messages.docs[index]
                                                      .get('file') !=
                                                  null
                                              ? messages.docs[index].get('file')
                                              : null,
                                          fileLink: messages.docs[index]
                                                      .get('data') !=
                                                  null
                                              ? messages.docs[index].get('data')
                                              : null,
                                          usAvatar: mainStore.userSnap
                                                      .get('avatar') ==
                                                  null
                                              ? null
                                              : mainStore.userSnap
                                                  .get('avatar'),
                                          spAvatar: mainStore.info.docs.isEmpty
                                              ? null
                                              : mainStore.info.docs.first
                                                  .get('support_avatar'),
                                          extension: messages.docs[index]
                                                      .get('extension') !=
                                                  null
                                              ? messages.docs[index]
                                                  .get('extension')
                                                  .toString()
                                                  .toLowerCase()
                                              : null,
                                          hour: messages.docs[index]
                                                      .get('created_at') ==
                                                  null
                                              ? ''
                                              : DateFormat('kk:mm').format(
                                                  messages.docs[index]
                                                      .get('created_at')
                                                      .toDate()),
                                        );
                                      },
                                    ),
                                    SizedBox(height: wXD(80, context)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        height: maxHeight(context),
                        width: maxWidth(context),
                      ),
                Positioned(
                  top: 0,
                  child: Container(
                    width: maxWidth(context),
                    height: wXD(70, context),
                    decoration: BoxDecoration(
                      color: Color(0xfffafafa),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: wXD(7, context)),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: wXD(11, context),
                                    right: wXD(11, context)),
                                child: InkWell(
                                  onTap: () => Modular.to.pop(),
                                  child: Icon(
                                    Icons.arrow_back_ios_outlined,
                                    size: wXD(26, context),
                                    color: Color(0xff707070),
                                  ),
                                ),
                              ),
                              Text(
                                'Suporte',
                                style: TextStyle(
                                    color: Color(0xff707070),
                                    fontSize: wXD(20, context),
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      MessageBar(focus: currentFocus),
                      Visibility(
                        visible: store.emojisShow,
                        child: SizedBox(
                          height: wXD(250, context),
                          width: maxWidth(context),
                          child: EmojiPicker(
                              onEmojiSelected:
                                  (Category category, Emoji emoji) {
                                _onEmojiSelected(emoji);
                              },
                              onBackspacePressed: store.onBackspacePressed,
                              config: const Config(
                                  columns: 7,
                                  emojiSizeMax: 32.0,
                                  verticalSpacing: 0,
                                  horizontalSpacing: 0,
                                  initCategory: Category.RECENT,
                                  bgColor: Color(0xFFF2F2F2),
                                  indicatorColor: Colors.blue,
                                  iconColor: Colors.grey,
                                  iconColorSelected: Colors.blue,
                                  progressIndicatorColor: Colors.blue,
                                  backspaceColor: Colors.blue,
                                  showRecentsTab: true,
                                  recentsLimit: 28,
                                  noRecentsText: 'No Recents',
                                  noRecentsStyle: TextStyle(
                                      fontSize: 20, color: Colors.black26),
                                  categoryIcons: CategoryIcons(),
                                  buttonMode: ButtonMode.MATERIAL)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        )),
      ),
    );
  }
}

class SeparatorDay extends StatelessWidget {
  final String date;

  const SeparatorDay({Key key, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: wXD(15, context)),
      child: Row(
        children: [
          Container(
            height: wXD(1, context),
            width: wXD(100, context),
            color: Color(0xff787C81),
          ),
          Spacer(),
          Text(
            '$date',
            style: TextStyle(
              color: Color(0xff787C81),
            ),
          ),
          Spacer(),
          Container(
            height: wXD(1, context),
            width: wXD(100, context),
            color: Color(0xff787C81),
          ),
        ],
      ),
    );
  }
}
