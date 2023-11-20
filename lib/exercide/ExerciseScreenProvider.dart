import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../module/models.dart';

class ExercisesScreenProvider extends ChangeNotifier {
  WorkoutDay? _workoutDay;
  List<Exercise> _exercises = [];

  WorkoutDay? get workoutDay => _workoutDay;
  List<Exercise> get exercises => _exercises;

  void setWorkoutDay(WorkoutDay workoutDay) {
    _workoutDay = workoutDay;
    loadExercises();
    notifyListeners();
  }

  void loadExercises() {
    var exercisesBox = Hive.box<Exercise>('ExercisesBox');
    _exercises = exercisesBox.values
        .where((exercise) => _workoutDay?.exercises.contains(exercise.key) ?? false)
        .toList();
    notifyListeners();
  }

  void deleteExercise(int index) {
    if (_workoutDay == null) return;

    final exerciseKey = _workoutDay!.exercises[index];
    Hive.box<Exercise>('ExercisesBox').deleteAt(exerciseKey);
    _workoutDay!.exercises.removeAt(index);
    _workoutDay!.save();
    loadExercises();
  }

  void updateExercise(int index, String newName) {
    if (_workoutDay == null) return;

    final exerciseKey = _workoutDay!.exercises[index];
    final exercise = Hive.box<Exercise>('ExercisesBox').get(exerciseKey);
    if (exercise != null) {
      exercise.name = newName;
      exercise.save();
      loadExercises();
    }
  }

  void addExerciseToWorkout(Exercise exercise) {
    if (_workoutDay == null) return;

    _workoutDay!.exercises.add(exercise.key);
    _workoutDay!.save();
    loadExercises();
  }
}
