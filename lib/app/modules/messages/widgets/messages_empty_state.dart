import 'package:encontrarCuidado/app/shared/color_theme.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MessagesEmptyState extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const MessagesEmptyState(
      {Key key, this.image, this.title, this.description, int height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxHeight(context) - wXD(255, context),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                height: wXD(285, context),
                width: wXD(285, context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: wXD(80, context),
                        ),
                        SvgPicture.asset(
                          "./assets/svg/doctorexplains.svg",
                          semanticsLabel: 'Acme Logo',
                          height: wXD(293, context),
                          width: wXD(247, context),
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(
                "./assets/svg/explanations.svg",
                semanticsLabel: 'Acme Logo',
                height: wXD(285, context),
                width: wXD(285, context),
                fit: BoxFit.cover,
              ),
            ],
          ),
          // SizedBox(height: wXD(60, context)),
          Container(
            margin: EdgeInsets.symmetric(horizontal: wXD(20, context)),
            alignment: Alignment.center,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorTheme.textGrey,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
