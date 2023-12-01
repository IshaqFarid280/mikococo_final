import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/consts/strnigs.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import 'package:provider/provider.dart';
import '../timer/timer.model.dart';
import 'Sets_timer_button.dart';
import 'sets_scren_top_listTile.dart';

class DummyTimerScreen extends StatefulWidget {
  final String exerciseName;
  final String exercisePath;
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
            // SetsScreenTopListTile(exerciseName: widget.exerciseName,exercisePath: widget.exercisePath,),

            Container(
              height: MediaQuery.sizeOf(context).height * 0.25,
              width: MediaQuery.sizeOf(context).width * 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: listTileLeadingColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.43,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          largeText(
                            title: getImageTitleLine(widget.exerciseName, 0),
                            color: whiteColor,
                            textSize: 20.0,
                          ),
                          SizedBox(height: 8),
                          largeText(
                            title: getImageTitleLine(widget.exerciseName, 1),
                            color: goldenColor,
                            textSize: 18.0,
                          ),
                          SizedBox(height: 8),
                          largeText(
                            title: getImageTitleLine(widget.exerciseName, 2),
                            color: whiteColor,
                            textSize: 18.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: widget.exercisePath
                        .toString()
                        .contains('assets/json')
                        ? Container(
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        clipBehavior: Clip.antiAlias,
                        height: MediaQuery.sizeOf(context).height * 0.21,
                        width: MediaQuery.sizeOf(context).width * 0.45,
                        child: Lottie.asset(
                          widget.exercisePath.toString(),
                          repeat: true,
                          fit: BoxFit.cover,
                        ))
                        : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.22,
                          width: MediaQuery.sizeOf(context).width * 0.45,

                          margin: EdgeInsets.only(right: 8),
                          child: Image(

                            fit: BoxFit.cover,
                            image: FileImage(File(
                                widget.exercisePath.toString())) as ImageProvider,
                          ),
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: leadingBtnColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: goldenColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: whiteColor,
                      ),
                      onPressed: () {
                        timerModel.decreaseDummyTimer();
                      },
                    ),
                    largeText(
                        title: '00 : ${timerModel.dummyTimerValue}',
                        color: timerModel.isTimerRunning
                            ? goldenColor
                            : whiteColor),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: whiteColor,
                      ),
                      onPressed: () {
                        timerModel.increaseDummyTimer();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
          ],
        ),
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
