import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/homescreen/add_info_screen.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';
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
        centerTitle: true,
        leading: LeadingIcon(),
        title: normalText(title: 'Globalfit'),
        // title: Text('Timer Screen'),
        actions: [
          AddThingsIcon(
            svgAsset: 'assets/svg/editicon.svg',
            svgColor: listTileEditColor,
            onTap: () async {
              _editTimer(context);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16),
            child: largeText(title: 'Timer Screen', weight: FontWeight.bold),
          ),
          Expanded(
            child: FutureBuilder(
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
          ),
        ],
      ),
      // bottomNavigationBar: TimerBottomNavigationBar(),
    );
  }

  void _editTimer(BuildContext context) async {
    var timerModel = Provider.of<TimerModel>(context, listen: false);

    List<int>? editedValues = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditTimerScreen(timerValues: timerModel.timerValues),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        children: List.generate(
          timerModel.timers.length,
          (index) => TimerButton(index: index, timerModel: timerModel),
        ),
      ),
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
      onTap: () {
        timerModel.handleTimerTap(context, index);
        _handleTimerTap(context);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color:timerModel.selectedBox == index ? iconColor : buttonColors,width:timerModel.selectedBox == index ? 4: 2),
          borderRadius: BorderRadius.circular(15),
          color: timerModel.selectedBox == index ? buttonColors : listTileLeadingColor,
        ),
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Center(
          child: largeText(
            textSize:timerModel.selectedBox == index ? 28.0 : 20.0,
            title: '${timerModel.currentValues[index]}s',
          ),
        ),
      ),
    );
  }

  void _handleTimerTap(BuildContext context) {
    timerModel.stopTimer(timerModel.selectedBox);
    timerModel.selectedBox = index;
    timerModel.currentValues[timerModel.selectedBox] =
        timerModel.timerValues[timerModel.selectedBox];
    timerModel.startTimer(timerModel.selectedBox,
        timerModel.currentValues[timerModel.selectedBox]);
  }
}

class TimerBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var timerModel = Provider.of<TimerModel>(context);

    return SubmitButton(
      primaryColor: buttonColors,
      onTap: () {
        timerModel.stopTimer(timerModel.selectedBox);
        Navigator.pop(context);
      },
      titlee: 'STOP',
    );

  }

  // void _handleBottomNavBarTap(int index, TimerModel timerModel) {
  //   if (index == 0) {
  //     timerModel.stopTimer(timerModel.selectedBox);
  //   } else if (index == 1) {
  //     // Handle the functionality for the second item (e.g., pause timer)
  //     // Add your logic here
  //   }
  // }
}
