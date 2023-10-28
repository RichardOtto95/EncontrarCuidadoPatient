import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../search_store.dart';

class Suggestion extends StatelessWidget {
  final String speciality;
  final String location;
  final String state;
  final String drId;
  final String drName;
  final MainStore mainStore;

  const Suggestion({
    Key key,
    this.speciality = 'Clínica Geral',
    this.location,
    this.state,
    this.drId,
    this.drName,
    this.mainStore,
  }) : super(key: key);
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  @override
  Widget build(BuildContext context) {
    String _city = location;
    String _state = state;
    String _speciality = speciality;
    final SearchStore store = Modular.get();
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('doctors')
            .doc(drId)
            .snapshots(),
        builder: (context, snapshot) {
          String avatar;
          DocumentSnapshot dr;

          if (snapshot.hasData) {
            dr = snapshot.data;
            avatar = dr.get('avatar');
          }

          return InkWell(
              onTap: () {
                mainStore.setRouterSearch = true;
                store.viewDrProfile(drId);
              },
              child: Container(
                  margin: EdgeInsets.only(
                    bottom: wXD(20, context),
                    left: wXD(20, context),
                  ),
                  child: Row(
                    children: [
                      // !nullLoc
                      //     ?
                      ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: avatar == null
                              ? Image.asset('assets/img/defaultUser.png',
                                  height: wXD(35, context),
                                  width: wXD(35, context),
                                  fit: BoxFit.cover)
                              : CachedNetworkImage(
                                  imageUrl: avatar,
                                  width: wXD(35, context),
                                  height: wXD(35, context),
                                  fit: BoxFit.cover)),
                      //     :
                      // Container(
                      //   margin: EdgeInsets.only(
                      //     right: wXD(10, context),
                      //   ),
                      //   height: wXD(35, context),
                      //   width: wXD(35, context),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(90),
                      //     border: Border.all(
                      //       color: Color(0xfffafafa),
                      //     ),
                      //     gradient: LinearGradient(
                      //       begin: Alignment.topCenter,
                      //       end: Alignment.bottomCenter,
                      //       colors: [
                      //         Color(0xff41C3B3),
                      //         Color(0xff21BCCE),
                      //       ],
                      //     ),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         offset: Offset(0, 3),
                      //         blurRadius: 6,
                      //         color: Color(0x25000000),
                      //       ),
                      //     ],
                      //   ),
                      //   alignment: Alignment.center,
                      //   child: Icon(
                      //     Icons.person_outline_outlined,
                      //     color: Color(0xfffafafa),
                      //     size: wXD(30, context),
                      //   ),
                      // ),
                      _state == null || _city == null || _speciality == null
                          ? Center(
                              child: Container(
                                child: Text(
                                  ' $drName',
                                  style: TextStyle(
                                      color: Color(0xff707070),
                                      fontSize: wXD(15, context),
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' $drName',
                                  style: TextStyle(
                                      color: Color(0xff707070),
                                      fontSize: wXD(15, context),
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  width: maxWidth(context) - wXD(60, context),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      " $_speciality, $_city, $_state",
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Color(0xff707070),
                                          fontSize: wXD(13, context),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            )
                    ],
                  )));
        });
  }
}
