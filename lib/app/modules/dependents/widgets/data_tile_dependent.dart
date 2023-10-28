import 'package:encontrarCuidado/app/modules/dependents/dependents_store.dart';
import 'package:encontrarCuidado/app/modules/sign/widgets/masktextinputformatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'float_menu_city.dart';
import 'float_menu_state.dart';

class DataTileDependent extends StatelessWidget {
  @required
  final String title;
  final String hint;
  final Function iconTap;
  final FocusNode focusNode;
  final Map<String, bool> mapFields;
  final String type;
  final bool mandatory;
  final Function onEditingComplete;

  const DataTileDependent({
    Key key,
    this.title,
    this.hint = '',
    this.iconTap,
    this.focusNode,
    this.mapFields,
    this.type,
    this.mandatory = false,
    this.onEditingComplete,
  }) : super(key: key);

  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  @override
  Widget build(BuildContext context) {
    final DependentsStore store = Modular.get();

    MaskTextInputFormatter maskFormatterCpf = new MaskTextInputFormatter(
        mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

    MaskTextInputFormatter maskFormatterCep = new MaskTextInputFormatter(
        mask: '##.###-###', filter: {"#": RegExp(r'[0-9]')});

    MaskTextInputFormatter maskFormatterPhone = new MaskTextInputFormatter(
        mask: '+## (##) #####-####', filter: {"#": RegExp(r'[0-9]')});

    List<MaskTextInputFormatter> getInputFormatter() {
      switch (type) {
        case 'cpf':
          return [maskFormatterCpf];
          break;

        case 'cep':
          return [maskFormatterCep];
          break;

        case 'phone':
          return [maskFormatterPhone];
          break;

        default:
          return [];
          break;
      }
    }

    return Container(
        margin: EdgeInsets.fromLTRB(
          wXD(28, context),
          wXD(9, context),
          wXD(26, context),
          wXD(0, context),
        ),
        padding: EdgeInsets.only(
          bottom: wXD(2, context),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0x50707070),
            ),
          ),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      mandatory ? '$title*' : '$title',
                      style: TextStyle(
                          fontSize: wXD(17, context),
                          fontWeight: FontWeight.w400,
                          color: Color(0xff95989A)),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: wXD(13, context)),
                      child: InkWell(
                        onTap: iconTap != null
                            ? iconTap
                            : () {
                                focusNode.requestFocus();
                              },
                        child: Icon(
                          Icons.edit,
                          color: Color(0xff95989A),
                          size: wXD(17, context),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: wXD(5, context),
                ),
                type != 'birthday' &&
                        type != 'gender' &&
                        type != 'city' &&
                        type != 'state'
                    ? TextFormField(
                        onEditingComplete: onEditingComplete,
                        autocorrect: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textCapitalization: type != 'fullname'
                            ? TextCapitalization.sentences
                            : TextCapitalization.words,
                        keyboardType: (type == 'cep' ||
                                type == 'cpf' ||
                                type == 'phone' ||
                                type == 'number_address')
                            ? TextInputType.number
                            : null,
                        inputFormatters: getInputFormatter(),
                        focusNode: focusNode,
                        validator: (value) {
                          if (mandatory) {
                            if (value.isEmpty) {
                              return 'Este campo não pode ser vazio';
                            } else {
                              switch (type) {
                                case 'email':
                                  bool emailValid = RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(value);

                                  if (!emailValid) {
                                    return 'Digite um e-mail válido';
                                  } else {
                                    return null;
                                  }
                                  break;

                                case 'cep':
                                  if (value.length < 10) {
                                    return 'Digite o CEP por completo';
                                  } else {
                                    return null;
                                  }
                                  break;

                                case 'cpf':
                                  if (value.length < 14) {
                                    return 'Digite o CPF por completo';
                                  } else {
                                    return null;
                                  }
                                  break;

                                case 'phone':
                                  if (value.length < 19) {
                                    return 'Digite o número por completo';
                                  } else {
                                    return null;
                                  }
                                  break;

                                default:
                                  return null;
                                  break;
                              }
                            }
                          } else {
                            return null;
                          }
                        },
                        cursorColor: Color(0xff707070),
                        style: TextStyle(
                            fontSize: wXD(17, context),
                            fontWeight: FontWeight.w400,
                            color: Color(0xff707070)),
                        decoration: InputDecoration.collapsed(
                          border: InputBorder.none,
                          hintText: hint,
                          hintStyle: TextStyle(
                              fontSize: wXD(17, context),
                              fontWeight: FontWeight.w600,
                              color: Color(0x30707070)),
                        ),
                        onChanged: (value) {
                          if (type == 'cpf') {
                            store.mapDependentAdd[type] =
                                maskFormatterCpf.getUnmaskedText();
                          } else {
                            if (type == 'cep') {
                              store.mapDependentAdd[type] =
                                  maskFormatterCep.getUnmaskedText();
                            } else {
                              if (type == 'phone') {
                                store.mapDependentAdd[type] =
                                    '+' + maskFormatterPhone.getUnmaskedText();
                              } else {
                                store.mapDependentAdd[type] = value;
                              }
                            }
                          }
                        },
                      )
                    : Observer(
                        builder: (context) {
                          return type == 'gender'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: iconTap,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          store.mapDependentAdd['gender'] !=
                                                  null
                                              ? store.mapDependentAdd['gender']
                                              : 'Ex: Feminino',
                                          style: TextStyle(
                                              fontSize: wXD(17, context),
                                              fontWeight: FontWeight.w400,
                                              color: store.mapDependentAdd[
                                                          'gender'] !=
                                                      null
                                                  ? Color(0xff707070)
                                                  : Color(0x30707070)),
                                        ),
                                      ),
                                    ),
                                    store.genderError
                                        ? Container(
                                            margin: EdgeInsets.only(top: 7),
                                            width: wXD(250, context),
                                            child: Text(
                                              'Este campo não pode ser vazio',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.red[700],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                )
                              : type == 'birthday'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: iconTap,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text(
                                              store.mapDependentAdd[
                                                          'birthday'] !=
                                                      null
                                                  ? store.converterDate(
                                                      store.mapDependentAdd[
                                                          'birthday'])
                                                  : store.converterDate(
                                                      null, true),
                                              style: TextStyle(
                                                  fontSize: wXD(17, context),
                                                  fontWeight: FontWeight.w400,
                                                  color: store.mapDependentAdd[
                                                              'birthday'] !=
                                                          null
                                                      ? Color(0xff707070)
                                                      : Color(0x30707070)),
                                            ),
                                          ),
                                        ),
                                        store.dateError
                                            ? Container(
                                                margin: EdgeInsets.only(top: 7),
                                                width: wXD(250, context),
                                                child: Text(
                                                  'Este campo não pode ser vazio',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.red[700],
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    )
                                  : Container();
                        },
                      ),
                type == 'city' ? CitysField() : Container(),
                type == 'state' ? StatesField() : Container(),
              ],
            );
          },
        ));
  }
}
