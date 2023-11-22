import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mikococo/charts/stats/Status.dart';
import 'package:mikococo/sets/sets_timer.dart';
import 'package:provider/provider.dart';
import '../charts/charts_screen.dart';
import '../module/models.dart';
import '../timer/timer.model.dart';

class SetsScreen extends StatefulWidget {
  final Exercise exercise;

  SetsScreen(this.exercise);

  @override
  _SetsScreenState createState() => _SetsScreenState();
}

class _SetsScreenState extends State<SetsScreen> {
  final TextEditingController kgController = TextEditingController();

  // Check if a date is within the last month
  bool isWithinLastMonth(DateTime date, DateTime now) {
    return date.isAfter(now.subtract(Duration(days: 30))) && date.isBefore(now);
  }


  List<int> getRepsData() {
    List<int> repsData = [];
    List<Map<String, dynamic>> setData = getSetData();

    for (var data in setData) {
      repsData.add(data['reps'] as int);
    }

    return repsData;
  }
  List<double> getKGData() {
    List<double> kgData = [];
    List<Map<String, dynamic>> setData = getSetData();

    for (var data in setData) {
      kgData.add(data['kg'] as double);
    }

    return kgData;
  }

  List<Map<String, dynamic>> getSetData() {
    List<Map<String, dynamic>> setData = [];
    DateTime now = DateTime.now();

    for (int setKey in setKeys) {
      final set = setsBox.get(setKey);
      if (set != null && set.date != null) {
        // Check if the set date is within the last month
        if (isWithinLastMonth(set.date!, now)) {
          setData.add({
            'date': set.date!,
            'reps': set.reps,
            'kg': set.kg,
          });
        }
      }
    }

    return setData;
  }

  List<int> setKeys = [];
  late Box<SetsScreenData> setsBox;

  int totalReps = 0;
  int totalKg = 0;
  int bestReps = 0;
  int bestKg = 0;
  double averageKg = 0.0;

  int? selectedReps;
  int? selectedKg;

  @override
  void initState() {
    super.initState();
    setsBox = Hive.box<SetsScreenData>('SetsBox');
    loadSetKeys();
    calculateStats();
  }

  void loadSetKeys() {
    setKeys.clear();

    if (widget.exercise.sets != null) {
      for (int setKey in widget.exercise.sets!) {
        setKeys.add(setKey);
      }
    }
  }

