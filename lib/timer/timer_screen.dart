import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mikococo/Gate_way_screen/buttom_navigation_screens.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/routine/MyRoutineClass.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () { Navigator.of(context).pop();},
          )
      ),

      body: Column(
        children: [
          Text('Timer')
        ],
      ),


    );
  }
}
