import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/consts/list.dart';
import 'package:mikococo/widgets_common/our_button.dart';


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
  Color _selectedColor = whiteColor; //initialize with  a default color

  String getHexCode(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }

  void _showColorSelectionDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              decoration:
              InputDecoration(hintText: 'Enter a Text, letter or symbol'),
              controller: leadingcontroller,
              style: TextStyle(),
            ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ourButton(
                          color: redColor,
                          onpressed: () {
                            Navigator.pop(context);
                          },
                          textColor: whiteColor,
                          title: "Yes"),
                      ourButton(
                          color: redColor,
                          onpressed: () {},
                          textColor: whiteColor,
                          title: "No"),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Add New Routine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[

            Row(
              children: [
                Stack(children: [
                  Container(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      child: Text(leadingcontroller.text),
                      backgroundColor: _selectedColor,
                    ),
                  ),
                  Positioned(
                    top: 25,
                    left: 25,
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
                            size: 16,
                          )),
                    ),
                  )
                ]),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Routine Name'),
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: _desccontroller,
              decoration: InputDecoration(labelText: 'Routine Description'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty && _desccontroller.text.isNotEmpty
                    && leadingcontroller.text.isNotEmpty) {
                  widget.onAdd(_controller.text, _desccontroller.text, leadingcontroller.text,
                      getHexCode(_selectedColor));
                  print(getHexCode(_selectedColor));
                  _controller.clear();
                  Navigator.pop(context);
                }
              },
              child: Text('Add Routine'),
            ),
          ],
        ),
      ),
    );
  }
}