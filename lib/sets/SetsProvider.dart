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
  int totalRepsDay = 0 ;
  int totalKgDay = 0 ;
  // New properties to track daily totals
  Map<String, int> dailyRepsMap = {};
  Map<String, int> dailyKgMap = {};

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

  void calculateDailyTotals() {
    dailyRepsMap.clear();
    dailyKgMap.clear();

    List<Map<String, dynamic>> setData = getSetData();

    for (var data in setData) {
      final DateTime? date = data['date'] as DateTime?;
      final int? reps = data['reps'] as int?;
      final double? kg = data['kg'] as double?;

      if (date != null && reps != null && kg != null) {
        final String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        dailyRepsMap[formattedDate] ??= 0;
        dailyKgMap[formattedDate] ??= 0;

        dailyRepsMap[formattedDate] = (dailyRepsMap[formattedDate] ?? 0) + reps;
        dailyKgMap[formattedDate] = (dailyKgMap[formattedDate] ?? 0) + kg.round();
      }
    }

    totalRepsDay = dailyRepsMap.values.fold(0, (sum, reps) => sum + reps);
    totalKgDay = dailyKgMap.values.fold(0, (sum, kg) => sum + kg);

    notifyListeners();
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
    return setData;
  }

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
