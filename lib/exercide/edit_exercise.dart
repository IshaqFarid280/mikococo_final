import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';

class EditExerciseForm extends StatelessWidget {
  final String initialName;

  final String? initalDescription;

  final void Function(String, String) onEdit; // Updated parameter type


  EditExerciseForm({required this.initialName, required this.onEdit,  this.initalDescription});

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _descscontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = initialName;
    _descscontroller.text = initalDescription!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        textFormField(
          context: context,
          text: 'Update Name',
          controller: _controller,
          // labelText: 'Example - Mass Gain Program'
        ),
        textFormField(
          context: context,
          text: 'Update Description',
          controller: _descscontroller,
          // labelText: 'Example - Mass Gain Program'
        ),

        SizedBox(height: 16),
        SubmitButton(onTap: (){
          onEdit(_controller.text,  _descscontroller.text);
        }, titlee: 'Update Exercise',
          primaryColor: goldenColor,

        ),

      ],
    );
  }
}
