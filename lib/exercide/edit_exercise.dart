import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';

class EditExerciseForm extends StatelessWidget {
  final String initialName;
  final void Function(String) onEdit;

  EditExerciseForm({required this.initialName, required this.onEdit});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = initialName;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        textFormField(
          context: context,
          text: 'Edit Exercise Name',
          controller: _controller,
          // labelText: 'Example - Mass Gain Program'
        ),

        SizedBox(height: 16),
        SubmitButton(onTap: (){
          onEdit(_controller.text);
        }, titlee: 'Update Exercise',
          primaryColor: goldenColor,

        ),

      ],
    );
  }
}
