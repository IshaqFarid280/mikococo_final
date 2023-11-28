import 'package:flutter/material.dart';
import 'package:mikococo/widgets_common/our_button.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  LeadingIcon(),
      )
    );
  }
}
