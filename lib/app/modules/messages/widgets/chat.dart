import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:encontrarCuidado/app/modules/drprofile/drprofile_page.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../message_bubble.dart';
import '../messages_store.dart';
import 'package:intl/intl.dart';
import 'message_bar.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  MessagesStore store = Modular.get();
  bool searchedPaint = false;

  @override
  void initState() {
    if (mainStore.consultChat) {
      store.getConsultChat();
    }
    super.initState();
  }

  @override
  void dispose() {
    store.handleNotifications(store.chatId, false);
    store.searchPos = null;
    super.dispose();
  }

  _onEmojiSelected(Emoji emoji) {
    store.txtcontrol
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: store.txtcontrol.text.length));
    store.setText(store.txtcontrol.text);
  }

  handleScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (store.scrollJump) {
        store.chatScroll.jumpTo(index: store.searchPos);
      }
      store.setJump(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        if (mainStore.consultChat == true) {
          mainStore.setSelectedTrunk(2);
          store.emojisShow = false;
          mainStore.profileChat = null;
          mainStore.hasChat = false;
        } else {
          store.mainStore.setSelectedTrunk(3);
          store.emojisShow = false;
          store.mainStore.hasChat = false;
        }
        Modular.to.pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: Observer(
            builder: (context) {
              return Column(
                children: [
                  EncontrarCuidadoNavBar(
                    leading: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: wXD(11, context), right: wXD(11, context)),
                          child: InkWell(
                              onTap: () {},
                              child: IconButton(
                                onPressed: () {
                                  if (store.mainStore.consultChat == true) {
                                    store.mainStore.setSelectedTrunk(2);
                                    store.emojisShow = false;
                                    store.mainStore.hasChat = false;
                                    store.mainStore.profileChat = null;
                                  } else {
                                    store.mainStore.setSelectedTrunk(3);
                                    store.emojisShow = false;
                                    store.mainStore.hasChat = false;
                                  }
                                  Modular.to.pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  size: wXD(26, context),
                                  color: Color(0xff707070),
                                ),
                              )),
                        ),
                        Text(
                          store.chatTitle == null ? 'Chat' : store.chatTitle,
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: wXD(20, context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  mainStore.consultChat && mainStore.hasChat == false
                      ? Expanded(child: Container())
                      : Expanded(
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(store.chatId)
                                  .collection('messages')
                                  .orderBy('created_at', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                QuerySnapshot messages = snapshot.data;
                                String id;

                                if ((snapshot.connectionState ==
                                            ConnectionState.waiting ||
                                        snapshot.hasError) ||
                                    !snapshot.hasData) {
                                  return Container();
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
                                  child: ScrollablePositionedList.builder(
                                      padding: EdgeInsets.only(
                                          top: wXD(10, context)),
                                      reverse: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: messages.docs.length,
                                      itemScrollController: store.chatScroll,
                                      itemBuilder: (context, index) {
                                        if (store.scrollJump == true) {
                                          handleScroll();
                                        }

                                        if (index == store.searchPos) {
                                          searchedPaint = true;
                                        }
                                        id = messages.docs[index].get('id');
                                        return MessageBubble(
                                          searched: index == store.searchPos
                                              ? searchedPaint
                                              : false,
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
                                              .get('pt_download'),
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
                                      }),
                                );
                              }),
                        ),
                  // Column(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children:
                  // [
                  //   LeftMessage(
                  //     text:
                  //         '''Bom dia! Estou enviando essa mensagem apenas para confirmar a sua consulta, podemos confirmar?''',
                  //     hour: '07:50',
                  //   ),
                  //   RightMessage(
                  //     text: 'Pode confirmar',
                  //     hour: '07:53',
                  //   ),
                  //   LeftMessage(
                  //     text:
                  //         'Consulta confirmada com sucesso! agradecemos a preferência.',
                  //     hour: '07:55',
                  //   ),
                  //   SeparatorDay(
                  //     date: '20 de fevereiro de 2021',
                  //   ),
                  //   LeftMessage(
                  //     text:
                  //         '''Bom dia! Estou enviando essa mensagem apenas para confirmar a sua consulta, podemos confirmar?''',
                  //     hour: '08:30',
                  //   ),
                  //   RightMessage(
                  //     text: 'Pode confirmar',
                  //     hour: '10:15',
                  //   ),
                  // ],

                  MessageBar(
                    focus: currentFocus,
                  ),
                  Visibility(
                    visible: store.emojisShow,
                    child: SizedBox(
                      height: 250,
                      child: EmojiPicker(
                          onEmojiSelected: (Category category, Emoji emoji) {
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
              );
            },
          ),
        ),
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
