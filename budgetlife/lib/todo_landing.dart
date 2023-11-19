import 'package:budgetlife/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgetlife/todo_entry.dart';
import 'package:budgetlife/todo_list.dart';
import 'package:budgetlife/todo_display.dart';

class ToDoHomePage extends StatefulWidget {
  const ToDoHomePage({super.key});

  @override
  State<ToDoHomePage> createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> {
  int test = 0;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ToDoList>(context, listen: false).initData();
  }

  void updateTest() {
    test = test + 1;
  }

  void saveToDo() {
    if (titleController.text.isNotEmpty) {
      ToDoEntry newToDo = ToDoEntry(
        title: titleController.text,
        description: descriptionController.text,
        isChecked: false,
        //dateTime: DateTime.now(),
      );
      Provider.of<ToDoList>(context, listen: false).addToDo(newToDo);
    }
    Navigator.pop(context);
    clearToDoControllers();
  }

  void cancelToDo() {
    Navigator.pop(context);
    clearToDoControllers();
  }

  void removeToDo(ToDoEntry todo) {
    Provider.of<ToDoList>(context, listen: false).removeToDo(todo);
  }

  void clearToDoControllers() {
    titleController.clear();
    descriptionController.clear();
  }

  void addToDo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a New ToDo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: "Description",
              ),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: saveToDo,
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: cancelToDo,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    int currentPage = appData.currentPage;
    return Consumer<ToDoList>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('To Do List'),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getToDoList().length,
              itemBuilder: (context, index) => ToDoDisplay(
                title: value.getToDoList()[index].title,
                description: value.getToDoList()[index].description,
                isChecked: value.getToDoList()[index].isChecked,
                //dateTime: value.getToDoList()[index].dateTime,
                deletePressed: (context) =>
                    removeToDo(value.getToDoList()[index]),
              ),
            ),
            const SizedBox(height: 35),
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
          onPressed: addToDo,
          backgroundColor: Colors.red,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
