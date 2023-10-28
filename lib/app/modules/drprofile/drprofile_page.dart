import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/models/doctor_model.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:encontrarCuidado/app/shared/widgets/empty_state.dart';
import 'package:encontrarCuidado/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:encontrarCuidado/app/shared/widgets/rounded_button.dart';
import 'package:encontrarCuidado/app/shared/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'drprofile_store.dart';
import 'widgets/feed_card_drprofile.dart';

final DrProfileStore store = Modular.get();
final MainStore mainStore = Modular.get();
String doctorId = '';

class DrProfilePage extends StatefulWidget {
  final DoctorModel doctorModel;

  const DrProfilePage({Key key, this.doctorModel}) : super(key: key);
  @override
  _DrProfilePageState createState() => _DrProfilePageState();
}

class _DrProfilePageState extends State<DrProfilePage> {
  int index = 0;

  @override
  void initState() {
    store.getRatings(widget.doctorModel.id);
    doctorId = widget.doctorModel.id;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
            onWillPop: () async {
              mainStore.setRouterSearch = false;
              return true;
            },
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EncontrarCuidadoAppBar(
                      onTap: () {
                        mainStore.setRouterSearch = false;
                        Modular.to.pop();
                      },
                      title: 'Perfil do médico',
                    ),
                    Perfil(doctorModel: widget.doctorModel),
                    Separator(),
                    MedicDetails(
                      index: index,
                      onTap0: () {
                        if (index != 0) {
                          setState(() {
                            index = 0;
                          });
                        }
                      },
                      onTap1: () {
                        if (index != 1) {
                          setState(() {
                            index = 1;
                          });
                        }
                      },
                      onTap2: () {
                        if (index != 2) {
                          setState(() {
                            index = 2;
                          });
                        }
                      },
                      onTap3: () {
                        if (index != 3) {
                          setState(() {
                            index = 3;
                          });
                        }
                      },
                    ),
                    Expanded(
                      child: index == 0
                          ? RefreshIndicator(
                              onRefresh: () async {
                                setState(() {
                                  index = 0;
                                });
                              },
                              child: GestureDetector(
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Posts())))
                          : SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: index == 1
                                  ? Informations(
                                      doctorModel: widget.doctorModel,
                                    )
                                  : index == 2
                                      ? Contact(
                                          doctorModel: widget.doctorModel,
                                        )
                                      : index == 3
                                          ? OpinionDetail()
                                          : Container(),
                            ),
                    )
                  ],
                ),
                Observer(builder: (context) {
                  return Visibility(
                    visible: store.setCards,
                    child: AnimatedContainer(
                      height: maxHeight,
                      width: maxWidth,
                      color: !store.setCards
                          ? Colors.transparent
                          : Color(0x50000000),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.decelerate,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(top: wXD(15, context)),
                          height: wXD(215, context),
                          width: wXD(324, context),
                          decoration: BoxDecoration(
                              color: Color(0xfffafafa),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(33))),
                          child: Column(
                            children: [
                              Container(
                                width: wXD(240, context),
                                margin: EdgeInsets.only(top: wXD(15, context)),
                                child: Text(
                                  '''Para realizar seu primeiro agendamento, é necessário adicionar um cartão em Perfil > Pagamentos > Adicionar Cartão. Deseja navegar para esta seção?''',
                                  style: TextStyle(
                                    fontSize: wXD(15, context),
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xfa707070),
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      store.setCardDialog(!store.setCards);
                                    },
                                    child: Container(
                                      height: wXD(47, context),
                                      width: wXD(98, context),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 3),
                                                blurRadius: 3,
                                                color: Color(0x28000000))
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(17)),
                                          border: Border.all(
                                              color: Color(0x80707070)),
                                          color: Color(0xfffafafa)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Não',
                                        style: TextStyle(
                                            color: Color(0xff2185D0),
                                            fontWeight: FontWeight.bold,
                                            fontSize: wXD(16, context)),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () async {
                                      store.setCardDialog(!store.setCards);
                                      Modular.to.pushNamed('/payment/add-card',
                                          arguments: false);
                                    },
                                    child: Container(
                                      height: wXD(47, context),
                                      width: wXD(98, context),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 3),
                                                blurRadius: 3,
                                                color: Color(0x28000000))
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(17)),
                                          border: Border.all(
                                              color: Color(0x80707070)),
                                          color: Color(0xfffafafa)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Sim',
                                        style: TextStyle(
                                            color: Color(0xff2185D0),
                                            fontWeight: FontWeight.bold,
                                            fontSize: wXD(16, context)),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              Spacer(
                                flex: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            )
            // })
            ),
      ),
    );
  }
}

