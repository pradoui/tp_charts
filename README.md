# TP Charts

A beautiful animated line chart widget for Flutter with customizable styling, smooth animations, and interactive hover effects.

## Features

- 🎨 **Customizable Design**: Extensive styling options for colors, gradients, and typography
- ✨ **Smooth Animations**: Beautiful entrance animations with customizable duration and curves
- 🖱️ **Interactive**: Hover effects with tooltips showing data values
- 📱 **Responsive**: Adapts to different screen sizes and orientations
- 📅 **DateTime Support**: Automatic filtering by date periods (Today, This Week, This Year, All Period)
- 🎛️ **Filter Buttons**: Built-in filter buttons for easy data selection
- 🌐 **Cross-platform**: Works on all Flutter platforms

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  tp_charts: ^1.0.0
```

## Usage

### DateTime-based Chart (Recommended)

```dart
import 'package:tp_charts/tp_charts.dart';

CustomLineChart(
  dates: [
    DateTime(2024, 1, 1),
    DateTime(2024, 2, 1),
    DateTime(2024, 3, 1),
    DateTime(2024, 4, 1),
  ],
  yValues: [100.0, 150.0, 120.0, 180.0],
)
```

### String-based Chart (Legacy)

```dart
CustomLineChart(
  xValues: ['Jan', 'Feb', 'Mar', 'Apr'],
  yValues: [100.0, 150.0, 120.0, 180.0],
)
```

### Customized Chart with Filters

```dart
CustomLineChart(
  dates: myDateTimeList,
  yValues: myValuesList,
  
  // Styling
  color: Colors.blue,
  lineWidth: 3.0,
  pointRadius: 8.0,
  
  // Animation
  animationDuration: Duration(milliseconds: 1500),
  
  // Filtering
  showFilterButtons: true,
  selectedFilter: FilterType.thisWeek,
  onFilterChanged: (filter) {
    print('Filter changed to: $filter');
  },
  
  // Dynamic Grid (adapts to data size)
  autoGridCount: true,
  minGridCount: 3,
  maxGridCount: 10,
  
  // Grid customization
  gridLineColor: Colors.grey,
  gridLineOpacity: 0.1,
  
  // Tooltip customization
  tooltipTextStyle: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  ),
  tooltipBoxColor: Colors.black87,
)
```

### Chart with Single Data Point

```dart
CustomLineChart(
  dates: [DateTime.now()],
  yValues: [150.0],
  
  // Grid will automatically adapt for single point
  autoGridCount: true,
  minGridCount: 3,
  
  color: Colors.green,
)
```

### Standalone Filter Buttons

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
| `dates` | `List<DateTime>?` | `null` | DateTime objects for X-axis (preferred for automatic filtering) |
| `xValues` | `List<String>?` | `null` | String labels for X-axis (alternative to dates) |
| `yValues` | `List<double>` | **required** | Numeric values for the Y-axis |
| `color` | `Color` | `Color(0xFF3B82F6)` | Primary color for line and area |
| `lineWidth` | `double` | `3.0` | Width of the line stroke |
| `pointRadius` | `double` | `7.0` | Radius of hover points |
| `animationDuration` | `Duration` | `Duration(milliseconds: 1500)` | Duration of entrance animation |
| `showFilterButtons` | `bool` | `true` | Whether to show built-in filter buttons |
| `selectedFilter` | `FilterType` | `FilterType.allPeriod` | Currently selected filter |
| `onFilterChanged` | `Function(FilterType)?` | `null` | Callback when filter changes |
| `gridLineColor` | `Color` | `Colors.grey` | Color of grid lines |
| `gridLineOpacity` | `double` | `0.05` | Opacity of grid lines (0.0 to 1.0) |
| `gridCount` | `int` | `5` | Number of horizontal grid lines (when autoGridCount is false) |
| `autoGridCount` | `bool` | `false` | Whether to automatically adjust grid count based on data |
| `maxGridCount` | `int` | `10` | Maximum grid lines when using auto grid count |
| `minGridCount` | `int` | `3` | Minimum grid lines when using auto grid count |
| `tooltipTextStyle` | `TextStyle` | - | Style for tooltip text |
| `labelTextStyle` | `TextStyle` | - | Style for axis labels |
| `tooltipBoxColor` | `Color` | `Colors.black` | Background color of tooltip |

### FilterType Enum

- `FilterType.today` - Shows data from today only
- `FilterType.thisWeek` - Shows data from the last 7 days
- `FilterType.thisYear` - Shows data from the current year
- `FilterType.allPeriod` - Shows all available data

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

## Complete Example

Check out the complete example in the `/example` folder:

```dart
import 'package:flutter/material.dart';
import 'package:tp_charts/tp_charts.dart';

class MyChart extends StatefulWidget {
  @override
  _MyChartState createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  FilterType selectedFilter = FilterType.allPeriod;

  @override
  Widget build(BuildContext context) {
    final dates = [
      DateTime(2024, 8, 1),
      DateTime(2024, 8, 5),
      DateTime(2024, 8, 10),
      DateTime(2024, 8, 15),
      DateTime(2024, 8, 20),
    ];
    
    final values = [1200.0, 1900.0, 1600.0, 2100.0, 2400.0];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: CustomLineChart(
          dates: dates,
          yValues: values,
          color: Colors.blue,
          lineWidth: 3.0,
          selectedFilter: selectedFilter,
          onFilterChanged: (filter) {
            setState(() {
              selectedFilter = filter;
            });
          },
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
