import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mikococo/routine/routine_list.dart';
import '../module/models.dart';
import 'add_routine.dart';




class MyRoutinesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    void addRoutine(String name) {
      final routine = Routine(name, []);
      Hive.box<Routine>('RoutineBox').add(routine);
    }
    void deleteRoutine(int index) {
      Hive.box<Routine>('RoutineBox').deleteAt(index);
    }
    void updateRoutine(int index, String newName) {
      final routine = Hive.box<Routine>('RoutineBox').getAt(index);
      if (routine != null) {
        routine.name = newName;
        routine.save();
      }
    }
    var routineBox = Hive.box<Routine>('RoutineBox');
    List<Routine> routines = routineBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Routines'),
      ),
      body: MyRoutinesList(routines,deleteRoutine,updateRoutine),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Routine'),
                content: AddRoutineForm(
                  onAdd: (String name) {
                    addRoutine(name);
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


