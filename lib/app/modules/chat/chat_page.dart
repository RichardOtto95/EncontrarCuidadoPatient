import 'package:encontrarCuidado/app/modules/messages/widgets/message_bar.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:flutter/material.dart';

import 'chat_store.dart';

class ChatPage extends StatefulWidget {
  final String title;
  const ChatPage({Key key, this.title = 'ChatPage'}) : super(key: key);
  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final ChatStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EncontrarCuidadoNavBar(
              leading: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: wXD(11, context), right: wXD(11, context)),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: wXD(26, context),
                        color: Color(0xff707070),
                      ),
                    ),
                  ),
                  Text(
                    'Chat',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: wXD(20, context),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                // dragStartBehavior: DragStartBehavior.down,
                reverse: true,
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LeftMessage(
                      avatar:
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
                      text:
                          '''Bom dia! Estou enviando essa mensagem apenas para confirmar a sua consulta, podemos confirmar?''',
                      hour: '07:50',
                    ),
                    RightMessage(
                      avatar:
                          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80',
                      text: 'Pode confirmar',
                      hour: '07:53',
                    ),
                    LeftMessage(
                      avatar:
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
                      text:
                          'Consulta confirmada com sucesso! agradecemos a preferência.',
                      hour: '07:55',
                    ),
                    SeparatorDay(
                      date: '20 de fevereiro de 2021',
                    ),
                    LeftMessage(
                      avatar:
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
                      text:
                          '''Bom dia! Estou enviando essa mensagem apenas para confirmar a sua consulta, podemos confirmar?''',
                      hour: '08:30',
                    ),
                    RightMessage(
                      avatar:
                          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80',
                      text: 'Ok, obrigada!',
                      hour: '10:15',
                    ),
                  ],
                ),
              ),
            ),
            MessageBar()
          ],
        ),
      ),
    );
  }
}

class RightMessage extends StatelessWidget {
  final String text;
  final String hour;
  final String avatar;

  const RightMessage({Key key, this.text, this.hour, this.avatar})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: wXD(16, context),
        left: wXD(44, context),
        right: wXD(16, context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            // height: wXD(77, context),
            // width: wXD(243, context),
            decoration: BoxDecoration(
              color: Color(0xff434B56),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: wXD(20, context),
                    top: wXD(15, context),
                    right: wXD(20, context),
                    bottom: wXD(8, context),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                        color: Color(0xfffafafa),
                        fontSize: wXD(14, context),
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(
                    right: wXD(17, context),
                    bottom: wXD(4, context),
                  ),
                  child: Text(
                    hour,
                    style: TextStyle(
                        color: Color(0xfffafafa),
                        fontSize: wXD(14, context),
                        fontWeight: FontWeight.w300),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: wXD(11, context),
          ),
          CircleAvatar(
            radius: wXD(30, context),
            backgroundImage: avatar == null || avatar == ''
                ? AssetImage('assets/img/defaultUser.png')
                : NetworkImage(avatar),
          ),
        ],
      ),
    );
  }
}

class LeftMessage extends StatelessWidget {
  final String text;
  final String hour;
  final String avatar;

  const LeftMessage({Key key, this.text, this.hour, this.avatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(
        bottom: wXD(16, context),
        left: wXD(16, context),
        right: wXD(44, context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: wXD(30, context),
            backgroundImage: avatar == null || avatar == ''
                ? AssetImage('assets/img/defaultUser.png')
                : NetworkImage(avatar),
          ),
          SizedBox(
            width: wXD(11, context),
          ),
          Container(
            // height: wXD(77, context),
            width: wXD(243, context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff41C3B3),
                  Color(0xff21BCCE),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: wXD(20, context),
                    top: wXD(15, context),
                    right: wXD(20, context),
                    bottom: wXD(13, context),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                        color: Color(0xfffafafa),
                        fontSize: wXD(14, context),
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(
                    right: wXD(17, context),
                    bottom: wXD(4, context),
                  ),
                  child: Text(
                    hour,
                    style: TextStyle(
                        color: Color(0xfffafafa),
                        fontSize: wXD(14, context),
                        fontWeight: FontWeight.w300),
                  ),
                )
              ],
            ),
          ),
        ],
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
