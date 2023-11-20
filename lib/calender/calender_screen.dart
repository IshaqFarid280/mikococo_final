import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:table_calendar/table_calendar.dart';

import '../module/models.dart';

class ShareScreen extends StatefulWidget {
  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  late Box<SetsScreenData> setsBox;
  late Box<Exercise> exercisesBox;
  late CalendarFormat _calendarFormat;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    setsBox = Hive.box<SetsScreenData>('SetsBox');
    exercisesBox = Hive.box<Exercise>('ExercisesBox');
    _calendarFormat = CalendarFormat.month;
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCalendar(),
            SizedBox(height: 16),
            _buildExerciseData(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _shareExerciseData(_formatExerciseData());
              },
              child: Text('Share'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      calendarFormat: _calendarFormat,
      focusedDay: _selectedDate,
      firstDay: DateTime.utc(2022, 1, 1),
      lastDay: DateTime.utc(2023, 12, 31),
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDate = selectedDay;
        });
      },
    );
  }

  Widget _buildExerciseData() {
    String exerciseData = _formatExerciseData();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Exercise Data',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Text(
          exerciseData,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  String _formatExerciseData() {
    String formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate);
    String exerciseText = 'Workout : $formattedDate\n';
    List<SetsScreenData> selectedDateSets = getSelectedDateSets(_selectedDate);

    for (SetsScreenData set in selectedDateSets) {
      Exercise? exercise = exercisesBox.get(set.exerciseKey);

      if (exercise != null) {
        String exerciseName = exercise.name ?? 'Unknown Exercise';
        String setInfo = '$exerciseName: ${set.reps}x${set.kg}kg';
        exerciseText += '$setInfo\n';
      }
    }
    return exerciseText;
  }

  List<SetsScreenData> getSelectedDateSets(DateTime selectedDate) {
    List<SetsScreenData> selectedDateSets = [];
    for (int i = 0; i < setsBox.length; i++) {
      SetsScreenData set = setsBox.getAt(i)!;
      if (_isSameDay(set.date!, selectedDate)) {
        selectedDateSets.add(set);
      }
    }
    return selectedDateSets;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  void _shareExerciseData(String exerciseData) {
    Share.share(exerciseData);
  }
}
