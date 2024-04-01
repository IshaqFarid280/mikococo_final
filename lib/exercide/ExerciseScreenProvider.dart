import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../module/models.dart';
import '../timer/timer.model.dart';

class ExercisesScreenProvider extends ChangeNotifier {
  WorkoutDay? _workoutDay;
  List<Exercise> _exercises = [];
  WorkoutDay? get workoutDay => _workoutDay;
  List<Exercise> get exercises => _exercises;


  void updateExcerciseList(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex = newIndex -1;
      // Print for debugging
      print("Reordered: $oldIndex to $newIndex");
    }

    final exercise = _exercises.removeAt(oldIndex);
    _exercises.insert(newIndex, exercise);

    // Notify listeners
    notifyListeners();
  }

  void setWorkoutDay(WorkoutDay workoutDay) {
    _workoutDay = workoutDay;
    loadExercises();
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  loadExercises()  {
    if (_workoutDay == null) return;

    var exercisesBox = Hive.box<Exercise>('ExercisesBox');
    _exercises = exercisesBox.values
        .where((exercise) => _workoutDay!.exercises.contains(exercise.key))
        .toList();
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }


  void deleteExercise(int index) {
    if (_workoutDay == null) return;

    final exerciseKey = _workoutDay!.exercises[index];
    Hive.box<Exercise>('ExercisesBox').deleteAt(exerciseKey);
    _workoutDay!.exercises.removeAt(index);
    _workoutDay!.save();
    loadExercises();
  }

  void updateExercise(int index, String newName, newDescription) {
    if (_workoutDay == null) return;

    final exerciseKey = _workoutDay!.exercises[index];
    final exercise = Hive.box<Exercise>('ExercisesBox').get(exerciseKey);
    if (exercise != null) {
      exercise.name = newName;
      exercise.description = newDescription;
      exercise.save();
      loadExercises();
    }
  }

  void addExerciseToWorkout(Exercise exercise) {
    if (_workoutDay == null) return;

    _workoutDay!.exercises.add(exercise.key);
    _workoutDay!.save();
    loadExercises();
    print('Exercise added: ${exercise.name}');
  }
  void reorderExercises(int oldIndex, int newIndex){
    if (oldIndex >= 0 &&
        oldIndex < _exercises.length &&
        newIndex >= 0 &&
        newIndex < _exercises.length) {
      // Remove the exercise from the old index
      final removedExercise = _exercises.removeAt(oldIndex);

      // Insert the exercise at the new index
      _exercises.insert(newIndex, removedExercise);

      // Notify listeners about the change
      notifyListeners();
    }
  }
}
