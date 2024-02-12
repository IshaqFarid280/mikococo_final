import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import '../module/models.dart';
import 'motionToastConstructor.dart';

class ExportProvider extends ChangeNotifier {
  Future<void> exportData(context) async {
    final Box<Routine> routinesBox = await Hive.openBox<Routine>('RoutineBox');
    final List<Routine> routines = routinesBox.values.toList();

    final directory = await getExternalStorageDirectory();
    final file = File('${directory?.path}/routines_export.csv');

    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    final List<List<dynamic>> csvContent = [];

    // Add CSV header
    csvContent.add(['Routine Name', 'Description', 'Leading Word', 'Avatar Color', 'Workout Days', 'Exercise Name', 'Exercise Image', 'Sets']);
    for (var routine in routines) {
      for (var dayKey in routine.workoutDays) {
        final WorkoutDay workoutDay = Hive.box<WorkoutDay>('WorkoutDaysBox').get(dayKey)!;
        for (var exerciseKey in workoutDay.exercises) {
          final Exercise exercise = Hive.box<Exercise>('ExercisesBox').get(exerciseKey)!;
          // Add routine and workout day data for the first exercise in the workout day
          if (exerciseKey == workoutDay.exercises.first) {
            csvContent.add([routine.name, routine.description, routine.leadingword, routine.avatarColor, '${workoutDay.name}(${workoutDay.exercises.length} exercises)']);
          } else {
            // Blank cells for routine and workout day data for subsequent exercises in the same workout day
            csvContent.add(['', '', '', '', '']);
          }

          // Add exercise data
          csvContent.add([exercise.name, exercise.image ?? '']);

          // Add sets
          for (var setKey in exercise.sets ?? []) {
            final SetsScreenData set = Hive.box<SetsScreenData>('SetsBox').get(setKey)!;
            csvContent.add(['', '', '', '', '', '', '${set.reps} reps', '${set.kg} kg', set.date?.toIso8601String() ?? '']);
          }
        }
      }
    }

    // Write CSV to file
    final csvData = const ListToCsvConverter(eol: '\r\n').convert(csvContent); // Corrected usage
    await file.writeAsString(csvData);
    CustomMotionToast.showSuccessToast(context, 'Data exported successfully', 'Exported data saved in ${directory?.path}/routines_export.csv');
    notifyListeners();
  }

  Future<void> shareExportedFile() async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory?.path}/routines_export.csv');

    if (file.existsSync()) {
      Share.shareFiles(['${file.path}'], text: 'Check out my exported data!');
    } else {
      // Handle the case where the file does not exist
    }
  }
}
