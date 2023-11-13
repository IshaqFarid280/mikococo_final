import 'package:flutter/material.dart';

class EditRoutineForm extends StatefulWidget {
  final String initialName;
  final Function(String) onEdit;

  EditRoutineForm({required this.initialName, required this.onEdit});

  @override
  _EditRoutineFormState createState() => _EditRoutineFormState();
}

class _EditRoutineFormState extends State<EditRoutineForm> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(labelText: 'New Routine Name'),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            widget.onEdit(_controller.text);
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
