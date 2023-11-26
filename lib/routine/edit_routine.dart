import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';

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
    return Container(
      color: blackColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: textFormField(context: context, controller: _controller, text: 'New Routine Name'),
          ),

          SizedBox(height: 16),
          SubmitButton(onTap: (){

            widget.onEdit(_controller.text);
          },
            primaryColor: goldenColor, titlee: 'Save',),

        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
