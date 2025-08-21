import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';

/// Filter types for date-based filtering
enum FilterType { today, thisWeek, thisYear, allPeriod }

/// A customizable animated line chart widget for Flutter
///
/// This widget displays data as a smooth line chart with various customization options
/// including colors, animations, grid lines, tooltips, and hover effects.
/// It automatically filters data based on selected time period.
class CustomLineChart extends StatefulWidget {
  /// List of DateTime objects for the X-axis
  final List<DateTime>? dates;

  /// List of labels for the X-axis (alternative to dates)
  final List<String>? xValues;

  /// List of values for the Y-axis (numeric data)
  final List<double> yValues;

  /// Primary color for the line and area fill
  final Color color;

  /// Gradient for the area under the line (optional)
  final Gradient gradient;

  /// Width of the line stroke
  final double lineWidth;

  /// Radius of the hover point
  final double pointRadius;

  /// Duration of the entrance animation
  final Duration animationDuration;

  // Grid customization
  /// Color of the grid lines
  final Color gridLineColor;

  /// Opacity of the grid lines (0.0 to 1.0)
  final double gridLineOpacity;

  /// Width of the grid lines
  final double gridLineWidth;

  /// Number of horizontal grid lines
  final int gridCount;

  /// Whether to automatically adjust grid count based on data
  final bool autoGridCount;

  /// Maximum number of grid lines when using auto grid count
  final int maxGridCount;

  /// Minimum number of grid lines when using auto grid count
  final int minGridCount;

  // Point customization (for hover effect)
  /// Color of the point border when hovering
  final Color pointBorderColor;

  /// Width of the point border when hovering
  final double pointBorderWidth;

  /// Color of the point center when hovering
  final Color pointCenterColor;

  // Tooltip customization
  /// Text style for the tooltip
  final TextStyle tooltipTextStyle;

  /// Text style for the axis labels
  final TextStyle labelTextStyle;

  /// Background color of the tooltip box
  final Color tooltipBoxColor;

  /// Color of the tooltip arrow
  final Color tooltipCaretColor;

  /// Color of the dash line from point to x-axis
  final Color dashColor;

  /// Width of the dash line
  final double dashWidth;

  /// Color of the label when highlighted
  final Color labelHighlightColor;

  /// Whether to show filter buttons
  final bool showFilterButtons;

  /// Current selected filter
  final FilterType selectedFilter;

  /// Callback when filter is changed
  final Function(FilterType)? onFilterChanged;

