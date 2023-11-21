import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../exercide/exercise_screen.dart';
import '../module/models.dart';
import 'edit_workout.dart';

class WorkoutDaysList extends StatelessWidget {
  final List<WorkoutDay> workoutDays;
  final void Function(int) onDelete;
  final void Function(int, String) onUpdate;

  WorkoutDaysList(this.workoutDays,this.onDelete,this.onUpdate);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workoutDays.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: IconButton(onPressed: (){
            onDelete(index);
          },icon: Icon(Icons.delete),),
          title: Text(workoutDays[index].name),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExercisesScreen(workoutDays[index]),
              ),
            );
          },
          trailing: IconButton(onPressed: (){
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Edit Workout Day'),
                  content: EditWorkoutDayForm(
                    initialName: workoutDays[index].name,
                    onEdit: (String newName) {
                      onUpdate(index, newName);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            );
          },icon: Icon(Icons.edit),),
        );
      },
    );
  }
}