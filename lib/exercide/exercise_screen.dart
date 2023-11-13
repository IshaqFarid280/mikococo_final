import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mikococo/homescreen/home_screen.dart';
import '../module/models.dart';
import 'exercise_list.dart';



class ExercisesScreen extends StatefulWidget {
  final WorkoutDay workoutDay;

  ExercisesScreen(this.workoutDay);

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {

  void deleteExercise(int index) {
    final exerciseKey = widget.workoutDay.exercises[index];
    Hive.box<Exercise>('ExercisesBox').deleteAt(exerciseKey);
    widget.workoutDay.exercises.removeAt(index);
    widget.workoutDay.save();
  }
  void updateExercise(int index, String newName) {
    final exerciseKey = widget.workoutDay.exercises[index];
    final exercise = Hive.box<Exercise>('ExercisesBox').get(exerciseKey);
    if (exercise != null) {
      exercise.name = newName;
      exercise.save();
    }
  }

  void addExerciseToWorkout(Exercise exercise) {
    setState(() {
      widget.workoutDay.exercises.add(exercise.key);
      widget.workoutDay.save();
    });
  }
  Widget build(BuildContext context) {
    var exercisesBox = Hive.box<Exercise>('ExercisesBox');
    List<Exercise> exercises = exercisesBox.values
        .where((exercise) => widget.workoutDay.exercises.contains(exercise.key))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises for ${widget.workoutDay.name}'),
      ),
      body: ExercisesList(exercises,deleteExercise,updateExercise),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context)=> HomeScreen(widget.workoutDay),),);
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return AlertDialog(
          //       title: Text('Add Exercise'),
          //       content: AddExerciseForm(
          //         onAdd: (String name) {
          //           addExercise(name, widget.workoutDay);
          //           Navigator.of(context).pop();
          //         },
          //       ),
          //     );
          //   },
          // );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // void addExercise(String name, WorkoutDay workoutDay) {
  //   final exercise = Exercise(name);
  //   Hive.box<Exercise>('ExercisesBox').add(exercise).then((exerciseKey) {
  //     workoutDay.exercises.add(exerciseKey);
  //     workoutDay.save();
  //   });
  // }

}