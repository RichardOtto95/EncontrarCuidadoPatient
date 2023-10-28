import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_store.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/modules/payment/widgets/historic.dart';
import 'package:encontrarCuidado/app/shared/color_theme.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrarCuidado/app/shared/widgets/title_widget.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:encontrarCuidado/app/modules/payment/payment_store.dart';
import 'package:flutter/material.dart';
import 'widgets/card_payment.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key key}) : super(key: key);
  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  final MainStore mainStore = Modular.get();
  final AuthStore authStore = Modular.get();
  final PaymentStore store = Modular.get();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    bool hasCard = false;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Modular.to.pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Observer(
              builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EncontrarCuidadoNavBar(
                      leading: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: wXD(11, context),
                                right: wXD(11, context)),
                            child: InkWell(
                              onTap: () {
                                Modular.to.pop();
                              },
                              child: Icon(
                                Icons.arrow_back_ios_outlined,
                                size: maxWidth * 26 / 375,
                                color: Color(0xff707070),
                              ),
                            ),
                          ),
                          Text(
                            'Pagamento',
                            style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: wXD(20, context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: wXD(3, context)),
                    TitleWidget(
                        title: !mainStore.emptyStatePayment
                            ? 'Meus Cartões'
                            : 'Adicione um cartão'),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('patients')
                          .doc(authStore.user.uid)
                          .collection('cards')
                          .where('status', isEqualTo: 'ACTIVE')
                          .orderBy('created_at', descending: false)
                          .snapshots(),
                      builder: (context, snapshotCards) {
                        if (snapshotCards.hasData) {
                          hasCard = snapshotCards.data.docs.isNotEmpty;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            store.getCards(snapshotCards.data);
                          });
                        }
                        return Container(
                          margin: EdgeInsets.only(bottom: wXD(2, context)),
                          decoration: BoxDecoration(
                            color: Color(0xfffafafa),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x29000000),
                                offset: Offset(0, 3),
                                blurRadius: 3,
                              ),
                            ],
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(25),
                            ),
                          ),
                          height: wXD(270, context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Observer(
                                builder: (context) {
                                  if (store.cardsList == null) {
                                    return Expanded(
                                        child: Row(
                                      children: [
                                        Spacer(),
                                        CircularProgressIndicator(),
                                        Spacer(),
                                      ],
                                    ));
                                  }

                                  if (store.cardsList.isEmpty) {
                                    return Container(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: wXD(53, context),
                                            bottom: wXD(44, context)),
                                        child: Image.asset(
                                            'assets/img/Imagemsemcartão.jpeg'),
                                      ),
                                    );
                                  }

                                  return Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: wXD(10, context)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                          store.cardsList.length,
                                          (i) {
                                            DocumentSnapshot docCard =
                                                store.cardsList[i];

                                            return CardPayment(
                                                docCard: docCard,
                                                finalNumber:
                                                    docCard['final_number'],
                                                colors: docCard['colors']);
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    print(
                                        'xxxxxxxxxxxxxx onTap $hasCard xxxxxxxxxxx');
                                    Modular.to.pushNamed('/payment/add-card',
                                        arguments: hasCard);
                                  },
                                  child: Container(
                                    width: maxWidth * .66,
                                    height: maxWidth * .1,
                                    margin: EdgeInsets.only(
                                        // top: maxWidth * .03,
                                        bottom: wXD(22, context)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Adicionar cartão',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(23)),
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
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    TitleWidget(
                      title: 'Histórico de transações',
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('patients')
                          .doc(authStore.user.uid)
                          .collection('transactions')
                          .orderBy('updated_at', descending: true)
                          .snapshots(),
                      builder: (context, snapshotTransactions) {
                        if (snapshotTransactions.hasData) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            store.getTransactions(snapshotTransactions.data);
                          });
                        }
                        return Observer(
                          builder: (context) {
                            if (store.transactionsList == null) {
                              return Row(
                                children: [
                                  Spacer(),
                                  CircularProgressIndicator(),
                                  Spacer(),
                                ],
                              );
                            }

                            if (store.transactionsList.isEmpty) {
                              return Center(
                                child: Container(
                                  margin:
                                      EdgeInsets.only(top: wXD(40, context)),
                                  width: wXD(280, context),
                                  child: Text(
                                    'Sem transações registradas!',
                                    style: TextStyle(
                                      color: ColorTheme.textGrey,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Column(
                              children: List.generate(
                                store.transactionsList.length,
                                (i) {
                                  DocumentSnapshot doctransactions =
                                      store.transactionsList[i];

                                  String shortId =
                                      doctransactions['appointment_id']
                                          .substring(
                                              doctransactions['appointment_id']
                                                      .length -
                                                  4,
                                              doctransactions['appointment_id']
                                                  .length)
                                          .toUpperCase();

                                  return Historic(
                                    tr: doctransactions,
                                    value: doctransactions['value'],
                                    text: getLabel(doctransactions) +
                                        '($shortId).',
                                    description: getDescription(
                                        doctransactions, shortId),
                                    date: store
                                        .getDate(doctransactions['updated_at']),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String getLabel(DocumentSnapshot docTransaction) {
    print('xxxxxx status ${docTransaction.get('status')} xxxxx');
    switch (docTransaction.get('status')) {
      case 'PENDING_REFUND':
        return 'Reembolso pendente';
        break;

      case 'REFUND':
        if (docTransaction.get('type') == 'GUARANTEE_REFUND') {
          return 'Reembolso da caução';
        }
        if (docTransaction.get('type') == 'REMAINING_REFUND') {
          return 'Reembolso remanescente';
        }
        return 'Tipo não identificado';
        break;

      case 'OUTCOME':
        if (docTransaction.get('type') == 'GUARANTEE') {
          return 'Pagamento da caução';
        }

        if (docTransaction.get('type') == 'GUARANTEE_REFUND') {
          return 'Reembolso da caução';
        }

        if (docTransaction.get('type') == 'REMAINING') {
          return 'Pagamento remanescente';
        }

        if (docTransaction.get('type') == 'REMAINING_REFUND') {
          return 'Reembolso remanescente';
        }

        return 'Tipo não identificado.';
        break;

      case 'REFUND_REQUESTED_INCOME':
        return 'Reembolso solicitado';
        break;

      default:
        return 'Status não identificado';
        break;
    }
  }

  String getDescription(DocumentSnapshot docTransaction, String shortId) {
    switch (docTransaction.get('status')) {
      case 'PENDING_REFUND':
        return 'Reembolso pendente referente à consulta ($shortId).';
        break;

      case 'REFUND':
        if (docTransaction.get('type') == 'GUARANTEE_REFUND') {
          return 'Reembolso da caução referente à consulta ($shortId) realizado.';
        }

        if (docTransaction.get('type') == 'REMAINING_REFUND') {
          return 'Reembolso referente à consulta ($shortId) realizado.';
        }

        return 'Reembolso realizado';
        break;

      case 'OUTCOME':
        if (docTransaction.get('type') == 'GUARANTEE') {
          return 'Pagamento da caução referente à consulta ($shortId).';
        }

        if (docTransaction.get('type') == 'GUARANTEE_REFUND') {
          return 'Reembolso da caução referente à consulta ($shortId).';
        }

        if (docTransaction.get('type') == 'REMAINING') {
          return 'Pagamento remanescente referente à consulta ($shortId).';
        }

        if (docTransaction.get('type') == 'REMAINING_REFUND') {
          return 'Reembolso remanescente referente à consulta ($shortId).';
        }

        return 'Tipo não identificado.';
        break;

      case 'REFUND_REQUESTED_INCOME':
        return 'Reembolso solicitado referente à consulta ($shortId).';
        break;

      default:
        return 'Status não identificado';
        break;
    }
  }
}
