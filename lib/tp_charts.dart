/// TP Charts - A beautiful animated line chart widget for Flutter
///
/// This library provides customizable chart widgets with smooth animations,
/// hover effects, automatic date filtering, and extensive styling options.
///
/// ## Features
/// - Smooth entrance animations
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
/// ### With DateTime (automatic filtering)
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
/// ### With String labels (legacy mode)
/// ```dart
/// CustomLineChart(
///   xValues: ['Jan', 'Feb', 'Mar', 'Apr'],
///   yValues: [100.0, 150.0, 120.0, 180.0],
///   color: Colors.blue,
///   lineWidth: 3.0,
/// )
/// ```
library tp_charts;

export 'src/custom_line_chart.dart';
export 'src/chart_filter_button.dart';
