import 'package:budgetlife/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgetlife/bar_graph.dart';
import 'package:budgetlife/expense_list.dart';
import 'package:budgetlife/expense.dart';

class ExpenseReport extends StatelessWidget {
  final DateTime weekStart;
  final double weeklyBudget;

  const ExpenseReport({
    super.key,
    required this.weekStart,
    required this.weeklyBudget,
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
      expenses.calculateDailyExpenseSummary(weekStart)[sun] ?? 0,
      expenses.calculateDailyExpenseSummary(weekStart)[mon] ?? 0,
      expenses.calculateDailyExpenseSummary(weekStart)[tues] ?? 0,
      expenses.calculateDailyExpenseSummary(weekStart)[wed] ?? 0,
      expenses.calculateDailyExpenseSummary(weekStart)[thurs] ?? 0,
      expenses.calculateDailyExpenseSummary(weekStart)[fri] ?? 0,
      expenses.calculateDailyExpenseSummary(weekStart)[sat] ?? 0,
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
      expenses.calculateDailyExpenseSummary(weekStart)[sun] ?? 0,
      expenses.calculateDailyExpenseSummary(weekStart)[mon] ?? 0,
      expenses.calculateDailyExpenseSummary(weekStart)[tues] ?? 0,
      expenses.calculateDailyExpenseSummary(weekStart)[wed] ?? 0,
      expenses.calculateDailyExpenseSummary(weekStart)[thurs] ?? 0,
      expenses.calculateDailyExpenseSummary(weekStart)[fri] ?? 0,
      expenses.calculateDailyExpenseSummary(weekStart)[sat] ?? 0,
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
      builder: (context, value, child) {
        List<Expense> weeklyExpenses = value.getExpenseList(weekStart);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: Row(
                children: [
                  const Text('Weekly Total: '),
                  Text(
                      '\$${getWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
              child: Row(
                children: [
                  const Text('Weekly Budget: '),
                  Text('\$${weeklyBudget.toStringAsFixed(2)}'),
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
                    child: PieChartWidget(expenses: weeklyExpenses),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: screenWidth,
                    child: BarGraph(
                      maxY: weeklyBudget,
                      sunTotal: value.calculateDailyExpenseSummary(
                              weekStart)[sunday] ??
                          0,
                      monTotal: value.calculateDailyExpenseSummary(
                              weekStart)[monday] ??
                          0,
                      tuesTotal: value.calculateDailyExpenseSummary(
                              weekStart)[tuesday] ??
                          0,
                      wedTotal: value.calculateDailyExpenseSummary(
                              weekStart)[wednesday] ??
                          0,
                      thursTotal: value.calculateDailyExpenseSummary(
                              weekStart)[thursday] ??
                          0,
                      friTotal: value.calculateDailyExpenseSummary(
                              weekStart)[friday] ??
                          0,
                      satTotal: value.calculateDailyExpenseSummary(
                              weekStart)[saturday] ??
                          0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
