import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/consts/list.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';

class AddRoutineForm extends StatefulWidget {
  final Function(String, String, String, String) onAdd;

  AddRoutineForm({required this.onAdd});

  @override
  _AddRoutineFormState createState() => _AddRoutineFormState();
}

class _AddRoutineFormState extends State<AddRoutineForm> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _desccontroller = TextEditingController();
  final TextEditingController leadingcontroller = TextEditingController();
  Color _selectedColor = greyColor; //initialize with  a default color

  String getHexCode(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }

  void _showColorSelectionDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: ThemeData(
              canvasColor: leadingBtnColor,
            ),
            child: AlertDialog(
              backgroundColor: leadingBtnColor,
              title: onewordTextFormField(controller: leadingcontroller, hint: 'Enter a Text, letter or symbol'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: colorSelection
                          .map((color) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = color;
                                    print(_selectedColor);
                                  });
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: color,
                                    radius: 15,
                                  ),
                                ),
                              ))
                          .toList(),
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
      bottomNavigationBar: SubmitButton(
          titlee: 'Add Routine',
          primaryColor: goldenColor,
          onTap: () {
            if (_controller.text.isNotEmpty &&
                _desccontroller.text.isNotEmpty ) {

              if (leadingcontroller.text.isEmpty) {
                // Set the first character of _controller to leadingcontroller
                leadingcontroller.text = _controller.text.substring(0, 1);
              }

              widget.onAdd(_controller.text, _desccontroller.text,
                  leadingcontroller.text, getHexCode(_selectedColor));
              print(getHexCode(_selectedColor));
              _controller.clear();
              Navigator.pop(context);
            }
          }),
      appBar: AppBar(
        leading: LeadingIcon(),
        title: largeText(title: 'Add New Routine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            children: [
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
                        color: _selectedColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: MediaQuery.of(context).size.height * .1,
                    width: MediaQuery.of(context).size.width * .2,
                    child: Center(
                        child: Text(
                      leadingcontroller.text.isNotEmpty
                          ? leadingcontroller.text.toUpperCase()
                          :_controller.text.isNotEmpty
                          ? _controller.text.substring(0, 1).toUpperCase()
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
          ),SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          textFormField(
            context: context,
            text: 'Routine Name',
            controller: _controller,
            hint: 'example - mass gain program',
            // labelText: 'Example - Mass Gain Program'
          ),
          textFormField(
            context: context,
            text: 'Routine Description',
            controller: _desccontroller,
            hint: 'example - december',
            // labelText: 'Example - Mass Gain Program'
          ),
        ]),
      ),
    );
  }

}
