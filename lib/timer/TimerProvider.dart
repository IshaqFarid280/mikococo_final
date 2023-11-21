import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  late List<int> _currentValues;
  List<Timer?> _timers = List.filled(4, null);

  List<int> get currentValues => _currentValues;

  TimerProvider(List<int> initialValues) {
    _currentValues = List.from(initialValues);
  }

  void startTimer(int index) {
    _stopTimer(index);
    _timers[index] = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentValues[index] > 0) {
        _currentValues[index]--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  void stopTimer(int index) {
    _stopTimer(index);
    notifyListeners();
  }

  void _stopTimer(int index) {
    if (index >= 0 && index < _timers.length) {
      _timers[index]?.cancel();
    }
  }
}
