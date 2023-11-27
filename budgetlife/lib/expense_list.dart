import 'package:budgetlife/budget_life_data.dart';
import 'package:flutter/material.dart';
import 'expense.dart';

class ExpenseList extends ChangeNotifier {
  final expenseDataBase = HiveDatabase();
  // Create List of Expenses
  Map<DateTime, List<Expense>> weeklyExpenses = {};
  List<Expense> expenseList = [];
  double weeklyBudget = 1000;

  // Return List of Expenses
  List<Expense> getExpenseList(DateTime dateTime) {
    return weeklyExpenses[dateTime] ?? [];
  }

  void initData() {
    if (expenseDataBase.getWeeklyExpenses().isNotEmpty) {
      weeklyExpenses = expenseDataBase.getWeeklyExpenses();
    }
  }

  void addExpense(Expense expense) {
    DateTime startOfWeek = getStartWeekDate(expense.dateTime);
    if (!weeklyExpenses.containsKey(startOfWeek)) {
      weeklyExpenses[startOfWeek] = [];
    }
    weeklyExpenses[startOfWeek]!.add(expense);
    notifyListeners();
    expenseDataBase.saveWeeklyExpenses(weeklyExpenses);
  }

  void removeExpense(Expense expense) {
    DateTime startOfWeek = getStartWeekDate(expense.dateTime);
    if (weeklyExpenses.containsKey(startOfWeek)) {
      weeklyExpenses[startOfWeek]!.remove(expense);
      notifyListeners();
      expenseDataBase.saveWeeklyExpenses(weeklyExpenses);
      // expenseDataBase.saveData(weeklyExpenses[startOfWeek]!);
    }
  }

  // Find and Return the Day of the Week
  String getDay(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  // Get the Date for Week Start
  DateTime getStartWeekDate(DateTime dateTime) {
    DateTime startWeekDate = dateTime;
    // Find Nearest Sunday (Start of Week)
    for (int i = 0; i < 7; i++) {
      if (getDay(dateTime.subtract(Duration(days: i))) == 'Sunday') {
        startWeekDate = dateTime.subtract(Duration(days: i));
      }
    }
    return startWeekDate;
  }

  // Add to or Create Total Cost For a Specific Date
  Map<String, double?> calculateDailyExpenseSummary(DateTime dateTime) {
    Map<String, double> dailyExpenseSummary = {};
    for (var expense in weeklyExpenses[dateTime]!) {
      String date = setDateTimeString(expense.dateTime);
      double price = double.parse(expense.price);
      // If There Are Already Existing Expenses with the Current Date
      if (dailyExpenseSummary.containsKey(date)) {
        double curPrice = dailyExpenseSummary[date]!;
        curPrice = curPrice + price;
        dailyExpenseSummary[date] = curPrice;
      } else {
        dailyExpenseSummary.addAll({date: price});
      }
    }
    return dailyExpenseSummary;
  }

  void setWeeklyBudget(double newBudget) {
    weeklyBudget = newBudget;
    notifyListeners();
    expenseDataBase.saveWeeklyBudget(weeklyBudget);
  }

  void initWeeklyBudget() {
    weeklyBudget = expenseDataBase.getWeeklyBudget() ?? 1000;
    notifyListeners();
  }
}

// Convert a DateTime Object to a String (yyyy/mm/dd)
String setDateTimeString(DateTime dateTime) {
  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  // Final Date as String
  String curDate = year + month + day;
  return curDate;
}
