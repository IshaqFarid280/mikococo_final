import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mikococo/exercide/exercise_screen.dart';
import 'package:mikococo/workout/edit_workout.dart';
import 'package:mikococo/workout/work_out_froum.dart';
import '../module/models.dart';

class WorkoutDaysScreen extends StatefulWidget {
  final Routine routine;

  WorkoutDaysScreen(this.routine);

  @override
  _WorkoutDaysScreenState createState() => _WorkoutDaysScreenState();
}

class _WorkoutDaysScreenState extends State<WorkoutDaysScreen> {
  List<WorkoutDay> workoutDays = [];

  @override
  void initState() {
    super.initState();
    _loadWorkoutDays();
  }

  void _loadWorkoutDays() {
    var workoutDaysBox = Hive.box<WorkoutDay>('WorkoutDaysBox');
    setState(() {
      workoutDays = workoutDaysBox.values
          .where((day) => widget.routine.workoutDays.contains(day.key))
          .toList();
    });
  }

  void deleteWorkoutDay(int index) {
    final workoutDayKey = widget.routine.workoutDays[index];
    Hive.box<WorkoutDay>('WorkoutDaysBox').deleteAt(workoutDayKey);
    setState(() {
      widget.routine.workoutDays.removeAt(index);
    });
    widget.routine.save();
  }

  void updateWorkoutDay(int index, String newName) {
    final workoutDayKey = widget.routine.workoutDays[index];
    final workoutDay = Hive.box<WorkoutDay>('WorkoutDaysBox').get(workoutDayKey);
    if (workoutDay != null) {
      workoutDay.name = newName;
      workoutDay.save();
      _loadWorkoutDays(); // Refresh the list after update
    }
  }

  void addWorkoutDay(String name, String leadingWorkoutWord, String workoutAvatarColor, Routine routine) {
    final workoutDay = WorkoutDay(name, leadingWorkoutWord, workoutAvatarColor, []);
    Hive.box<WorkoutDay>('WorkoutDaysBox').add(workoutDay).then((dayKey) {
      setState(() {
        routine.workoutDays.add(dayKey);
      });
      routine.save();
      _loadWorkoutDays(); // Refresh the list after addition
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Days for ${widget.routine.name}'),
      ),
      body: ListView.builder(
        itemCount: workoutDays.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(int.parse(
                  workoutDays[index].avatarColors.replaceFirst('#', ''),
                  radix: 16) | 0xff000000,
              ),
              child: Text(
                workoutDays[index].leadingword,
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(workoutDays[index].name),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ExercisesScreen(workoutDays.elementAt(index)),
                ),
              );
            },
            trailing: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Edit Workout Day'),
                      content: EditWorkoutDayForm(
                        initialName: workoutDays[index].name,
                        onEdit: (String newName) {
                          updateWorkoutDay(index, newName);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.edit),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (ctx) => AddWorkoutDayForm(
                onAdd: (String name, String leadingtext, String leadingavatarcolor) {
                  addWorkoutDay(name, leadingtext, leadingavatarcolor, widget.routine);
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
