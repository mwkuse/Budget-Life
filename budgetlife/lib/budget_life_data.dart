import 'package:budgetlife/expense.dart';
import 'package:budgetlife/todo_entry.dart';
import 'package:hive/hive.dart';

class HiveDatabase {
  final _hiveBox = Hive.box("budget_life_database");

  // Budgeter
  // Given a list allExpense convert into dynamic list and add to hive box
  void saveData(List<Expense> allExpenses) {
    List<List<dynamic>> formattedExpenses = [];
    for (var expense in allExpenses) {
      List<dynamic> formattedExpense = [
        expense.type,
        expense.price,
        expense.dateTime,
        expense.category,
      ];
      formattedExpenses.add(formattedExpense);
    }
    _hiveBox.put("expenses", formattedExpenses);
  }

  List<Expense> getData() {
    List<Expense> expenseData = [];
    List hiveExpenses = _hiveBox.get("expenses") ?? [];

    for (int i = 0; i < hiveExpenses.length; i++) {
      String type = hiveExpenses[i][0];
      String price = hiveExpenses[i][1];
      DateTime dateTime = hiveExpenses[i][2];
      String category = hiveExpenses[i][3];

      Expense expense = Expense(
          type: type, price: price, dateTime: dateTime, category: category);

      expenseData.add(expense);
    }
    return expenseData;
  }

  void saveWeeklyBudget(double weeklyBudget) {
    _hiveBox.put("weeklyBudget", weeklyBudget);
  }

  double? getWeeklyBudget() {
    return _hiveBox.get("weeklyBudget");
  }

  // To Do List
  void saveToDoData(List<ToDoEntry> allToDos) {
    List<List<dynamic>> formattedToDos = [];
    for (var todo in allToDos) {
      List<dynamic> formattedToDo = [
        todo.title,
        todo.description,
        todo.isChecked,
        //todo.dateTime,
      ];
      formattedToDos.add(formattedToDo);
    }
    _hiveBox.put("todos", formattedToDos);
  }

  List<ToDoEntry> getToDoData() {
    List<ToDoEntry> toDoData = [];
    List hiveToDos = _hiveBox.get("todos") ?? [];

    for (int i = 0; i < hiveToDos.length; i++) {
      String title = hiveToDos[i][0];
      String description = hiveToDos[i][1];
      bool isChecked = hiveToDos[i][2];
      //DateTime dateTime = hiveToDos[i][2];

      ToDoEntry todo = ToDoEntry(
          title: title,
          description: description,
          isChecked: isChecked /*,dateTime: dateTime*/);
      toDoData.add(todo);
    }
    return toDoData;
  }
}
