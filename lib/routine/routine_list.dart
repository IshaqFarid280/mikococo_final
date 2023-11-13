import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../module/models.dart';
import '../workout/workoutScreen.dart';
import 'edit_routine.dart';

class MyRoutinesList extends StatelessWidget {
  final List<Routine> routines;
  final void Function(int) onDelete;
  final void Function(int, String) onUpdate;

  MyRoutinesList(this.routines,this.onDelete,this.onUpdate);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: routines.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: IconButton(onPressed: (){
            onDelete(index);
          }, icon: Icon(Icons.delete),),
          trailing: IconButton(onPressed: (){
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Edit Routine'),
                  content: EditRoutineForm(
                    initialName: routines[index].name,
                    onEdit: (String newName) {
                      onUpdate(index, newName);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            );
          }, icon: Icon(Icons.edit)),
          title: Text(routines[index].name,style: TextStyle(color: Colors.black),),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WorkoutDaysScreen(routines[index]),
              ),
            );
          },
        );
      },
    );
  }
}