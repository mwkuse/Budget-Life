import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'expense_list.dart';
import 'landing.dart';
import 'todo_landing.dart';
import 'todo_list.dart';

void main() async {
  await Hive.initFlutter();
  // Initialize Hive Local Database
  await Hive.openBox("budget_life_database");

  // Delete Hive Database
  // final hivebox = Hive.box("budget_life_database");
  // hivebox.deleteFromDisk();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppData(),
      builder: (context, child) => const MyApp(),
    ),
  );
}

class AppData with ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;
  void setCurrentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: appData.currentPage == 0 ? const Page1() : const Page2(),
      ),
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseList(),
      builder: (context, child) {
        return const HomePage();
      },
    );
  }
}

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ToDoList(),
      builder: (context, child) {
        return const ToDoHomePage();
      },
    );
  }
}
