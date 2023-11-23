import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';





Widget largeText({title, Color color = Colors.white,textSize = 20,FontWeight weight = FontWeight.bold}) {
  return AutoSizeText(
    title,
    style: TextStyle(color: color, fontSize: textSize,fontWeight: weight),
  );
}


Widget normalText({title, Color color = Colors.white,textSize = 14,FontWeight weight = FontWeight.w700}) {
  return AutoSizeText(
    title,
    style: TextStyle(color: color, fontSize: textSize,fontWeight: weight),
  );
}

Widget smallText({title, Color color = Colors.white,textSize = 12,FontWeight weight = FontWeight.w500}) {

  return AutoSizeText (
    title,
    style: TextStyle(color: color, fontSize: textSize,fontWeight: weight),
  );
}

Widget listTileText({title, Color color = Colors.white,textSize,FontWeight weight = FontWeight.bold}) {
  return AutoSizeText(
    title,
    style: TextStyle(color: color, fontSize: textSize,fontWeight: weight),
  );
}