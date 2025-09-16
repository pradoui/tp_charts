import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';

/// Period types for date formatting
enum PeriodType { hour, day, week, month, year, custom }

/// A customizable animated line chart widget for Flutter without filter buttons
///
/// This widget displays data as a smooth line chart with various customization options
/// including colors, animations, grid lines, tooltips, and hover effects.
/// It accepts a date range filter externally through startDate and endDate parameters.
class SimpleLineChart extends StatefulWidget {
  /// List of DateTime objects for the X-axis
  final List<DateTime>? dates;

  /// List of labels for the X-axis (alternative to dates)
  final List<String>? xValues;

  /// List of values for the Y-axis (numeric data)
  final List<double> yValues;

  /// Start date for filtering data (optional)
  final DateTime? startDate;

  /// End date for filtering data (optional)
  final DateTime? endDate;

  /// Type of period for date label formatting
  final PeriodType periodType;

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

  // X-axis label customization
  /// Maximum number of X-axis labels to show
  final int maxXLabels;

  /// Whether to rotate X-axis labels when they overlap
  final bool rotateLabels;

  /// Rotation angle for X-axis labels (in radians)
  final double labelRotation;

  const SimpleLineChart({
    super.key,
    this.dates,
    this.xValues,
    required this.yValues,
    this.startDate,
    this.endDate,
    this.periodType = PeriodType.custom,
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
    // X-axis label customization defaults
    this.maxXLabels = 8,
    this.rotateLabels = false,
    this.labelRotation = 0.785398, // 45 degrees in radians
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
       assert(minGridCount > 0, 'minGridCount must be greater than 0'),
       assert(maxXLabels > 0, 'maxXLabels must be greater than 0');

  @override
  State<SimpleLineChart> createState() => _SimpleLineChartState();
}

class _SimpleLineChartState extends State<SimpleLineChart>
    with SingleTickerProviderStateMixin {
  int? _hoveredIndex;
  late AnimationController _animationController;
  late Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();
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
  void didUpdateWidget(SimpleLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart animation if data changed
    if (oldWidget.yValues != widget.yValues ||
        oldWidget.dates != widget.dates ||
        oldWidget.xValues != widget.xValues ||
        oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      _restartAnimation();
    }

    // Update animation duration if changed
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
    // Se a animação está desabilitada (duration zero), não usar delay
    final delay = widget.animationDuration == Duration.zero
        ? Duration.zero
        : const Duration(milliseconds: 200);

    Future.delayed(delay, () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  void _restartAnimation() {
    _animationController.reset();
    _startAnimation();
  }

  /// Filters data based on provided startDate and endDate parameters
  Map<String, dynamic> _getFilteredData() {
    if (widget.dates == null) {
      // Use xValues as is if no dates provided
      return {'xValues': widget.xValues!, 'yValues': widget.yValues};
    }

    final dates = widget.dates!;
    final values = widget.yValues;

    List<DateTime> filteredDates = [];
    List<double> filteredValues = [];
    List<String> formattedLabels = [];

    // Filter by date range if provided
    for (int i = 0; i < dates.length; i++) {
      bool includeDate = true;

      // Check start date
      if (widget.startDate != null && dates[i].isBefore(widget.startDate!)) {
        includeDate = false;
      }

      // Check end date
      if (widget.endDate != null && dates[i].isAfter(widget.endDate!)) {
        includeDate = false;
      }

      if (includeDate) {
        filteredDates.add(dates[i]);
        filteredValues.add(values[i]);
      }
    }

    // Format labels based on period type
    if (filteredDates.isNotEmpty) {
      switch (widget.periodType) {
        case PeriodType.hour:
          formattedLabels = filteredDates
              .map((d) => DateFormat('HH:mm').format(d))
              .toList();
          break;
        case PeriodType.day:
          formattedLabels = filteredDates
              .map((d) => DateFormat('dd/MM').format(d))
              .toList();
          break;
        case PeriodType.week:
          formattedLabels = filteredDates
              .map((d) => _getWeekdayAbbr(d))
              .toList();
          break;
        case PeriodType.month:
          formattedLabels = filteredDates
              .map((d) => DateFormat('dd/MM').format(d))
              .toList();
          break;
        case PeriodType.year:
          formattedLabels = filteredDates
              .map((d) => DateFormat('MMM').format(d))
              .toList();
          break;
        case PeriodType.custom:
          // Auto-detect format based on date range
          if (filteredDates.length > 1) {
            final span = filteredDates.last
                .difference(filteredDates.first)
                .inDays;
            if (span <= 1) {
              // Same day - show date only (no hours)
              formattedLabels = filteredDates
                  .map((d) => DateFormat('dd/MM').format(d))
                  .toList();
            } else if (span <= 31) {
              // Within a month - show days
              formattedLabels = filteredDates
                  .map((d) => DateFormat('dd/MM').format(d))
                  .toList();
            } else {
              // Longer period - show months
              formattedLabels = filteredDates
                  .map((d) => DateFormat('MMM/yy').format(d))
                  .toList();
            }
          } else {
            formattedLabels = filteredDates
                .map((d) => DateFormat('dd/MM').format(d))
                .toList();
          }
          break;
      }
    }

    return {'xValues': formattedLabels, 'yValues': filteredValues};
  }

  String _getWeekdayAbbr(DateTime date) {
    const weekdays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    return weekdays[date.weekday % 7];
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
          'Não existem valores no período especificado.',
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onHover: (event) => _handleHover(event, constraints, yValues),
          onExit: _handleExit,
          child: AnimatedBuilder(
            animation: _lineAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: _SimpleLineChartPainter(
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
                  maxXLabels: widget.maxXLabels,
                  rotateLabels: widget.rotateLabels,
                  labelRotation: widget.labelRotation,
                ),
                child: Container(),
              );
            },
          ),
        );
      },
    );
  }
}