class Posts extends StatelessWidget {
  const Posts({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return mainStore.setRouterSearch
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('doctors')
                .doc(doctorId)
                .collection('feed')
                .where('status', isEqualTo: 'VISIBLE')
                .orderBy('created_at', descending: true)
                .snapshots(),
            builder: (context, snapshotFeed) {
              if (snapshotFeed.connectionState == ConnectionState.waiting)
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              if (snapshotFeed.hasData) {
                print(
                    '%%%%%%%%%%%% ${snapshotFeed.data.docs.length} %%%%%%%%%%%%');
              }
              return snapshotFeed.hasData && snapshotFeed.data.docs.isNotEmpty
                  ? Column(
                      children: [
                        Column(
                            children: List.generate(
                                snapshotFeed.data.docs.length, (index) {
                          DocumentSnapshot feed = snapshotFeed.data.docs[index];
                          store.mapReport.putIfAbsent(feed['id'], () => false);

                          return FeedCardProfile(
                            routerSearch: true,
                            avatar: feed['dr_avatar'],
                            description: feed['text'],
                            imageUrl: feed['bgr_image'],
                            likes: feed['like_count'].toString(),
                            name: feed['dr_name'],
                            postId: feed['id'],
                            speciality: feed['dr_speciality'],
                            status: feed['status'],
                            timeAgo: store.getTime(feed['created_at']),
                            doctorId: doctorId,
                          );
                        })),
                        SizedBox(
                          height: wXD(80, context),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        EmptyStateList(
                          image: 'assets/img/work_on2.png',
                          title: 'Sem postagens',
                          description: 'Sem postagens para serem exibidas',
                        ),
                        SizedBox(height: wXD(80, context)),
                      ],
                    );
            },
          )
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('patients')
                .doc(store.authStore.user.uid)
                .collection('feed')
                .where('dr_id', isEqualTo: doctorId)
                .where('status', isEqualTo: 'VISIBLE')
                .orderBy('created_at', descending: true)
                .snapshots(),
            builder: (context, snapshotFeed) {
              if (snapshotFeed.connectionState == ConnectionState.waiting)
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              if (snapshotFeed.hasData) {
                print(
                    '%%%%%%%%%%%% ${snapshotFeed.data.docs.length} %%%%%%%%%%%%');
              }
              return snapshotFeed.hasData && snapshotFeed.data.docs.isNotEmpty
                  ? Column(
                      children: [
                        Column(
                            children: List.generate(
                                snapshotFeed.data.docs.length, (index) {
                          DocumentSnapshot feed = snapshotFeed.data.docs[index];
                          store.mapReport.putIfAbsent(feed['id'], () => false);

                          return FeedCardProfile(
                            routerSearch: false,
                            avatar: feed['dr_avatar'],
                            description: feed['text'],
                            imageUrl: feed['bgr_image'],
                            likes: feed['like_count'].toString(),
                            name: feed['dr_name'],
                            postId: feed['id'],
                            speciality: feed['dr_speciality'],
                            status: feed['status'],
                            timeAgo: store.getTime(feed['created_at']),
                            doctorId: doctorId,
                          );
                        })),
                        SizedBox(
                          height: wXD(80, context),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        EmptyStateList(
                          image: 'assets/img/work_on2.png',
                          title: 'Sem postagens',
                          description: 'Sem postagens para serem exibidas',
                        ),
                        SizedBox(height: wXD(80, context)),
                      ],
                    );
            },
          );
  }
}

class Perfil extends StatelessWidget {
  final DoctorModel doctorModel;
  final MainStore mainstore = Modular.get();

