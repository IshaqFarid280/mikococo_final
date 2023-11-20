import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mikococo/exercide/edit_exercise.dart';
import 'package:mikococo/homescreen/home_screen.dart';
import 'package:mikococo/sets/SetsScreen.dart';
import '../module/models.dart';



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
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: (){
              Navigator.push(context, CupertinoPageRoute(builder: (context)=>SetsScreen(exercises[index])));
            },
            leading: CircleAvatar(
              backgroundImage:exercises[index].image.toString().contains('assets/images') ? AssetImage(exercises[index].image.toString()):FileImage(File(exercises[index].image.toString()))  as ImageProvider,
              //
            ),

            title: Text(exercises[index].name),
            trailing:IconButton(onPressed: (){
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Edit Exercise'),
                    content: EditExerciseForm(
                      initialName: exercises[index].name,
                      onEdit: (String newName) {
                        updateExercise(index, newName);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              );
            }, icon:const Icon(Icons.edit)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> HomeScreen(widget.workoutDay),),);
        },
        child: Icon(Icons.add),
      ),
    );
  }



}