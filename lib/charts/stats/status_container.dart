import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.43,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        largeText(
                          title: getImageTitleLine(exerciseName, 0),
                          color: whiteColor,
                          textSize: 20.0,
                        ),
                        SizedBox(height: 8),
                        largeText(
                          title: getImageTitleLine(exerciseName, 1),
                          color: goldenColor,
                          textSize: 18.0,
                        ),
                        SizedBox(height: 8),
                        largeText(
                          title: getImageTitleLine(exerciseName, 2),
                          color: whiteColor,
                          textSize: 18.0,
                        ),
                      ],
                    ),
                  ),
                ),
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

              ),
            child:     exerciseImagePath.contains('assets/json')
                ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                width:MediaQuery.sizeOf(context).width * 0.35,
                height:140,
                child: Lottie.asset(
                  exerciseImagePath.toString(),
                  repeat: false,
                  fit: BoxFit.cover,
                ))
                : Container(
                clipBehavior: Clip.antiAlias,
                width:MediaQuery.sizeOf(context).width * 0.35,
                height:140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    isAntiAlias:true,
                    image: FileImage(File(
                        exerciseImagePath.toString())) as ImageProvider,
                  ),)
            ),
              ),


          // exerciseImagePath.contains('assets/json')
          //     ? Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     clipBehavior: Clip.antiAlias,
          //     width:MediaQuery.sizeOf(context).width * 0.35,
          //     height:140,
          //     child: Lottie.asset(
          //       exerciseImagePath.toString(),
          //       repeat: false,
          //       fit: BoxFit.cover,
          //     ))
          //     : Container(
          //     clipBehavior: Clip.antiAlias,
          //     width:MediaQuery.sizeOf(context).width * 0.35,
          //     height:140,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       image: DecorationImage(
          //         isAntiAlias:true,
          //         image: FileImage(File(
          //             exerciseImagePath.toString())) as ImageProvider,
          //       ),)
          // ),
        ],
      ),
    );
  }
  String getImageTitleLine(String? title, int lineIndex) {
    if (title == null) return '';
    final words = title.split(' ');

    final start = lineIndex * 2;
    if (start >= words.length) return ''; // Check if start index is out of bounds

    final end = (lineIndex + 1) * 2;
    return words.sublist(start, min(end, words.length)).join(' ');
  }
}
