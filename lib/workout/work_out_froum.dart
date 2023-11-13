import 'package:flutter/material.dart';

class AddWorkoutDayForm extends StatefulWidget {
  final Function(String) onAdd;

  AddWorkoutDayForm({required this.onAdd});

  @override
  _AddWorkoutDayFormState createState() => _AddWorkoutDayFormState();
}

class _AddWorkoutDayFormState extends State<AddWorkoutDayForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(labelText: 'Workout Day Name'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onAdd(_controller.text);
              _controller.clear();
            }
          },
          child: Text('Add Workout Day'),
        ),
      ],
    );
  }
}