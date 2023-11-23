import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mikococo/sets/sets_timer.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import 'package:provider/provider.dart';
import '../charts/charts_screen.dart';
import '../charts/stats/Status.dart';
import '../consts/colors.dart';
import '../module/models.dart';
import '../timer/timer.model.dart';
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
          return _SetsScreenContent();
        },
      ),
    );
  }
}

class _SetsScreenContent extends StatefulWidget {
  @override
  _SetsScreenState createState() => _SetsScreenState();
}

class _SetsScreenState extends State<_SetsScreenContent> {
  late SetsScreenStateProvider _setsScreenStateProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setsScreenStateProvider = SetsScreenStateProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: listTileText(title:'Sets ${_setsScreenStateProvider.exercise?.name}'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, CupertinoPageRoute(builder: (context)=> ChartScreen(
                repsData: _setsScreenStateProvider.getRepsData(),
                kgData: _setsScreenStateProvider.getKGData(),
                dates: _setsScreenStateProvider.getSetData().map((data) => data['date'] as DateTime).toList())));
          }, icon:const Icon(Icons.add_chart)),
          IconButton(onPressed: (){
            Navigator.push(context, CupertinoPageRoute(builder: (context)=> StatusScreen(
              bestReps: _setsScreenStateProvider.bestReps.toString(),
              bestKg: _setsScreenStateProvider.bestKg.toString(),
              averageKg: _setsScreenStateProvider.averageKg.toStringAsFixed(2),
              totalReps: _setsScreenStateProvider.totalReps.toString(),
              totalKg: _setsScreenStateProvider.totalKg.toString(),
            )));
          }, icon:const Icon(Icons.webhook_outlined)),
          IconButton(onPressed: (){
            Navigator.push(context, CupertinoPageRoute(builder: (context)=> DummyTimerScreen()));
          }, icon:const Icon(Icons.watch_later)),
        ],
      ),
      body: ValueListenableBuilder<Box<SetsScreenData>>(
        valueListenable: _setsScreenStateProvider.setsBox.listenable(),
        builder: (context, Box<SetsScreenData> box, _) {
          return ListView.builder(
            physics:const BouncingScrollPhysics(),
            itemCount: _setsScreenStateProvider.setKeys.length,
            itemBuilder: (context, index) {
              final setIndex = index;
              final setKey = _setsScreenStateProvider.setKeys[setIndex];
              final set = box.get(setKey)!;
              if (setIndex == 0 || set.date!.day != box.get(_setsScreenStateProvider.setKeys[setIndex - 1])!.date!.day) {
                // Display date ListTile
                final formattedDate = DateFormat('yyyy-MM-dd').format(set.date!);
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ListTile(
                          contentPadding: EdgeInsets.only(left: 15,top: 5,bottom: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: goldenColor,
                          title: listTileText(title: formattedDate,),
                        ),
                      ),
                    ),
                    // Display set ListTile
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Padding(
                        padding:const EdgeInsets.symmetric(horizontal: 5),
                        child: ListTile(
                          contentPadding: EdgeInsets.only(left: 15,top: 5,bottom: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: listTileColor,
                          title: listTileText(title:'Set ${setIndex + 1}:    Reps ${set.reps} x  KG  ${set.kg}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  await _showEditSetBottomSheet(context, setKey, set.reps, set.kg.round());
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _setsScreenStateProvider.deleteSet(setKey);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                // Display set ListTile without the date
                return Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 15,top: 5,bottom: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: listTileColor,
                      title: listTileText(title: 'Set ${setIndex + 1}:   Reps ${set.reps} X KG  ${set.kg}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              await _showEditSetBottomSheet(context, setKey, set.reps, set.kg.round());
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _setsScreenStateProvider.deleteSet(setKey);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showAddSetBottomSheet(context);
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: Consumer<TimerModel>(
        builder: (context, timerModel, _) => BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon:timerModel.isTimerRunning ? Icon(Icons.pause_circle_outline)  : Icon(Icons.play_circle_outline_outlined),
              label: timerModel.selectedBox != -1
                  ? 'Timer: ${timerModel.currentValues[timerModel.selectedBox]}s'
                  : 'Dummy : ${timerModel.dummyTimerValue}',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stop),
              label: 'Stop Timer',
            ),
          ],
          onTap:timerModel.isTimerRunning ? (index){
            if (timerModel.selectedBox != -1 &&
                timerModel.timers[timerModel.selectedBox] != null &&
                timerModel.timers[timerModel.selectedBox]!.isActive) {
              timerModel.stopTimer(timerModel.selectedBox);
            }
            timerModel.stopDummyTimer();
          }: (index) {
            print('isDummy: ${timerModel.isDummy}, selectedBox: ${timerModel.selectedBox}');

            if (timerModel.isDummy) {
              if (index == 0) {
                print('Starting dummy timer');
                timerModel.startDummyTimer(true);
              }
            } else {
              if (index == 0) {
                print('Starting or stopping the timer');
                // Start or stop the timer in TimerScreen for the selected box
                if (timerModel.selectedBox != -1) {
                  if (timerModel.timers[timerModel.selectedBox] != null &&
                      timerModel.timers[timerModel.selectedBox]!.isActive) {
                    print('Stopping the timer');
                    timerModel.stopTimer(timerModel.selectedBox);
                  } else {
                    print('Starting the timer');
                    // Adjust the initial value as needed
                    timerModel.startTimer(timerModel.selectedBox, 45);
                  }
                }
              } else if (index == 1) {
                print('Stopping the timer');
                // Stop the timer for the selected box
                if (timerModel.selectedBox != -1 &&
                    timerModel.timers[timerModel.selectedBox] != null &&
                    timerModel.timers[timerModel.selectedBox]!.isActive) {
                  timerModel.stopTimer(timerModel.selectedBox);
                }
              }
            }
          },


        ),
      ),
    );
  }

  Future<void> _showAddSetBottomSheet(BuildContext context) async {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        int? selectedReps;
        int? selectedKg;

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButton<int>(
                    value: selectedReps,
                    onChanged: (int? newValue) {
                      print("Selected Reps: $newValue");
                      setState(() {
                        selectedReps = newValue;
                      });
                    },
                    items: List.generate(20, (index) {
                      return DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text((index + 1).toString()),
                      );
                    }),
                  ),
                  DropdownButton<int>(
                    value: selectedKg,
                    onChanged: (int? newValue) {
                      print("Selected Kg: $newValue");
                      setState(() {
                        selectedKg = newValue;
                      });
                    },
                    items: List.generate(20, (index) {
                      return DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text((index + 1).toString()),
                      );
                    }),
                  ),
                  ElevatedButton(
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
                    child: Text('Add Set'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showEditSetBottomSheet(BuildContext context, int setKey, int initialReps, int initialKg) async {
    int editedReps = initialReps;
    int editedKg = initialKg;

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButton<int>(
                    value: editedReps,
                    onChanged: (int? newValue) {
                      setState(() {
                        editedReps = newValue!;
                      });
                    },
                    items: List.generate(20, (index) {
                      return DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text((index + 1).toString()),
                      );
                    }),
                  ),
                  DropdownButton<int>(
                    value: editedKg,
                    onChanged: (int? newValue) {
                      setState(() {
                        editedKg = newValue!;
                      });
                    },
                    items: List.generate(20, (index) {
                      return DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text((index + 1).toString()),
                      );
                    }),
                  ),
                  ElevatedButton(
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
                    child: Text('Edit Set'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