  const CustomLineChart({
    super.key,
    this.dates,
    this.xValues,
    required this.yValues,
    this.color = const Color(0xFF3B82F6),
    this.gradient = const LinearGradient(
      colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    this.lineWidth = 3,
    this.pointRadius = 7,
    this.animationDuration = const Duration(milliseconds: 1500),
    // Grid customization defaults
    this.gridLineColor = Colors.grey,
    this.gridLineOpacity = 0.05,
    this.gridLineWidth = 1,
    this.gridCount = 5,
    this.autoGridCount = false,
    this.maxGridCount = 10,
    this.minGridCount = 3,
    // Point customization defaults
    this.pointBorderColor = Colors.white,
    this.pointBorderWidth = 3,
    this.pointCenterColor = const Color(0xFF3B82F6),
    // Tooltip customization defaults
    this.tooltipTextStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
    this.labelTextStyle = const TextStyle(color: Colors.grey, fontSize: 13),
    this.tooltipBoxColor = Colors.black,
    this.tooltipCaretColor = Colors.black,
    this.dashColor = Colors.black,
    this.dashWidth = 0.8,
    this.labelHighlightColor = Colors.black,
    // Filter options
    this.showFilterButtons = true,
    this.selectedFilter = FilterType.allPeriod,
    this.onFilterChanged,
  }) : assert(yValues.length >= 1, 'At least 1 data point is required'),
       assert(
         dates != null || xValues != null,
         'Either dates or xValues must be provided',
       ),
       assert(
         dates == null || dates.length == yValues.length,
         'dates and yValues must have the same length',
       ),
       assert(
         xValues == null || xValues.length == yValues.length,
         'xValues and yValues must have the same length',
       ),
       assert(
         gridLineOpacity >= 0.0 && gridLineOpacity <= 1.0,
         'gridLineOpacity must be between 0.0 and 1.0',
       ),
       assert(gridCount > 0, 'gridCount must be greater than 0'),
       assert(
         maxGridCount >= minGridCount,
         'maxGridCount must be >= minGridCount',
       ),
       assert(minGridCount > 0, 'minGridCount must be greater than 0');

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart>
    with SingleTickerProviderStateMixin {
  int? _hoveredIndex;
  late AnimationController _animationController;
  late Animation<double> _lineAnimation;
  late FilterType _currentFilter;

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.selectedFilter;
    _setupAnimation();
    _startAnimation();
  }

  /// Calculate dynamic grid count based on data length
  int _calculateGridCount(List<double> data) {
    if (!widget.autoGridCount) {
      return widget.gridCount;
    }

    // For single item, use minimum grid count
    if (data.length == 1) {
      return widget.minGridCount;
    }

    // Calculate optimal grid count based on data points
    // Use roughly 1 grid line per 2-3 data points, but respect min/max
    int optimalCount = (data.length / 2.5).round();

    return optimalCount.clamp(widget.minGridCount, widget.maxGridCount);
  }

  @override
  void didUpdateWidget(CustomLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update filter if changed externally
    if (oldWidget.selectedFilter != widget.selectedFilter) {
      setState(() {
        _currentFilter = widget.selectedFilter;
      });
    }

    // Restart animation if data changed
    if (oldWidget.yValues != widget.yValues ||
        oldWidget.dates != widget.dates ||
        oldWidget.xValues != widget.xValues) {
      _restartAnimation();
    } // Update animation duration if changed
    if (oldWidget.animationDuration != widget.animationDuration) {
      _animationController.duration = widget.animationDuration;
    }
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _lineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
    );
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  void _restartAnimation() {
    _animationController.reset();
    _startAnimation();
  }

  /// Filters data based on selected filter type
  Map<String, dynamic> _getFilteredData() {
    if (widget.dates == null) {
      // Use xValues as is if no dates provided
      return {'xValues': widget.xValues!, 'yValues': widget.yValues};
    }

    final now = DateTime.now();
    final dates = widget.dates!;
    final values = widget.yValues;

    List<DateTime> filteredDates = [];
    List<double> filteredValues = [];
    List<String> formattedLabels = [];

    switch (_currentFilter) {
      case FilterType.today:
        final today = DateTime(now.year, now.month, now.day);
        final tomorrow = today.add(const Duration(days: 1));

        for (int i = 0; i < dates.length; i++) {
          if (dates[i].isAfter(today.subtract(const Duration(seconds: 1))) &&
              dates[i].isBefore(tomorrow)) {
            filteredDates.add(dates[i]);
            filteredValues.add(values[i]);
            formattedLabels.add(DateFormat('HH:mm').format(dates[i]));
          }
        }
        break;

      case FilterType.thisWeek:
        final sunday = now.subtract(Duration(days: now.weekday % 7));
        final startOfWeek = DateTime(sunday.year, sunday.month, sunday.day);
        final endOfWeek = startOfWeek.add(const Duration(days: 7));

        for (int i = 0; i < dates.length; i++) {
          if (dates[i].isAfter(
                startOfWeek.subtract(const Duration(seconds: 1)),
              ) &&
              dates[i].isBefore(endOfWeek)) {
            filteredDates.add(dates[i]);
            filteredValues.add(values[i]);
            // Group by day and format as weekday abbreviation
            formattedLabels.add(_getWeekdayAbbr(dates[i]));
          }
        }
        break;

      case FilterType.thisYear:
        final startOfYear = DateTime(now.year, 1, 1);
        final endOfYear = DateTime(now.year + 1, 1, 1);

        for (int i = 0; i < dates.length; i++) {
          if (dates[i].isAfter(
                startOfYear.subtract(const Duration(seconds: 1)),
              ) &&
              dates[i].isBefore(endOfYear)) {
            filteredDates.add(dates[i]);
            filteredValues.add(values[i]);
            formattedLabels.add(DateFormat('MMM').format(dates[i]));
          }
        }
        break;

      case FilterType.allPeriod:
        filteredDates = List.from(dates);
        filteredValues = List.from(values);

        // Determine best format based on date range
        if (dates.length > 1) {
          final span = dates.last.difference(dates.first).inDays;
          if (span <= 1) {
            // Same day - show hours
            formattedLabels = dates
                .map((d) => DateFormat('HH:mm').format(d))
                .toList();
          } else if (span <= 31) {
            // Within a month - show days
            formattedLabels = dates
                .map((d) => DateFormat('dd/MM').format(d))
                .toList();
          } else {
            // Longer period - show months
            formattedLabels = dates
                .map((d) => DateFormat('MMM/yy').format(d))
                .toList();
          }
        } else {
          formattedLabels = dates
              .map((d) => DateFormat('dd/MM').format(d))
              .toList();
        }
        break;
    }

    return {'xValues': formattedLabels, 'yValues': filteredValues};
  }

  String _getWeekdayAbbr(DateTime date) {
    const weekdays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    return weekdays[date.weekday % 7];
  }

  List<FilterType> _getAvailableFilters() {
    if (widget.dates == null) return [];

    final dates = widget.dates!;
    final now = DateTime.now();

    List<FilterType> filters = [FilterType.allPeriod];

    // Only show other filters if we have date-based data
    if (dates.any((d) => d.year == now.year)) {
      filters.insert(0, FilterType.thisYear);
    }

    final thisWeekStart = now.subtract(Duration(days: now.weekday % 7));
    if (dates.any(
      (d) => d.isAfter(thisWeekStart.subtract(const Duration(days: 1))),
    )) {
      filters.insert(0, FilterType.thisWeek);
    }

    final today = DateTime(now.year, now.month, now.day);
    if (dates.any(
      (d) => d.isAfter(today.subtract(const Duration(seconds: 1))),
    )) {
      filters.insert(0, FilterType.today);
    }

    return filters;
  }

  String _getFilterLabel(FilterType filter) {
    switch (filter) {
      case FilterType.today:
        return 'Hoje';
      case FilterType.thisWeek:
        return 'Esta Semana';
      case FilterType.thisYear:
        return 'Este Ano';
      case FilterType.allPeriod:
        return 'Todo o Período';
    }
  }

  void _onFilterChanged(FilterType filter) {
    if (_currentFilter != filter) {
      setState(() {
        _currentFilter = filter;
      });
      widget.onFilterChanged?.call(filter);
      _restartAnimation();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleHover(
    PointerHoverEvent event,
    BoxConstraints constraints,
    List<double> currentYValues,
  ) {
    final double leftPadding = 56.0;
    final double chartWidth = (constraints.maxWidth - leftPadding) * 0.95;
    final double dx = chartWidth / (currentYValues.length - 1);
    final localX = event.localPosition.dx - leftPadding;
    int index = ((localX) / dx).round();
    index = index.clamp(0, currentYValues.length - 1);
    if (_hoveredIndex != index) {
      setState(() {
        _hoveredIndex = index;
      });
    }
  }

  void _handleExit(PointerExitEvent event) {
    setState(() {
      _hoveredIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _getFilteredData();
    final xValues = filteredData['xValues'] as List<String>;
    final yValues = filteredData['yValues'] as List<double>;

    // Show empty state if no data for current filter
    if (yValues.isEmpty) {
      return Container(
        height: 300,
        alignment: Alignment.center,
        child: Text(
          'Não existem valores nesse período.',
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
      );
    }

    final availableFilters = _getAvailableFilters();

    return Column(
      children: [
        // Filter buttons (if dates are provided and showFilterButtons is true)
        if (widget.showFilterButtons &&
            widget.dates != null &&
            availableFilters.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: availableFilters.map((filter) {
                final isSelected = _currentFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: () => _onFilterChanged(filter),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? widget.color : Colors.grey[100],
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
          ),

        // Chart
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return MouseRegion(
                onHover: (event) => _handleHover(event, constraints, yValues),
                onExit: _handleExit,
                child: AnimatedBuilder(
                  animation: _lineAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _LineChartPainter(
                        data: yValues,
                        labels: xValues,
                        highlightIndex: _hoveredIndex,
                        highlightValue: _hoveredIndex != null
                            ? yValues[_hoveredIndex!].toString()
                            : '',
                        color: widget.color,
                        gradient: widget.gradient,
                        lineWidth: widget.lineWidth,
                        pointRadius: widget.pointRadius,
                        animationValue: _lineAnimation.value,
                        showTooltip: _hoveredIndex != null,
                        gridLineColor: widget.gridLineColor,
                        gridLineOpacity: widget.gridLineOpacity,
                        gridLineWidth: widget.gridLineWidth,
                        pointBorderColor: widget.pointBorderColor,
                        pointBorderWidth: widget.pointBorderWidth,
                        pointCenterColor: widget.pointCenterColor,
                        tooltipTextStyle: widget.tooltipTextStyle,
                        labelTextStyle: widget.labelTextStyle,
                        tooltipBoxColor: widget.tooltipBoxColor,
                        tooltipCaretColor: widget.tooltipCaretColor,
                        dashColor: widget.dashColor,
                        dashWidth: widget.dashWidth,
                        labelHighlightColor: widget.labelHighlightColor,
                        gridCount: _calculateGridCount(yValues),
                      ),
                      child: Container(),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final int? highlightIndex;
  final String highlightValue;
  final Color color;
  final Gradient gradient;
  final double lineWidth;
  final double pointRadius;
  final double animationValue;
  final bool showTooltip;
  final Color gridLineColor;
  final double gridLineOpacity;
  final double gridLineWidth;
  final Color pointBorderColor;
  final double pointBorderWidth;
  final Color pointCenterColor;
  final TextStyle tooltipTextStyle;
  final TextStyle labelTextStyle;
  final Color tooltipBoxColor;
  final Color tooltipCaretColor;
  final Color dashColor;
  final double dashWidth;
  final Color labelHighlightColor;
  final int gridCount;

  _LineChartPainter({
    required this.data,
    required this.labels,
    required this.highlightIndex,
    required this.highlightValue,
    required this.color,
    required this.gradient,
    required this.lineWidth,
    required this.pointRadius,
    required this.animationValue,
    required this.showTooltip,
    required this.gridLineColor,
    required this.gridLineOpacity,
    required this.gridLineWidth,
    required this.pointBorderColor,
    required this.pointBorderWidth,
    required this.pointCenterColor,
    required this.tooltipTextStyle,
    required this.labelTextStyle,
    required this.tooltipBoxColor,
    required this.tooltipCaretColor,
    required this.dashColor,
    required this.dashWidth,
    required this.labelHighlightColor,
    required this.gridCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double leftPadding = 56.0;
    final double chartHeight = size.height * 0.8;
    final double chartWidth = (size.width - leftPadding) * 0.95;
    final double minY = data.reduce(min);
    final double maxY = data.reduce(max);
    final double yRange = (maxY - minY) == 0 ? 1 : (maxY - minY);
    final double dx = chartWidth / (data.length - 1);

    _drawGrid(canvas, leftPadding, chartHeight, chartWidth, minY, maxY, yRange);
    final points = _calculatePoints(leftPadding, chartHeight, dx, minY, yRange);
    _drawChart(canvas, points, chartHeight, chartWidth);
    _drawTooltip(canvas, points, chartHeight);
    _drawLabels(canvas, points, chartHeight);
  }

  void _drawGrid(
    Canvas canvas,
    double leftPadding,
    double chartHeight,
    double chartWidth,
    double minY,
    double maxY,
    double yRange,
  ) {
    // Handle edge case where we have only one value or no range
    if (yRange == 0) {
      // Draw a single horizontal line in the middle
      double y = chartHeight / 2;
      final gridPaint = Paint()
        ..color = gridLineColor.withAlpha((gridLineOpacity * 255).round())
        ..strokeWidth = gridLineWidth;

      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(leftPadding + chartWidth, y),
        gridPaint,
      );

      final label = TextPainter(
        text: TextSpan(text: minY.toStringAsFixed(0), style: labelTextStyle),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      label.paint(
        canvas,
        Offset(leftPadding - label.width - 8, y - label.height / 2),
      );
      return;
    }

    // Regular grid drawing
    for (int i = 0; i < gridCount; i++) {
      double t = gridCount > 1 ? i / (gridCount - 1) : 0;
      double value = minY + (maxY - minY) * t;
      double y = chartHeight - ((value - minY) / yRange * chartHeight);

      final gridPaint = Paint()
        ..color = gridLineColor.withAlpha((gridLineOpacity * 255).round())
        ..strokeWidth = gridLineWidth;

      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(leftPadding + chartWidth, y),
        gridPaint,
      );

      final label = TextPainter(
        text: TextSpan(text: value.toStringAsFixed(0), style: labelTextStyle),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      label.paint(
        canvas,
        Offset(leftPadding - label.width - 8, y - label.height / 2),
      );
    }
  }

  List<Offset> _calculatePoints(
    double leftPadding,
    double chartHeight,
    double dx,
    double minY,
    double yRange,
  ) {
    List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      double x = leftPadding + i * dx;
      double baseY = chartHeight;
      double targetY = chartHeight - ((data[i] - minY) / yRange * chartHeight);
      double animatedY = baseY - (baseY - targetY) * animationValue;
      points.add(Offset(x, animatedY));
    }
    return points;
  }

  void _drawChart(
    Canvas canvas,
    List<Offset> points,
    double chartHeight,
    double chartWidth,
  ) {
    if (points.isEmpty) return;

    // Handle single point case
    if (points.length == 1) {
      _drawSinglePoint(canvas, points[0]);
      return;
    }

    final controls = _getCubicControlPoints(points);
    _drawArea(canvas, points, controls, chartHeight, chartWidth);
    _drawLine(canvas, points, controls);
  }

  void _drawSinglePoint(Canvas canvas, Offset point) {
    // Draw a circle for single point
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(point, pointRadius, pointPaint);

    // Draw border if specified
    if (pointBorderWidth > 0) {
      final borderPaint = Paint()
        ..color = pointBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = pointBorderWidth;

      canvas.drawCircle(point, pointRadius, borderPaint);
    }
  }

  List<Offset> _getCubicControlPoints(List<Offset> pts) {
    List<Offset> controls = [];
    for (int i = 0; i < pts.length; i++) {
      Offset p0 = i > 0 ? pts[i - 1] : pts[i];
      Offset p1 = pts[i];
      Offset p2 = i < pts.length - 1 ? pts[i + 1] : pts[i];
      double dx1 = (p2.dx - p0.dx) / 6;
      Offset cp1 = Offset(p1.dx + dx1, p1.dy);
      Offset cp2 = Offset(p2.dx - dx1, p2.dy);
      controls.add(cp1);
      controls.add(cp2);
    }
    return controls;
  }

  void _drawArea(
    Canvas canvas,
    List<Offset> points,
    List<Offset> controls,
    double chartHeight,
    double chartWidth,
  ) {
    Path areaPath = Path();
    areaPath.moveTo(points.first.dx, chartHeight);
    areaPath.lineTo(points.first.dx, points.first.dy);

    if (points.length > 2) {
      for (int i = 0; i < points.length - 1; i++) {
        if (i * 2 + 1 < controls.length) {
          Offset cp1 = controls[i * 2];
          Offset cp2 = controls[i * 2 + 1];
          Offset p1 = points[i + 1];
          areaPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
        } else {
          areaPath.lineTo(points[i + 1].dx, points[i + 1].dy);
        }
      }
    } else {
      areaPath.lineTo(points.last.dx, points.last.dy);
    }

    areaPath.lineTo(points.last.dx, chartHeight);
    areaPath.close();

    Paint areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withAlpha((0.35 * 255 * animationValue).round()),
          color.withAlpha((0.10 * 255 * animationValue).round()),
          Colors.transparent,
        ],
        stops: [0.0, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, chartWidth, chartHeight))
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(areaPath, areaPaint);
  }

  void _drawLine(Canvas canvas, List<Offset> points, List<Offset> controls) {
    Paint linePaint = Paint()
      ..color = color.withOpacity(animationValue)
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    Path linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);

    if (points.length > 2) {
      for (int i = 0; i < points.length - 1; i++) {
        if (i * 2 + 1 < controls.length) {
          Offset cp1 = controls[i * 2];
          Offset cp2 = controls[i * 2 + 1];
          Offset p1 = points[i + 1];
          linePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
        } else {
          linePath.lineTo(points[i + 1].dx, points[i + 1].dy);
        }
      }
    } else {
      linePath.lineTo(points.last.dx, points.last.dy);
    }

    canvas.drawPath(linePath, linePaint);
  }

  void _drawTooltip(Canvas canvas, List<Offset> points, double chartHeight) {
    if (!showTooltip || highlightIndex == null) return;

    final hx = points[highlightIndex!].dx;
    final hy = points[highlightIndex!].dy;

    // Draw point
    Paint borderPaint = Paint()
      ..color = pointBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = pointBorderWidth;
    Paint centerPaint = Paint()
      ..color = pointCenterColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(hx, hy), pointRadius, centerPaint);
    canvas.drawCircle(Offset(hx, hy), pointRadius, borderPaint);

    // Draw tooltip box
    final textPainter = TextPainter(
      text: TextSpan(text: highlightValue, style: tooltipTextStyle),
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    )..layout(maxWidth: 80);

    final boxWidth = textPainter.width + 28;
    final boxHeight = textPainter.height + 16;
    final boxRect = Rect.fromCenter(
      center: Offset(hx, hy - 28),
      width: boxWidth,
      height: boxHeight,
    );

    Paint boxPaint = Paint()
      ..color = tooltipBoxColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawRRect(
      RRect.fromRectAndRadius(boxRect, const Radius.circular(8)),
      boxPaint,
    );

    textPainter.paint(
      canvas,
      Offset(hx - textPainter.width / 2, hy - 28 - textPainter.height / 2),
    );

    // Draw tooltip arrow
    _drawTooltipArrow(canvas, hx, boxRect.bottom);

    // Draw dash line
    _drawDashLine(canvas, hx, hy, chartHeight);
  }

  void _drawTooltipArrow(Canvas canvas, double centerX, double topY) {
    const double caretWidth = 14;
    const double caretHeight = 8;

    Path caretPath = Path();
    caretPath.moveTo(centerX - caretWidth / 2, topY);
    caretPath.lineTo(centerX, topY + caretHeight);
    caretPath.lineTo(centerX + caretWidth / 2, topY);
    caretPath.close();

    Paint caretPaint = Paint()
      ..color = tooltipCaretColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(caretPath, caretPaint);
  }

  void _drawDashLine(Canvas canvas, double x, double y, double chartHeight) {
    Paint dashPaint = Paint()
      ..color = dashColor
      ..strokeWidth = dashWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double dashStartY = y + pointRadius + 2;
    double dashEndY = chartHeight;
    const double dashLength = 7;
    const double dashSpace = 7;

    double currentY = dashStartY;
    while (currentY + dashLength < dashEndY) {
      canvas.drawLine(
        Offset(x, currentY),
        Offset(x, currentY + dashLength),
        dashPaint,
      );
      currentY += dashLength + dashSpace;
    }
  }

  void _drawLabels(Canvas canvas, List<Offset> points, double chartHeight) {
    for (int i = 0; i < labels.length; i++) {
      final labelPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: i == highlightIndex
              ? labelTextStyle.copyWith(
                  color: labelHighlightColor,
                  fontWeight: FontWeight.bold,
                )
              : labelTextStyle,
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      double lx = points[i].dx - labelPainter.width / 2;
      double ly = chartHeight + 8;
      labelPainter.paint(canvas, Offset(lx, ly));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
