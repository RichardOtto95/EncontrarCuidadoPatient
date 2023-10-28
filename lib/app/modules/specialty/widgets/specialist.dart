import 'package:cached_network_image/cached_network_image.dart';
import 'package:encontrarCuidado/app/modules/drprofile/drprofile_page.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../specialty_store.dart';

class Specialist extends StatefulWidget {
  final String name;
  final String id;
  final String hospital;
  final String speciality;
  final String avatar;
  final dynamic price;

  const Specialist({
    Key key,
    this.name,
    this.hospital,
    this.speciality,
    this.avatar = '',
    this.price,
    this.id,
  }) : super(key: key);

  @override
  _SpecialistState createState() => _SpecialistState();
}

class _SpecialistState extends ModularState<Specialist, SpecialtyStore> {
  bool show = false;
  final SpecialtyStore store = Modular.get();

  @override
  void initState() {
    store.getRatings(widget.id);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: wXD(10, context),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: wXD(20, context), vertical: wXD(9, context)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xff707070).withOpacity(.4),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  store.viewDrProfile(widget.id);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: widget.avatar == null
                      ? Image.asset(
                          'assets/img/defaultUser.png',
                          height: wXD(60, context),
                          width: wXD(60, context),
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.avatar,
                          width: wXD(60, context),
                          height: wXD(60, context),
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                ),
                // CircleAvatar(
                //   radius: wXD(30, context),
                //   backgroundImage: widget.avatar == null
                //       ? AssetImage('assets/img/defaultUser.png')
                //       : NetworkImage(widget.avatar),
                // ),
              ),
              Container(
                width: maxWidth(context) * .7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: wXD(330, context),
                      padding: EdgeInsets.only(
                        top: wXD(3, context),
                        left: wXD(5, context),
                      ),
                      child: Text(
                        widget.name.length >= 30
                            ? '${widget.name.substring(0, 30)}...'
                            : '${widget.name}',
                        style: TextStyle(
                          color: Color(0xff484D54),
                          fontSize: wXD(16, context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: wXD(8, context),
                        top: wXD(2, context),
                        bottom: wXD(2, context),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: wXD(80, context),
                            child: SelectableText(
                              '${widget.speciality}',
                              maxLines: 1,
                              scrollPhysics: ScrollPhysics(),
                              style: TextStyle(
                                color: Color(0xff484D54),
                                fontSize: wXD(14, context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: wXD(5, context),
                              right: wXD(5, context),
                              bottom: wXD(3.5, context),
                            ),
                            height: wXD(6, context),
                            width: wXD(6, context),
                            decoration: BoxDecoration(
                                color: Color(0xff484D54),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                          ),
                          Container(
                            width: wXD(150, context),
                            child: SelectableText(
                              '${widget.hospital}',
                              scrollPhysics: ScrollPhysics(),
                              maxLines: 1,
                              style: TextStyle(
                                color: Color(0xff484D54),
                                fontSize: wXD(14, context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Observer(builder: (context) {
                      List listRatings = store.mapRatings[widget.id];

                      String lengthRatings = listRatings != null
                          ? listRatings.last.toString()
                          : '0.0';

                      String stars = listRatings != null
                          ? listRatings.first.toString()
                          : '0';

                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.star_rate_rounded,
                              color: Color(0xffFBBD08),
                              size: wXD(20, context),
                            ),
                            Text(
                              lengthRatings,
                              style: TextStyle(
                                  color: Color(0xff2185D0),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '  $stars opiniões',
                              style: TextStyle(
                                color: Color(0xff787C81),
                                fontSize: wXD(14, context),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(top: wXD(10, context)),
                height: wXD(42, context),
                width: wXD(85, context),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff41C3B3), width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff41C3B3),
                          Color(0xff21BCCE),
                        ])),
                alignment: Alignment.center,
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () async {
                    if (await mainStore.getCards() == false) {
                      store.setCardDialog(true);
                    } else {
                      mainStore.setDoctorId(widget.id);
                      await Modular.to.pushNamed('/schedule', arguments: false);
                    }
                  },
                  child: Text(
                    'Agendar',
                    style: TextStyle(
                      color: Color(0xfffafafa),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    show = !show;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: wXD(10, context),
                    left: wXD(18, context),
                    right: wXD(3, context),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: wXD(6, context)),
                  height: wXD(42, context),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff41C3B3), width: 2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            show == false
                                ? Color(0xff41C3B3)
                                : Colors.transparent,
                            show == false
                                ? Color(0xff21BCCE)
                                : Colors.transparent,
                          ])),
                  alignment: Alignment.center,
                  child: Text(
                      show == false
                          ? 'Preço'
                          : formatedCurrency(widget.price == null
                              ? widget.price
                              : widget.price.toDouble()),
                      style: TextStyle(
                        color: show == false
                            ? Color(0xfffafafa)
                            : Color(0xff787C81),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
