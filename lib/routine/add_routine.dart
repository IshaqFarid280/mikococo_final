import 'package:flutter/material.dart';


class AddRoutineForm extends StatefulWidget {
  final Function(String) onAdd;

  AddRoutineForm({required this.onAdd});

  @override
  _AddRoutineFormState createState() => _AddRoutineFormState();
}

class _AddRoutineFormState extends State<AddRoutineForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(labelText: 'Routine Name'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onAdd(_controller.text);
              _controller.clear();
            }
          },
          child: Text('Add Routine'),
        ),
      ],
    );
  }
}