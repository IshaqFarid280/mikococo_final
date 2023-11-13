import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mikococo/workout/work_out_froum.dart';
import 'package:mikococo/workout/work_out_list.dart';
import '../module/models.dart';

class WorkoutDaysScreen extends StatelessWidget {
  final Routine routine;

  WorkoutDaysScreen(this.routine);

  @override
  Widget build(BuildContext context) {
    var workoutDaysBox = Hive.box<WorkoutDay>('WorkoutDaysBox');
    List<WorkoutDay> workoutDays = workoutDaysBox.values
        .where((day) => routine.workoutDays.contains(day.key))
        .toList();
    void deleteWorkoutDay(int index) {
      final workoutDayKey = routine.workoutDays[index];
      Hive.box<WorkoutDay>('WorkoutDaysBox').deleteAt(workoutDayKey);
      routine.workoutDays.removeAt(index);
      routine.save();
    }
    void updateWorkoutDay(int index, String newName) {
      final workoutDayKey = routine.workoutDays[index];
      final workoutDay = Hive.box<WorkoutDay>('WorkoutDaysBox').get(workoutDayKey);
      if (workoutDay != null) {
        workoutDay.name = newName;
        workoutDay.save();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Days for ${routine.name}'),
      ),
      body: WorkoutDaysList(workoutDays,deleteWorkoutDay,updateWorkoutDay),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Workout Day'),
                content: AddWorkoutDayForm(
                  onAdd: (String name) {
                    addWorkoutDay(name, routine);
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void addWorkoutDay(String name, Routine routine) {
    final workoutDay = WorkoutDay(name, []);
    Hive.box<WorkoutDay>('WorkoutDaysBox').add(workoutDay).then((dayKey) {
      routine.workoutDays.add(dayKey);
      routine.save();
    });
  }

}