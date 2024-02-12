
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mikococo/sets/sets_timer.dart';
import 'package:mikococo/timer/timer_screen.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import 'package:provider/provider.dart';
import '../charts/charts_screen.dart';
import '../charts/stats/Status.dart';
import '../consts/colors.dart';
import '../consts/strnigs.dart';
import '../module/models.dart';
import '../timer/timer.model.dart';
import '../widgets_common/our_button.dart';
import 'SetsProvider.dart';
import 'package:flutter/cupertino.dart';

class SetsScreen extends StatelessWidget {
  final Exercise exercise;

  SetsScreen(this.exercise);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SetsScreenStateProvider(exercise),
      child: Consumer<SetsScreenStateProvider>(
        builder: (context, setsProvider, _) {
         setsProvider.setExercise(exercise); // Set the exercise when it's available
          return SetsScreenContent();
        },
      ),
    );
  }
}

class SetsScreenContent extends StatefulWidget {
  @override
  _SetsScreenState createState() => _SetsScreenState();
}

class _SetsScreenState extends State<SetsScreenContent> {
  late SetsScreenStateProvider _setsScreenStateProvider;




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setsScreenStateProvider = SetsScreenStateProvider.of(context);
  }
  void _showAddSetDialog(DateTime selectedDate) async {

    int? selectedReps;
    int? selectedKg;

    await showModalBottomSheet<void>(
      elevation: 10,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: listTileColor,
          height: MediaQuery.of(context).size.height *
              0.35, // Adjust the height as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      magnification: 1,
                      useMagnifier: true,
                      itemExtent: 70.0,
                      onSelectedItemChanged: (int index) {
                        print("Selected Reps: ${index + 1}");
                        selectedReps = index + 1;
                      },
                      children: List.generate(50, (index) {
                        return Center(
                            child: normalText(
                                title: ('${index + 1}  reps').toString(),
                                textSize: 20.0));
                      }),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      useMagnifier: true,
                      itemExtent: 70.0,
                      onSelectedItemChanged: (int index) {
                        print("Selected Kg: ${index + 1}");
                        selectedKg = index + 1;
                      },
                      children: List.generate(50, (index) {
                        return Center(
                            child: normalText(
                                title: ('${index + 1}  kg').toString(),
                                textSize: 20.0));
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: SubmitButton(
                  onTap: () {
                    print("Add Set Pressed");
                    if (selectedReps != null && selectedKg != null) {
                      _addSetsForDate(selectedDate,selectedReps!.toInt(),selectedKg!.toDouble());
                    }
                    Navigator.of(context).pop();
                  },
                  titlee: 'Validate the Set',
                  primaryColor: goldenColor,
                ),
              ),
            ],
          ),
        );
      },
    );
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: Text('Add Sets for ${DateFormat('MMM d, yyyy').format(selectedDate)}'),
    //       content: Column(
    //         children: [
    //           // Text fields for reps and kg
    //           TextField(
    //             controller: repsController,
    //             keyboardType: TextInputType.number,
    //             decoration: InputDecoration(labelText: 'Reps'),
    //           ),
    //           TextField(
    //             controller: kgController,
    //             keyboardType: TextInputType.number,
    //             decoration: InputDecoration(labelText: 'Kg'),
    //           ),
    //         ],
    //       ),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //           child: Text('Cancel'),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             _addSetsForDate(selectedDate);
    //             Navigator.pop(context);
    //           },
    //           child: Text('Add Sets'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  void _addSetsForDate(DateTime selectedDate, int reps,double kg) {
    // final int reps = int.tryParse(repsController.text) ?? 0;
    // final double kg = double.tryParse(kgController.text) ?? 0.0;
    _setsScreenStateProvider.addSetForDate(selectedDate, reps, kg);
  }

  String  ? exerciseName ;
  String ? exercisePath ;
  @override
  Widget build(BuildContext context) {
    exerciseName = _setsScreenStateProvider.exercise?.name ;
    exercisePath = _setsScreenStateProvider.exercise!.image;
    return Scaffold(
      appBar: AppBar(
        leading: LeadingIcon(),
        centerTitle: true,
        title: normalText(title: appName),
      ),
      body: ValueListenableBuilder<Box<SetsScreenData>>(
        valueListenable: _setsScreenStateProvider.setsBox.listenable(),
        builder: (context, Box<SetsScreenData> box, _) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: normalText(
                      title: _setsScreenStateProvider.exercise?.name,
                      textSize: 18.0),
                  tileColor: listTileLeadingColor,
                  onTap: (){
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => DummyTimerScreen(exerciseName: exerciseName.toString(),exercisePath: exercisePath.toString(),)));
                  },
                  leading: _setsScreenStateProvider.exercise!.image.toString().toString().contains('assets/json')

                    ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Lottie.asset(
                          _setsScreenStateProvider.exercise!.image.toString(),
                          repeat: false,
                        )))
                    : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.height * 0.15,
                      image: FileImage(File(_setsScreenStateProvider.exercise!.image.toString())) as ImageProvider,
                    )),
                ),
              ),

                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.01,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _setsScreenStateProvider.setsByDate.length,
                  itemBuilder: (context, index) {
                    String formattedDate = _setsScreenStateProvider.setsByDate.keys.toList()[index];
                    List<SetsScreenData> setsForDate = _setsScreenStateProvider.setsByDate[formattedDate]!;
                    int totalReps = _setsScreenStateProvider.totalDailyRepsMap[formattedDate] ?? 0;
                    int totalKg = _setsScreenStateProvider.totalDailyKgMap[formattedDate] ?? 0;

                    return Column(
                      children: [
                        // Display date ListTile
                        InkWell(
                          onTap: (){
                            _showAddSetDialog(setsForDate.first.date!);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: MediaQuery.of(context).size.width * 0.85,
                            decoration: BoxDecoration(
                              color: buttonColors,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: listTileText(
                                          title: DateFormat('MMM d').format(setsForDate.first.date!),
                                          textSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(height: 1),
                                      listTileText(
                                        title: DateFormat('yyyy').format(setsForDate.first.date!),
                                        textSize: 14.0,
                                      ),
                                    ],
                                  ),
                                ),
                                normalText(
                                  title: ' Total ',
                                  textSize: 16.0,
                                  color: whiteColor,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    normalText(title: '$totalReps', textSize: 12.0, color: skinColor),
                                    normalText(title: ' reps ', textSize: 12.0, color: skinColor),
                                  ],
                                ),
                                normalText(title: ' X ', textSize: 12.0, color: whiteColor),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    normalText(title: '$totalKg ', textSize: 12.0, color: skinColor),
                                    normalText(title: ' kg ', textSize: 12.0, color: skinColor),
                                  ],
                                ),
                                SizedBox(width: MediaQuery.sizeOf(context).width * 0.01,)
                              ],
                            ),
                          ),
                        ),

                        // Display sets for the current date
                        for (var set in setsForDate)
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              child: Slidable(
                                endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (index) async {
                                        await _showEditSetBottomSheet(context, set.key, set.reps, set.kg.round());
                                      },
                                      backgroundColor: greyColor,
                                      icon: Icons.brush_outlined,
                                    ),
                                    SlidableAction(
                                      onPressed: (index) async {
                                        _setsScreenStateProvider.deleteSet(set.key);
                                      },
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                      backgroundColor: deleteColor,
                                      icon: Icons.delete,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      smallText(
                                        title: 'Set ${setsForDate.indexOf(set) + 1}',
                                        textSize: 14.0,
                                        color: iconColor,
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.15,
                                      ),
                                      normalText(
                                        title: set.reps.toString(),
                                        color: buttonColors,
                                        textSize: 20.0,
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.02,
                                      ),
                                      smallText(title: 'reps'),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.05,
                                      ),
                                      smallText(
                                        title: 'x',
                                        color: iconColor,
                                        textSize: 14.0,
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.05,
                                      ),
                                      normalText(
                                        title: set.kg.toString(),
                                        color: buttonColors,
                                        textSize: 20.0,
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.02,
                                      ),
                                      smallText(title: 'kg'),
                                    ],
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  tileColor: listTileColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: floatingActionButton(
        onTap: () async {
          await _showAddSetBottomSheet(context);
        },
      ),
      bottomNavigationBar: Consumer<TimerModel>(builder: (context, timerModel, _) {
        return Container(
          height: MediaQuery.sizeOf(context).height * 0.065,
          decoration:const  BoxDecoration(
            color: listTileLeadingColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => StatusScreen(
                              bestReps: _setsScreenStateProvider.bestReps
                                  .toString(),
                              bestKg: _setsScreenStateProvider.bestKg
                                  .toString(),
                              averageKg: _setsScreenStateProvider.averageKg
                                  .toStringAsFixed(2),
                              totalReps: _setsScreenStateProvider.totalReps
                                  .toString(),
                              totalKg: _setsScreenStateProvider.totalKg
                                  .toString(),
                              exerciseName: _setsScreenStateProvider
                                  .exercise!.name
                                  .toString(),
                              exercisePath: _setsScreenStateProvider
                                  .exercise!.image
                                  .toString(),
                            )));
                  },
                  icon: const Icon(
                    Icons.stacked_bar_chart_outlined,
                    color: iconColor,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ChartScreen(
                                repsData:
                                _setsScreenStateProvider.getRepsData(),
                                kgData: _setsScreenStateProvider.getKGData(),
                                dates: _setsScreenStateProvider
                                    .getSetData()
                                    .map((data) => data['date'] as DateTime)
                                    .toList())));
                  },
                  icon: const Icon(
                    Icons.poll_outlined,
                    color: iconColor,
                    size: 30,
                  )),
              Container(
                height: MediaQuery.sizeOf(context).height * 0.06,
                width: MediaQuery.sizeOf(context).width * 0.45,
                decoration: BoxDecoration(
                  color: listTileColor,
                  border: Border.all(color: timerModel.isTimerRunning ? buttonColors : iconColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, CupertinoPageRoute(builder: (context)=> TimerScreen()));
                      },
                      child: normalText(
                          title: timerModel.selectedBox != -1
                              ? '00: ${timerModel.currentValues[timerModel.selectedBox]}s'
                              : '00: ${timerModel.dummyTimerValue}',
                          color: timerModel.isTimerRunning
                              ? buttonColors
                              : whiteColor),
                    ),
                    IconButton(
                        onPressed: timerModel.isTimerRunning
                            ? () {
                          if (timerModel.selectedBox != -1 &&
                              timerModel.timers[timerModel.selectedBox] !=
                                  null &&
                              timerModel.timers[timerModel.selectedBox]!
                                  .isActive) {
                            timerModel.stopTimer(timerModel.selectedBox);
                          }
                          timerModel.stopDummyTimer();
                        }
                            : () {
                          print(
                              'isDummy: ${timerModel.isDummy}, selectedBox: ${timerModel.selectedBox}');

                          if (timerModel.isDummy) {
                            print('Starting dummy timer');
                            timerModel.startDummyTimer(true);
                          } else {
                            print('Starting or stopping the timer');
// Start or stop the timer in TimerScreen for the selected box
                            if (timerModel.selectedBox != -1) {
                              if (timerModel.timers[
                              timerModel.selectedBox] !=
                                  null &&
                                  timerModel
                                      .timers[timerModel.selectedBox]!
                                      .isActive) {
                                print('Stopping the timer');
                                timerModel
                                    .stopTimer(timerModel.selectedBox);
                              } else {
                                print('Starting the timer');
// Adjust the initial value as needed
                                timerModel.startTimer(
                                    timerModel.selectedBox, 45);
                              }
                            }
                          }
                        },
                        icon: timerModel.isTimerRunning
                            ? const Icon(
                          Icons.stop_circle_outlined,
                          color: buttonColors,
                          size: 30,
                        )
                            : const Icon(
                          Icons.play_circle_outlined,
                          color: iconColor,
                          size: 30,
                        )),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => DummyTimerScreen(exerciseName: exerciseName.toString(),exercisePath: exercisePath.toString(),)));
                  },
                  icon: const Icon(
                    Icons.more_time_outlined,
                    color: iconColor,
                    size: 30,
                  )),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _showAddSetBottomSheet(BuildContext context) async {
    int? selectedReps;
    int? selectedKg;

    await showModalBottomSheet<void>(
      elevation: 10,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: listTileColor,
          height: MediaQuery.of(context).size.height *
              0.35, // Adjust the height as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      magnification: 1,
                      useMagnifier: true,
                      itemExtent: 70.0,
                      onSelectedItemChanged: (int index) {
                        print("Selected Reps: ${index + 1}");
                        selectedReps = index + 1;
                      },
                      children: List.generate(50, (index) {
                        return Center(
                            child: normalText(
                                title: ('${index + 1}  reps').toString(),
                                textSize: 20.0));
                      }),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      useMagnifier: true,
                      itemExtent: 70.0,
                      onSelectedItemChanged: (int index) {
                        print("Selected Kg: ${index + 1}");
                        selectedKg = index + 1;
                      },
                      children: List.generate(50, (index) {
                        return Center(
                            child: normalText(
                                title: ('${index + 1}  kg').toString(),
                                textSize: 20.0));
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: SubmitButton(
                  onTap: () {
                    print("Add Set Pressed");
                    if (selectedReps != null && selectedKg != null) {
                      final set = SetsScreenData(
                        selectedReps!,
                        selectedKg!.toDouble(),
                        DateTime.now(),
                        _setsScreenStateProvider.exercise!.key,
                      );
                      print("Adding Set: $set");
                      _setsScreenStateProvider.addSet(set);
                    }
                    Navigator.of(context).pop();
                  },
                  titlee: 'Validate the Set',
                  primaryColor: goldenColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showEditSetBottomSheet(
      BuildContext context, int setKey, int initialReps, int initialKg) async {
    int editedReps = initialReps;
    int editedKg = initialKg;

    await showModalBottomSheet<void>(
      elevation: 10,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: listTileColor,
          height: MediaQuery.of(context).size.height *
              0.35, // Adjust the height as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoPicker(
                        magnification: 1,
                        useMagnifier: true,
                        itemExtent: 70.0,
                        onSelectedItemChanged: (int index) {
                          print("Edited Reps: ${index + 1}");
                          editedReps = index + 1;
                        },
                        children: List.generate(50, (index) {
                          return Center(
                              child: normalText(
                                  title: ('${index + 1}  reps').toString(),
                                  textSize: 20.0));
                        }),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoPicker(
                        magnification: 1,
                        useMagnifier: true,
                        itemExtent: 70.0,
                        onSelectedItemChanged: (int index) {
                          print("Edited Kg: ${index + 1}");
                          editedKg = index + 1;
                        },
                        children: List.generate(50, (index) {
                          return Center(
                              child: normalText(
                                  title: ('${index + 1}  kg').toString(),
                                  textSize: 20.0));
                        }),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: ourButton(
                  onPressed: () {
                    final editedSet = SetsScreenData(
                      editedReps,
                      editedKg.toDouble(),
                      DateTime.now(),
                      _setsScreenStateProvider.exercise?.key,
                    );
                    _setsScreenStateProvider.editSet(setKey, editedSet);
                    Navigator.of(context).pop();
                  },
                  title: 'Edit the set',
                  textColor: whiteColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
