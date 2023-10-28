import 'package:flutter/material.dart';

class DataTile extends StatelessWidget {
  @required
  @required
  final String title;
  final String hint;
  final bool enabled;
  final bool noIcon;
  final Function onChanged;
  final Function iconTap;
  final FocusNode focusNode;

  const DataTile({
    Key key,
    this.title,
    this.enabled = true,
    this.onChanged,
    this.hint = '',
    this.noIcon = false,
    this.iconTap,
    this.focusNode,
  }) : super(key: key);

  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '$title',
                style: TextStyle(
                    fontSize: wXD(17, context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xff95989A)),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: wXD(13, context)),
                child: InkWell(
                  onTap: iconTap,
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
          TextFormField(
            focusNode: focusNode,
            enabled: enabled,
            cursorColor: Color(0xff707070),
            style: TextStyle(
                fontSize: wXD(17, context),
                fontWeight: FontWeight.w400,
                color: Color(0xff707070)),
            decoration: InputDecoration.collapsed(
              border: InputBorder.none,
              hintText: '$hint',
              hintStyle: TextStyle(
                fontSize: wXD(17, context),
                fontWeight: FontWeight.w600,
                color: enabled ? Color(0x30707070) : Color(0xfa707070),
              ),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
