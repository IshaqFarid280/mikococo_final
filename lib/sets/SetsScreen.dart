
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mikococo/sets/sets_scren_top_listTile.dart';
import 'package:mikococo/sets/sets_timer.dart';
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
          setsProvider
              .setExercise(exercise); // Set the exercise when it's available
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
                SetsScreenTopListTile(exerciseName: _setsScreenStateProvider.exercise?.name,exercisePath:_setsScreenStateProvider.exercise!.image,),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.01,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _setsScreenStateProvider.setKeys.length,
                  itemBuilder: (context, index) {
                    final setIndex = index;
                    final setKey = _setsScreenStateProvider.setKeys[setIndex];
                    final set = box.get(setKey)!;
                    if (setIndex == 0 ||
                        set.date!.day !=
                            box
                                .get(_setsScreenStateProvider
                                    .setKeys[setIndex - 1])!
                                .date!
                                .day) {
                      // Display date ListTile
                      final formattedDate =
                          DateFormat('MMMM  d, yyyy').format(set.date!);
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.02,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 35,
                            width: MediaQuery.sizeOf(context).width * 0.85,
                            decoration: BoxDecoration(
                              color: buttonColors,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: listTileText(
                              title: '$formattedDate    ${_setsScreenStateProvider.totalRepsDay} reps  x   ${_setsScreenStateProvider.totalKgDay} kgs'
                            )),
                          ),
                          // Display set ListTile
                          SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              child: Slidable(
                              endActionPane:ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(onPressed: (index) async {
                                 await _showEditSetBottomSheet(context, setKey, set.reps, set.kg.round());
                               },
                                    backgroundColor: greyColor,
                                    icon: Icons.brush_outlined,),
                                  SlidableAction(onPressed: (index) async {
                                    _setsScreenStateProvider.deleteSet(setKey);
                                  },
                                    borderRadius:const BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    backgroundColor: deleteColor,
                                    icon: Icons.delete,),
                                ],
                              ),
                                child: ListTile(
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      smallText(
                                          title: 'Set ${setIndex + 1}',
                                          textSize: 14.0,
                                          color: iconColor),
                                      SizedBox(
                                        width: MediaQuery.sizeOf(context).width *
                                            0.15,
                                      ),
                                      normalText(
                                          title: set.reps.toString(),
                                          color: buttonColors,
                                          textSize: 20.0),
                                      SizedBox(
                                        width: MediaQuery.sizeOf(context).width *
                                            0.02,
                                      ),
                                      smallText(title: 'reps'),
                                      SizedBox(
                                        width: MediaQuery.sizeOf(context).width *
                                            0.05,
                                      ),
                                      smallText(
                                          title: 'x',
                                          color: iconColor,
                                          textSize: 14.0),
                                      SizedBox(
                                        width: MediaQuery.sizeOf(context).width *
                                            0.05,
                                      ),
                                      normalText(
                                          title: set.kg.toString(),
                                          color: buttonColors,
                                          textSize: 20.0),
                                      SizedBox(
                                        width: MediaQuery.sizeOf(context).width *
                                            0.02,
                                      ),
                                      smallText(title: 'kg'),
                                    ],
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: 15, top: 5, bottom: 5),
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
                    } else {
                      // Display set ListTile without the date
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          child: Slidable(
                            endActionPane:ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(onPressed: (index) async {
                                  await _showEditSetBottomSheet(context, setKey, set.reps, set.kg.round());
                                },backgroundColor: greyColor,
                                  icon: Icons.brush_outlined,),
                                SlidableAction(onPressed: (index) async {
                                  _setsScreenStateProvider.deleteSet(setKey);
                                },
                                  borderRadius:const BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  backgroundColor: deleteColor,
                                  icon: Icons.delete,),
                              ],
                            ),
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.only(left: 15, top: 5, bottom: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              tileColor: listTileColor,
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  smallText(
                                      title: 'Set ${setIndex + 1}',
                                      textSize: 14.0,
                                      color: iconColor),
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.15,
                                  ),
                                  normalText(
                                      title: set.reps.toString(),
                                      color: buttonColors,
                                      textSize: 20.0),
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.02,
                                  ),
                                  smallText(title: 'reps'),
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.05,
                                  ),
                                  smallText(
                                      title: 'x',
                                      color: iconColor,
                                      textSize: 14.0),
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.05,
                                  ),
                                  normalText(
                                      title: set.kg.toString(),
                                      color: buttonColors,
                                      textSize: 20.0),
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.02,
                                  ),
                                  smallText(title: 'kg'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
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
      bottomNavigationBar:
          Consumer<TimerModel>(builder: (context, timerModel, _) {
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
                    normalText(
                        title: timerModel.selectedBox != -1
                            ? '00: ${timerModel.currentValues[timerModel.selectedBox]}s'
                            : '00: ${timerModel.dummyTimerValue}',
                        color: timerModel.isTimerRunning
                            ? buttonColors
                            : whiteColor),
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
                      children: List.generate(100, (index) {
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
                child: ourButton(
                  onPressed: () {
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
                  title: 'Validate the Set',
                  textColor: whiteColor,
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
                        children: List.generate(100, (index) {
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
