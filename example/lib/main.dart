import 'package:flutter/material.dart';
import 'package:tp_charts/tp_charts.dart';

void main() {
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP Charts Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  DateTime? _startDate;
  DateTime? _endDate;
  PeriodType _periodType = PeriodType.custom;

  // Sample data
  final List<DateTime> _dates = List.generate(30, (index) {
    return DateTime.now().subtract(Duration(days: 29 - index));
  });

  final List<double> _values = [
    1200,
    1350,
    980,
    1500,
    1100,
    1800,
    1650,
    1400,
    1250,
    1700,
    1550,
    1300,
    1450,
    1600,
    1200,
    1750,
    1400,
    1150,
    1500,
    1650,
    1300,
    1450,
    1700,
    1550,
    1200,
    1800,
    1650,
    1400,
    1500,
    1750,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TP Charts Examples'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // CustomLineChart with built-in filters
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CustomLineChart - With Built-in Filters',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: CustomLineChart(
                          dates: _dates,
                          yValues: _values,
                          color: Colors.blue,
                          showFilterButtons: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // SimpleLineChart with external filters
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SimpleLineChart - External Date Filters',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),

                      // External filter controls
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _setDaysFilter(7, PeriodType.week),
                            child: Text('Semana'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () =>
                                _setDaysFilter(30, PeriodType.month),
                            child: Text('Mês'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () =>
                                _setDaysFilter(365, PeriodType.year),
                            child: Text('Ano'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _clearFilters,
                            child: Text('Todos'),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),
                      Expanded(
                        child: SimpleLineChart(
                          dates: _dates,
                          yValues: _values,
                          startDate: _startDate,
                          endDate: _endDate,
                          periodType: _periodType,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setDaysFilter(int days, PeriodType periodType) {
    final now = DateTime.now();
    setState(() {
      _startDate = now.subtract(Duration(days: days - 1));
      _endDate = now;
      _periodType = periodType;
    });
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _periodType = PeriodType.custom;
    });
  }
}
