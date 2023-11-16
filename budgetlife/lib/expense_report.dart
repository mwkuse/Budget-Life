import 'package:budgetlife/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgetlife/bar_graph.dart';
import 'package:budgetlife/expense_list.dart';

class ExpenseReport extends StatelessWidget {
  final DateTime weekStart;

  const ExpenseReport({
    super.key,
    required this.weekStart,
  });

  double getMaxExpense(
    ExpenseList expenses,
    String sun,
    String mon,
    String tues,
    String wed,
    String thurs,
    String fri,
    String sat,
  ) {
    double? maxExpense = 100;
    List<double> expenseValues = [
      expenses.calculateDailyExpenseSummary()[sun] ?? 0,
      expenses.calculateDailyExpenseSummary()[mon] ?? 0,
      expenses.calculateDailyExpenseSummary()[tues] ?? 0,
      expenses.calculateDailyExpenseSummary()[wed] ?? 0,
      expenses.calculateDailyExpenseSummary()[thurs] ?? 0,
      expenses.calculateDailyExpenseSummary()[fri] ?? 0,
      expenses.calculateDailyExpenseSummary()[sat] ?? 0,
    ];
    expenseValues.sort();

    maxExpense = expenseValues.last + 10;
    return maxExpense == 0 ? 100 : maxExpense;
  }

  String getWeekTotal(
    ExpenseList expenses,
    String sun,
    String mon,
    String tues,
    String wed,
    String thurs,
    String fri,
    String sat,
  ) {
    List<double> expenseValues = [
      expenses.calculateDailyExpenseSummary()[sun] ?? 0,
      expenses.calculateDailyExpenseSummary()[mon] ?? 0,
      expenses.calculateDailyExpenseSummary()[tues] ?? 0,
      expenses.calculateDailyExpenseSummary()[wed] ?? 0,
      expenses.calculateDailyExpenseSummary()[thurs] ?? 0,
      expenses.calculateDailyExpenseSummary()[fri] ?? 0,
      expenses.calculateDailyExpenseSummary()[sat] ?? 0,
    ];
    double totalExpense = 0;
    for (int i = 0; i < expenseValues.length; i++) {
      totalExpense = totalExpense + expenseValues[i];
    }
    return totalExpense.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String sunday = setDateTimeString(weekStart.add(const Duration(days: 0)));
    String monday = setDateTimeString(weekStart.add(const Duration(days: 1)));
    String tuesday = setDateTimeString(weekStart.add(const Duration(days: 2)));
    String wednesday =
        setDateTimeString(weekStart.add(const Duration(days: 3)));
    String thursday = setDateTimeString(weekStart.add(const Duration(days: 4)));
    String friday = setDateTimeString(weekStart.add(const Duration(days: 5)));
    String saturday = setDateTimeString(weekStart.add(const Duration(days: 6)));

    return Consumer<ExpenseList>(
      builder: (context, value, child) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                const Text('Weekly Total: '),
                Text(
                    '\$${getWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}'),
              ],
            ),
          ),
          SizedBox(
            height: 325,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: screenWidth,
                  child: PieChartWidget(expenses: value.getExpenseList()),
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: screenWidth,
                  child: BarGraph(
                    maxY: getMaxExpense(value, sunday, monday, tuesday,
                        wednesday, thursday, friday, saturday),
                    sunTotal: value.calculateDailyExpenseSummary()[sunday] ?? 0,
                    monTotal: value.calculateDailyExpenseSummary()[monday] ?? 0,
                    tuesTotal:
                        value.calculateDailyExpenseSummary()[tuesday] ?? 0,
                    wedTotal:
                        value.calculateDailyExpenseSummary()[wednesday] ?? 0,
                    thursTotal:
                        value.calculateDailyExpenseSummary()[thursday] ?? 0,
                    friTotal: value.calculateDailyExpenseSummary()[friday] ?? 0,
                    satTotal:
                        value.calculateDailyExpenseSummary()[saturday] ?? 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
