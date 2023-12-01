import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
import 'package:share/share.dart';
import 'package:table_calendar/table_calendar.dart';

import '../consts/colors.dart';
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
        leading: LeadingIcon(),
        title: normalText(title: 'Share Exercise'),
      ),
      bottomNavigationBar: SubmitButton(
          onTap: () {
            _shareExerciseData(_formatExerciseData());
          },
          titlee: 'Share Exercises', primaryColor: buttonColors),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCalendar(),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
              _buildExerciseData(),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      weekNumbersVisible: false,
      daysOfWeekVisible: true,
      headerVisible: true,
      headerStyle: HeaderStyle(
        leftChevronIcon: Icon(Icons.arrow_back_ios,color: whiteColor,size: 15,),
        rightChevronIcon:Icon(Icons.arrow_forward_ios,color: whiteColor,size: 15,),
        headerMargin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
            color: listTileLeadingColor),
        titleCentered: true,
        formatButtonDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: buttonColors),
        formatButtonShowsNext: true,
        formatButtonVisible: true,
        formatButtonTextStyle: TextStyle(color: whiteColor),
        titleTextStyle: TextStyle(
            color: whiteColor, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: buttonColors),
        weekendStyle: TextStyle(color: buttonColors),
      ),
      calendarStyle: const CalendarStyle(
          selectedTextStyle: TextStyle(color: buttonColors),
          selectedDecoration: BoxDecoration(shape: BoxShape.circle, color: goldenColor),
          todayTextStyle: TextStyle(color: whiteColor),
          todayDecoration:
          BoxDecoration(shape: BoxShape.circle, color: buttonColors),
          // rangeStartTextStyle: TextStyle(color: whiteColor),
          // withinRangeTextStyle: TextStyle(color: whiteColor),
          defaultTextStyle: TextStyle(color: whiteColor),
          rangeHighlightColor: goldenColor,
          markerDecoration: BoxDecoration(color: goldenColor),
          outsideDaysVisible: true,),
      calendarFormat: _calendarFormat,
      focusedDay: _selectedDate,
      firstDay: DateTime.utc(2022, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
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

      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          bool hasExerciseData = _hasExerciseDataForDate(date);
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: hasExerciseData ? goldenColor : Colors.transparent,
                    width: 1.0,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color: hasExerciseData ? goldenColor : whiteColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExerciseData() {
    String exerciseData = _formatExerciseData();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
        smallText(title: exerciseData,weight: FontWeight.bold),
      ],
    );
  }

  String _formatExerciseData() {
    String formattedDate = DateFormat('dd / MM / yyyy').format(_selectedDate);
    String exerciseText = 'Workout : $formattedDate\n';
    List<SetsScreenData> selectedDateSets = getSelectedDateSets(_selectedDate);

    for (SetsScreenData set in selectedDateSets) {
      Exercise? exercise = exercisesBox.get(set.exerciseKey);

      if (exercise != null) {
        String exerciseName = exercise.name ?? 'Unknown Exercise';
        String setInfo = '$exerciseName:  ${set.reps} reps x ${set.kg} kg';
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
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _hasExerciseDataForDate(DateTime date) {
    List<SetsScreenData> selectedDateSets = getSelectedDateSets(date);
    return selectedDateSets.isNotEmpty;
  }

  void _shareExerciseData(String exerciseData) {
    Share.share(exerciseData);
  }
}
