
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';

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
        centerTitle: true,
        leading: LeadingIcon(),
        title: normalText(title: 'Globalfit'),
        actions: [
          AddThingsIcon(
            svgAsset: 'assets/svg/saveicon.svg',
            svgColor: listTileEditColor,
            onTap: () async {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.04,),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 8),
            child: largeText(title: 'Edit Timer'),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.01,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              widget.timerValues.length,
                  (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: leadingBtnColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: buttonColors)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      normalText(title: 'Timer ${index + 1}  : '),
                      IconButton(
                        icon: Icon(Icons.remove, color: whiteColor,),
                        onPressed: () {
                          _decrementTimer(index);
                        },
                      ),
                      normalText(title: '${editedValues[index]}s'),
                      IconButton(
                        icon: Icon(Icons.add, color: whiteColor,),
                        onPressed: () {
                          _incrementTimer(index);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
