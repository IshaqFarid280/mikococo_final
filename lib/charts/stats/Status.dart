

import 'package:flutter/material.dart';
import 'package:mikococo/charts/stats/status_container.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/consts/strnigs.dart';
import 'package:mikococo/widgets_common/our_button.dart';

import '../../widgets_common/text_widgets.dart';

class StatusScreen extends StatelessWidget {
  final String  totalReps ; // Replace with your actual data
  final String  totalKg  ;// Replace with your actual data
  final String  averageKg ;// Replace with your actual data
  final String bestReps  ;// Replace with your actual data
  final String bestKg  ;// Replace with your actual data
  final String exerciseName  ;
  final String  exercisePath ;

  StatusScreen({required this.totalKg,required this.totalReps,required this.averageKg ,required this.bestKg,required this.bestReps,required this.exerciseName,required this.exercisePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: LeadingIcon(),
        title: normalText(title: appName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics:const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
              normalText(title: 'Statistics',textSize: 22.0),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
              ExerciseStatusContainer(exerciseName: exerciseName.toString(),exerciseImagePath: exercisePath.toString(),),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.03,),
              StatusContainer(title1: 'My Total Reps', title2:'Total Reps  $totalReps ' , color: statusContainer1),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
              StatusContainer(title1: 'My Total Weight', title2:'Total Kgs  $totalKg ' , color: statusContainer2),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
              StatusContainer(title1: 'My Average', title2:'Reps  Kgs  $averageKg ' , color: statusContainer3),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
              StatusContainer(title1: 'My Best Resp', title2:'Highest Resp  $bestReps' , color: statusContainer1),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
              StatusContainer(title1: 'My Best Weight', title2:'Highest Kgs  $bestKg' , color: statusContainer2),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
            ],
          ),
        ),
      ),
    );
  }
}