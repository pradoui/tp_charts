# TP Charts

A beautiful animated line chart widget for Flutter with customizable styling, smooth animations, and interactive hover effects.

## Features

- 🎨 **Customizable Design**: Extensive styling options for colors, gradients, and typography
- ✨ **Smooth Animations**: Beautiful entrance animations with customizable duration and curves
- 🖱️ **Interactive**: Hover effects with tooltips showing data values
- 📱 **Responsive**: Adapts to different screen sizes and orientations
- 🎛️ **Filter Buttons**: Optional filter buttons for data selection
- 🌐 **Cross-platform**: Works on all Flutter platforms

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  tp_charts: ^1.0.0
```

## Usage

### Basic Line Chart

```dart
import 'package:tp_charts/tp_charts.dart';

CustomLineChart(
  xValues: ['Jan', 'Feb', 'Mar', 'Apr'],
  yValues: [100.0, 150.0, 120.0, 180.0],
)
```

### Customized Chart

```dart
CustomLineChart(
  xValues: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
  yValues: [420.0, 580.0, 610.0, 720.0, 850.0],
  
  // Styling
  color: Colors.blue,
  lineWidth: 3.0,
  pointRadius: 8.0,
  
  // Animation
  animationDuration: Duration(milliseconds: 1500),
  
  // Grid customization
  gridLineColor: Colors.grey,
  gridLineOpacity: 0.1,
  gridCount: 5,
  
  // Tooltip customization
  tooltipTextStyle: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  ),
  tooltipBoxColor: Colors.black87,
  
  // Label customization
  labelTextStyle: TextStyle(
    color: Colors.grey,
    fontSize: 12,
  ),
)
```

### With Filter Buttons

```dart
ChartFilterButton(
  label: 'This Week',
  selected: isSelected,
  onTap: () => onFilterSelected(),
  selectedBackgroundColor: Colors.blue,
  selectedTextColor: Colors.white,
  unselectedBackgroundColor: Colors.grey[100],
  unselectedTextColor: Colors.grey[600],
)
```

## Parameters

### CustomLineChart

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `xValues` | `List<String>` | **required** | Labels for the X-axis |
| `yValues` | `List<double>` | **required** | Numeric values for the Y-axis |
| `color` | `Color` | `Color(0xFF3B82F6)` | Primary color for line and area |
| `lineWidth` | `double` | `3.0` | Width of the line stroke |
| `pointRadius` | `double` | `7.0` | Radius of hover points |
| `animationDuration` | `Duration` | `Duration(milliseconds: 1500)` | Duration of entrance animation |
| `gridLineColor` | `Color` | `Colors.grey` | Color of grid lines |
| `gridLineOpacity` | `double` | `0.05` | Opacity of grid lines (0.0 to 1.0) |
| `gridCount` | `int` | `5` | Number of horizontal grid lines |
| `tooltipTextStyle` | `TextStyle` | - | Style for tooltip text |
| `labelTextStyle` | `TextStyle` | - | Style for axis labels |
| `tooltipBoxColor` | `Color` | `Colors.black` | Background color of tooltip |

### ChartFilterButton

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `label` | `String` | **required** | Text displayed on button |
| `selected` | `bool` | **required** | Whether button is selected |
| `onTap` | `VoidCallback?` | `null` | Callback when button is tapped |
| `selectedBackgroundColor` | `Color?` | `Colors.blue` | Background color when selected |
| `selectedTextColor` | `Color?` | `Colors.white` | Text color when selected |
| `unselectedBackgroundColor` | `Color?` | `Colors.white` | Background color when not selected |
| `unselectedTextColor` | `Color?` | `Colors.grey[700]` | Text color when not selected |
| `animationDuration` | `Duration` | `Duration(milliseconds: 200)` | Animation duration |
| `borderRadius` | `double` | `16.0` | Border radius of button |

## Example

Check out the complete example in the `/example` folder:

```dart
import 'package:flutter/material.dart';
import 'package:tp_charts/tp_charts.dart';

class MyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: CustomLineChart(
          xValues: ['Jan', 'Feb', 'Mar', 'Apr', 'May'],
          yNames: ['January', 'February', 'March', 'April', 'May'],
          values: [1200.0, 1900.0, 1600.0, 2100.0, 2400.0],
          color: Colors.blue,
          lineWidth: 3.0,
        ),
      ),
    );
  }
}
```

## Requirements

- Flutter >= 3.0.0
- Dart >= 3.8.1

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
