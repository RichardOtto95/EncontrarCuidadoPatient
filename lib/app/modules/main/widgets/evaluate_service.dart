import 'package:cached_network_image/cached_network_image.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

class EvaluateService extends StatefulWidget {
  final bool visible;

  const EvaluateService({
    Key key,
    this.visible = false,
  }) : super(key: key);
  @override
  _EvaluateServiceState createState() => _EvaluateServiceState();
}

class _EvaluateServiceState extends State<EvaluateService> {
  final MainStore mainStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    bool loadCircular = false;
    return Visibility(
      visible: widget.visible,
      child: Listener(
        onPointerDown: (_) {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      height: maxHeight(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: wXD(17, context),
                              top: wXD(10, context),
                              right: wXD(10, context),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/img/logo-icone.png',
                                  height: wXD(47, context),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    mainStore.popUpRating = false;

                                    // mainStore.answerRating(false);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: wXD(40, context),
                                    color: Color(0xff707070),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(flex: 1),
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: mainStore.doctorPhoto == null
                                    ? Image.asset(
                                        'assets/img/defaultUser.png',
                                        height: wXD(108, context),
                                        width: wXD(108, context),
                                        fit: BoxFit.cover,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: mainStore.doctorPhoto,
                                        width: wXD(108, context),
                                        height: wXD(108, context),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                      ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: wXD(42, context)),
                                // height: wXD(132, context),
                                // width: wXD(132, context),
                                // alignment: Alignment.bottomCenter,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(150),
                                  child: Container(
                                    height: wXD(132, context),
                                    width: wXD(132, context),
                                    // alignment: Alignment.bottomCenter,
                                    child: SingleChildScrollView(
                                      physics: NeverScrollableScrollPhysics(),
                                      child: Column(
                                        children: [
                                          SizedBox(height: wXD(12, context)),
                                          SvgPicture.asset(
                                            "./assets/svg/doctoravaliation.svg",
                                            semanticsLabel: 'Acme Logo',
                                            height: wXD(180, context),
                                            width: wXD(114, context),
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(flex: 1),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: wXD(20, context)),
                            width: maxWidth(context),
                            child: Text(
                              mainStore.doctorName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xff484D54),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Spacer(flex: 2),
                          Text(
                            'Avaliar a consulta',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xff707070).withOpacity(.9),
                              fontSize: wXD(18, context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(flex: 1),
                          RatingBar.builder(
                            itemSize: wXD(40, context),
                            initialRating: mainStore.valueRating,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              mainStore.valueRating = rating;
                            },
                          ),
                          Spacer(flex: 1),
                          Container(
                            width: wXD(334, context),
                            height: wXD(101, context),
                            padding: EdgeInsets.symmetric(
                              vertical: wXD(14, context),
                              horizontal: wXD(29, context),
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xfffafafa),
                              border: Border.all(color: Color(0xff707070)),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(7),
                                bottom: Radius.circular(7),
                              ),
                            ),
                            child: TextFormField(
                              maxLines: 4,
                              textCapitalization: TextCapitalization.sentences,
                              cursorColor: Color(0xff707070),
                              style: TextStyle(
                                  fontSize: wXD(17, context),
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xfa707070)),
                              decoration: InputDecoration.collapsed(
                                hintText:
                                    'Como foi o atendimento com o especialista?',
                                hintStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0x80707070)),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                mainStore.textRating = value;
                              },
                            ),
                          ),
                          Spacer(flex: 1),
                          StatefulBuilder(
                            builder: (context, stateSet) {
                              return InkWell(
                                onTap: () {
                                  stateSet(() {
                                    loadCircular = true;
                                  });
                                  mainStore.answerRating();
                                },
                                child: Container(
                                  width: wXD(197, context),
                                  height: wXD(47, context),
                                  alignment: Alignment.center,
                                  child: loadCircular
                                      ? CircularProgressIndicator()
                                      : Text(
                                          'Salvar',
                                          style: TextStyle(
                                              fontSize: wXD(17, context),
                                              color: Colors.white),
                                        ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(53)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xff41C3B3),
                                        Color(0xff21BCCE),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Spacer(flex: 3),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
