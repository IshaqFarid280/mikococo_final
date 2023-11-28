import 'dart:io';

import 'package:flutter/material.dart';

import '../consts/colors.dart';
import '../widgets_common/text_widgets.dart';



class SetsScreenTopListTile extends StatelessWidget {
   SetsScreenTopListTile({required this.exerciseName,required this.exercisePath,});
   final String  ? exerciseName ;
   final String ? exercisePath ;
   // final String goals ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListTile(
        contentPadding:
        const EdgeInsets.only(left: 15, top: 5, bottom: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: normalText(
            title: exerciseName,
            textSize: 22.0,
            weight: FontWeight.bold),
        tileColor: listTileLeadingColor,
        // subtitle: smallText(title: goals,color: iconColor),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: exercisePath.toString()
              .toString()
              .contains('assets/images')
              ? AssetImage(
            exercisePath.toString(),
          )
              : FileImage(File(exercisePath.toString())) as ImageProvider,
          //
        ),
      ),
    );
  }
}
