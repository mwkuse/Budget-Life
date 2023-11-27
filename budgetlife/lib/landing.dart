import 'package:budgetlife/budget_life_data.dart';
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
  int currentWeekIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<ExpenseList>(context, listen: false).initData();
      Provider.of<ExpenseList>(context, listen: false).initWeeklyBudget();
      List<DateTime> weeks = Provider.of<ExpenseList>(context, listen: false)
          .weeklyExpenses
          .keys
          .toList();
      weeks.sort();
      setState(() {
        currentWeekIndex = weeks.length - 1;
      });
    });
  }

  // Controllers Allows Access to Text that User Types
  final weeklyBudgetController = TextEditingController();
  final expenseTypeController = TextEditingController();
  final dollarController = TextEditingController();
  final centController = TextEditingController();
  String? selectedCategory;
  double weeklyBudget = 1000;

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

  void changeWeeklyBudget(double newBudget) {
    //print('New Weekly Budget is: $newBudget');
    weeklyBudget = newBudget;
    Future.delayed(Duration.zero, () {
      Provider.of<ExpenseList>(context, listen: false)
          .setWeeklyBudget(newBudget);
      HiveDatabase().saveWeeklyBudget(newBudget);
    });
  }

  void addExpense() {
    DateTime setDateTime = DateTime.now();
    String selectedDateText = 'Set Date';
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Add a New Expense'),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
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
                    ListTile(
                      title: Text(selectedDateText),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      onTap: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: setDateTime,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (newDate != null) {
                          setState(() {
                            setDateTime = DateTime(
                                newDate.year, newDate.month, newDate.day);
                            selectedDateText =
                                "Selected Date: ${newDate.month}/${newDate.day}/${newDate.year}";
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () => saveExpense(setDateTime),
                  child: const Text('Save'),
                ),
                MaterialButton(
                  onPressed: cancelExpense,
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void saveExpense(DateTime setDateTime) {
    if (expenseTypeController.text.isNotEmpty &&
        dollarController.text.isNotEmpty &&
        centController.text.isNotEmpty) {
      String price = '${dollarController.text}.${centController.text}';
      Expense newExpense = Expense(
        type: expenseTypeController.text,
        price: price,
        dateTime: setDateTime,
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

  void goPreviousWeek() {
    setState(() {
      if (currentWeekIndex > 0) {
        currentWeekIndex--;
      }
    });
  }

  void goNextWeek() {
    setState(() {
      List<DateTime> weeks = Provider.of<ExpenseList>(context, listen: false)
          .weeklyExpenses
          .keys
          .toList();
      if (currentWeekIndex < weeks.length - 1) {
        currentWeekIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ExpenseList>(context, listen: false).initData();
    List<DateTime> weeks = Provider.of<ExpenseList>(context, listen: false)
        .weeklyExpenses
        .keys
        .toList();
    weeks.sort();
    DateTime currentWeekStart = currentWeekIndex < weeks.length
        ? weeks[currentWeekIndex]
        : DateTime.now();

    String greeting = getGreeting();
    final appData = Provider.of<AppData>(context);
    int currentPage = appData.currentPage;
    return Consumer<ExpenseList>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Budget Life'),
            backgroundColor: Colors.red,
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        'Set Weekly Budget',
                        textAlign: TextAlign.center,
                      ),
                      content: TextField(
                        controller: weeklyBudgetController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: "Enter Weekly Budget"),
                      ),
                      actions: [
                        ButtonBar(
                          alignment: MainAxisAlignment.end,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                double newBudget =
                                    double.parse(weeklyBudgetController.text);
                                Future.delayed(Duration.zero, () {
                                  setState(() {
                                    changeWeeklyBudget(newBudget);
                                  });
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('Set'),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
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
                ExpenseReport(
                  weekStart: currentWeekStart,
                  weeklyBudget: Provider.of<ExpenseList>(context, listen: false)
                      .weeklyBudget,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: goPreviousWeek,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Text(
                      "Week of ${currentWeekStart.month}/${currentWeekStart.day}/${currentWeekStart.year}",
                    ),
                    IconButton(
                      onPressed: goNextWeek,
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
                Provider.of<ExpenseList>(context)
                        .getExpenseList(currentWeekStart)
                        .isEmpty
                    ? const Center(
                        child: Text("No Expenses to Display"),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            value.getExpenseList(currentWeekStart).length,
                        itemBuilder: (context, index) => ExpenseDisplay(
                          key: ValueKey(value
                              .getExpenseList(currentWeekStart)[index]
                              .dateTime),
                          type: value
                              .getExpenseList(currentWeekStart)[index]
                              .type,
                          price: value
                              .getExpenseList(currentWeekStart)[index]
                              .price,
                          dateTime: value
                              .getExpenseList(currentWeekStart)[index]
                              .dateTime,
                          category: value
                              .getExpenseList(currentWeekStart)[index]
                              .category,
                          deletePressed: (context) => removeExpense(
                              value.getExpenseList(currentWeekStart)[index]),
                        ),
                      ),
                const SizedBox(
                  height: 35,
                ),
              ],
            ),
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
                      Future.delayed(Duration.zero, () {
                        setState(() {
                          currentPage = 0;
                          appData.setCurrentPage(currentPage);
                        });
                      });
                    },
                    icon: const Icon(Icons.attach_money),
                    color: currentPage == 0 ? Colors.black : Colors.white,
                  ),
                  IconButton(
                    onPressed: () {
                      Future.delayed(Duration.zero, () {
                        setState(() {
                          currentPage = 1;
                          appData.setCurrentPage(currentPage);
                        });
                      });
                    },
                    icon: const Icon(Icons.list),
                    color: currentPage == 1 ? Colors.black : Colors.white,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: addExpense,
            backgroundColor: Colors.red,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
