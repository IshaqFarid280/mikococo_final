import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mikococo/exercide/ExerciseScreenProvider.dart';
import 'package:mikococo/exercide/edit_exercise.dart';
import 'package:mikococo/homescreen/home_screen.dart';
import 'package:mikococo/sets/SetsScreen.dart';
import 'package:provider/provider.dart';
import '../module/models.dart';



class ExercisesScreen extends StatelessWidget {
  final WorkoutDay workoutDay;

  ExercisesScreen(this.workoutDay);

  // void deleteExercise(int index) {
  //   final exerciseKey = widget.workoutDay.exercises[index];
  //   Hive.box<Exercise>('ExercisesBox').deleteAt(exerciseKey);
  //   widget.workoutDay.exercises.removeAt(index);
  //   widget.workoutDay.save();
  // }
  // void updateExercise(int index, String newName) {
  //   final exerciseKey = widget.workoutDay.exercises[index];
  //   final exercise = Hive.box<Exercise>('ExercisesBox').get(exerciseKey);
  //   if (exercise != null) {
  //     exercise.name = newName;
  //     exercise.save();
  //   }
  // }
  //
  // void addExerciseToWorkout(Exercise exercise) {
  //   setState(() {
  //     widget.workoutDay.exercises.add(exercise.key);
  //     widget.workoutDay.save();
  //   });
  //
  // }

  Widget build(BuildContext context) {
    // var exercisesBox = Hive.box<Exercise>('ExercisesBox');
    // List<Exercise> exercises = exercisesBox.values
    //     .where((exercise) => widget.workoutDay.exercises.contains(exercise.key))
    //     .toList();
    var exercisesScreenProvider = Provider.of<ExercisesScreenProvider>(context);
    exercisesScreenProvider.setWorkoutDay(workoutDay);
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises for ${workoutDay.name}'),
      ),
      body: Consumer<ExercisesScreenProvider>(
        builder: (context, exercisesScreenProvider, _){
          return ListView.builder(
            itemCount: exercisesScreenProvider.exercises.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=>SetsScreen(exercisesScreenProvider.exercises[index])));
                },
                leading: CircleAvatar(
                  backgroundImage:exercisesScreenProvider.exercises[index].image.toString().contains('assets/images') ? AssetImage(exercisesScreenProvider.exercises[index].image.toString()):FileImage(File(exercisesScreenProvider.exercises[index].image.toString()))  as ImageProvider,
                  //
                ),

                title: Text(exercisesScreenProvider.exercises[index].name),
                trailing:IconButton(onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Edit Exercise'),
                        content: EditExerciseForm(
                          initialName: exercisesScreenProvider.exercises[index].name,
                          onEdit: (String newName) {
                            exercisesScreenProvider.updateExercise(index, newName);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  );
                }, icon:const Icon(Icons.edit)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> HomeScreen(workoutDay),),);
        },
        child: Icon(Icons.add),
      ),
    );
  }



}