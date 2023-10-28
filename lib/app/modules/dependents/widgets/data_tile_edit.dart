import 'package:encontrarCuidado/app/modules/dependents/dependents_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'float_menu_city_edit.dart';
import 'float_menu_state_edit.dart';

class DataTileEdit extends StatelessWidget {
  @required
  final String title;
  final String hint;
  final Function onChanged;
  final Function iconTap;
  final FocusNode focusNode;
  final bool mandatory;
  final String type;
  final String initialValue;
  final Function onEditingComplete;

  const DataTileEdit({
    Key key,
    this.title,
    this.onChanged,
    this.hint = '',
    this.iconTap,
    this.focusNode,
    this.mandatory = false,
    this.type,
    this.initialValue,
    this.onEditingComplete,
  }) : super(key: key);

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
          return null;
          break;
      }
    }

    TextInputType getKeyboardType() {
      if (type == 'cpf' || type == 'cep' || type == 'phone') {
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
                        child: InkWell(
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
                        )),
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
                        onEditingComplete: onEditingComplete,
                        initialValue: store.getMask(initialValue, type),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        autocorrect: true,
                        inputFormatters: getInputFormatter(),
                        keyboardType: getKeyboardType(),
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
                          switch (type) {
                            case 'cpf':
                              store.mapDependentUpdate[type] =
                                  maskFormatterCpf.getUnmaskedText();

                              break;

                            case 'cep':
                              store.mapDependentUpdate[type] =
                                  maskFormatterCep.getUnmaskedText();

                              break;

                            case 'phone':
                              store.mapDependentUpdate[type] =
                                  '+' + maskFormatterPhone.getUnmaskedText();

                              break;
                            default:
                              store.mapDependentUpdate[type] = value;
                              break;
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
                                      onTap: () {
                                        iconTap();
                                      },
                                      child: Container(
                                        width: wXD(250, context),
                                        child: Text(
                                          store.mapDependentUpdate['gender'] !=
                                                  null
                                              ? store
                                                  .mapDependentUpdate['gender']
                                              : initialValue != null
                                                  ? initialValue
                                                  : hint,
                                          style: TextStyle(
                                            fontSize: wXD(17, context),
                                            fontWeight: FontWeight.w600,
                                            color: store.mapDependentUpdate[
                                                            'gender'] ==
                                                        null &&
                                                    initialValue == null
                                                ? Color(0x30707070)
                                                : Color(0xfa707070),
                                          ),
                                        ),
                                      ),
                                    ),
                                    store.genderErrorEdit
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
                                            onTap: () {
                                              iconTap();
                                            },
                                            child: Container(
                                              width: wXD(250, context),
                                              child: Text(
                                                store.mapDependentUpdate[
                                                            'birthday'] !=
                                                        null
                                                    ? store.converterDate(store
                                                            .mapDependentUpdate[
                                                        'birthday'])
                                                    : initialValue != null
                                                        ? initialValue
                                                        : store.converterDate(
                                                            null, true),
                                                style: TextStyle(
                                                  fontSize: wXD(17, context),
                                                  fontWeight: FontWeight.w600,
                                                  color: store.mapDependentUpdate[
                                                                  'birthday'] ==
                                                              null &&
                                                          initialValue == null
                                                      ? Color(0x30707070)
                                                      : Color(0xfa707070),
                                                ),
                                              ),
                                            )),
                                        store.dateErrorEdit
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
                type == 'city' ? CitysFieldEdit() : Container(),
                type == 'state' ? StatesFieldEdit() : Container(),
              ],
            );
          },
        ));
  }
}
