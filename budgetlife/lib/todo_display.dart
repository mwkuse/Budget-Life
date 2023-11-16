import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';

class ToDoDisplay extends StatefulWidget {
  final String title;
  final String description;
  final bool isChecked;
  //final DateTime dateTime;
  final void Function(BuildContext)? deletePressed;

  const ToDoDisplay({
    super.key,
    required this.title,
    required this.description,
    required this.isChecked,
    /*required this.dateTime,*/
    required this.deletePressed,
  });

  @override
  ToDoDisplayState createState() => ToDoDisplayState();
}

class ToDoDisplayState extends State<ToDoDisplay> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  void updateCheckbox(bool? checked) async {
    if (checked != null) {
      setState(() {
        _isChecked = checked;
      });
    }
    final hivebox = Hive.box("budget_life_database");

    final List<dynamic> todos = hivebox.get('todos') ?? [];

    for (int i = 0; i < todos.length; i++) {
      if (todos[i][0] == widget.title) {
        List<dynamic> updatedToDo = [
          widget.title,
          widget.description,
          _isChecked,
        ];
        todos[i] = updatedToDo;
        await hivebox.put('todos', todos);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: widget.deletePressed,
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: _isChecked,
            onChanged: updateCheckbox,
            activeColor: Colors.red,
            checkColor: Colors.white,
          ),
          Expanded(
            child: ListTile(
              title: Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(widget.description),
            ),
          ),
        ],
      ),
    );
  }
}
