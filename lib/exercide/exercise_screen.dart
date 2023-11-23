import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
          List<Exercise> exercise = exercisesScreenProvider.exercises;

          if (exercise.isEmpty) {
            // If there are no routines, display a message
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/emptyIcon.png',
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No Items',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    "You don't have any routines. Add a routine using the '+' button.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return ReorderableListView.builder(
            onReorder: (oldIndex, newIndex){
              exercisesScreenProvider.updateExcerciseList(oldIndex, newIndex);


            },
            itemCount: exercise.length,
            itemBuilder: (context, index) {
              final currentroutine = exercise[index];
              return Slidable(

                key: ValueKey(currentroutine),
                endActionPane: ActionPane(
                  motion: StretchMotion(),
                  children: [
                    // settings option
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Edit Exercise'),
                              content: EditExerciseForm(
                                initialName: currentroutine.name,
                                onEdit: (String newName) {
                                  exercisesScreenProvider.updateExercise(index, newName);
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                        );
                      },
                      backgroundColor: Colors.grey.shade800,
                      icon: Icons.edit,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // delete option
                    SlidableAction(
                      onPressed: (context) {
                        exercisesScreenProvider.deleteExercise(index);
                      },
                      backgroundColor: Colors.red.shade400,
                      icon: Icons.delete,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),
                child: ListTile(
                  onTap: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context)=>SetsScreen(exercisesScreenProvider.exercises[index])));
                  },
                  leading: CircleAvatar(
                    backgroundImage:currentroutine.image.toString().contains('assets/images') ? AssetImage(exercisesScreenProvider.exercises[index].image.toString()):FileImage(File(exercisesScreenProvider.exercises[index].image.toString()))  as ImageProvider,
                    //
                  ),

                  title: Text(currentroutine.name),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> HomeScreen(workoutDay, isExerciseScreen: true,),),);
        },
        child: Icon(Icons.add),
      ),
    );
  }



}