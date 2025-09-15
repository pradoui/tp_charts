# TP Charts

A beautiful animated chart widgets library for Flutter with customizable styling and smooth animations.

## Features

- 📊 **CustomLineChart**: Line charts with built-in date filter buttons
- 📈 **SimpleLineChart**: Line charts with external date filtering for maximum flexibility  
- 🔥 **HotChart**: Gauge-style charts for displaying values with status indication
- ✨ Interactive hover effects with tooltips
- 🎨 Customizable colors, gradients, and styling
- 📱 Responsive design
- 🎯 Support for both DateTime and String data

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  tp_charts: ^1.0.7
```

Then run:

```bash
flutter pub get
```

## Quick Start

### CustomLineChart (with built-in filters)

```dart
import 'package:tp_charts/tp_charts.dart';

CustomLineChart(
  dates: [DateTime(2024, 1, 1), DateTime(2024, 1, 2), DateTime(2024, 1, 3)],
  yValues: [100.0, 150.0, 120.0],
  color: Colors.blue,
  showFilterButtons: true, // Built-in date filters
)
```

### SimpleLineChart (external filtering)

```dart
import 'package:tp_charts/tp_charts.dart';

SimpleLineChart(
  dates: [DateTime(2024, 1, 1), DateTime(2024, 1, 2), DateTime(2024, 1, 3)],
  yValues: [100.0, 150.0, 120.0],
  startDate: DateTime(2024, 1, 1), // External filter
  endDate: DateTime(2024, 1, 2),   // External filter
  color: Colors.green,
)
```

### HotChart (gauge-style)

```dart
HotChart(
  currentValue: 4.85,
  idealValue: 5.0,
  minValue: 0.0,
  maxValue: 10.0,
  size: 200.0,
)
```

## Chart Types

### CustomLineChart vs SimpleLineChart

| Feature | CustomLineChart | SimpleLineChart |
|---------|----------------|-----------------|
| Built-in filter buttons | ✅ Yes | ❌ No |
| External date filtering | ✅ Yes | ✅ Yes |
| Use case | Quick implementation | Maximum flexibility |
| Customization | Standard | Full control |

**Use CustomLineChart when:**
- You want a complete solution with built-in filters
- Standard date filters (Today, This Week, This Year, All) meet your needs

**Use SimpleLineChart when:**
- You need custom filter controls
- The chart is part of a larger control system
- You want maximum flexibility in UI design

## Customization Options

Both chart types support extensive customization:

```dart
SimpleLineChart(
  // Data
  dates: myDates,
  yValues: myValues,
  
  // Styling
  color: Colors.blue,
  lineWidth: 3.0,
  pointRadius: 6.0,
  gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlue]),
  
  // Grid
  gridLineColor: Colors.grey,
  gridLineOpacity: 0.1,
  gridCount: 5,
  autoGridCount: true,
  
  // Tooltip
  tooltipTextStyle: TextStyle(color: Colors.white, fontSize: 14),
  tooltipBoxColor: Colors.black87,
  
  // Animation
  animationDuration: Duration(milliseconds: 1500),
  
  // Labels
  maxXLabels: 8,
  rotateLabels: true,
)
```

## Visual Features

### Smooth Animations & Visual Polish

All charts feature beautiful visual elements:

- **Smooth Cubic Curves**: Professional-looking smooth curves using cubic Bézier interpolation
- **Gradient Fill**: Beautiful gradient background fill below chart lines
- **Animated Rendering**: Smooth opacity animations for professional appearance
- **Smart Tooltips**: Intelligent positioning that stays within widget bounds
- **Responsive Design**: Adapts to different screen sizes and orientations

Both `CustomLineChart` and `SimpleLineChart` share the same visual fidelity and smooth animation system for consistent user experience across your application.

## Examples

Run the example app to see all chart types in action:

```bash
cd example
flutter run
```

## Documentation

For detailed documentation and advanced usage, see the API documentation.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.