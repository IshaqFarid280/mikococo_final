import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_timer.dart';
import 'timer.model.dart'; // Adjust the import path based on your project structure

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Future<void> _loadTimerValues;

  @override
  void initState() {
    super.initState();
    _loadTimerValues = _loadValues();
  }

  Future<void> _loadValues() async {
    await Provider.of<TimerModel>(context, listen: false).loadTimerValues();
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
              _editTimer(context);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _loadTimerValues,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<TimerModel>(
              builder: (context, timerModel, child) {
                return TimerButtons(timerModel: timerModel);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: TimerBottomNavigationBar(),
    );
  }

  void _editTimer(BuildContext context) async {
    var timerModel = Provider.of<TimerModel>(context, listen: false);

    List<int>? editedValues = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTimerScreen(timerValues: timerModel.timerValues),
      ),
    );

    if (editedValues != null) {
      timerModel.timerValues = List.from(editedValues);
      timerModel.currentValues = List.from(editedValues);
    }
  }
}

class TimerButtons extends StatelessWidget {
  final TimerModel timerModel;

  TimerButtons({required this.timerModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            timerModel.timers.length,
                (index) => TimerButton(index: index, timerModel: timerModel),
          ),
        ),
      ],
    );
  }
}

class TimerButton extends StatelessWidget {
  final int index;
  final TimerModel timerModel;

  TimerButton({required this.index, required this.timerModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTimerTap(context),
      child: Container(
        width: 50,
        height: 50,
        color: timerModel.selectedBox == index ? Colors.blue : Colors.grey,
        child: Center(
          child: Text(
            '${timerModel.currentValues[index]}s',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  void _handleTimerTap(BuildContext context) {
    timerModel.stopTimer(timerModel.selectedBox);
    timerModel.selectedBox = index;
    timerModel.currentValues[timerModel.selectedBox] = timerModel.timerValues[timerModel.selectedBox];
    timerModel.startTimer(timerModel.selectedBox, timerModel.currentValues[timerModel.selectedBox]);
  }
}

class TimerBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var timerModel = Provider.of<TimerModel>(context);

    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.stop),
          label: 'Stop Timer',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pause),
          label: 'Pause Timer',
        ),
      ],
      onTap: (index) => _handleBottomNavBarTap(index, timerModel),
    );
  }

  void _handleBottomNavBarTap(int index, TimerModel timerModel) {
    if (index == 0) {
      timerModel.stopTimer(timerModel.selectedBox);
    } else if (index == 1) {
      // Handle the functionality for the second item (e.g., pause timer)
      // Add your logic here
    }
  }
}