class _SimpleLineChartPainter extends CustomPainter {
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
  final int maxXLabels;
  final bool rotateLabels;
  final double labelRotation;

  _SimpleLineChartPainter({
    required this.data,
    required this.labels,
    this.highlightIndex,
    this.highlightValue = '',
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
    required this.maxXLabels,
    required this.rotateLabels,
    required this.labelRotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const leftPadding = 56.0;
    const topPadding = 16.0;
    const bottomPadding = 40.0;
    const rightPadding = 16.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    // Calculate Y-axis bounds
    final minY = data.reduce(min);
    final maxY = data.reduce(max);
    final range = maxY - minY;
    final padding = range * 0.1;
    final adjustedMinY = minY - padding;
    final adjustedMaxY = maxY + padding;
    final adjustedRange = adjustedMaxY - adjustedMinY;

    // Calculate data points
    List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final x = leftPadding + (i / (data.length - 1)) * chartWidth;
      final y =
          topPadding +
          chartHeight -
          ((data[i] - adjustedMinY) / adjustedRange) * chartHeight;
      points.add(Offset(x, y));
    }

    // Draw grid lines
    _drawGrid(canvas, leftPadding, topPadding, chartWidth, chartHeight);

    // Draw Y-axis labels
    _drawYAxisLabels(
      canvas,
      leftPadding,
      topPadding,
      chartHeight,
      adjustedMinY,
      adjustedMaxY,
    );

    // Draw area under the line (gradient fill)
    _drawArea(canvas, points, chartHeight, topPadding);

    // Draw the line with animation
    _drawLine(canvas, points);

    // Draw X-axis labels
    _drawLabels(canvas, points, topPadding + chartHeight);

    // Draw hover effects
    if (showTooltip &&
        highlightIndex != null &&
        highlightIndex! < points.length) {
      _drawHoverEffects(
        canvas,
        points[highlightIndex!],
        topPadding + chartHeight,
        size,
      );
    }
  }

