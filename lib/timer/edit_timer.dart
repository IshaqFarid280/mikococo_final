
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../module/models.dart';

class EditTimerScreen extends StatefulWidget {
  final List<int> timerValues;

  EditTimerScreen({required this.timerValues});

  @override
  _EditTimerScreenState createState() => _EditTimerScreenState();
}

class _EditTimerScreenState extends State<EditTimerScreen> {
  late List<int> editedValues;

  @override
  void initState() {
    super.initState();
    editedValues = List.from(widget.timerValues);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Timers'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              // Save the edited values to Hive
              final timerValuesBox = Hive.box<TimerValues>('timerValues');
              await timerValuesBox.put('values', TimerValues(editedValues));

              // Return the edited values to the previous screen
              Navigator.pop(context, editedValues);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.timerValues.length,
              (index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Timer ${index + 1}: '),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    _decrementTimer(index);
                  },
                ),
                Text('${editedValues[index]}s'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _incrementTimer(index);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _decrementTimer(int index) {
    setState(() {
      if (editedValues[index] > 0) {
        editedValues[index]--;
      }
    });
  }

  void _incrementTimer(int index) {
    setState(() {
      editedValues[index]++;
    });
  }
}
