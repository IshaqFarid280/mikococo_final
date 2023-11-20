// ... (your existing imports)
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mikococo/consts/colors.dart';



class ChartScreen extends StatelessWidget {
  final List<int> repsData;
  final List<double> kgData;
  final List<DateTime> dates;  // Add dates as a parameter
  ChartScreen({required this.repsData, required this.kgData, required this.dates});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
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
  Set<int> uniqueIndices = Set<int>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.35,
      width: MediaQuery.sizeOf(context).width * 0.65,// Adjust the height as needed
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: LineChart(
        LineChartData(
          backgroundColor: Colors.black,
          gridData: FlGridData(show: false,),
          // Set the background color to black
          titlesData: FlTitlesData(
            rightTitles: SideTitles(
              showTitles: false,
              // getTextStyles: (context, value) => const TextStyle(color: Colors.white),
            ),
            topTitles:SideTitles(
              showTitles: false,
              // getTextStyles: (context, value) => const TextStyle(color: Colors.white),
            ),
            leftTitles: SideTitles(
              showTitles: false,
              // getTextStyles: (context, value) => const TextStyle(color: Colors.white),
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white),
             // Customize the date labels based on your needs
              getTitles: (value) {
                int index = value.toInt();
                if (uniqueIndices.contains(index)) {
                  return ''; // Avoid displaying duplicate labels
                }

                // Show dates only for the first and last set
                if ((index == 0 || index == data.length - 1) &&
                    index < dates.length && index < data.length && data[index] != 0) {
                  uniqueIndices.add(index);
                  return DateFormat('MM-dd').format(dates[index]);
                }
                return ''; // Return an empty string for other indices
              },
            ),
          ),
          borderData: FlBorderData(show: false, border: Border.all(color: Colors.grey)),
          lineBarsData: [
            LineChartBarData(
              aboveBarData:  BarAreaData(show: true,colors: [skinColor,redColor],gradientFrom:const Offset(0,1),gradientTo:const Offset(3, 0), ),
              preventCurveOverShooting:true,
              preventCurveOvershootingThreshold: 10,
              // gradientFrom:const Offset(0, 5),
              // gradientTo:const Offset(5, 0),
              barWidth: 3,
              spots: List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index].toDouble())),
              isCurved: true,
              belowBarData:BarAreaData(show: true,colors: [blueColor,redColor],gradientFrom:const Offset(1,0),gradientTo:const Offset(0, 3), ),
              colors: [Colors.blue],
              dotData: FlDotData(show: true),
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
  Set<int> uniqueIndices = Set<int>();
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.35,
        width: MediaQuery.sizeOf(context).width * 0.65, // Adjust the height as needed
      child: LineChart(
        swapAnimationDuration: Duration(seconds:2),
        swapAnimationCurve :Curves.easeInCirc,
        LineChartData(
          gridData: FlGridData(show: false),
          backgroundColor: Colors.black, // Set the background color to black
          titlesData: FlTitlesData(
            rightTitles: SideTitles(
              showTitles: false,
              // getTextStyles: (context, value) => const TextStyle(color: Colors.white),
            ),
            topTitles:SideTitles(
              showTitles: false,
              // getTextStyles: (context, value) => const TextStyle(color: Colors.white),
            ),
            leftTitles: SideTitles(
              showTitles: false,
              // getTextStyles: (context, value) => const TextStyle(color: Colors.white),
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white),
              // Customize the date labels based on your needs
              getTitles: (value) {
                int index = value.toInt();
                if (uniqueIndices.contains(index)) {
                  return ''; // Avoid displaying duplicate labels
                }

                // Show dates only for the first and last set
                if ((index == 0 || index == data.length - 1) &&
                    index < dates.length && index < data.length && data[index] != 0) {
                  uniqueIndices.add(index);
                  return DateFormat('MM-dd').format(dates[index]);
                }
                return ''; // Return an empty string for other indices
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              aboveBarData:BarAreaData(show: true,colors: [blueColor,redColor],gradientFrom:const Offset(0,1),gradientTo:const Offset(3, 0), ),
              preventCurveOverShooting:true,
              gradientFrom:const Offset(0, 5),
              gradientTo:const Offset(5, 0),
              barWidth: 3,
              spots: List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index])),
              isCurved: true,
              belowBarData:BarAreaData(show: true,colors: [skinColor,redColor],gradientFrom:const Offset(0,0.5),gradientTo:const Offset(3, 0), ),
              colors: [redColor],
              dotData: FlDotData(show: true,),
            ),
          ],
        ),
      ),
    );
  }
}
