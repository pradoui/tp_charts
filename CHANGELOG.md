## 1.0.3

### Critical Bug Fix for Single Data Point Charts

#### 🐛 Critical Bug Fix
- **Fixed NaN Offset Error**: Resolved critical rendering issue where single data point charts caused NaN (Not a Number) values in canvas drawing
- **Single Point Positioning**: Fixed calculation for centering single data points in chart area
- **Division by Zero**: Prevented division by zero when calculating point spacing (dx) for single-point datasets

#### 🎯 Improvements
- Better error handling for edge cases in chart rendering
- More robust calculations for single data point scenarios
- Enhanced stability for charts with minimal data

#### 🔧 Technical Details
- Fixed `dx = chartWidth / (data.length - 1)` calculation when `data.length = 1`
- Improved `_calculatePoints` function to handle single points correctly
- Added proper centering logic for single data points

---

## 1.0.2

### Smart X-Axis Labels for Large Datasets

#### ✨ New Features
- **Intelligent Label Display**: Automatically limits X-axis labels to prevent overcrowding
- **Label Rotation**: Rotate labels when they overlap to save horizontal space
- **Smart Label Selection**: Shows first, last, and evenly distributed labels for optimal readability

#### 🔧 New Parameters
- `maxXLabels`: Maximum number of X-axis labels to display (default: 8)
- `rotateLabels`: Enable label rotation for space-saving (default: false)
- `labelRotation`: Rotation angle for labels in radians (default: 45°)

#### 🎯 Improvements
- Better handling of large datasets (100+ data points)
- Prevents X-axis label overlap and visual clutter
- Maintains readability across different screen sizes
- Optimized performance for charts with many data points

#### 🐛 Bug Fixes
- Fixed X-axis label overcrowding with large datasets
- Improved label positioning for rotated text
- Better canvas state management for label rendering

#### 📚 Documentation
- Added examples for large dataset handling
- Updated parameter documentation
- Enhanced usage examples for label customization

---

## 1.0.1

### Enhanced Grid and Single Point Support

#### ✨ New Features
- **Dynamic Grid Count**: Automatically adjust grid lines based on data size
- **Single Data Point Support**: Charts now work with just 1 data point
- **Flexible Grid Control**: User-defined min/max grid line limits

#### 🔧 New Parameters
- `autoGridCount`: Enable automatic grid adjustment (default: false)
- `maxGridCount`: Maximum number of grid lines when using auto mode (default: 10)
- `minGridCount`: Minimum number of grid lines when using auto mode (default: 3)

#### 🎯 Improvements
- Better handling of edge cases (single point, zero range)
- Improved grid rendering for small datasets
- Enhanced visual representation for single data points
- More robust chart rendering across different data sizes

#### 🐛 Bug Fixes
- Fixed assertion that required minimum 2 data points
- Fixed grid calculation for single value datasets
- Improved chart drawing for edge cases

#### 📚 Documentation
- Updated README with new grid parameters
- Added examples for single point charts
- Enhanced parameter documentation

---

## 1.0.0

### Initial Release

#### ✨ Features
- Beautiful animated line charts with smooth entrance animations
- Interactive hover effects with tooltips
- DateTime-based filtering (Today, This Week, This Year, All Period)
- Support for both DateTime and String data on X-axis
- Customizable colors, gradients, and styling options
- Responsive design for all screen sizes
- Cross-platform support (iOS, Android, Web, Desktop)

#### 📱 Widgets
- `CustomLineChart`: Main chart widget with extensive customization options
- `ChartFilterButton`: Reusable filter button component

#### 🎨 Customization Options
- Line colors and gradients
- Grid line appearance
- Point styling and hover effects
- Tooltip appearance and positioning
- Animation duration and curves
- Text styles and colors

#### 📊 Data Support
- DateTime objects for time-based data
- String labels for categorical data
- Automatic filtering based on date ranges
- Smooth interpolation between data points

#### 🔧 Technical Features
- Built with Flutter's CustomPainter for optimal performance
- Responsive layout with automatic scaling
- Memory-efficient rendering
- Smooth 60fps animations
