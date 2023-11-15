// ... (your existing imports)

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartScreen extends StatelessWidget {
  final List<int> repsData;
  final List<double> kgData;
  final List<DateTime> dates;  // Add dates as a parameter

  ChartScreen({required this.repsData, required this.kgData, required this.dates});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Charts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Reps Chart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            RepsChart(data: repsData, dates: dates),  // Pass dates to RepsChart
            SizedBox(height: 16.0),
            Text(
              'KG Chart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            KGChart(data: kgData, dates: dates),  // Pass dates to KGChart
          ],
        ),
      ),
    );
  }
}

class RepsChart extends StatelessWidget {
  final List<int> data;
  final List<DateTime> dates;

  RepsChart({required this.data, required this.dates});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0, // Adjust the height as needed
      child: LineChart(
        LineChartData(
          backgroundColor: Colors.black, // Set the background color to black
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white),
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white),
              // Customize the date labels based on your needs
              getTitles: (value) {
                int index = value.toInt();
                if (index >= 0 && index < dates.length) {
                  return DateFormat('MM-dd').format(dates[index]);
                }
                return '';
              },
            ),
          ),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index].toDouble())),
              isCurved: true,
              belowBarData: BarAreaData(show: false),
              colors: [Colors.blue],
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

class KGChart extends StatelessWidget {
  final List<double> data;
  final List<DateTime> dates;

  KGChart({required this.data, required this.dates});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0, // Adjust the height as needed
      child: LineChart(
        LineChartData(
          backgroundColor: Colors.black, // Set the background color to black
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white),
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white),
              // Customize the date labels based on your needs
              getTitles: (value) {
                int index = value.toInt();
                if (index >= 0 && index < dates.length) {
                  return DateFormat('MM-dd').format(dates[index]);
                }
                return '';
              },
            ),
          ),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index])),
              isCurved: true,
              belowBarData: BarAreaData(show: false),
              colors: [Colors.red],
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}


// class RepsChart extends StatelessWidget {
//   final List<int> data;
//   final List<DateTime> dates;  // Add dates as a parameter
//
//   RepsChart({required this.data, required this.dates});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 300.0, // Adjust the height as needed
//       child: LineChart(
//         LineChartData(
//           backgroundColor: Colors.black,  // Set the background color to black
//           titlesData: FlTitlesData(
//             leftTitles: SideTitles(
//               showTitles: true,
//               getTextStyles: (context, value) => const TextStyle(color: Colors.white),
//             ),
//             bottomTitles: SideTitles(
//               showTitles: true,
//               getTextStyles: (context, value) => const TextStyle(color: Colors.white),
//               // Customize the date labels based on your needs
//               getTitles: (value) {
//                 int index = value.toInt();
//                 if (index >= 0 && index < dates.length) {
//                   return DateFormat('MM-dd').format(dates[index]);
//                 }
//                 return '';
//               },
//             ),
//           ),
//           borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
//           lineBarsData: [
//             LineChartBarData(
//               spots: List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index].toDouble())),
//               isCurved: true,
//               belowBarData: BarAreaData(show: false),
//               colors: [Colors.blue],
//               dotData: FlDotData(show: false),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class KGChart extends StatelessWidget {
//   final List<double> data;
//   final List<DateTime> dates;  // Add dates as a parameter
//
//   KGChart({required this.data, required this.dates});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 300.0, // Adjust the height as needed
//       child: LineChart(
//         LineChartData(
//           backgroundColor: Colors.black,  // Set the background color to black
//           titlesData: FlTitlesData(
//             leftTitles: SideTitles(
//               showTitles: true,
//               getTextStyles: (context, value) => const TextStyle(color: Colors.white),
//             ),
//             bottomTitles: SideTitles(
//               showTitles: true,
//               getTextStyles: (context, value) => const TextStyle(color: Colors.white),
//               // Customize the date labels based on your needs
//               getTitles: (value) {
//                 int index = value.toInt();
//                 if (index >= 0 && index < dates.length) {
//                   return DateFormat('MM-dd').format(dates[index]);
//                 }
//                 return '';
//               },
//             ),
//           ),
//           borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
//           lineBarsData: [
//             LineChartBarData(
//               spots: List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index])),
//               isCurved: true,
//               belowBarData: BarAreaData(show: false),
//               colors: [Colors.red],
//               dotData: FlDotData(show: false),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
