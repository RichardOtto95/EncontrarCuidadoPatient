import 'package:encontrarCuidado/app/shared/color_theme.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class LoadCircularOverlay extends StatelessWidget {
  const LoadCircularOverlay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorTheme.totalBlack.withOpacity(.5),
      height: maxHeight(context),
      width: maxWidth(context),
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}
