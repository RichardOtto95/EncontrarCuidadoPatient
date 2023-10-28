import 'package:encontrarCuidado/app/modules/profile/profile_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'float_menu_city.dart';
import 'float_menu_states.dart';

class DataTileProfile extends StatelessWidget {
  @required
  final String type;
  final FocusNode focusNode;
  final String title;
  final String hint;
  final Function onChanged;
  final Function iconTap;
  final bool mandatory;
  final Function onEditingComplete;
  final String initialValue;
  final Function onTap;

  const DataTileProfile({
    Key key,
    this.title,
    this.onChanged,
    this.hint = '',
    this.iconTap,
    this.focusNode,
    this.type,
    this.mandatory = false,
    this.onEditingComplete,
    this.initialValue,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileStore store = Modular.get();

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

    TextInputType getKeyboardType() {
      if (type == 'cpf' ||
          type == 'cep' ||
          type == 'phone' ||
          type == 'numberAddress') {
        return TextInputType.number;
      } else {
        return null;
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
                      child: type != 'country' && type != 'phone'
                          ? InkWell(
                              onTap: iconTap == null
                                  ? () {
                                      focusNode.requestFocus();
                                    }
                                  : () {
                                      iconTap();
                                    },
                              child: Icon(
                                Icons.edit,
                                color: Color(0xff95989A),
                                size: wXD(17, context),
                              ),
                            )
                          : Container()),
                ],
              ),
              SizedBox(
                height: wXD(5, context),
              ),
              type != 'gender' &&
                      type != 'birthday' &&
                      type != 'city' &&
                      type != 'state'
                  ? TextFormField(
                      enabled:
                          type == 'country' || type == 'phone' ? false : true,
                      autocorrect: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      initialValue: store.getMask(initialValue, type),
                      onEditingComplete: onEditingComplete,
                      inputFormatters: getInputFormatter(),
                      keyboardType: getKeyboardType(),
                      focusNode: focusNode,
                      textCapitalization: type == 'email' ||
                              type == 'email2' ||
                              type == 'social'
                          ? TextCapitalization.none
                          : type != 'fullname'
                              ? TextCapitalization.sentences
                              : TextCapitalization.words,
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

                              case 'email2':
                                bool emailValid = true;

                                if (store.email != null) {
                                  emailValid = store.email.toLowerCase() ==
                                      store.mapPatient['email'].toLowerCase();
                                }
                                if (!emailValid) {
                                  return 'Os e-mails estão diferentes';
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
                          fontWeight: FontWeight.w600,
                          color: Color(0xfa707070)),
                      decoration: InputDecoration.collapsed(
                        hintText: hint,
                        hintStyle: TextStyle(
                            fontSize: wXD(17, context),
                            fontWeight: FontWeight.w600,
                            color: Color(0x30707070)),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if (type == 'cpf') {
                          onChanged(maskFormatterCpf.getUnmaskedText());
                        } else {
                          if (type == 'cep') {
                            onChanged(maskFormatterCep.getUnmaskedText());
                          } else {
                            onChanged(value);
                          }
                        }
                      },
                    )
                  : type != 'city' && type != 'state'
                      ? Observer(
                          builder: (context) {
                            return InkWell(
                              onTap: iconTap,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: wXD(250, context),
                                    child: Text(
                                      type == 'gender'
                                          ? store.mapPatient['gender'] != null
                                              ? store.mapPatient['gender']
                                              : hint
                                          : store.getMask(
                                                      store.mapPatient[
                                                          'birthday'],
                                                      type) !=
                                                  null
                                              ? store.getMask(
                                                  store.mapPatient['birthday'],
                                                  type)
                                              : hint,
                                      style: TextStyle(
                                        fontSize: wXD(17, context),
                                        fontWeight: FontWeight.w600,
                                        color: type == 'gender'
                                            ? store.mapPatient['gender'] != null
                                                ? Color(0xff707070)
                                                : Color(0x30707070)
                                            : store.mapPatient['birthday'] !=
                                                    null
                                                ? Color(0xff707070)
                                                : Color(0x30707070),
                                      ),
                                    ),
                                  ),
                                  store.genderError && type == 'gender'
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
                                  store.dateError && type != 'gender'
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
                              ),
                            );
                          },
                        )
                      : Container(),
              type == 'city' ? CitysField() : Container(),
              type == 'state' ? StatesField() : Container(),
            ],
          );
        },
      ),
    );
  }
}
