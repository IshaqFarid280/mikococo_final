import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';

Widget emptyBox(
    {required svgPicture, required largetexttitle, required normaltexttitle}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
            children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: listTileColor
            ),
          ),
          Positioned(
            top: 40,
            left: 40,
            child: SvgPicture.asset(
              svgPicture,
              color: greyColor,
              height: 70,
              width: 70,
            ),
          ),
        ]),
        SizedBox(height: 16),
        largeText(
          title: largetexttitle,

          color: greyColor,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18),
          child: Center(
            child: normalText(title: normaltexttitle, textSize: 12.0,
              color: greyColor,),
          ),
        ),
      ],
    ),
  );
}
