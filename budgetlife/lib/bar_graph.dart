import 'package:budgetlife/bar_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarGraph extends StatelessWidget {
  final double? maxY;
  final double sunTotal;
  final double monTotal;
  final double tuesTotal;
  final double wedTotal;
  final double thursTotal;
  final double friTotal;
  final double satTotal;

  const BarGraph({
    super.key,
    required this.maxY,
    required this.sunTotal,
    required this.monTotal,
    required this.tuesTotal,
    required this.wedTotal,
    required this.thursTotal,
    required this.friTotal,
    required this.satTotal,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    BarData mybars = BarData(
      sunTotal: sunTotal,
      monTotal: monTotal,
      tuesTotal: tuesTotal,
      wedTotal: wedTotal,
      thursTotal: thursTotal,
      friTotal: friTotal,
      satTotal: satTotal,
    );

    mybars.initializeBarData();
    return SizedBox(
      height: 200,
      width: screenWidth,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: BarChart(
          BarChartData(
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: const FlTitlesData(
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: getBottomLables,
                ),
              ),
            ),
            minY: 0,
            maxY: maxY,
            barGroups: mybars.barData
                .map((data) => BarChartGroupData(
                      x: data.x,
                      barRods: [
                        BarChartRodData(
                            toY: data.y,
                            color: Colors.red,
                            width: 20,
                            borderRadius: BorderRadius.circular(10),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxY,
                              color: Colors.grey.shade200,
                            )),
                      ],
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

Widget getBottomLables(double value, TitleMeta meta) {
  Widget text;
  const style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
  switch (value.toInt()) {
    case 0:
      text = const Text(
        'S',
        style: style,
      );
      break;
    case 1:
      text = const Text(
        'M',
        style: style,
      );
      break;
    case 2:
      text = const Text(
        'T',
        style: style,
      );
      break;
    case 3:
      text = const Text(
        'W',
        style: style,
      );
      break;
    case 4:
      text = const Text(
        'T',
        style: style,
      );
      break;
    case 5:
      text = const Text(
        'F',
        style: style,
      );
      break;
    case 6:
      text = const Text(
        'S',
        style: style,
      );
      break;
    default:
      text = const Text('');
      break;
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