  Perfil({Key key, this.doctorModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: wXD(18, context),
        left: wXD(15, context),
        right: wXD(15, context),
      ),
      width: wXD(375, context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: doctorModel.avatar == null
                ? Image.asset(
                    'assets/img/defaultUser.png',
                    height: wXD(88, context),
                    width: wXD(88, context),
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: doctorModel.avatar,
                    width: wXD(88, context),
                    height: wXD(88, context),
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                  ),
          ),
          SizedBox(
            width: wXD(8, context),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: wXD(10, context),
              ),
              Container(
                width: wXD(245, context),
                child: Text(
                  doctorModel.fullname != null
                      ? doctorModel.fullname
                      : doctorModel.username,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xff484D54),
                    fontWeight: FontWeight.w900,
                    fontSize: wXD(16, context),
                  ),
                ),
              ),
              Text(
                doctorModel.specialityName != null
                    ? doctorModel.specialityName
                    : 'Não informado',
                style: TextStyle(
                  color: Color(0xff484D54),
                  fontWeight: FontWeight.w400,
                  fontSize: wXD(14, context),
                ),
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: 'CRM:',
                  style: TextStyle(
                    color: Color(0xff484D54),
                    fontWeight: FontWeight.w400,
                    fontSize: wXD(14, context),
                  ),
                ),
                TextSpan(
                  text: doctorModel.crm != null
                      ? doctorModel.crm
                      : 'Não informado',
                  style: TextStyle(
                    color: Color(0xff484D54),
                    fontWeight: FontWeight.w300,
                    fontSize: wXD(13, context),
                  ),
                ),
              ])),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: 'RQE:',
                  style: TextStyle(
                    color: Color(0xff484D54),
                    fontWeight: FontWeight.w400,
                    fontSize: wXD(14, context),
                  ),
                ),
                TextSpan(
                  text: doctorModel.rqe != null
                      ? doctorModel.rqe
                      : 'Não informado',
                  style: TextStyle(
                    color: Color(0xff484D54),
                    fontWeight: FontWeight.w300,
                    fontSize: wXD(13, context),
                  ),
                ),
              ])),
              Observer(
                builder: (context) {
                  return Row(
                    children: [
                      Text(
                        store.ratingsAverage,
                        style: TextStyle(
                          color: Color(0xff2185D0),
                          fontWeight: FontWeight.w600,
                          fontSize: wXD(12, context),
                        ),
                      ),
                      SizedBox(
                        width: wXD(5, context),
                      ),
                      RatingBar.builder(
                        ignoreGestures: true,
                        itemSize: wXD(20, context),
                        initialRating: double.parse(store.ratingsAverage),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemBuilder: (context, _) => Icon(
                          Icons.star_rate_rounded,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      SizedBox(
                        width: wXD(3, context),
                      ),
                      Text(
                        '${store.ratingsLength} opiniões',
                        style: TextStyle(
                          color: Color(0xff484D54),
                          fontWeight: FontWeight.w300,
                          fontSize: wXD(13, context),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: wXD(15, context),
                  top: wXD(10, context),
                  bottom: wXD(10, context),
                ),
                child: RoundedButton(
                  onTap: () async {
                    if (await mainStore.getCards() == false) {
                      store.setCardDialog(true);
                    } else {
                      if (mainStore.setRouterSchedule) {
                        Modular.to.pop();
                      } else {
                        print(doctorModel.id);
                        mainstore.setDoctorId(doctorModel.id);
                        await Modular.to.pushNamed(
                          '/schedule',
                          arguments: true,
                        );
                      }
                    }
                  },
                  textStyle: TextStyle(
                      fontSize: wXD(13, context),
                      color: Colors.white,
                      fontWeight: FontWeight.w800),
                  title: '  Agendar consulta',
                  width: wXD(176, context),
                  height: wXD(35, context),
                  widget: Icon(
                    Icons.calendar_today,
                    color: Color(0xfffafafa),
                    size: wXD(23, context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MedicDetails extends StatelessWidget {
  final int index;
  final Function onTap0;
  final Function onTap1;
  final Function onTap2;
  final Function onTap3;

  const MedicDetails({
    Key key,
    this.index = 0,
    this.onTap0,
    this.onTap1,
    this.onTap2,
    this.onTap3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: wXD(25, context)),
      height: wXD(63, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 3,
            color: Color(0x30000000),
          )
        ],
        color: Color(0xfffafafa),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    onTap: onTap0,
                    child: Column(
                      children: [
                        Spacer(),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding:
                              EdgeInsets.symmetric(vertical: wXD(20, context)),
                          alignment: Alignment.center,
                          child: Text(
                            'Postagens',
                            style: TextStyle(
                              color: index == 0
                                  ? Color(0xff2185D0)
                                  : Color(0xff707070),
                              fontWeight: FontWeight.w700,
                              fontSize: wXD(15, context),
                            ),
                          ),
                        ),
                        Spacer(),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            'Postagens',
                            style: TextStyle(
                              color: Colors.transparent,
                              fontWeight: FontWeight.w700,
                              fontSize: wXD(15, context),
                            ),
                          ),
                          height: 3,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(15)),
                            color: index == 0
                                ? Color(0xff2185D0)
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: wXD(15, context)),
                  InkWell(
                    onTap: onTap1,
                    child: Column(
                      children: [
                        Spacer(),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding:
                              EdgeInsets.symmetric(vertical: wXD(20, context)),
                          // width: wXD(96, context),
                          alignment: Alignment.center,
                          child: Text(
                            'Informações',
                            style: TextStyle(
                              color: index == 1
                                  ? Color(0xff2185D0)
                                  : Color(0xff707070),
                              fontWeight: FontWeight.w700,
                              fontSize: wXD(15, context),
                            ),
                          ),
                        ),
                        Spacer(),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            'Informações',
                            style: TextStyle(
                              color: Colors.transparent,
                              fontWeight: FontWeight.w700,
                              fontSize: wXD(15, context),
                            ),
                          ),
                          height: 3,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(15)),
                            color: index == 1
                                ? Color(0xff2185D0)
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: wXD(15, context)),
                  InkWell(
                    onTap: onTap2,
                    child: Column(
                      children: [
                        Spacer(),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding:
                              EdgeInsets.symmetric(vertical: wXD(20, context)),
                          // width: wXD(90, context),
                          alignment: Alignment.center,
                          child: Text(
                            'Contato',
                            style: TextStyle(
                              color: index == 2
                                  ? Color(0xff2185D0)
                                  : Color(0xff707070),
                              fontWeight: FontWeight.w700,
                              fontSize: wXD(15, context),
                            ),
                          ),
                        ),
                        Spacer(),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            'Contato',
                            style: TextStyle(
                              color: Colors.transparent,
                              fontWeight: FontWeight.w700,
                              fontSize: wXD(15, context),
                            ),
                          ),
                          height: 3,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(15)),
                            color: index == 2
                                ? Color(0xff2185D0)
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: wXD(15, context)),
                  InkWell(
                    onTap: onTap3,
                    child: Column(
                      children: [
                        Spacer(),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding:
                              EdgeInsets.symmetric(vertical: wXD(20, context)),
                          // width: wXD(90, context),
                          alignment: Alignment.center,
                          child: Text(
                            'Opiniões',
                            style: TextStyle(
                              color: index == 3
                                  ? Color(0xff2185D0)
                                  : Color(0xff707070),
                              fontWeight: FontWeight.w700,
                              fontSize: wXD(15, context),
                            ),
                          ),
                        ),
                        Spacer(),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            'Opiniões',
                            style: TextStyle(
                              color: Colors.transparent,
                              fontWeight: FontWeight.w700,
                              fontSize: wXD(15, context),
                            ),
                          ),
                          height: 3,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(15)),
                            color: index == 3
                                ? Color(0xff2185D0)
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(width: wXD(15, context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Separator extends StatelessWidget {
  final double vertical;
  final double horizontal;

  const Separator({
    Key key,
    this.vertical = 0,
    this.horizontal = 25,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: wXD(375, context),
      height: wXD(1, context),
      margin: EdgeInsets.symmetric(
          horizontal: wXD(horizontal, context),
          vertical: wXD(vertical, context)),
      color: Color(0xff707070).withOpacity(.26),
    );
  }
}

class Informations extends StatelessWidget {
  final DoctorModel doctorModel;

  const Informations({Key key, this.doctorModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(
          title: 'Experiência',
          top: wXD(20, context),
          left: wXD(31, context),
          bottom: wXD(5, context),
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.person_pin,
          title: 'Sobre mim',
        ),
        InfoText(
          title: doctorModel.aboutMe != null
              ? doctorModel.aboutMe
              : 'Não informado',
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.business_center,
          title: 'Especialidade',
        ),
        InfoText(
          title: doctorModel.specialityName != null
              ? doctorModel.specialityName
              : 'Não informado',
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.school,
          title: 'Formação acadêmica',
        ),
        InfoText(
          title: doctorModel.academicEducation != null
              ? doctorModel.academicEducation
              : 'Não informado',
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.medical_services,
          title: 'Experiência em:    ',
        ),
        InfoText(
          title: doctorModel.experience != null
              ? doctorModel.experience
              : 'Não informado',
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.medication_rounded,
          title: 'Tratar condições médicas',
        ),
        InfoText(
          title: doctorModel.medicalConditions != null
              ? doctorModel.medicalConditions
              : 'Não informado',
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.medical_services,
          title: 'Faixa etária',
        ),
        InfoText(
          title: doctorModel.attendance != null
              ? doctorModel.attendance
              : 'Não informado',
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.local_hospital,
          title: 'Clínica',
        ),
        InfoText(
          title: doctorModel.clinicName != null
              ? doctorModel.clinicName
              : 'Não informado',
        ),
        // Separator(vertical: wXD(9, context)),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.language,
          title: 'Idiomas',
        ),
        InfoText(
          title: doctorModel.language != null
              ? doctorModel.language
              : 'Não informado',
        ),
        SizedBox(height: wXD(15, context))
      ],
    );
  }
}

class InfoText extends StatelessWidget {
  final String title;
  final double size;
  final double left;
  final double right;
  final double top;
  final double height;
  final Color color;
  final FontWeight weight;

  const InfoText({
    Key key,
    this.title,
    this.size = 15,
    this.left = 40,
    this.right = 20,
    this.top = 10,
    this.height = 1,
    this.color,
    this.weight,
  }) : super(key: key);

  getColor() {
    Color _color;
    if (color == null) {
      _color = Color(0xff707070);
    } else {
      _color = color;
    }
    return _color;
  }

  getWeight() {
    FontWeight _weight;
    if (weight == null) {
      _weight = FontWeight.w400;
    } else {
      _weight = weight;
    }
    return _weight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wXD(375, context),
      padding: EdgeInsets.only(
        left: wXD(left, context),
        right: wXD(right, context),
        top: wXD(top, context),
      ),
      child: Text(
        '$title',
        style: TextStyle(
          height: height,
          color: getColor(),
          fontWeight: getWeight(),
          fontSize: wXD(size, context),
        ),
      ),
    );
  }
}

class Topic extends StatelessWidget {
  final String title;

  const Topic({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: wXD(375, context),
      padding: EdgeInsets.only(
        top: wXD(4.5, context),
        bottom: wXD(4.5, context),
        left: wXD(40, context),
        right: wXD(20, context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin:
                EdgeInsets.only(right: wXD(4, context), top: wXD(5, context)),
            height: wXD(6, context),
            width: wXD(6, context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xff707070),
            ),
          ),
          Container(
            width: wXD(300, context),
            child: Text(
              '$title',
              maxLines: 5,
              style: TextStyle(
                color: Color(0xff707070),
                fontWeight: FontWeight.w400,
                fontSize: wXD(15, context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InformationTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final double left;
  final Color color;

  const InformationTitle({
    Key key,
    this.icon,
    this.title,
    this.color,
    this.left,
  }) : super(key: key);

  getColor() {
    Color _color;
    if (color == null) {
      _color = Color(0xff707070);
    } else {
      _color = color;
    }
    return _color;
  }

  getLeft(BuildContext context) {
    double _left;
    if (left == null) {
      _left = wXD(30, context);
    } else {
      _left = left;
    }
    return _left;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: getLeft(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: wXD(22, context),
            color: Color(0xff707070).withOpacity(.8),
          ),
          SizedBox(
            width: wXD(10, context),
          ),
          Container(
            width: wXD(294, context),
            padding: EdgeInsets.only(top: wXD(2, context)),
            child: Text(
              '$title',
              style: TextStyle(
                color: getColor(),
                fontWeight: FontWeight.w500,
                fontSize: wXD(15, context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Contact extends StatelessWidget {
  final DoctorModel doctorModel;

  const Contact({Key key, this.doctorModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: wXD(20, context),
        ),
        InformationTitle(icon: Icons.phone, title: 'Número de telefone'),
        InfoText(title: getMask(doctorModel.landline, 1)),
        InfoText(title: getMask(doctorModel.phone, 2)),
        Separator(vertical: wXD(9, context)),
        InformationTitle(icon: Icons.email, title: 'E-mail'),
        InfoText(
            title: doctorModel.email != null
                ? doctorModel.email.toLowerCase()
                : 'Não informado'),
        Separator(vertical: wXD(9, context)),
        InformationTitle(icon: Icons.phone_android, title: 'Rede Social'),
        InfoText(
            title: doctorModel.social != null
                ? doctorModel.social
                : 'Não informado'),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.pin_drop,
          title: 'Endereço',
        ),
        InfoText(
          title: 'CEP: ' + getMask(doctorModel.cep, 3),
        ),
        InfoText(
          title: doctorModel.state == null ||
                  doctorModel.city == null ||
                  doctorModel.neighborhood == null ||
                  doctorModel.address == null ||
                  doctorModel.numberAddress == null ||
                  doctorModel.complementAddress == null
              ? "Não informado"
              : doctorModel.state +
                  ', ' +
                  doctorModel.city +
                  ', ' +
                  doctorModel.neighborhood +
                  ', ' +
                  doctorModel.address +
                  ', ' +
                  doctorModel.numberAddress +
                  ', ' +
                  doctorModel.complementAddress,
        ),
      ],
    );
  }

  String getMask(String text, int index) {
    String newText;
    switch (index) {
      case 1:
        if (text != null) {
          return text;
        } else {
          return 'Não informado';
        }
        break;

      case 2:
        if (text != null) {
          newText = text.substring(0, 3) +
              ' (' +
              text.substring(3, 5) +
              ') ' +
              text.substring(5, 10) +
              '-' +
              text.substring(10, 14);
          return newText;
        } else {
          return 'Não informado';
        }
        break;

      case 3:
        if (text != null) {
          newText = text.substring(0, 2) +
              '.' +
              text.substring(2, 5) +
              '-' +
              text.substring(5, 8);
          return newText;
        } else {
          return 'Não informado';
        }
        break;

      default:
        return 'Não informado';
        break;
    }
  }
}

class OpinionDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OpinionsType(
              onTap0: () {
                if (store.index != 0) {
                  store.index = 0;
                  store.limit = 5;
                  store.moreReviews = true;
                }
              },
              onTap1: () {
                if (store.index != 1) {
                  store.index = 1;
                  store.limit = 5;
                  store.moreReviews = true;
                }
              },
              onTap2: () {
                if (store.index != 2) {
                  store.index = 2;
                  store.limit = 5;
                  store.moreReviews = true;
                }
              },
              onTap3: () {
                if (store.index != 3) {
                  store.index = 3;
                  store.limit = 5;
                  store.moreReviews = true;
                }
              },
            ),
            Opinions(),
          ],
        );
      },
    );
  }
}

class Opinions extends StatelessWidget {
  const Opinions({
    Key key,
  }) : super(key: key);

  String getText({int index}) {
    if (index == 1) {
      return ' positivas';
    } else if (index == 2) {
      return ' neutras';
    } else if (index == 3) {
      return ' negativas';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Observer(
          builder: (context) {
            return FutureBuilder(
              future: store.getOpinions(index: store.index, doctorId: doctorId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                if (snapshot.hasError)
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );

                if (snapshot.data.isEmpty) {
                  return EmptyStateList(
                    top: 0,
                    image: 'assets/img/work_on2.png',
                    title: 'Sem avaliações!',
                    description:
                        '''Sem avaliações${getText(index: store.index)} para serem exibidas.''',
                  );
                } else {
                  return Column(
                    children: [
                      Column(
                          children:
                              List.generate(snapshot.data.length, (index) {
                        var ref = snapshot.data[index];
                        return Opinion(
                          avaliation: ref['avaliation'].toDouble(),
                          date: ref['created_at'],
                          photo: ref['photo'],
                          text: ref['text'],
                          username: ref['username'],
                        );
                      })),
                      Visibility(
                        visible: store.moreReviews,
                        child: Center(
                          child: InkWell(
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async {
                              await store.getMoreOpinion();
                              setState(() {});
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: wXD(15, context),
                                bottom: wXD(25, context),
                              ),
                              height: wXD(35, context),
                              width: wXD(127, context),
                              decoration: BoxDecoration(
                                color: Color(0xfffafafa),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                                border: Border.all(
                                    color: Color(0xff707070).withOpacity(.3)),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    offset: Offset(0, 3),
                                    color: Color(0x30000000),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Ver mais',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xff2185d0),
                                  fontWeight: FontWeight.w500,
                                  fontSize: wXD(15, context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}

class Opinion extends StatelessWidget {
  final String photo;
  final String username;
  final Timestamp date;
  final double avaliation;
  final String text;

  const Opinion({
    Key key,
    this.photo,
    this.username,
    this.date,
    this.avaliation,
    this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: wXD(375, context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: wXD(6, context),
              left: wXD(18, context),
              right: wXD(34, context),
              bottom: wXD(8, context),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: photo != null
                      ? NetworkImage(photo)
                      : AssetImage('assets/img/defaultUser.png'),
                  backgroundColor: Colors.white,
                  radius: wXD(19.5, context),
                ),
                Container(
                  width: wXD(184, context),
                  padding: EdgeInsets.symmetric(horizontal: wXD(6, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$username',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontWeight: FontWeight.w500,
                          fontSize: wXD(14, context),
                        ),
                      ),
                      SizedBox(
                        height: wXD(3, context),
                      ),
                      Text(
                        store.converterDateToString(date),
                        style: TextStyle(
                          color: Color(0xff787C81),
                          fontWeight: FontWeight.w700,
                          fontSize: wXD(10, context),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                RatingBar.builder(
                  ignoreGestures: true,
                  itemSize: wXD(20, context),
                  initialRating: avaliation,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star_rate_rounded,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
              ],
            ),
          ),
          Container(
            width: wXD(375, context),
            padding: EdgeInsets.only(
              left: wXD(50, context),
              right: wXD(22, context),
            ),
            child: Text(
              '$text',
              style: TextStyle(
                color: Color(0xff707070),
                fontWeight: FontWeight.w400,
                fontSize: wXD(15, context),
              ),
            ),
          ),
          Separator(
            vertical: wXD(7, context),
          ),
        ],
      ),
    );
  }
}

class OpinionsType extends StatelessWidget {
  final Function onTap0;
  final Function onTap1;
  final Function onTap2;
  final Function onTap3;

  const OpinionsType({
    Key key,
    this.onTap0,
    this.onTap1,
    this.onTap2,
    this.onTap3,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(wXD(10, context), wXD(10, context),
          wXD(10, context), wXD(0, context)),
      height: wXD(36, context),
      width: MediaQuery.of(context).size.width,
      child: LayoutBuilder(
        builder: (context, constraints2) {
          return Observer(
            builder: (context) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                        color: Color(0xff707070).withOpacity(.3),
                        width: 2,
                      )),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: onTap0,
                              child: Container(
                                alignment: Alignment.center,
                                width: constraints2.maxWidth * .22,
                                height: wXD(33, context),
                                child: Text(
                                  'Todas',
                                  style: TextStyle(
                                    color: store.index == 0
                                        ? Color(0xff2185D0)
                                        : Color(0xff707070),
                                    fontWeight: FontWeight.w700,
                                    fontSize: wXD(15, context),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: onTap1,
                              child: Container(
                                alignment: Alignment.center,
                                width: constraints2.maxWidth * .25,
                                height: wXD(33, context),
                                child: Text(
                                  'Positivas',
                                  style: TextStyle(
                                    color: store.index == 1
                                        ? Color(0xff2185D0)
                                        : Color(0xff707070),
                                    fontWeight: FontWeight.w700,
                                    fontSize: wXD(15, context),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: onTap2,
                              child: Container(
                                alignment: Alignment.center,
                                width: constraints2.maxWidth * .23,
                                height: wXD(33, context),
                                child: Text(
                                  'Neutras',
                                  style: TextStyle(
                                    color: store.index == 2
                                        ? Color(0xff2185D0)
                                        : Color(0xff707070),
                                    fontWeight: FontWeight.w700,
                                    fontSize: wXD(15, context),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: onTap3,
                              child: Container(
                                alignment: Alignment.center,
                                width: constraints2.maxWidth * .3,
                                height: wXD(33, context),
                                child: Text(
                                  'Negativas',
                                  style: TextStyle(
                                    color: store.index == 3
                                        ? Color(0xff2185D0)
                                        : Color(0xff707070),
                                    fontWeight: FontWeight.w700,
                                    fontSize: wXD(15, context),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AnimatedPositioned(
                    bottom: 0,
                    left: store.index == 0
                        ? 0
                        : store.index == 1
                            ? constraints2.maxWidth * .22
                            : store.index == 2
                                ? constraints2.maxWidth * .47
                                : constraints2.maxWidth * .70,
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 300),
                    child: AnimatedContainer(
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 300),
                      height: 2,
                      width: store.index == 0
                          ? constraints2.maxWidth * .22
                          : store.index == 1
                              ? constraints2.maxWidth * .25
                              : store.index == 2
                                  ? constraints2.maxWidth * .23
                                  : constraints2.maxWidth * .30,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(8)),
                        color: Color(0xff2185d0),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
