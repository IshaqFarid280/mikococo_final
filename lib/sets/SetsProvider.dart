import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../module/models.dart';

class SetsScreenStateProvider extends ChangeNotifier {
  late Box<SetsScreenData> setsBox;
  List<int> setKeys = [];
  int totalReps = 0;
  int totalKg = 0;
  int bestReps = 0;
  int bestKg = 0;
  double averageKg = 0.0;
  Exercise? exercise;
  int totalDailyReps = 0 ;
  int totalDailyKg = 0 ;
  // New properties to track daily totals
  Map<String, int> totalDailyRepsMap = {};
  Map<String, int> totalDailyKgMap = {};

  SetsScreenStateProvider(this.exercise) {
    _initializeSetsBox();
  }

  Future<void> _initializeSetsBox() async {
    setsBox = await Hive.openBox<SetsScreenData>('SetsBox');
    notifyListeners();

    if (exercise != null) {
      loadSetKeys();
      calculateStats();
    }
  }

  // Check if a date is within the last month
  bool isWithinLastMonth(DateTime date, DateTime now) {
    return date.isAfter(now.subtract(Duration(days: 30))) && date.isBefore(now);
  }



  List<int> getRepsData() {
    List<int> repsData = [];
    List<Map<String, dynamic>> setData = getSetData();

    for (var data in setData) {
      repsData.add(data['reps'] as int);
    }

    return repsData;
  }

  List<double> getKGData() {
    List<double> kgData = [];
    List<Map<String, dynamic>> setData = getSetData();

    for (var data in setData) {
      kgData.add(data['kg'] as double);
    }

    return kgData;
  }

  void calculateDailyTotals() {
    totalDailyRepsMap.clear();
    totalDailyKgMap.clear();

    List<Map<String, dynamic>> setData = getSetData();
    DateTime now = DateTime.now();
    final DateFormat displayFormat = DateFormat('MMMM d, yyyy');

    for (var data in setData) {
      final DateTime? date = data['date'] as DateTime?;
      final int? reps = data['reps'] as int?;
      final double? kg = data['kg'] as double?;

      if (date != null && reps != null && kg != null) {
        final String formattedDate = displayFormat.format(date);

        totalDailyRepsMap[formattedDate] ??= 0;
        totalDailyKgMap[formattedDate] ??= 0;

        totalDailyRepsMap[formattedDate] = (totalDailyRepsMap[formattedDate] ?? 0) + reps;
        totalDailyKgMap[formattedDate] = (totalDailyKgMap[formattedDate] ?? 0) + kg.round();
      }
    }

    // Add print statements
    print('calculateDailyTotals - totalDailyRepsMap: $totalDailyRepsMap');
    print('calculateDailyTotals - totalDailyKgMap: $totalDailyKgMap');

    // Clear overall daily totals
    totalDailyReps = 0;
    totalDailyKg = 0;

    // Calculate the overall daily totals for the current date
    final String currentFormattedDate = displayFormat.format(now);
    totalDailyReps = totalDailyRepsMap[currentFormattedDate] ?? 0;
    totalDailyKg = totalDailyKgMap[currentFormattedDate] ?? 0;

    notifyListeners();
  }
  List<Map<String, dynamic>> getSetData() {
    List<Map<String, dynamic>> setData = [];
    DateTime now = DateTime.now();

    for (int setKey in setKeys) {
      final set = setsBox.get(setKey);
      if (set != null && set.date != null) {
        // Check if the set date is within the last month
        if (isWithinLastMonth(set.date!, now)) {
          setData.add({
            'date': set.date!,
            'reps': set.reps,
            'kg': set.kg,
          });
        }
      }
    }

    // Add print statements
    print('getSetData - setData: $setData');

    return setData;
  }



  // List<Map<String, dynamic>> getSetData() {
  //   List<Map<String, dynamic>> setData = [];
  //   DateTime now = DateTime.now();
  //
  //   for (int setKey in setKeys) {
  //     final set = setsBox.get(setKey);
  //     if (set != null && set.date != null) {
  //       // Check if the set date is within the last month
  //       if (isWithinLastMonth(set.date!, now)) {
  //         setData.add({
  //           'date': set.date!,
  //           'reps': set.reps,
  //           'kg': set.kg,
  //         });
  //       }
  //     }
  //   }
  //   return setData;
  // }

  void loadSetKeys() {
    setKeys.clear();
    if (exercise?.sets != null) {
      setKeys.addAll(exercise!.sets!);
    }
  }

  void calculateStats() {
    totalReps = 0;
    totalKg = 0;
    bestReps = 0;
    bestKg = 0;
    setKeys.forEach((setKey) {
      final set = setsBox.get(setKey);
      if (set != null) {
        totalReps += set.reps;
        totalKg += set.kg.round();
        if (set.reps > bestReps) {
          bestReps = set.reps;
        }
        if (set.kg > bestKg) {
          bestKg = set.kg.round();
        }
      }
    });

    if (setKeys.isNotEmpty) {
      averageKg = totalKg / setKeys.length;
    }
   calculateDailyTotals();
    notifyListeners();
  }

  Future<void> addSet(SetsScreenData set) async {
    print("Adding set: $set");

    // Ensure exercise is not null before proceeding
    if (exercise == null || exercise?.key == null) {
      print("Exercise or Exercise key is null. Cannot add set.");
      return;
    }

    final key = await setsBox.add(set);
    exercise?.sets?.add(key);
    exercise?.save();

    print("Set added successfully. Exercise sets: ${exercise!.sets}");

    loadSetKeys();
    calculateStats();
    calculateDailyTotals();
  }

  void editSet(int setKey, SetsScreenData editedSet) {
    setsBox.put(setKey, editedSet);
    loadSetKeys();
    calculateStats();
  }

  void deleteSet(int setKey) {
    setsBox.delete(setKey);
    exercise?.sets?.remove(setKey);
    exercise?.save();
    loadSetKeys();
    Future.delayed(Duration.zero,(){
      calculateStats();
    });
  }

  void setExercise(Exercise newExercise) {
    exercise = newExercise;
    // Ensure sets is not null
    exercise?.sets ??= [];
      Future.delayed(Duration.zero,(){
        notifyListeners();
      });
  }

  static SetsScreenStateProvider of(BuildContext context) {
    return Provider.of<SetsScreenStateProvider>(context, listen: false);
  }
}
