import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../module/models.dart';
import 'edit_timer.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _selectedBox = -1; // Index of the selected box
  late List<int> _timerValues;
  late List<int> _currentValues;
  List<Timer?> _timers = List.filled(4, null); // Timers for each box

  @override
  void initState() {
    super.initState();
    _loadTimerValues();
  }

  Future<void> _loadTimerValues() async {
    final timerValuesBox = await Hive.openBox<TimerValues>('timerValues');
    final timerValues = timerValuesBox.get('values', defaultValue: TimerValues([30, 60, 90, 120]));

    setState(() {
      _timerValues = List.from(timerValues?.values ?? []);
      _currentValues = List.from(timerValues?.values ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              // Navigate to EditTimerScreen and get the edited values
              List<int>? editedValues = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTimerScreen(timerValues: _timerValues),
                ),
              );

              // Update the timer values if the user made changes
              if (editedValues != null) {
                setState(() {
                  _timerValues = List.from(editedValues);
                  _currentValues = List.from(editedValues);
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              _timerValues.length,
                  (index) => GestureDetector(
                onTap: () {
                  _handleBoxTap(index);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  color: _selectedBox == index ? Colors.blue : Colors.grey,
                  child: Center(
                    child: Text(
                      '${_currentValues[index]}s',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.stop),
            label: 'Stop Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pause), // Customize the icon as needed
            label: 'Pause Timer', // Customize the label as needed
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            _stopTimer(_selectedBox);
          } else if (index == 1) {
            // Handle the functionality for the second item (e.g., pause timer)
            // Add your logic here
          }
        },
      ),
    );
  }

  void _handleBoxTap(int index) {
    if (_selectedBox != index) {
      _stopTimer(_selectedBox);
      setState(() {
        _selectedBox = index;
        _currentValues[_selectedBox] = _timerValues[_selectedBox];
      });
      _startTimer(_currentValues[_selectedBox]);
    }
  }

  void _startTimer(int initialValue) {
    _timers[_selectedBox]?.cancel(); // Cancel previous timer, if any
    _timers[_selectedBox] = Timer.periodic(Duration(seconds: 1), (timer) {
      if (initialValue > 0) {
        setState(() {
          _currentValues[_selectedBox] = initialValue;
        });
        initialValue--;
      } else {
        timer.cancel();
        setState(() {
          _selectedBox = -1;
        });
      }
    });
  }

  void _stopTimer(int index) {
    if (index >= 0 && index < _timers.length) {
      _timers[index]?.cancel();
    }
  }
}