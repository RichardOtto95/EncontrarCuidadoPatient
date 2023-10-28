import 'package:flutter/material.dart';

import '../utilities.dart';

// class DoctorNote extends StatelessWidget {
//   final String text;

//   const DoctorNote({Key key, this.text}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: wXD(16, context)),
//         padding: EdgeInsets.symmetric(
//           horizontal: wXD(13, context),
//           vertical: wXD(16, context),
//         ),
//         height: wXD(101, context),
//         width: wXD(334, context),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(7)),
//           border: Border.all(
//             color: Color(0xff707070),
//           ),
//         ),
//         alignment: Alignment.topLeft,
//         child: TextFormField(
//           maxLines: 5,
//           cursorColor: Color(0xff707070),
//           decoration: InputDecoration.collapsed(
//             border: InputBorder.none,
//             hintText: '$text',
//             hintStyle: TextStyle(
//                 height: 1.3,
//                 fontSize: wXD(16, context),
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xff707070).withOpacity(.5)),
//           ),
//         ),
//       ),
//     );
//   }
// }

class DoctorNote extends StatelessWidget {
  final String text;
  final Function onTap;
  final Function onChanged;

  const DoctorNote({
    Key key,
    this.text,
    this.onTap,
    this.onChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: wXD(16, context)),
        padding: EdgeInsets.symmetric(
          horizontal: wXD(13, context),
          vertical: wXD(16, context),
        ),
        height: wXD(101, context),
        width: wXD(334, context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          border: Border.all(
            color: Color(0xff707070),
          ),
        ),
        alignment: Alignment.topLeft,
        child: TextFormField(
          onTap: onTap,
          maxLines: 5,
          cursorColor: Color(0xff707070),
          onChanged: (val) => onChanged(val),
          decoration: InputDecoration.collapsed(
            border: InputBorder.none,
            hintText: '$text',
            hintStyle: TextStyle(
                height: 1.3,
                fontSize: wXD(16, context),
                fontWeight: FontWeight.w600,
                color: Color(0xff707070).withOpacity(.5)),
          ),
        ),
      ),
    );
  }
}
