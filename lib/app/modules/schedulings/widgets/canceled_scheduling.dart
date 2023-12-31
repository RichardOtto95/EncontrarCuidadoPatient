import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/models/doctor_model.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../scheduling_store.dart';

class CanceledScheduling extends StatelessWidget {
  final String doctorId;
  final Timestamp date;
  final SchedulingStore store;
  final Function viewConsulationDetail;
  final String status, appointmentId;

  const CanceledScheduling({
    Key key,
    this.date,
    this.doctorId,
    this.store,
    this.viewConsulationDetail,
    this.status,
    this.appointmentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: wXD(15, context),
        right: wXD(15, context),
        left: wXD(15, context),
      ),
      padding: EdgeInsets.symmetric(vertical: wXD(10, context)),
      height: wXD(160, context),
      width: wXD(334, context),
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
      child: Column(
        children: [
          Text(
            store.getDate(date),
            style: TextStyle(
              color: Color(0xff707070).withOpacity(.7),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('doctors')
                  .doc(doctorId)
                  .get(),
              builder: (context, snapshotDoctor) {
                if (!snapshotDoctor.hasData)
                  return Container(
                      height: wXD(60, context),
                      width: wXD(300, context),
                      alignment: Alignment.center,
                      child: CircularProgressIndicator());
                DocumentSnapshot docDoctor = snapshotDoctor.data;

                return InkWell(
                  onTap: () {
                    DoctorModel doctorModel =
                        DoctorModel.fromDocument(docDoctor);

                    Modular.to.pushNamed('/drprofile', arguments: doctorModel);
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: wXD(7, context),
                    ),
                    height: wXD(60, context),
                    width: wXD(300, context),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: wXD(30, context),
                          backgroundImage: docDoctor['avatar'] == null
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
                              width: wXD(230, context),
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
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Id da consulta: ' + appointmentId,
                              style: TextStyle(
                                color: Color(0xff484D54),
                                fontWeight: FontWeight.w400,
                                fontSize: wXD(13, context),
                              ),
                            ),
                            Text(
                              docDoctor['speciality_name'] != null
                                  ? docDoctor['speciality_name']
                                  : 'Especialidade',
                              style: TextStyle(
                                color: Color(0xff484D54),
                                fontWeight: FontWeight.w400,
                                fontSize: wXD(13, context),
                              ),
                            ),
                            // SizedBox(
                            //   height: wXD(20, context),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
          Spacer(),
          InkWell(
            onTap: () async {
              viewConsulationDetail();
              store.mainStore.consultChat = true;
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Text(
                        status == 'REFUSED'
                            ? 'Encaixe recusado'
                            : 'Atendimento cancelado',
                        style: TextStyle(
                          color: Color(0xff707070).withOpacity(.8),
                          fontWeight: FontWeight.w600,
                          fontSize: wXD(14, context),
                        ),
                      ),
                    ),
                    Icon(Icons.close,
                        color: Color(0xffDB2828), size: wXD(23, context)),
                  ],
                ),
                Text(
                  'Detalhes',
                  style: TextStyle(
                    color: Color(0xff2185D0),
                    fontWeight: FontWeight.w500,
                    fontSize: wXD(13, context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
