

import 'package:flutter/material.dart';

import '../../widgets_common/text_widgets.dart';

class StatusScreen extends StatelessWidget {
  final String  totalReps ; // Replace with your actual data
  final String  totalKg  ;// Replace with your actual data
  final String  averageKg ;// Replace with your actual data
  final String bestReps  ;// Replace with your actual data
  final String bestKg  ;// Replace with your actual data

  StatusScreen({required this.totalKg,required this.totalReps,required this.averageKg ,required this.bestKg,required this.bestReps});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stauts'),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: normalText(title :'Total Reps: $totalReps'),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: normalText(title :'Total KG: $totalKg'),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: normalText(title :'Average KG: ${averageKg}'),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: normalText(title :'Best Reps: $bestReps'),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: normalText(title :'Best KG: $bestKg'),
            ),
          ],
        ),
      ),
    );
  }
}