  void calculateStats() {
    totalReps = 0;
    totalKg = 0;
    bestReps = 0;
    bestKg = 0;
    for (int setKey in setKeys) {
      final set = setsBox.get(setKey);
      if (set != null) {
        totalReps += set.reps;
        totalKg += set.kg.round();
        if (set.reps > bestReps) {
          bestReps = set.reps;
        }
        if (set.kg > bestKg) {
          bestKg = set.kg.round();
        }
      }
    }
    if (setKeys.isNotEmpty) {
      averageKg = totalKg / setKeys.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    var timerModel = Provider.of<TimerModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sets for ${widget.exercise.name}', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DummyTimerScreen(),
                ),
              );
            },
            icon: Icon(Icons.timer),
          ),
          IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChartScreen(
                  repsData: getRepsData(),
                  kgData: getKGData(),
                  dates: getSetData().map((data) => data['date'] as DateTime).toList(),
                ),
              ),
            );
          }, icon: Icon(Icons.add_chart)),
          IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>StatusScreen(
                  totalKg: totalKg.toString(),
                  totalReps: totalReps.toString(),
                  averageKg: averageKg.toStringAsFixed(2),
                  bestKg: bestKg.toString(),
                  bestReps: bestReps.toString(),
                )
              ),
            );
          }, icon: Icon(Icons.stacked_bar_chart)),
        ],
      ),
      body: ListView.builder(
        itemCount: setKeys.length,
        itemBuilder: (context, index) {
          final setIndex = index;
          final set = setsBox.get(setKeys[setIndex])!;

          // Check if the date has been displayed already
          if (setIndex == 0 || set.date!.day != setsBox.get(setKeys[setIndex - 1])!.date!.day) {
            // Display date ListTile
            final formattedDate = DateFormat('yyyy-MM-dd').format(set.date!);
            return Column(
              children: [
                ListTile(
                  title: Text(formattedDate, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                // Display set ListTile
                ListTile(
                  title: Text('Set ${setIndex + 1}: Reps - ${set.reps}, KG - ${set.kg}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditSetBottomSheet(setKeys[setIndex], set.reps, set.kg.round());
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteSet(setKeys[setIndex]);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Display set ListTile without the date
            return ListTile(
              title: Text('Set ${setIndex + 1}: Reps - ${set.reps}, KG - ${set.kg}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showEditSetBottomSheet(setKeys[setIndex], set.reps, set.kg.round());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteSet(setKeys[setIndex]);
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSetBottomSheet();
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


  // Consumer<TimerModel>(
  // builder: (context, timerModel, _) => BottomNavigationBar(
  // items: [
  // BottomNavigationBarItem(
  // icon: Icon(Icons.timer),
  // label: timerModel.selectedBox != -1
  // ? 'Timer: ${timerModel.currentValues[timerModel.selectedBox]}s'
  //     : 'Dummy : ${timerModel.dummyTimerValue}',
  // ),
  // BottomNavigationBarItem(
  // icon: Icon(Icons.stop),
  // label: 'Stop Timer',
  // ),
  // ],
  // onTap: timerModel.isDummy ? (index){
  // if (index == 0){
  // timerModel.startDummyTimer();
  // }
  // }:(index) {
  // if (index == 0) {
  // // Start or stop the timer in TimerScreen for the selected box
  // if (timerModel.selectedBox != -1) {
  // if (timerModel.timers[timerModel.selectedBox] != null &&
  // timerModel.timers[timerModel.selectedBox]!.isActive) {
  // timerModel.stopTimer(timerModel.selectedBox);
  // } else {
  // // Adjust the initial value as needed
  // timerModel.startTimer(timerModel.selectedBox, 45);
  // }
  // }
  // } else if (index == 1) {
  // // Stop the timer for the selected box
  // if (timerModel.selectedBox != -1 &&
  // timerModel.timers[timerModel.selectedBox] != null &&
  // timerModel.timers[timerModel.selectedBox]!.isActive) {
  // timerModel.stopTimer(timerModel.selectedBox);
  // }
  // }
  // },
  // ),
  // ),
  void _showAddSetBottomSheet() {
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
                    value: selectedReps,
                    onChanged: (int? newValue) {
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
                      if (selectedReps != null && selectedKg != null) {
                        final set = SetsScreenData(selectedReps!, selectedKg!.toDouble(), DateTime.now(),widget.exercise.key);

                        setsBox.add(set).then((key) {
                          // Update exercise's sets list
                          if (widget.exercise.sets == null) {
                            widget.exercise.sets = [];
                          }
                          widget.exercise.sets!.add(key);
                          widget.exercise.save();

                          loadSetKeys();
                          calculateStats();

                          Navigator.of(context).pop();
                        });
                      } else {
                        // Handle the case where either selectedReps or selectedKg is null
                        // You might want to show an error message or take appropriate action.
                      }
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

  void _showEditSetBottomSheet(int setKey, int initialReps, int initialKg) {
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
                      final editedSet = SetsScreenData(editedReps, editedKg.toDouble(), DateTime.now(),widget.exercise.key);
                      setsBox.put(setKey, editedSet);
                      loadSetKeys();
                      calculateStats();

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

  void _deleteSet(int setKey) {
    setsBox.delete(setKey);
    widget.exercise.sets?.remove(setKey);
    widget.exercise.save();
    loadSetKeys();
    calculateStats();
  }
}
