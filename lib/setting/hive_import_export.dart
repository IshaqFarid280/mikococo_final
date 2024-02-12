import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import '../module/models.dart';

// HiveProvider class to manage Hive data and perform import/export operations

// HiveProvider class to manage Hive data and perform import/export operations
class HiveProvider extends ChangeNotifier {
  Future<void> importDataFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null && result.files.isNotEmpty) {
      File file = File(result.files.single.path!);
      String dataString = await file.readAsString();

      List<dynamic> data = json.decode(dataString);

      // Clear existing data
      await Hive.box<Routine>('RoutineBox').clear();
      await Hive.box<WorkoutDay>('WorkoutDaysBox').clear();
      await Hive.box<Exercise>('ExercisesBox').clear();
      await Hive.box<SetsScreenData>('SetsBox').clear();
      // Import data
      await importData(data);
    }
  }

  Future<void> importData(List<dynamic> data) async {
    // Import data
    for (var item in data) {
      if (item is Map<String, dynamic>) {
        if (item.containsKey('name') && item.containsKey('description')) {
          await Hive.box<Routine>('RoutineBox').add(Routine.fromJson(item));
        } else if (item.containsKey('name') && item.containsKey('leadingword')) {
          await Hive.box<WorkoutDay>('WorkoutDaysBox').add(WorkoutDay.fromJson(item));
        } else if (item.containsKey('name')) {
          await Hive.box<Exercise>('ExercisesBox').add(Exercise.fromJson(item));
        } else if (item.containsKey('reps') && item.containsKey('kg')) {
          await Hive.box<SetsScreenData>('SetsBox').add(SetsScreenData.fromJson(item));
        }
      }
    }

    // Notify listeners that data has changed
    notifyListeners();
  }


  Future<String> exportData(BuildContext context) async {
    // Export data (replace this with your export logic)
    List<dynamic> data = []; // Example data
    data.addAll(Hive.box<Routine>('RoutineBox').values);
    data.addAll(Hive.box<WorkoutDay>('WorkoutDaysBox').values);
    data.addAll(Hive.box<Exercise>('ExercisesBox').values);
    data.addAll(Hive.box<SetsScreenData>('SetsBox').values);
    // Convert data to JSON format
    String dataString = json.encode(data);

    // Write data to a file in the downloads folder
    final downloadsDirectory = await getExternalStorageDirectory();
    final fileName = 'exported_data.json';
    final filePath = '${downloadsDirectory!.path}/$fileName';
    final file = File(filePath);
    await file.writeAsString(dataString);

    // Share data as a file
    Share.shareFiles([filePath], text: 'Exported Data');

    return filePath; // Return the file path for any further processing
  }
}