import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/consts/strnigs.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import 'package:provider/provider.dart';
import '../timer/timer.model.dart';
import 'Sets_timer_button.dart';
import 'sets_scren_top_listTile.dart';

class DummyTimerScreen extends StatefulWidget {
  final String  exerciseName ;
  final String exercisePath ;
  DummyTimerScreen({required this.exercisePath, required this.exerciseName});

  @override
  State<DummyTimerScreen> createState() => _DummyTimerScreenState();
}

class _DummyTimerScreenState extends State<DummyTimerScreen> {
  TextEditingController goalsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final timerModel = Provider.of<TimerModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: LeadingIcon(),
        centerTitle: true,
        title: normalText(title: appName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
            SetsScreenTopListTile(exerciseName: widget.exerciseName,exercisePath: widget.exercisePath,),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SetsTimerButton(onTap:(){
                  timerModel.increaseDummyTimer();},
                icon: Icons.add,),
                SizedBox(width: MediaQuery.sizeOf(context).width * 0.03,),
                largeText(title:'00 : ${timerModel.dummyTimerValue}',color:timerModel.isTimerRunning ? goldenColor :whiteColor),
                SizedBox(width: MediaQuery.sizeOf(context).width * 0.03,),
                SetsTimerButton(onTap:(){
                  timerModel.decreaseDummyTimer();
                }, icon: Icons.remove,),
              ],
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),

          ],
        ),
      ),
    );
  }
}
