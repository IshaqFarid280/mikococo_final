import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ChartScreen extends StatelessWidget {
  final List<int> repsData;
  final List<double> kgData;
  final List<DateTime> dates;

  ChartScreen({required this.repsData, required this.kgData, required this.dates});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Reps and KG Charts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'No of Reps',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0),
            RepsChart(data: repsData, dates: dates),
            SizedBox(height: 16.0),
            Text(
              'Weight ( kg )',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0),
            KGChart(data: kgData, dates: dates),
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
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[900],
      ),
      padding: const EdgeInsets.all(5),
      child: LineChart(
        LineChartData(
          backgroundColor: Colors.grey[900],
          gridData: FlGridData(
            drawHorizontalLine: true,
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(
            rightTitles: SideTitles(
              showTitles: true,
              reservedSize: 2,
            ),
            topTitles: SideTitles(
              showTitles: true,
              reservedSize: 2,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              margin: 10,
              rotateAngle: 90,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white, fontSize: 12),
              getTitles: (value) {
                int index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return data[index].toString();
                }
                return '';
              },
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white, fontSize: 12),
              getTitles: (value) {
                int index = value.toInt();
                if (index >= 0 && index < dates.length) {
                  return DateFormat('MM-dd').format(dates[index]);
                }
                return '';
              },
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              preventCurveOverShooting: true,
              barWidth: 3,
              spots: List.generate(
                data.length,
                    (index) => FlSpot(index.toDouble(), data[index].toDouble()),
              ),
              isCurved: false,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[900],
      ),
      padding: const EdgeInsets.all(5),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: true, drawHorizontalLine: false),
          backgroundColor: Colors.grey[900],
          titlesData: FlTitlesData(
            rightTitles: SideTitles(
              showTitles: true,
              reservedSize: 5,
            ),
            topTitles: SideTitles(
              reservedSize: 5,
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              margin: 10,
              rotateAngle: 90,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white, fontSize: 12),
              getTitles: (value) {
                int index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return data[index].toString();
                }
                return '';
              },
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white, fontSize: 12),
              getTitles: (value) {
                int index = value.toInt();
                if (index >= 0 && index < dates.length) {
                  return DateFormat('MM-dd').format(dates[index]);
                }
                return '';
              },
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              preventCurveOverShooting: true,
              barWidth: 3,
              spots: List.generate(
                data.length,
                    (index) => FlSpot(index.toDouble(), data[index]),
              ),
              isCurved: false,
              colors: [Colors.green],
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}