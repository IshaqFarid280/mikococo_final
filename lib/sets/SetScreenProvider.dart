import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mikococo/module/models.dart'; // Make sure to import the necessary packages and classes

class SetsScreenProvider extends ChangeNotifier {
  final TextEditingController kgController = TextEditingController();
  late Box<SetsScreenData> setsBox;

  List<int> setKeys = [];
  int totalReps = 0;
  int totalKg = 0;
  int bestReps = 0;
  int bestKg = 0;
  double averageKg = 0.0;

  int? selectedReps;
  int? selectedKg;

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

  List<Map<String, dynamic>> getSetData() {
    List<Map<String, dynamic>> setData = [];
    DateTime now = DateTime.now();

    for (int setKey in setKeys) {
      final set = setsBox.get(setKey);
      if (set != null && set.date != null) {
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

  SetsScreenProvider(int? exerciseKey) {
    setsBox = Hive.box<SetsScreenData>('SetsBox');
    loadSetKeys(exerciseKey!);
    calculateStats();
  }


  void loadSetKeys(int? exerciseKey) {
    setKeys.clear();
    final exercise = Hive.box<Exercise>('ExercisesBox').get(exerciseKey);
    if (exercise != null && exercise.sets != null) {
      for (int setKey in exercise.sets!) {
        setKeys.add(setKey);
      }
    }
  }

  void calculateStats() {
    totalReps = 0;
    totalKg = 0;
    bestReps = 0;
    bestKg = 0;
    for (int setKey in setKeys) {
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
    }
    if (setKeys.isNotEmpty) {
      averageKg = totalKg / setKeys.length;
    }
  }
}
