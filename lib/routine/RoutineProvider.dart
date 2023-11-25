import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mikococo/module/models.dart';

class RoutineProvider extends ChangeNotifier {
  List<Routine> _routines = []; // Initialize with your data


  List<Routine> get routines => _routines;

  void updateRoutineList(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex = newIndex -1;
      // Print for debugging
      print("Reordered: $oldIndex to $newIndex");
    }

    final routine = _routines.removeAt(oldIndex);
    _routines.insert(newIndex, routine);

    // Notify listeners
    notifyListeners();
  }

  void loadRoutines() {
    var routineBox = Hive.box<Routine>('RoutineBox');
    _routines = routineBox.values.toList();
    // Schedule the notification after the build phase is complete
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  void deleteRoutine(int index) {
    Hive.box<Routine>('RoutineBox').deleteAt(index);
    loadRoutines(); // Refresh the list after deletion
  }

  void updateRoutine(int index, String newName) {
    final routine = Hive.box<Routine>('RoutineBox').getAt(index);
    if (routine != null) {
      routine.name = newName;
      routine.save();
      loadRoutines(); // Refresh the list after update
    }
  }

  void addRoutine(String name, String des, String leadword, String avatarColor) {
    final routine = Routine(name, des, leadword, avatarColor, []);
    Hive.box<Routine>('RoutineBox').add(routine);
    loadRoutines(); // Refresh the list after addition
  }

}
