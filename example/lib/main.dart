import 'package:flutter/material.dart';
import 'package:tp_charts/tp_charts.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP Charts Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('TP Charts Examples'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TP Charts Examples',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose an example to see different chart features',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Example Cards
            Expanded(
              child: ListView(
                children: [
                  _buildExampleCard(
                    context,
                    'Basic Chart with Manual Filters',
                    'Chart using string labels with manual filter buttons',
                    Icons.show_chart,
                    Colors.blue,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BasicChartExample(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildExampleCard(
                    context,
                    'DateTime Chart with Auto Filters',
                    'Chart using DateTime data with automatic period filtering',
                    Icons.date_range,
                    Colors.green,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DateTimeChartExample(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// Basic Chart Example (legacy mode)
class BasicChartExample extends StatefulWidget {
  const BasicChartExample({super.key});

  @override
  State<BasicChartExample> createState() => _BasicChartExampleState();
}

enum BasicFilterType { today, thisWeek, thisMonth }

class _BasicChartExampleState extends State<BasicChartExample> {
  BasicFilterType _selectedFilter = BasicFilterType.thisWeek;

  // Sample data for different time periods
  final Map<BasicFilterType, Map<String, dynamic>> _sampleData = {
    BasicFilterType.today: {
      'xValues': ['00:00', '06:00', '12:00', '18:00'],
      'yValues': [120.0, 350.0, 680.0, 520.0],
    },
    BasicFilterType.thisWeek: {
      'xValues': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      'yValues': [2400.0, 2100.0, 2800.0, 3200.0, 3800.0, 2900.0, 2200.0],
    },
    BasicFilterType.thisMonth: {
      'xValues': ['W1', 'W2', 'W3', 'W4'],
      'yValues': [8400.0, 9200.0, 7800.0, 10500.0],
    },
  };

  void _selectFilter(BasicFilterType filter) {
    if (_selectedFilter != filter) {
      setState(() {
        _selectedFilter = filter;
      });
    }
  }

  String _getFilterLabel(BasicFilterType filter) {
    switch (filter) {
      case BasicFilterType.today:
        return 'Today';
      case BasicFilterType.thisWeek:
        return 'This Week';
      case BasicFilterType.thisMonth:
        return 'This Month';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _sampleData[_selectedFilter]!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Basic Chart Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales Analytics',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Track your performance over time',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Filter Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: BasicFilterType.values.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: () => _selectFilter(filter),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _getFilterLabel(filter),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Chart
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: CustomLineChart(
                  key: ValueKey(_selectedFilter),
                  xValues: List<String>.from(currentData['xValues']),
                  yValues: List<double>.from(currentData['yValues']),
                  color: Colors.blue,
                  pointBorderColor: Colors.blue,
                  pointCenterColor: Colors.white,
                  lineWidth: 3,
                  animationDuration: const Duration(milliseconds: 1200),
                  showFilterButtons: false, // Manual filter buttons above
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DateTime Chart Example with automatic filtering
class DateTimeChartExample extends StatefulWidget {
  const DateTimeChartExample({super.key});

  @override
  State<DateTimeChartExample> createState() => _DateTimeChartExampleState();
}

class _DateTimeChartExampleState extends State<DateTimeChartExample> {
  FilterType selectedFilter = FilterType.allPeriod;

  List<DateTime> _generateSampleDates() {
    final now = DateTime.now();
    final List<DateTime> dates = [];

    // Gerar dados dos últimos 6 meses com dados semanais
    for (int i = 180; i >= 0; i -= 7) {
      dates.add(now.subtract(Duration(days: i)));
    }

    // Adicionar alguns dados desta semana
    for (int i = 6; i >= 0; i--) {
      dates.add(now.subtract(Duration(days: i)));
    }

    // Adicionar dados de hoje (por horas)
    for (int hour = 0; hour <= now.hour; hour += 2) {
      dates.add(DateTime(now.year, now.month, now.day, hour));
    }

    return dates;
  }

  List<double> _generateSampleValues(List<DateTime> dates) {
    return dates.map((date) {
      final daysSinceEpoch =
          date.millisecondsSinceEpoch / (1000 * 60 * 60 * 24);
      final base = daysSinceEpoch * 0.1;
      final variation = (daysSinceEpoch % 7) * 50;
      return (base + variation + 1000).clamp(500.0, 5000.0).toDouble();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dates = _generateSampleDates();
    final values = _generateSampleValues(dates);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DateTime Chart Example'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gráfico com Filtros Automáticos por Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Este gráfico recebe datas e valores, e automaticamente oferece filtros baseados nos dados disponíveis.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Botões de filtro
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChartFilterButton(
                  label: 'Hoje',
                  selected: selectedFilter == FilterType.today,
                  onTap: () {
                    setState(() {
                      selectedFilter = FilterType.today;
                    });
                  },
                ),
                ChartFilterButton(
                  label: 'Esta Semana',
                  selected: selectedFilter == FilterType.thisWeek,
                  onTap: () {
                    setState(() {
                      selectedFilter = FilterType.thisWeek;
                    });
                  },
                ),
                ChartFilterButton(
                  label: 'Este Ano',
                  selected: selectedFilter == FilterType.thisYear,
                  onTap: () {
                    setState(() {
                      selectedFilter = FilterType.thisYear;
                    });
                  },
                ),
                ChartFilterButton(
                  label: 'Todos',
                  selected: selectedFilter == FilterType.allPeriod,
                  onTap: () {
                    setState(() {
                      selectedFilter = FilterType.allPeriod;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: CustomLineChart(
                  dates: dates,
                  yValues: values,
                  color: Colors.green,
                  selectedFilter: selectedFilter,
                  onFilterChanged: (filter) {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Filtros disponíveis:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              '• Hoje: Dados de hoje (por hora)\n'
              '• Esta Semana: Dados dos últimos 7 dias\n'
              '• Este Ano: Dados do ano atual\n'
              '• Todo o Período: Todos os dados disponíveis',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
