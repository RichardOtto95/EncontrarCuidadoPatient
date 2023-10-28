import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/modules/dependents/widgets/dependent_tile.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/empty_state.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:encontrarCuidado/app/modules/dependents/dependents_store.dart';
import 'package:flutter/material.dart';

class DependentsPage extends StatefulWidget {
  const DependentsPage({
    Key key,
  }) : super(key: key);
  @override
  DependentsPageState createState() => DependentsPageState();
}

class DependentsPageState extends State<DependentsPage> {
  final DependentsStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
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
                        size: maxWidth(context) * 26 / 375,
                        color: Color(0xff707070),
                      ),
                    ),
                  ),
                  Text(
                    'Dependentes',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: wXD(20, context),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                Modular.to.pushNamed('/dependents/add-dependent');
              },
              child: Container(
                padding: EdgeInsets.only(
                  top: wXD(15, context),
                  bottom: wXD(20, context),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: wXD(28, context),
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(
                      Icons.person_add,
                      size: wXD(21, context),
                      color: Color(0x80707070),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: wXD(15, context)),
                      child: Text(
                        'Adicionar dependente',
                        style: TextStyle(
                          fontSize: wXD(19, context),
                          color: Color(0xaa707070),
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0x40707070),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('patients')
                    .doc(store.authStore.user.uid)
                    .collection('dependents')
                    .where('status', isEqualTo: 'ACTIVE')
                    .snapshots(),
                builder: (context, snapshotDependents) {
                  if (!snapshotDependents.hasData) return Container();
                  QuerySnapshot queryDependents = snapshotDependents.data;
                  if (queryDependents.docs.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: queryDependents.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot docDependent =
                              queryDependents.docs[index];

                          return DependentTile(
                            onTap: () {
                              store.editDependent(docDependent.id);
                            },
                            text: '${docDependent['fullname']}',
                          );
                        },
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Column(
                        children: [
                          Spacer(flex: 1),
                          EmptyStateList(
                            image: 'assets/img/pacient_communication.png',
                            title: 'Sem dependentes',
                            description:
                                'Não há dependentes para serem exibidos',
                          ),
                          Spacer(flex: 2),
                        ],
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
