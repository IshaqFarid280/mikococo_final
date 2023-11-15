import 'package:flutter/material.dart';
import 'package:mikococo/consts/colors.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () { Navigator.of(context).pop();},
          )
      ),
      body: Column(
        children: [
          Text(
            'Calender'
          )
        ],
      ),
    );
  }
}
