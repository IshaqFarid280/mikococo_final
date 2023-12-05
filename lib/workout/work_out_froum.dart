import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/consts/list.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';

class AddWorkoutDayForm extends StatefulWidget {
  final Function(String, String, String) onAdd;

  AddWorkoutDayForm({required this.onAdd});

  @override
  _AddWorkoutDayFormState createState() => _AddWorkoutDayFormState();
}

class _AddWorkoutDayFormState extends State<AddWorkoutDayForm> {
  final TextEditingController _workoutNameController = TextEditingController();
  final TextEditingController leadingworkoutcontroller = TextEditingController();
  Color _selectedworkoutColor = greyColor; //initialize with  a default color
  int _selectedColorIndex = 0;

  String getHexCodeWorkout(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }

  void _showColorSelectionDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: ThemeData(
              canvasColor: blackColor,
            ),
            child: AlertDialog(
              backgroundColor: blackColor,
              title: onewordTextFormField(
                  controller: leadingworkoutcontroller,
                  hint: 'Enter a Text, letter or symbol'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: colorSelection.asMap().entries.map((entry) {
                        int index = entry.key;
                        Color color = entry.value;
                        bool isSelected = index == _selectedColorIndex;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedworkoutColor = color;
                              _selectedColorIndex = index;
                              print(_selectedworkoutColor);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Stack(alignment: Alignment.center, children: [
                              CircleAvatar(
                                backgroundColor: color,
                                radius: 15,
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check,
                                  color: whiteColor,
                                  size: 20,
                                )
                            ]),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.02,
                    ),
                    SubmitButtonnoPadding(onTap: (){
                      Navigator.of(context).pop();
                    }, primaryColor: goldenColor, titlee: 'Submit',)
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: LeadingIcon(),
        title: largeText(title: 'Add New Workout'),
      ),
      bottomNavigationBar: SubmitButton(
          titlee: 'Add Workout',
          primaryColor: goldenColor,
          onTap: () {
            if (_workoutNameController.text.isNotEmpty) {
              if(leadingworkoutcontroller.text.isNotEmpty){
// Set the first character of _controller to leadingcontroller
                leadingworkoutcontroller.text = _workoutNameController.text.substring(0, 1);
              }
              widget.onAdd(
                  _workoutNameController.text,
                  leadingworkoutcontroller.text,
                  getHexCodeWorkout(_selectedworkoutColor));
              print(getHexCodeWorkout(_selectedworkoutColor));
            }
          }),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                          color: _selectedworkoutColor,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      height: MediaQuery.of(context).size.height * .1,
                      width: MediaQuery.of(context).size.width * .2,
                      child: Center(
                          child: Text(
                        leadingworkoutcontroller.text.isNotEmpty
                          ?leadingworkoutcontroller.text.toUpperCase()
                              :_workoutNameController.text.isNotEmpty
                      ?_workoutNameController.text.substring(0, 1).toUpperCase()
                  : '',
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      )),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey),
                        padding: EdgeInsets.all(4),
                        child: InkWell(
                            onTap: () {
                              _showColorSelectionDialog();
                            },
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: goldenColor,
                            )),
                      ),
                    )
                  ]),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            textFormField(
              context: context,
              text: 'Workout Name',
              controller: _workoutNameController,
              hint: 'example - day 1',
              // labelText: 'Example - Mass Gain Program'
            ),
          ],
        ),
      ),
    );
  }
}
