import 'package:hive_flutter/hive_flutter.dart';

class Expense {
  final String type;
  final String price;
  final DateTime dateTime;
  final String category;

  // Constructor
  Expense({
    required this.type,
    required this.price,
    required this.dateTime,
    required this.category,
  });
}

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final typeId = 0;

  @override
  Expense read(BinaryReader reader) {
    Expense expense = Expense(
      type: reader.readString(),
      price: reader.readString(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      category: reader.readString(),
    );
    return expense;
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer.writeString(obj.type);
    writer.writeString(obj.price);
    writer.writeInt(obj.dateTime.millisecondsSinceEpoch);
    writer.writeString(obj.category);
  }
}
