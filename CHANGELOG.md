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
