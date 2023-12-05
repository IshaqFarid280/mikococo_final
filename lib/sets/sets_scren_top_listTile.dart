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
    return Container(
      clipBehavior: Clip.antiAlias,
      width:MediaQuery.sizeOf(context).width * 1,
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color:listTileColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                largeText(title: exerciseName,textSize:24.0),
                const  SizedBox(height:15,),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right:5),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            height:120,
            width:MediaQuery.sizeOf(context).width * 0.35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: listTileLeadingColor,
              image: DecorationImage(image:exercisePath.toString().contains('assets/images') ? AssetImage(exercisePath.toString(),) : FileImage(File(exercisePath.toString()),) as ImageProvider,isAntiAlias: true,fit: BoxFit.cover) ,
            ),
          ),
        ],
      ),
    );
  }
}