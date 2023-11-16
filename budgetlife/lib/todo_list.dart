import 'package:budgetlife/budget_life_data.dart';
import 'package:flutter/material.dart';
import 'todo_entry.dart';

class ToDoList extends ChangeNotifier {
  final toDoDataBase = HiveDatabase();
  // Create List of ToDo Entries
  List<ToDoEntry> toDoList = [];

  // Return List of ToDo Entries
  List<ToDoEntry> getToDoList() {
    return toDoList;
  }

  void initData() {
    if (toDoDataBase.getData().isNotEmpty) {
      toDoList = toDoDataBase.getToDoData();
    }
    // toDoList = toDoDataBase.getToDoData();
  }

  // Add New Expense to List
  void addToDo(ToDoEntry todo) {
    toDoList.add(todo);
    notifyListeners();
    toDoDataBase.saveToDoData(toDoList);
  }

  // Remove Expense from List
  void removeToDo(ToDoEntry todo) {
    toDoList.remove(todo);
    notifyListeners();
    toDoDataBase.saveToDoData(toDoList);
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
}
