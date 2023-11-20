import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mikococo/module/models.dart';

class WorkoutDaysScreenProvider extends ChangeNotifier {
  List<WorkoutDay> _workoutDays = [];

  List<WorkoutDay> get workoutDays => _workoutDays;

  void loadWorkoutDays(Routine routine) {
    var workoutDaysBox = Hive.box<WorkoutDay>('WorkoutDaysBox');
    _workoutDays = workoutDaysBox.values
        .where((day) => routine.workoutDays.contains(day.key))
        .toList();
    notifyListeners();
  }

  void deleteWorkoutDay(int index, Routine routine) {
    final workoutDayKey = routine.workoutDays[index];
    Hive.box<WorkoutDay>('WorkoutDaysBox').deleteAt(workoutDayKey);
    routine.workoutDays.removeAt(index);
    routine.save();
    loadWorkoutDays(routine); // Refresh the list after deletion
  }

  void updateWorkoutDay(int index, String newName, Routine routine) {
    final workoutDayKey = routine.workoutDays[index];
    final workoutDay = Hive.box<WorkoutDay>('WorkoutDaysBox').get(workoutDayKey);
    if (workoutDay != null) {
      workoutDay.name = newName;
      workoutDay.save();
      loadWorkoutDays(routine); // Refresh the list after update
    }
  }

  void addWorkoutDay(String name, String leadingWorkoutWord, String workoutAvatarColor, Routine routine) {
    final workoutDay = WorkoutDay(name, leadingWorkoutWord, workoutAvatarColor, []);
    Hive.box<WorkoutDay>('WorkoutDaysBox').add(workoutDay).then((dayKey) {
      routine.workoutDays.add(dayKey);
      routine.save();
      loadWorkoutDays(routine); // Refresh the list after addition
    });
  }
}
