import 'package:flutter/material.dart';

class EditWorkoutDayForm extends StatelessWidget {
  final String initialName;
  final void Function(String) onEdit;

  EditWorkoutDayForm({required this.initialName, required this.onEdit});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = initialName;

    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(labelText: 'New Workout Day Name'),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            onEdit(_controller.text);
          },
          child: Text('Update Workout Day'),
        ),
      ],
    );
  }
}
