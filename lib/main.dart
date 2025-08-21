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
                  const SizedBox(height: 16),
                  _buildExampleCard(
                    context,
                    'Dynamic Grid & Single Point',
                    'Charts with adaptive grid and single data point support',
                    Icons.grid_on,
                    Colors.orange,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DynamicGridExample(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildExampleCard(
                    context,
                    'HotChart - Gauge Style',
                    'Gauge-style charts for displaying values with status indication',
                    Icons.speed,
                    Colors.teal,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HotChartExample(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildExampleCard(
                    context,
                    'Large Dataset with Smart Labels',
                    'Charts with 100+ data points and intelligent label display',
                    Icons.data_usage,
                    Colors.purple,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LargeDatasetExample(),
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

// Dynamic Grid Example
class DynamicGridExample extends StatefulWidget {
  const DynamicGridExample({super.key});

  @override
  State<DynamicGridExample> createState() => _DynamicGridExampleState();
}

class _DynamicGridExampleState extends State<DynamicGridExample> {
  int dataPointCount = 1;
  bool autoGrid = true;

  List<DateTime> _generateDates(int count) {
    final now = DateTime.now();
    return List.generate(
      count,
      (index) => now.subtract(Duration(days: count - 1 - index)),
    );
  }

  List<double> _generateValues(int count) {
    return List.generate(
      count,
      (index) => 100 + (index * 50) + (index % 3) * 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dates = _generateDates(dataPointCount);
    final values = _generateValues(dataPointCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Grid Example'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Grid Dinâmico e Suporte a Dados Únicos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Teste o comportamento do gráfico com diferentes quantidades de dados.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('Pontos de dados: '),
                        Expanded(
                          child: Slider(
                            value: dataPointCount.toDouble(),
                            min: 1,
                            max: 20,
                            divisions: 19,
                            label: dataPointCount.toString(),
                            onChanged: (value) {
                              setState(() {
                                dataPointCount = value.toInt();
                              });
                            },
                          ),
                        ),
                        Text('$dataPointCount'),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Grid automático: '),
                        Switch(
                          value: autoGrid,
                          onChanged: (value) {
                            setState(() {
                              autoGrid = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

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
                  key: ValueKey('$dataPointCount-$autoGrid'),
                  dates: dates,
                  yValues: values,
                  color: Colors.orange,
                  showFilterButtons: false,
                  autoGridCount: autoGrid,
                  minGridCount: 2,
                  maxGridCount: 8,
                  gridCount: 4, // Used when autoGrid is false
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Info
            Text(
              autoGrid
                  ? 'Grid automático: ${dataPointCount == 1 ? '2 linhas (mínimo)' : '${((dataPointCount / 2.5).round().clamp(2, 8))} linhas (baseado nos dados)'}'
                  : 'Grid fixo: 4 linhas',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              dataPointCount == 1
                  ? 'Ponto único: Exibido como círculo no centro do gráfico'
                  : 'Múltiplos pontos: Linha suave conectando os pontos',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Large Dataset Example
class LargeDatasetExample extends StatefulWidget {
  const LargeDatasetExample({super.key});

  @override
  State<LargeDatasetExample> createState() => _LargeDatasetExampleState();
}

class _LargeDatasetExampleState extends State<LargeDatasetExample> {
  int dataPoints = 50;
  bool useSmartLabels = true;
  bool rotateLabels = false;
  int maxLabels = 8;

  List<DateTime> _generateDates(int count) {
    final now = DateTime.now();
    return List.generate(count, (index) {
      return now.subtract(Duration(days: count - index));
    });
  }

  List<double> _generateValues(int count) {
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(count, (index) {
      // Simulate realistic data with trend and variation
      double trend = index * 2.0; // Upward trend
      double variation =
          ((random + index * 17) % 100 - 50) * 0.5; // Random variation
      return (100 + trend + variation).clamp(50.0, 500.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dates = _generateDates(dataPoints);
    final values = _generateValues(dataPoints);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Large Dataset Example'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dataset Grande com Labels Inteligentes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Demonstra como o widget lida com grandes volumes de dados (${dataPoints} pontos)',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Controles:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Data points slider
                    Text('Pontos de dados: $dataPoints'),
                    Slider(
                      value: dataPoints.toDouble(),
                      min: 10,
                      max: 200,
                      divisions: 19,
                      onChanged: (value) {
                        setState(() {
                          dataPoints = value.round();
                        });
                      },
                    ),

                    // Max labels slider
                    Text('Máximo de labels: $maxLabels'),
                    Slider(
                      value: maxLabels.toDouble(),
                      min: 3,
                      max: 15,
                      divisions: 12,
                      onChanged: (value) {
                        setState(() {
                          maxLabels = value.round();
                        });
                      },
                    ),

                    // Toggles
                    SwitchListTile(
                      title: const Text('Labels inteligentes'),
                      subtitle: Text(
                        useSmartLabels
                            ? 'Mostra apenas $maxLabels labels estrategicamente'
                            : 'Mostra todos os labels (pode sobrepor)',
                      ),
                      value: useSmartLabels,
                      onChanged: (value) {
                        setState(() {
                          useSmartLabels = value;
                        });
                      },
                    ),

                    SwitchListTile(
                      title: const Text('Rotacionar labels'),
                      subtitle: const Text('Economiza espaço horizontal'),
                      value: rotateLabels,
                      onChanged: (value) {
                        setState(() {
                          rotateLabels = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

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
                  key: ValueKey(
                    '$dataPoints-$useSmartLabels-$rotateLabels-$maxLabels',
                  ),
                  dates: dates,
                  yValues: values,

                  // Smart label settings
                  maxXLabels: useSmartLabels ? maxLabels : dataPoints,
                  rotateLabels: rotateLabels,
                  labelRotation: rotateLabels ? 0.785398 : 0, // 45 degrees
                  // Auto grid for better visualization
                  autoGridCount: true,
                  maxGridCount: 8,
                  minGridCount: 4,

                  // Styling
                  color: Colors.purple,
                  lineWidth: 2,
                  animationDuration: const Duration(milliseconds: 1000),
                  showFilterButtons: false, // Focus on the data visualization
                  // Grid styling
                  gridLineOpacity: 0.1,
                  labelTextStyle: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Info
            Text(
              useSmartLabels
                  ? 'Exibindo $maxLabels de $dataPoints labels de forma inteligente'
                  : 'Exibindo todos os $dataPoints labels (pode causar sobreposição)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              rotateLabels
                  ? 'Labels rotacionados em 45° para economizar espaço'
                  : 'Labels na horizontal',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class HotChartExample extends StatefulWidget {
  const HotChartExample({super.key});

  @override
  State<HotChartExample> createState() => _HotChartExampleState();
}

class _HotChartExampleState extends State<HotChartExample> {
  double currentValue = 4.85;
  double minValue = 0.0;
  double maxValue = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('HotChart Example'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'HotChart - Gauge Style Chart',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Gauge-style charts for displaying values with status indication',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Main HotChart
            Container(
              width: double.infinity,
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
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  HotChart(
                    currentValue: currentValue,
                    minValue: minValue,
                    maxValue: maxValue,
                    size: 250,
                    showStatusText: true,
                    excellentStatusText: 'Ótimo',
                    regularStatusText: 'Regular',
                    poorStatusText: 'Ruim',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Controls
            Container(
              width: double.infinity,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Controls',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Current Value Slider
                  Text(
                    'Current Value: ${currentValue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Slider(
                    value: currentValue,
                    min: minValue,
                    max: maxValue,
                    divisions: 100,
                    activeColor: Colors.teal,
                    onChanged: (value) {
                      setState(() {
                        currentValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Multiple HotCharts Examples
            Container(
              width: double.infinity,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Multiple HotCharts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Row of smaller charts
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      _buildSmallChart('Performance', 8.2, 7.0, 0, 10),
                      _buildSmallChart('Quality', 6.5, 8.0, 0, 10),
                      _buildSmallChart('Speed', 4.1, 5.0, 0, 10),
                      _buildSmallChart('Efficiency', 9.1, 8.5, 0, 10),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Info
            Text(
              'O HotChart exibe valores em estilo velocímetro com indicação de status baseada em porcentagem: 0-30% = Ótimo (verde), 30-60% = Regular (amarelo), 60%+ = Ruim (vermelho).',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallChart(
    String title,
    double current,
    double ideal,
    double min,
    double max,
  ) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        HotChart(
          currentValue: current,
          minValue: min,
          maxValue: max,
          size: 120,
          showStatusText: false,
          trackWidth: 12,
          valueTextStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
