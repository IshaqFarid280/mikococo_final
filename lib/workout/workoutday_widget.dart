import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';



class WorkoutdayContainer extends StatelessWidget {
  final String routineName;
  WorkoutdayContainer ({required this.routineName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        width:MediaQuery.sizeOf(context).width * 1,
        height: 112,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color:buttonColors,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  largeText(title: 'Workout Days',textSize:22.0),
                  const  SizedBox(height:15,),
                  normalText(title: routineName,textSize: 14.0,weight: FontWeight.w300),
                ],
              ),
            ),
            Image.asset('assets/images/nagaIshaq.png',isAntiAlias: true,),
          ],
        ),
      ),
    );
  }
}