  void _drawGrid(
    Canvas canvas,
    double leftPadding,
    double topPadding,
    double chartWidth,
    double chartHeight,
  ) {
    Paint gridPaint = Paint()
      ..color = gridLineColor.withOpacity(gridLineOpacity)
      ..strokeWidth = gridLineWidth
      ..style = PaintingStyle.stroke;

    // Draw horizontal grid lines
    for (int i = 0; i <= gridCount; i++) {
      final y = topPadding + (i / gridCount) * chartHeight;
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(leftPadding + chartWidth, y),
        gridPaint,
      );
    }
  }

  void _drawYAxisLabels(
    Canvas canvas,
    double leftPadding,
    double topPadding,
    double chartHeight,
    double minY,
    double maxY,
  ) {
    for (int i = 0; i <= gridCount; i++) {
      final value = maxY - (i / gridCount) * (maxY - minY);
      final y = topPadding + (i / gridCount) * chartHeight;

      final textPainter = TextPainter(
        text: TextSpan(text: value.toStringAsFixed(1), style: labelTextStyle),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(leftPadding - textPainter.width - 8, y - textPainter.height / 2),
      );
    }
  }

  void _drawArea(
    Canvas canvas,
    List<Offset> points,
    double chartHeight,
    double topPadding,
  ) {
    if (points.length < 2) return;

    final controls = _getCubicControlPoints(points);

    Path areaPath = Path();
    areaPath.moveTo(points.first.dx, topPadding + chartHeight);
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

    areaPath.lineTo(points.last.dx, topPadding + chartHeight);
    areaPath.close();

    // Create gradient dynamically based on the chart's color
    Paint areaPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withAlpha((0.35 * 255 * animationValue).round()),
              color.withAlpha((0.10 * 255 * animationValue).round()),
              Colors.transparent,
            ],
            stops: [0.0, 0.7, 1.0],
          ).createShader(
            Rect.fromLTWH(
              0,
              topPadding,
              points.last.dx - points.first.dx,
              chartHeight,
            ),
          )
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(areaPath, areaPaint);
  }

  void _drawLine(Canvas canvas, List<Offset> points) {
    if (points.length < 2) return;

    final controls = _getCubicControlPoints(points);

    Paint linePaint = Paint()
      ..color = color.withOpacity(animationValue)
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
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

    // Create animated path
    final pathMetrics = linePath.computeMetrics();
    final animatedPath = Path();

    for (final pathMetric in pathMetrics) {
      final extractedPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * animationValue,
      );
      animatedPath.addPath(extractedPath, Offset.zero);
    }

    canvas.drawPath(animatedPath, linePaint);
  }

  void _drawHoverEffects(
    Canvas canvas,
    Offset point,
    double chartHeight,
    Size canvasSize,
  ) {
    final hx = point.dx;
    final hy = point.dy;

    // Draw point
    Paint pointPaint = Paint()
      ..color = pointBorderColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(hx, hy), pointRadius, pointPaint);

    Paint centerPaint = Paint()
      ..color = pointCenterColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(hx, hy),
      pointRadius - pointBorderWidth,
      centerPaint,
    );

    // Format the value for better display
    String formattedValue = highlightValue;
    try {
      final numValue = double.parse(highlightValue);
      // Format with appropriate decimal places
      if (numValue % 1 == 0) {
        // Integer value
        formattedValue = numValue.toStringAsFixed(0);
      } else {
        // Decimal value - show up to 2 decimal places, removing trailing zeros
        formattedValue = numValue
            .toStringAsFixed(2)
            .replaceAll(RegExp(r'\.?0+$'), '');
      }
    } catch (e) {
      // Keep original value if parsing fails
      formattedValue = highlightValue;
    }

    // Draw tooltip
    final textPainter = TextPainter(
      text: TextSpan(text: formattedValue, style: tooltipTextStyle),
      textDirection: ui.TextDirection.ltr,
    )..layout();

    final boxWidth = textPainter.width + 16;
    final boxHeight = textPainter.height + 12;

    // Calculate tooltip position to keep it within canvas bounds
    double tooltipX = hx;
    double tooltipY = hy - 28 - boxHeight / 2;

    // Adjust horizontal position if tooltip goes out of bounds
    const double margin = 8.0;
    if (tooltipX - boxWidth / 2 < margin) {
      tooltipX = margin + boxWidth / 2;
    } else if (tooltipX + boxWidth / 2 > canvasSize.width - margin) {
      tooltipX = canvasSize.width - margin - boxWidth / 2;
    }

    // Adjust vertical position if tooltip goes out of bounds
    if (tooltipY < margin) {
      tooltipY = hy + pointRadius + 16; // Show below the point instead
    }

    final boxRect = Rect.fromCenter(
      center: Offset(tooltipX, tooltipY),
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
      Offset(
        tooltipX - textPainter.width / 2,
        tooltipY - textPainter.height / 2,
      ),
    );

    // Draw tooltip arrow - adjust direction based on position
    if (tooltipY < hy) {
      // Arrow pointing down (tooltip is above point)
      _drawTooltipArrow(canvas, tooltipX, boxRect.bottom, true);
    } else {
      // Arrow pointing up (tooltip is below point)
      _drawTooltipArrow(canvas, tooltipX, boxRect.top, false);
    }

    // Draw dash line
    _drawDashLine(canvas, hx, hy, chartHeight);
  }

  void _drawTooltipArrow(
    Canvas canvas,
    double centerX,
    double topY, [
    bool pointDown = true,
  ]) {
    const double caretWidth = 14;
    const double caretHeight = 8;

    Path caretPath = Path();

    if (pointDown) {
      // Arrow pointing down (normal case)
      caretPath.moveTo(centerX - caretWidth / 2, topY);
      caretPath.lineTo(centerX, topY + caretHeight);
      caretPath.lineTo(centerX + caretWidth / 2, topY);
    } else {
      // Arrow pointing up (when tooltip is below point)
      caretPath.moveTo(centerX - caretWidth / 2, topY);
      caretPath.lineTo(centerX, topY - caretHeight);
      caretPath.lineTo(centerX + caretWidth / 2, topY);
    }

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
    if (labels.isEmpty || points.isEmpty) return;

    // Calculate which labels to show
    List<int> indicesToShow = _calculateLabelIndices();

    for (int index in indicesToShow) {
      if (index >= labels.length || index >= points.length) continue;

      final isHighlighted = index == highlightIndex;
      final labelText = labels[index];

      final labelPainter = TextPainter(
        text: TextSpan(
          text: labelText,
          style: isHighlighted
              ? labelTextStyle.copyWith(
                  color: labelHighlightColor,
                  fontWeight: FontWeight.bold,
                )
              : labelTextStyle,
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      double lx = points[index].dx;
      double ly = chartHeight + 8;

      if (rotateLabels && labelRotation != 0) {
        // Save canvas state for rotation
        canvas.save();

        // Move to label position
        canvas.translate(lx, ly + labelPainter.height);

        // Rotate
        canvas.rotate(labelRotation);

        // Draw rotated label
        labelPainter.paint(canvas, Offset(-labelPainter.width / 2, 0));

        // Restore canvas state
        canvas.restore();
      } else {
        // Draw normal horizontal label
        lx = lx - labelPainter.width / 2;
        labelPainter.paint(canvas, Offset(lx, ly));
      }
    }
  }

  /// Calculate which label indices to show based on available space
  List<int> _calculateLabelIndices() {
    if (labels.length <= maxXLabels) {
      // If we have few labels, show all
      return List.generate(labels.length, (index) => index);
    }

    List<int> indices = [];

    // Always show first and last
    indices.add(0);
    if (labels.length > 1) {
      indices.add(labels.length - 1);
    }

    // Calculate step to distribute remaining labels evenly
    int remainingSlots = maxXLabels - 2; // minus first and last
    if (remainingSlots > 0) {
      double step = (labels.length - 1) / (remainingSlots + 1);

      for (int i = 1; i <= remainingSlots; i++) {
        int index = (step * i).round();
        if (index > 0 &&
            index < labels.length - 1 &&
            !indices.contains(index)) {
          indices.add(index);
        }
      }
    }

    // Sort indices
    indices.sort();
    return indices;
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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
