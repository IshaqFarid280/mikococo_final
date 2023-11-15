import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';




Widget largeText({title, Color color = Colors.white,  context,textSize,FontWeight weight = FontWeight.bold}) {
  double screenWidth = MediaQuery.of(context).size.width;
  textSize = screenWidth < 600 ? 18.0 : 20.0;
  return Text(
    title,
    style: TextStyle(color: color, fontSize: textSize,fontWeight: weight),
  );
}


Widget normalText({title, Color color = Colors.white,  context,textSize,FontWeight weight = FontWeight.w700}) {
  double screenWidth = MediaQuery.of(context).size.width;
  textSize = screenWidth < 600 ? 14.0 : 16.0;
  return Text(
    title,
    style: TextStyle(color: color, fontSize: textSize,fontWeight: weight),
  );
}

Widget smallText({title, Color color = Colors.white,  context,textSize,FontWeight weight = FontWeight.w500}) {
  double screenWidth = MediaQuery.of(context).size.width;
  textSize = screenWidth < 600 ? 10.0 : 12.0;
  return Text(
    title,
    style: TextStyle(color: color, fontSize: textSize,fontWeight: weight),
  );
}

Widget listTileText({title, Color color = Colors.white,  context,textSize,FontWeight weight = FontWeight.bold}) {
  return Text(
    title,
    style: TextStyle(color: color, fontSize: textSize,fontWeight: weight),
  );
}