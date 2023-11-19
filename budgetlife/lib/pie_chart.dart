import 'package:budgetlife/expense.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  final List<Expense> expenses;

  const PieChartWidget({
    super.key,
    required this.expenses,
  });

  Color getColor(int index) {
    List<Color> colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.brown,
      Colors.pink,
    ];
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (expenses.isEmpty) {
      // Display an empty PieChart
      return SizedBox(
        height: 325,
        width: screenWidth,
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                color: Colors.grey,
                value: 1,
                title: 'No Expenses',
                radius: 125,
                titleStyle: const TextStyle(
                  color: Colors.black, // Hide the text for the empty chart
                ),
              ),
            ],
            centerSpaceRadius: 0,
            centerSpaceColor: Colors.transparent,
            borderData: FlBorderData(show: false),
            sectionsSpace: 0,
          ),
        ),
      );
    }
    Map<String, double> categoryData = {};
    for (var expense in expenses) {
      String category = expense.category;
      var price = double.parse(expense.price);
      categoryData[category] = (categoryData[category] ?? 0) + price;
    }

    int index = 0;
    List<PieChartSectionData> pieSections = [];
    for (var entry in categoryData.entries) {
      pieSections.add(
        PieChartSectionData(
          color: getColor(index),
          value: entry.value,
          // title: entry.key,
          radius: 50,
          titleStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      );
      index = index + 1;
    }

    return Column(
      children: [
        const SizedBox(height: 30),
        SizedBox(
          height: 200,
          width: screenWidth,
          child: PieChart(
            PieChartData(
              sections: pieSections,
              centerSpaceRadius: 60,
              centerSpaceColor: Colors.white,
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              // pieTouchData: PieTouchData(
              //     enabled: true,
              //     touchCallback: (FlTouchEvent? touchEvent,
              //         PieTouchResponse? touchResponse) {
              //       if (touchEvent is FlLongPressEnd) {
              //         // Return null to hide the tooltip when the touch ends
              //         return;
              //       }
              //       if (touchEvent != null && touchResponse != null) {
              //         var entry = categoryData.entries.elementAt(
              //             touchResponse.touchedSection!.touchedSectionIndex);
              //         Tooltip(
              //           message:
              //               '${entry.key}: \$${entry.value.toStringAsFixed(2)}',
              //           textStyle: const TextStyle(
              //               color: Colors.white, fontWeight: FontWeight.bold),
              //         );
              //       }

              //       // Return null if no tooltip should be shown
              //       return;
              //     })
            ),
          ),
        ),
        const SizedBox(height: 35),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: List.generate(
              categoryData.length,
              (index) => SizedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      color: getColor(index),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Flexible(
                      child: Text(
                        categoryData.keys.elementAt(index),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
