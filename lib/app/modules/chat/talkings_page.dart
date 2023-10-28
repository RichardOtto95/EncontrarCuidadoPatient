import 'package:encontrarCuidado/app/modules/sign/widgets/masktextinputformatter.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'chat_page.dart';

class TalkingsPage extends StatefulWidget {
  @override
  _TalkingsPageState createState() => _TalkingsPageState();
}

var maskFormatter = new MaskTextInputFormatter(
    mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

class _TalkingsPageState extends State<TalkingsPage> {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  bool isScrollingDown = false;
  bool _show = true;

  @override
  void initState() {
    super.initState();
    handleScroll();
  }

  void hideFloationButton() {
    setState(() {
      _show = false;
    });
  }

  void showFloationButton() {
    setState(() {
      _show = true;
    });
  }

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          hideFloationButton();
        }
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          showFloationButton();
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            focusNode.unfocus();
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EncontrarCuidadoNavBar(
                    leading: Row(
                      children: [
                        SizedBox(
                          width: wXD(15, context),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            size: maxWidth * 26 / 375,
                            color: Color(0xff707070),
                          ),
                        ),
                        SizedBox(
                          width: wXD(15, context),
                        ),
                        Text(
                          'Mensagens',
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: wXD(20, context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: wXD(5, context),
                      horizontal: wXD(16, context),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0x50707070),
                        ),
                      ),
                    ),
                    width: wXD(343, context),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: wXD(15, context)),
                          child: Icon(
                            Icons.search,
                            size: wXD(25, context),
                            color: Color(0xff707070).withOpacity(.6),
                          ),
                        ),
                        Container(
                          width: wXD(288, context),
                          child: TextField(
                            inputFormatters: [maskFormatter],
                            onChanged: (text) {
                              text = maskFormatter.getUnmaskedText();

                              print('Telefone: value: $text');
                            },
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              counterText: "",
                              labelText: 'Procurar mensagens',
                              labelStyle: TextStyle(
                                color: const Color(0xff707070).withOpacity(.6),
                                fontSize: wXD(16, context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: wXD(25, context), left: 25),
                    child: Text(
                      'Minhas conversas',
                      style: TextStyle(
                          color: Color(0xff41C3B3),
                          fontSize: wXD(19, context),
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          PerfilTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChatPage()));
                            },
                            name: 'Juliana Paula',
                            avatar:
                                "https://img.freepik.com/fotos-gratis/retrato-de-mulher-rindo_23-2148666462.jpg?size=338&ext=jpg",
                            time: 'Hoje',
                            description:
                                'Bom dia fulana, conseguiu rea lkauenfiuhaioushe...',
                            notifications: 4,
                            online: true,
                          ),
                          PerfilTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChatPage()));
                            },
                            name: 'Pablo Picasso',
                            avatar:
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOFWCsOJ7kpe0SdClJkcP4-lmAlpSIl1NHhw&usqp=CAU",
                            time: 'Ontem',
                            description: 'Perfeito, fico no aguardo dos..',
                            notifications: 3,
                            online: true,
                          ),
                          PerfilTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChatPage()));
                            },
                            name: 'Larissa Manoela',
                            avatar:
                                "https://cdn-istoe-ssl.akamaized.net/wp-content/uploads/sites/14/2019/01/larissa-manoela.jpg",
                            time: '3 dias',
                            description: 'Claro, se precisar estou aqui!',
                            online: true,
                          ),
                          PerfilTile(
                            name: 'Maria Fernandes',
                            avatar:
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJCQI8OMsqGF-VKc91HVafCrpueXFr7rsGZlYWcZtOPbgRQRi1lreCsQpaOMxJCDfE9u4&usqp=CAU",
                            time: '2 sem',
                            description: 'Sim, está confirmado para o...',
                            online: false,
                          ),
                          PerfilTile(
                            name: 'Cirilo Ferraz',
                            avatar:
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScFwRuKc43QWEq7mYAXC2ptxoqENKIVOW_qQ&usqp=CAU",
                            time: '15 de Jan',
                            description: 'Espero que tenha se sentido...',
                            online: false,
                          ),
                          PerfilTile(
                            name: 'Cirilo Ferraz',
                            avatar:
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScFwRuKc43QWEq7mYAXC2ptxoqENKIVOW_qQ&usqp=CAU",
                            time: '15 de Jan',
                            description: 'Espero que tenha se sentido...',
                            online: false,
                          ),
                          PerfilTile(
                            name: 'Cirilo Ferraz',
                            avatar:
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScFwRuKc43QWEq7mYAXC2ptxoqENKIVOW_qQ&usqp=CAU",
                            time: '15 de Jan',
                            description: 'Espero que tenha se sentido...',
                            online: false,
                          ),
                          PerfilTile(
                            name: 'Cirilo Ferraz',
                            avatar:
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScFwRuKc43QWEq7mYAXC2ptxoqENKIVOW_qQ&usqp=CAU",
                            time: '15 de Jan',
                            description: 'Espero que tenha se sentido...',
                            online: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PerfilTile extends StatelessWidget {
  final String name;
  final String text;
  final int notifications;
  final bool online;
  final String avatar;
  final String time;
  final String description;
  final Function onTap;

  const PerfilTile({
    Key key,
    this.name,
    this.text,
    this.notifications = 0,
    this.online = false,
    this.avatar,
    this.time,
    this.description,
    this.onTap,
  }) : super(key: key);

  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: maxWidth,
        padding: EdgeInsets.only(
          left: wXD(15, context),
          top: wXD(19, context),
          // right: wXD(19, context),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: wXD(5, context)),
                  child: CircleAvatar(
                    backgroundImage: avatar != null
                        ? NetworkImage(avatar)
                        : AssetImage('assets/img/defaultUser.png'),
                    backgroundColor: Colors.white,
                    radius: wXD(30, context),
                  ),
                ),
                online == false
                    ? Container()
                    : Positioned(
                        bottom: wXD(0, context),
                        right: wXD(2, context),
                        child: Container(
                          height: wXD(17.61, context),
                          width: wXD(17.61, context),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white, width: wXD(3, context)),
                            borderRadius: BorderRadius.circular(90),
                            color: Color(0xff41C3B3),
                          ),
                        ),
                      ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: wXD(12, context)),
              width: wXD(215, context),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name',
                    style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: wXD(16, context),
                        fontWeight: FontWeight.w900),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: wXD(3, context)),
                    child: Column(
                      children: [
                        Text(
                          '$description',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: wXD(15, context),
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: wXD(65, context),
                  alignment: Alignment.center,
                  child: Text(
                    '$time',
                    style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: wXD(13, context),
                        fontWeight: FontWeight.w400),
                  ),
                ),
                notifications == 0
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(top: wXD(3, context)),
                        height: wXD(18, context),
                        width: wXD(18, context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          color: Color(0xff41C3B3),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          child: Center(
                            child: Text(
                              '$notifications',
                              style: TextStyle(
                                  color: Color(0xffFAFAFA),
                                  fontSize: wXD(13, context),
                                  height: 1,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
