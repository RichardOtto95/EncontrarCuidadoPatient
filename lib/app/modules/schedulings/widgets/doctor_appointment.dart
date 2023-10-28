import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class DoctorAppointment extends StatelessWidget {
  final String doctorId;
  final Function onTap;

  const DoctorAppointment({
    Key key,
    this.onTap,
    this.doctorId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          bottom: wXD(15, context),
          right: wXD(15, context),
          left: wXD(15, context),
        ),
        padding: EdgeInsets.symmetric(vertical: wXD(10, context)),
        height: wXD(122, context),
        width: wXD(306, context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(3, 3),
              color: Color(0x30000000),
            ),
          ],
          color: Color(0xfffafafa),
        ),
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('doctors')
                .doc(doctorId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              }
              DocumentSnapshot docDoctor = snapshot.data;
              return Container(
                margin: EdgeInsets.only(
                  top: wXD(7, context),
                ),
                width: wXD(300, context),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: wXD(7, context),
                    ),
                    CircleAvatar(
                      radius: wXD(30, context),
                      backgroundImage: docDoctor['avatar'] == null ||
                              docDoctor['avatar'] == ''
                          ? AssetImage('assets/img/defaultUser.png')
                          : NetworkImage(docDoctor['avatar']),
                    ),
                    SizedBox(
                      width: wXD(8, context),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: wXD(220, context),
                          padding: EdgeInsets.only(
                            top: wXD(2, context),
                            bottom: wXD(3, context),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              docDoctor['fullname'] != null
                                  ? docDoctor['fullname']
                                  : docDoctor['username'],
                              style: TextStyle(
                                color: Color(0xff484D54),
                                fontWeight: FontWeight.w900,
                                fontSize: wXD(15, context),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          docDoctor['speciality_name'] != null
                              ? docDoctor['speciality_name']
                              : 'Vazio',
                          style: TextStyle(
                            color: Color(0xff484D54),
                            fontWeight: FontWeight.w400,
                            fontSize: wXD(13, context),
                          ),
                        ),
                        InkWell(
                          onTap: onTap,
                          child: Container(
                            margin: EdgeInsets.only(top: wXD(20, context)),
                            height: wXD(30, context),
                            width: wXD(217, context),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color(0xff41c3b3),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Enviar Mensagem',
                              style: TextStyle(
                                  color: Color(0xff41c3b3),
                                  fontWeight: FontWeight.w500,
                                  fontSize: wXD(13, context)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
