import 'package:budgetlife/single_bar.dart';

class BarData {
  final double sunTotal;
  final double monTotal;
  final double tuesTotal;
  final double wedTotal;
  final double thursTotal;
  final double friTotal;
  final double satTotal;

  BarData({
    required this.sunTotal,
    required this.monTotal,
    required this.tuesTotal,
    required this.wedTotal,
    required this.thursTotal,
    required this.friTotal,
    required this.satTotal,
  });

  List<SingleBar> barData = [];

  void initializeBarData() {
    barData = [
      SingleBar(x: 0, y: sunTotal),
      SingleBar(x: 1, y: monTotal),
      SingleBar(x: 2, y: tuesTotal),
      SingleBar(x: 3, y: wedTotal),
      SingleBar(x: 4, y: thursTotal),
      SingleBar(x: 5, y: friTotal),
      SingleBar(x: 6, y: satTotal),
    ];
  }
}
