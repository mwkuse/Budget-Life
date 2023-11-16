import 'package:budgetlife/expense_display.dart';
import 'package:budgetlife/expense_report.dart';
import 'package:budgetlife/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expense.dart';
import 'expense_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseList>(context, listen: false).initData();
  }

  // Controllers Allows Access to Text that User Types
  final expenseTypeController = TextEditingController();
  final dollarController = TextEditingController();
  final centController = TextEditingController();
  String? selectedCategory;

  final categories = [
    'Food',
    'Housing',
    'Insurance',
    'Medical',
    'Miscellaneous',
    'Recreation',
    'Transportation',
    'Utilities'
  ];

  DropdownMenuItem<String> dropdownMenuItem(String category) =>
      DropdownMenuItem(value: category, child: Text(category));

  void addExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a New Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: expenseTypeController,
              decoration: const InputDecoration(
                hintText: "Expense Type",
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dollarController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Dollars",
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: centController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Cents",
                    ),
                  ),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map(dropdownMenuItem).toList(),
              onChanged: (value) => setState(() {
                selectedCategory = value;
              }),
              decoration: const InputDecoration(
                labelText: 'Category',
                hintText: 'Select a category',
              ),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: saveExpense,
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: cancelExpense,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void saveExpense() {
    if (expenseTypeController.text.isNotEmpty &&
        dollarController.text.isNotEmpty &&
        centController.text.isNotEmpty) {
      String price = '${dollarController.text}.${centController.text}';
      Expense newExpense = Expense(
        type: expenseTypeController.text,
        price: price,
        dateTime: DateTime.now(),
        category: selectedCategory ?? 'Miscellaneous',
      );
      Provider.of<ExpenseList>(context, listen: false).addExpense(newExpense);
    }
    Navigator.pop(context);
    clearExpenseControllers();
    setState(() {
      selectedCategory = null;
    });
  }

  void cancelExpense() {
    Navigator.pop(context);
    clearExpenseControllers();
  }

  void removeExpense(Expense expense) {
    Provider.of<ExpenseList>(context, listen: false).removeExpense(expense);
  }

  void clearExpenseControllers() {
    expenseTypeController.clear();
    dollarController.clear();
    centController.clear();
  }

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    }
    if (hour < 17) {
      return 'Good Afternoon!';
    }
    return 'Good Evening!';
  }

  @override
  Widget build(BuildContext context) {
    String greeting = getGreeting();
    final appData = Provider.of<AppData>(context);
    int currentPage = appData.currentPage;
    return Consumer<ExpenseList>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Budget Life'),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                greeting,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ExpenseReport(weekStart: value.getStartWeekDate()),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getExpenseList().length,
              itemBuilder: (context, index) => ExpenseDisplay(
                type: value.getExpenseList()[index].type,
                price: value.getExpenseList()[index].price,
                dateTime: value.getExpenseList()[index].dateTime,
                category: value.getExpenseList()[index].category,
                deletePressed: (context) =>
                    removeExpense(value.getExpenseList()[index]),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 5.0,
          clipBehavior: Clip.antiAlias,
          color: Colors.red,
          child: SizedBox(
            height: kBottomNavigationBarHeight,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 0;
                      appData.setCurrentPage(currentPage);
                    });
                  },
                  icon: const Icon(Icons.attach_money),
                  color: currentPage == 0 ? Colors.black : Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentPage = 1;
                      appData.setCurrentPage(currentPage);
                    });
                  },
                  icon: const Icon(Icons.list),
                  color: currentPage == 1 ? Colors.black : Colors.white,
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: addExpense,
          backgroundColor: Colors.red,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
