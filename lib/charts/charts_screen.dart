// ... (your existing imports)
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mikococo/consts/colors.dart';
import 'package:mikococo/consts/strnigs.dart';
import 'package:mikococo/widgets_common/our_button.dart';
import 'package:mikococo/widgets_common/text_widgets.dart';



class ChartScreen extends StatefulWidget {
  final List<int> repsData;
  final List<double> kgData;
  final List<DateTime> dates;  // Add dates as a parameter
  ChartScreen({required this.repsData, required this.kgData, required this.dates});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        leading: LeadingIcon(),
        title: normalText(title:appName),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            normalText(title: 'No of Reps',),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            RepsChart(data: widget.repsData, dates: widget.dates),  // Pass dates to RepsChart
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            normalText(title : 'Weight ( kg ) ',),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            KGChart(data: widget.kgData, dates: widget.dates),  // Pass dates to KGChart
          ],
        ),
      ),
    );
  }
}

class RepsChart extends StatefulWidget {
  final List<int> data;
  final List<DateTime> dates;

  RepsChart({required this.data, required this.dates});

  @override
  State<RepsChart> createState() => _RepsChartState();
}

class _RepsChartState extends State<RepsChart> {
  Set<int> uniqueIndices = Set<int>();

  List<String> cachedTitles = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.35,
      width: MediaQuery.sizeOf(context).width * 1,// Adjust the height as needed
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
          color: listTileColor),
      padding:const  EdgeInsets.all(5),
      child: LineChart(
        LineChartData(
          backgroundColor: listTileColor,
          gridData: FlGridData(drawHorizontalLine: true,drawVerticalLine: false),
          axisTitleData: FlAxisTitleData(rightTitle: AxisTitle(showTitle:true,reservedSize: 5),),
          titlesData: FlTitlesData(
            rightTitles: SideTitles(
              showTitles: false,
              reservedSize:10,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white,fontSize:20),
              getTitles: (value) {
                int index = value.toInt();
                print('RepsChart Index: $index, Data Length: ${widget.data.length}, Dates Length: ${widget.dates.length}');
                if (index >= 0 && index < widget.data.length) {
                  if (!uniqueIndices.contains(index)) {
                    uniqueIndices.add(index);
                    String title = widget.data[index].toString();
                    cachedTitles.add(title);
                    print('RepsChart Returning Reps: $title');
                    return title;
                  } else {
                    int cachedIndex = uniqueIndices.toList().indexOf(index);
                    print('RepsChart Returning Cached Reps: ${cachedTitles[cachedIndex]}');
                    return cachedTitles[cachedIndex];
                  }
                }
                print('RepsChart Returning Empty String');
                return '';
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white,fontSize:12),
            ),
            topTitles:SideTitles(
              margin: 5,
            showTitles: true,
            getTextStyles: (context, value) => const TextStyle(color:whiteColor,fontSize: 12),
            // Customize the date labels based on your needs
            getTitles: (value) {
              int index = value.toInt();
              if (uniqueIndices.contains(index)) {
                return ''; // Avoid displaying duplicate labels
              }
              // Show dates only for the first and last set
              if ((index == 0 || index == widget.data.length - 1) &&
                  index < widget.dates.length && index < widget.data.length && widget.data[index] != 0) {
                uniqueIndices.add(index);
                return DateFormat('MM-dd').format(widget.dates[index]);
              }
              return ''; // Return an empty string for other indices
            },
          ),
            bottomTitles:SideTitles(
              margin: 10,
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white,fontSize:12),
            ),
          ),
          borderData: FlBorderData(show: false,),
          lineBarsData: [
            LineChartBarData(
              // aboveBarData:  BarAreaData(show: true,colors: [skinColor,redColor],gradientFrom:const Offset(0,1),gradientTo:const Offset(3, 0), ),
              preventCurveOverShooting:true,
              preventCurveOvershootingThreshold: 10,
              // gradientFrom:const Offset(0, 5),
              // gradientTo:const Offset(5, 0),
              barWidth: 3,
              spots: List.generate(widget.data.length, (index) => FlSpot(index.toDouble(), widget.data[index].toDouble())),
              isCurved: false,
              // belowBarData:BarAreaData(show: true,colors: [blueColor,redColor],gradientFrom:const Offset(1,0),gradientTo:const Offset(0, 3), ),
              colors: [buttonColors],
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}


class KGChart extends StatefulWidget {
  final List<double> data;
  final List<DateTime> dates;

  KGChart({required this.data, required this.dates});

  @override
  State<KGChart> createState() => _KGChartState();
}

class _KGChartState extends State<KGChart> {
  Set<int> uniqueIndices = Set<int>();
  List<String> cachedTitles = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.35,
      width: MediaQuery.sizeOf(context).width * 1,// Adjust the height as needed
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
          color: listTileColor),
      padding:const  EdgeInsets.all(5),
      child: LineChart(
        LineChartData(
          backgroundColor: listTileColor,
          gridData: FlGridData(drawHorizontalLine: false,drawVerticalLine: true),
          axisTitleData: FlAxisTitleData(rightTitle: AxisTitle(showTitle:true,reservedSize: 5),),
          titlesData: FlTitlesData(
            rightTitles: SideTitles(
              showTitles: false,
              reservedSize:10,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white,fontSize:20),
              getTitles: (value) {
                int index = value.toInt();
                print('RepsChart Index: $index, Data Length: ${widget.data.length}, Dates Length: ${widget.dates.length}');
                if (index >= 0 && index < widget.data.length) {
                  if (!uniqueIndices.contains(index)) {
                    uniqueIndices.add(index);
                    String title = widget.data[index].toString();
                    cachedTitles.add(title);
                    print('RepsChart Returning Reps: $title');
                    return title;
                  } else {
                    int cachedIndex = uniqueIndices.toList().indexOf(index);
                    print('RepsChart Returning Cached Reps: ${cachedTitles[cachedIndex]}');
                    return cachedTitles[cachedIndex];
                  }
                }
                print('RepsChart Returning Empty String');
                return '';
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white,fontSize:12),
            ),
            topTitles:SideTitles(
              margin: 5,
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color:whiteColor,fontSize: 12),
              // Customize the date labels based on your needs
              getTitles: (value) {
                int index = value.toInt();
                if (uniqueIndices.contains(index)) {
                  return ''; // Avoid displaying duplicate labels
                }
                // Show dates only for the first and last set
                if ((index == 0 || index == widget.data.length - 1) &&
                    index < widget.dates.length && index < widget.data.length && widget.data[index] != 0) {
                  uniqueIndices.add(index);
                  return DateFormat('MM-dd').format(widget.dates[index]);
                }
                return ''; // Return an empty string for other indices
              },
            ),
            bottomTitles:SideTitles(
              margin: 10,
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Colors.white,fontSize:12),
            ),
          ),
          borderData: FlBorderData(show: false,),
          lineBarsData: [
            LineChartBarData(
              // aboveBarData:  BarAreaData(show: true,colors: [skinColor,redColor],gradientFrom:const Offset(0,1),gradientTo:const Offset(3, 0), ),
              preventCurveOverShooting:true,
              preventCurveOvershootingThreshold: 10,
              // gradientFrom:const Offset(0, 5),
              // gradientTo:const Offset(5, 0),
              barWidth: 3,
              spots: List.generate(widget.data.length, (index) => FlSpot(index.toDouble(), widget.data[index].toDouble())),
              isCurved: false,
              // belowBarData:BarAreaData(show: true,colors: [blueColor,redColor],gradientFrom:const Offset(1,0),gradientTo:const Offset(0, 3), ),
              colors: [buttonColors],
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}




