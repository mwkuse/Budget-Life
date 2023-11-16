import 'package:budgetlife/budget_life_data.dart';
import 'package:flutter/material.dart';
import 'expense.dart';

class ExpenseList extends ChangeNotifier {
  final expenseDataBase = HiveDatabase();
  // Create List of Expenses
  List<Expense> expenseList = [];

  // Return List of Expenses
  List<Expense> getExpenseList() {
    return expenseList;
  }

  void initData() {
    if (expenseDataBase.getData().isNotEmpty) {
      expenseList = expenseDataBase.getData();
    }
  }

  // Add New Expense to List
  void addExpense(Expense expense) {
    expenseList.add(expense);
    notifyListeners();
    expenseDataBase.saveData(expenseList);
  }

  // Remove Expense from List
  void removeExpense(Expense expense) {
    expenseList.remove(expense);
    notifyListeners();
    expenseDataBase.saveData(expenseList);
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
  DateTime getStartWeekDate() {
    DateTime? startWeekDate;
    DateTime today = DateTime.now();
    // Find Nearest Sunday (Start of Week)
    for (int i = 0; i < 7; i++) {
      if (getDay(today.subtract(Duration(days: i))) == 'Sunday') {
        startWeekDate = today.subtract(Duration(days: i));
      }
    }
    return startWeekDate!;
  }

  // Add to or Create Total Cost For a Specific Date
  Map<String, double?> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};
    for (var expense in expenseList) {
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
