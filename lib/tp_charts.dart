/// TP Charts - A beautiful animated chart widgets library for Flutter
///
/// This library provides customizable chart widgets with smooth animations,
/// hover effects, automatic date filtering, and extensive styling options.
///
/// ## Features
/// - **CustomLineChart**: Smooth line charts with entrance animations
/// - **HotChart**: Gauge-style charts for displaying values with status indication
/// - Interactive hover effects with tooltips
/// - Automatic date-based filtering (Today, This Week, This Year, All Period)
/// - Support for both DateTime and String data
/// - Customizable colors, gradients, and styling
/// - Grid lines and axis labels
/// - Responsive design
/// - Filter buttons for data selection
///
/// ## Usage
///
/// ### CustomLineChart with DateTime (automatic filtering)
/// ```dart
/// import 'package:tp_charts/tp_charts.dart';
///
/// CustomLineChart(
///   dates: [DateTime(2024, 1, 1), DateTime(2024, 1, 2), ...],
///   yValues: [100.0, 150.0, 120.0, 180.0],
///   color: Colors.blue,
///   lineWidth: 3.0,
///   showFilterButtons: true,
/// )
/// ```
///
/// ### CustomLineChart with String labels (legacy mode)
/// ```dart
/// CustomLineChart(
///   xValues: ['Jan', 'Feb', 'Mar', 'Apr'],
///   yValues: [100.0, 150.0, 120.0, 180.0],
///   color: Colors.blue,
///   lineWidth: 3.0,
/// )
/// ```
///
/// ### HotChart (gauge-style chart)
/// ```dart
/// HotChart(
///   currentValue: 4.85,
///   idealValue: 5.0,
///   minValue: 0.0,
///   maxValue: 10.0,
///   size: 200.0,
///   showStatusText: true,
/// )
/// ```
library tp_charts;

export 'src/custom_line_chart.dart';
export 'src/chart_filter_button.dart';
export 'src/hot_chart.dart';
