import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';

import 'edit_address.dart';

class Address extends StatefulWidget {
  final bool principal;
  final String address;
  final String city;
  final String cep;
  final String state;

  const Address({
    Key key,
    this.principal = false,
    this.address,
    this.city,
    this.cep,
    this.state,
  }) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: wXD(20, context),
      ),
      padding: EdgeInsets.symmetric(
        vertical: wXD(15, context),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0x70707070),
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 3,
          ),
          Container(
            width: wXD(330, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.principal
                    ? Container(
                        margin: EdgeInsets.only(bottom: wXD(15, context)),
                        height: wXD(19, context),
                        width: wXD(117, context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                          border: Border.all(
                            color: Color(0xff707070),
                          ),
                          color: Color(0xffcecece).withOpacity(.32),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Principal',
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Container(),
                Text(
                  '${widget.address}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xff707070),
                  ),
                ),
                Text(
                  '${widget.city}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xff707070),
                  ),
                ),
                Text(
                  '${widget.state}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xff707070),
                  ),
                ),
                Text(
                  '${widget.cep}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xff707070),
                  ),
                ),
                SizedBox(
                  height: wXD(15, context),
                ),
                Row(
                  children: [
                    Container(
                      height: wXD(25, context),
                      width: wXD(80, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                        border: Border.all(
                          color: Color(0xff2185D0),
                        ),
                        color: Color(0xfffafafa),
                      ),
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => EditAddress()),
                        ),
                        child: Text(
                          'Editar',
                          style: TextStyle(
                            color: Color(0xff2185D0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: wXD(8, context)),
                      height: wXD(25, context),
                      width: wXD(80, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                        border: Border.all(
                          color: Color(0xff2185D0),
                        ),
                        color: Color(0xfffafafa),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Remover',
                        style: TextStyle(
                          color: Color(0xffDB2828),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    widget.principal
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(left: wXD(8, context)),
                            height: wXD(25, context),
                            width: wXD(149, context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                              border: Border.all(
                                color: Color(0xff2185D0),
                              ),
                              color: Color(0xfffafafa),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Definir como principal',
                              style: TextStyle(
                                color: Color(0xff2185D0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
