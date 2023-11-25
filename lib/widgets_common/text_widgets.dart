import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';

Widget largeText(
    {title,
    Color color = Colors.white,
    textSize = 20.0,
    FontWeight weight = FontWeight.bold}) {
  return AutoSizeText(
    title,
    style: TextStyle(color: color, fontSize: textSize, fontWeight: weight, fontFamily: "Poppins"),
  );
}

Widget normalText(
    {title,
    Color color = Colors.white,
    textSize = 16.0,
    FontWeight weight = FontWeight.w700}) {
  return AutoSizeText(
    title,
    style: TextStyle(color: color, fontSize: textSize, fontWeight: weight, fontFamily: "Poppins"),
  );
}

Widget smallText(
    {title,
    Color color = Colors.white,
    textSize = 12.0,
    FontWeight weight = FontWeight.w500}) {
  return AutoSizeText(
    title,
    style: TextStyle(color: color, fontSize: textSize, fontWeight: weight, fontFamily: "Poppins"),
  );
}

Widget listTileText(
    {title,
    Color color = Colors.white,
    textSize,
    FontWeight weight = FontWeight.bold}) {
  return AutoSizeText(
    title,
    style: TextStyle(color: color, fontSize: textSize, fontWeight: weight, fontFamily: "Poppins"),
  );
}

Widget textFormField(
    {required BuildContext context, text, controller, labelText, hint}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .001,
        ),
        AutoSizeText(
          text,
          style: TextStyle(color: whiteColor, fontSize: 12, fontFamily: "Poppins"),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .01,
        ),
        TextFormField(
          cursorColor: whiteColor,
          controller: controller,
          style: TextStyle(
            color: whiteColor,
              fontFamily: "Poppins"
          ),
          decoration: InputDecoration(


            labelText: labelText,
            labelStyle: TextStyle(
              color: whiteColor,
              fontSize: 14
            ),
            hintText: hint,
            hintStyle: TextStyle(
              color: whiteColor,
              fontSize: 14,
              fontWeight: FontWeight.w100
            ),
            isDense: true,
            fillColor: Colors.transparent,
            filled: true,
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: greyColor, width: 0.0),
            ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: greyColor
                  )
              )
          ),
        ),
      ],
    ),
  );
}
