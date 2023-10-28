import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:encontrarCuidado/app/modules/feed/report.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'feed_store.dart';

class FeedCard extends StatefulWidget {
  final String doctorId;
  final String name;
  final String feedId;
  final String avatar;
  final String speciality;
  final String description;
  final String imageUrl;
  final String timeAgo;

  const FeedCard({
    Key key,
    this.name,
    this.speciality,
    this.description,
    this.imageUrl,
    this.avatar,
    this.timeAgo,
    this.feedId,
    this.doctorId,
  }) : super(key: key);

  @override
  _FeedCardState createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  final FeedStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  bool report = false, liked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Observer(
      builder: (context) {
        print(
            "store.feedMapReporting[widget.feedId]: ${store.feedMapReporting[widget.feedId]}");
        return store.feedMapReporting[widget.feedId] == false ||
                store.feedMapReporting[widget.feedId] == null
            ? StatefulBuilder(builder: (context, stateSet) {
                return Stack(
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        stateSet(() {
                          report = false;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: maxWidth * .04,
                            left: maxWidth * .05,
                            right: maxWidth * .05,
                            bottom: maxWidth * .02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10, left: 6),
                              child: Row(
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      store.viewDrProfile(widget.doctorId);
                                    },
                                    child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('doctors')
                                            .doc(widget.doctorId)
                                            .snapshots(),
                                        builder:
                                            (context, snapshotDoctorConnected) {
                                          if (snapshotDoctorConnected.hasData) {
                                            DocumentSnapshot doctorDoc =
                                                snapshotDoctorConnected.data;

                                            store.connected =
                                                doctorDoc['connected'] ||
                                                    doctorDoc[
                                                        'connected_secretary'];
                                          }

                                          return Row(
                                            children: [
                                              Stack(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: widget
                                                                .avatar ==
                                                            null
                                                        ? AssetImage(
                                                            'assets/img/defaultUser.png')
                                                        : NetworkImage(
                                                            widget.avatar),
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius: maxWidth * .06,
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 1,
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      height: 13,
                                                      width: 13,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: store.connected
                                                            ? Color(0xff00B5AA)
                                                            : Colors.red,
                                                        border: Border.all(
                                                          width: 2,
                                                          color:
                                                              Color(0xfffafafa),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: wXD(240, context),
                                                    child: Text(
                                                      widget.name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize:
                                                            maxWidth * .036,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff484D54),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        widget.speciality,
                                                        style: TextStyle(
                                                          fontSize:
                                                              maxWidth * .036,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Color(0xff484D54),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5),
                                                        height: 5,
                                                        width: 5,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color:
                                                              Color(0xff707070),
                                                        ),
                                                      ),
                                                      Text(
                                                        widget.timeAgo,
                                                        style: TextStyle(
                                                          fontSize:
                                                              maxWidth * .036,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Color(0xff787C81),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      stateSet(() {
                                        report = !report;
                                      });
                                    },
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        width: wXD(40, context),
                                        height: wXD(40, context),
                                        child: Icon(Icons.more_vert)),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height * .3,
                                width: MediaQuery.of(context).size.width * .9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(18),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: widget.imageUrl,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            'assets/img/defaultUser.png'),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('patients')
                                      .doc(store.authStore.user.uid)
                                      .collection('feed')
                                      .doc(widget.feedId)
                                      .snapshots(),
                                  builder: (context, snapshotFeedLiked) {
                                    if (snapshotFeedLiked.hasData) {
                                      DocumentSnapshot feedDoc =
                                          snapshotFeedLiked.data;

                                      liked = feedDoc['liked'];
                                    }
                                    return Row(
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            print(store.getLiking());
                                            if (!store.getLiking()) {
                                              await store.toLike(widget.feedId,
                                                  widget.doctorId);
                                            }
                                          },
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  liked
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: liked
                                                      ? Colors.red[900]
                                                      : Color(0xff484D54),
                                                ),
                                                SizedBox(
                                                  width: 9,
                                                ),
                                                Text(
                                                  'Curtir',
                                                  style: TextStyle(
                                                    fontSize: maxWidth * .036,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff484D54),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 11,
                                        ),
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            mainStore.feedRoute = true;
                                            if (await mainStore.getCards() ==
                                                false) {
                                              store.setCardDialog(true);
                                            } else {
                                              mainStore
                                                  .setDoctorId(widget.doctorId);
                                              await Modular.to.pushNamed(
                                                  '/schedule',
                                                  arguments: false);
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.event_note_outlined,
                                                color: Color(0xff484D54),
                                              ),
                                              SizedBox(
                                                width: 9,
                                              ),
                                              Text(
                                                'Agendar uma consulta',
                                                style: TextStyle(
                                                  fontSize: maxWidth * .036,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff484D54),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            ExpandableText(
                              widget.description,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: maxWidth * .035,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff484D54)),
                              prefixText: "${widget.name}: ",
                              prefixStyle: TextStyle(
                                fontSize: maxWidth * .036,
                                fontWeight: FontWeight.bold,
                              ),
                              expandText: 'mais',
                              collapseText: 'menos',
                              maxLines: 3,
                              linkEllipsis: false,
                              linkColor: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: report,
                      child: Positioned(
                        top: maxWidth * .08,
                        right: maxWidth * .1,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            store.reportingPost = true;

                            stateSet(() {
                              report = false;
                            });

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Report(
                                          feedId: widget.feedId,
                                        )));
                          },
                          child: Container(
                            height: maxWidth * .1,
                            width: maxWidth * .4,
                            decoration: BoxDecoration(
                              color: Color(0xfffafafa),
                              borderRadius: BorderRadius.all(
                                Radius.circular(13),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x29000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Reportar postagem',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: maxWidth * .035,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              })
            : Container(
                padding: EdgeInsets.only(
                  left: wXD(38, context),
                  top: 0,
                  bottom: 0,
                  right: wXD(38, context),
                ),
                color: Color(0xffEEEDED),
                height: wXD(131, context),
                width: maxWidth,
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(flex: 3),
                        Icon(
                          Icons.check_circle,
                          color: Color(0xff41C3B3),
                          size: wXD(30, context),
                        ),
                        Spacer(flex: 1),
                        Text(
                          'Agradecemos\no aviso',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff484D54),
                          ),
                        ),
                        Spacer(flex: 5),
                      ],
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(top: wXD(6, context)),
                      width: wXD(149, context),
                      child: ClipRRect(
                        child: Container(
                            width: maxWidth,
                            child: SvgPicture.asset(
                              'assets/svg/doctornoting.svg',
                              semanticsLabel: 'Acme Logo',
                              height: wXD(316, context),
                              width: wXD(149, context),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            )),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
