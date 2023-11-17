import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _selectedBox = -1; // Index of the selected box
  List<int> _timerValues = [30, 60, 90, 120]; // Initial values for each box
  List<int> _currentValues = [30, 60, 90, 120]; // Current displayed values for each box
  List<Timer?> _timers = List.filled(4, null); // Timers for each box

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer Screen'),
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
