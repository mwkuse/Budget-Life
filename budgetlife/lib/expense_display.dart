import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseDisplay extends StatelessWidget {
  final String type;
  final String price;
  final String category;
  final DateTime dateTime;
  final void Function(BuildContext)? deletePressed;

  const ExpenseDisplay({
    super.key,
    required this.type,
    required this.price,
    required this.dateTime,
    required this.category,
    required this.deletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: deletePressed,
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${dateTime.day} / ${dateTime.month} / ${dateTime.year}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(type, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        subtitle: Text(
          'Category: $category',
          style: const TextStyle(fontSize: 10),
        ),
        trailing: Text('\$$price'),
      ),
    );
  }
}
