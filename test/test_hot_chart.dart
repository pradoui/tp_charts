import 'package:flutter/material.dart';
import 'package:tp_charts/tp_charts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: HotChart(
            currentValue: 45.0,
            minValue: 0.0,
            maxValue: 100.0,
            size: 200.0,
            excellentStatusText: 'Excelente',
            regularStatusText: 'Regular',
            poorStatusText: 'Ruim',
            excellentColor: Colors.green,
            regularColor: Colors.orange,
            poorColor: Colors.red,
            showStatusText: true,
            animate: true,
            animationDuration: Duration(milliseconds: 1000),
          ),
        ),
      ),
    );
  }
}
