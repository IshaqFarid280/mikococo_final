import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../timer/timer.model.dart';

class DummyTimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerModel = Provider.of<TimerModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dummy Timer Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Dummy Timer Value: ${timerModel.dummyTimerValue}s'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    timerModel.increaseDummyTimer();
                  },
                  child: Icon(Icons.add),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    timerModel.decreaseDummyTimer();
                  },
                  child: Icon(Icons.remove),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
