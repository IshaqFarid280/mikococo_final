import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../module/models.dart';

class TimerModel extends ChangeNotifier {
  int selectedBox = -1;
  List<int> timerValues = [];
  List<int> currentValues = [];
  List<Timer?> timers = List.filled(4, null);
  int dummyTimerValue = 60;
  bool isDummy = true ;
   Timer  ? _timer;
   bool isTimerRunning = false ;
  


  void playTimerReachedZeroSound() {
    AssetsAudioPlayer().open(
      Audio('assets/sound/beepSound.mp3'),
    );
  }


  void resetDummyTimer() {
    dummyTimerValue = 60;
    notifyListeners();
  }

  void increaseDummyTimer() {
    dummyTimerValue += 5;
    notifyListeners();
  }

  void decreaseDummyTimer() {
    dummyTimerValue -= 5;
    if (dummyTimerValue < 0) {
      dummyTimerValue = 0;
    }
    notifyListeners();
  }

  void startDummyTimer(bool isDummy) {
    isDummy = true;
    isTimerRunning = true;
    notifyListeners();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (dummyTimerValue > 0) {
        dummyTimerValue--;
        notifyListeners();
      } else {
        resetDummyTimer(); // Reset the dummy values when the timer reaches zero
        stopDummyTimer();
        playTimerReachedZeroSound();
        isDummy = false;
        isTimerRunning = false;
        notifyListeners();
      }
    });
    isDummy = true;
    notifyListeners();
  }




  void stopDummyTimer() {
    isTimerRunning = false;
    _timer!.cancel();
    resetDummyTimer();
    notifyListeners();
  }

  void startTimer(int selectedBox, int initialValue) {
    print('Start Timer Called - selectedBox: $selectedBox, initialValue: $initialValue');
    print('Timer List Length: ${timers.length}');
    print('Timer State: ${timers[selectedBox]?.isActive}');

    isDummy = false;
    isTimerRunning = true ;// Set isDummy to false initially
    notifyListeners();

    if (selectedBox == dummyTimerValue) {
      // Handle starting the dummy timer
      stopTimer(selectedBox); // Stop the previous timer
      this.selectedBox = selectedBox;
      currentValues[selectedBox] = initialValue;
      _startTimer(currentValues[selectedBox]); // Start the timer with the current value
    } else if (selectedBox >= 0 && selectedBox < timers.length) {
      // Handle starting the regular timer
      stopTimer(this.selectedBox); // Stop the previous timer
      this.selectedBox = selectedBox;
      currentValues[selectedBox] = initialValue;
      _startTimer(currentValues[selectedBox]); // Start the timer with the current value
    }

    isDummy = true;
    isTimerRunning = false;// Set isDummy to true after starting the timer
    notifyListeners();
  }


  void stopTimer(int index) {
  if (index >= 0 && index < timers.length) {
    timers[index]?.cancel();
    selectedBox = -1;
    isTimerRunning = false;
    notifyListeners();
  }
}
  void _startTimer(int initialValue) {
    timers[selectedBox]?.cancel();
    timers[selectedBox] = Timer.periodic(Duration(seconds: 1), (timer) {
      if (initialValue > 0) {
        currentValues[selectedBox] = initialValue;
        initialValue--;
      } else {
        timer.cancel();
        selectedBox = -1;
        isTimerRunning = false;
        playTimerReachedZeroSound();
      }
      isTimerRunning = true;
      notifyListeners();
    });
  }

  Future<void> loadTimerValues() async {
    await Hive.openBox<TimerValues>('timerValues');
    final timerValuesBox = Hive.box<TimerValues>('timerValues');
    final timerValues =
    timerValuesBox.get('values', defaultValue: TimerValues([30, 60, 90, 120]));
    this.timerValues = List.from(timerValues?.values ?? []);
    currentValues = List.from(timerValues?.values ?? []);
  }
}


class TimerValuesProvider {
  List<int> values;

  TimerValuesProvider(this.values);

  factory TimerValuesProvider.fromJson(Map<String, dynamic> json) {
    return TimerValuesProvider(List<int>.from(json['values']));
  }

  Map<String, dynamic> toJson() {
    return {'values': values};
  }
}




// void stopTimer(int index) {
//   if (index >= 0 && index < timers.length) {
//     timers[index]?.cancel();
//     selectedBox = -1;
//     notifyListeners();
//   }
// }// void _startTimer(int initialValue) {
//   //   timers[selectedBox]?.cancel();
//   //   timers[selectedBox] = Timer.periodic(Duration(seconds: 1), (timer) {
//   //     if (initialValue > 0) {
//   //       currentValues[selectedBox] = initialValue;
//   //       initialValue--;
//   //     } else {
//   //       timer.cancel();
//   //       selectedBox = -1;
//   //     }
//   //     notifyListeners();
//   //   });
//   // }
// void _startTimer(int initialValue) {
//   if (selectedBox == dummyTimerIndex) {
//     // Handle dummy timer logic
//     if (dummyTimerIndex < 0 || dummyTimerIndex >= timerValues.length) {
//       print('Invalid dummy timer index or timerValues length is not sufficient.');
//       selectedBox = -1;
//       return;
//     }
//   }
//
//   timers[selectedBox]?.cancel();
//   timers[selectedBox] = Timer.periodic(Duration(seconds: 1), (timer) {
//     if (selectedBox == dummyTimerIndex) {
//       // Handle dummy timer logic
//       if (initialValue > 0) {
//         currentValues[dummyTimerIndex] = initialValue;
//         initialValue--;
//       } else {
//         timer.cancel();
//         selectedBox = -1;
//       }
//     } else {
//       // Handle regular timer logic
//       if (initialValue > 0) {
//         currentValues[selectedBox] = initialValue;
//         initialValue--;
//       } else {
//         timer.cancel();
//         selectedBox = -1;
//         isTimerRunning = false; // Update the flag
//       }
//     }
//
//     notifyListeners();
//   });
// }

// void stopTimer(int index) {
//   if (index >= 0 && index < timers.length) {
//     timers[index]?.cancel();
//     selectedBox = -1;
//     isTimerRunning = false;
//     notifyListeners();
//   }
// }