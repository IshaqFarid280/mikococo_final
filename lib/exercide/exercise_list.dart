import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mikococo/services/Boxes.dart';
import '../module/models.dart';
import 'edit_exercise.dart';



class ExercisesList extends StatelessWidget {
  final List<Exercise> exercises;
  final void Function(int) onDelete;
  final void Function(int, String) onUpdate;

  ExercisesList(this.exercises,this.onDelete,this.onUpdate);

  @override
  Widget build(BuildContext context) {
     ImageItem imageItem ;
    return ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage:exercises[index].image.toString().contains('assets/images') ? AssetImage(exercises[index].image.toString()):FileImage(File(exercises[index].image.toString()))  as ImageProvider,
              //
          ),
          // leading: IconButton(onPressed: (){
          //   onDelete(index);
          // }, icon:const Icon(Icons.delete)),
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
                      onUpdate(index, newName);
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
  }
}