import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';




class StatusContainer extends StatelessWidget {
  String title1 ;
  String title2 ;
  Color color ;
    StatusContainer({required this.title1,required this.title2,required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: MediaQuery.sizeOf(context).width * 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.03,),
          normalText(title: title1,textSize: 18.0,),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.03,),
          largeText(title: title2,textSize: 22.0)

        ],
      ),
    );
  }
}


class ExerciseStatusContainer extends StatelessWidget {
  final String exerciseName;
  final String exerciseImagePath;
  ExerciseStatusContainer ({required this.exerciseName,required this.exerciseImagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width:MediaQuery.sizeOf(context).width * 1,
      height: 150,
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
                normalText(title: 'All Rounds Included',textSize: 16.0,weight: FontWeight.w300,),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right:5),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            height:140,
              width:MediaQuery.sizeOf(context).width * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: listTileLeadingColor,
                image: DecorationImage(image:exerciseImagePath.contains('assets/images') ? AssetImage(exerciseImagePath.toString(),) : FileImage(File(exerciseImagePath.toString()),) as ImageProvider,isAntiAlias: true,fit: BoxFit.cover) ,
              ),
              ),
        ],
      ),
    );
  }
}
