import 'dart:math';
import 'package:flutter/material.dart';

/// A customizable gauge-style chart widget that displays a value and its status
///
/// This widget displays a value in a gauge/speedometer style with color indication
/// based on how close the current value is to an ideal value.
class HotChart extends StatefulWidget {
  /// The current value to display in the center
  final double currentValue;

  /// Minimum value for the gauge scale
  final double minValue;

  /// Maximum value for the gauge scale
  final double maxValue;

  /// Width and height of the chart (it's always square)
  final double size;

  /// Color when the value is good (close to ideal)
  final Color goodColor;

  /// Color when the value is average
  final Color averageColor;

  /// Color when the value is bad (far from ideal)
  final Color badColor;

  /// Background color of the gauge
  final Color backgroundColor;

  /// Color of the gauge track
  final Color trackColor;

  /// Text style for the main value
  final TextStyle valueTextStyle;

  /// Text style for the status label
  final TextStyle statusTextStyle;

  /// Thickness of the gauge track
  final double trackWidth;

  /// Duration of the animation
  final Duration animationDuration;

  /// Whether to show the status text below the value
  final bool showStatusText;

  /// Custom status texts for each state based on position percentage
  final String excellentStatusText;
  final String regularStatusText;
  final String poorStatusText;

  /// Colors for each status
  final Color excellentColor;
  final Color regularColor;
  final Color poorColor;

  /// Whether to animate the entrance
  final bool animate;

  const HotChart({
    super.key,
    required this.currentValue,
    this.minValue = 0.0,
    this.maxValue = 10.0,
    this.size = 200.0,
    this.goodColor = const Color(0xFF10B981), // Green
    this.averageColor = const Color(0xFFF59E0B), // Yellow/Orange
    this.badColor = const Color(0xFFEF4444), // Red
    this.backgroundColor = Colors.white,
    this.trackColor = const Color(0xFFF3F4F6),
    this.valueTextStyle = const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    this.statusTextStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black54,
    ),
    this.trackWidth = 20.0,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.showStatusText = true,
    this.excellentStatusText = 'Ótimo',
    this.regularStatusText = 'Regular',
    this.poorStatusText = 'Ruim',
    this.excellentColor = const Color(0xFF059669), // Strong green
    this.regularColor = const Color(0xFFF59E0B), // Yellow
    this.poorColor = const Color(0xFFDC2626), // Red
    this.animate = true,
  }) : assert(minValue < maxValue, 'minValue must be less than maxValue'),
       assert(
         currentValue >= minValue && currentValue <= maxValue,
         'currentValue must be between minValue and maxValue',
       ),
       assert(size > 0, 'size must be positive'),
       assert(trackWidth > 0, 'trackWidth must be positive');

  @override
  State<HotChart> createState() => _HotChartState();
}

class _HotChartState extends State<HotChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    if (widget.animate) {
      _startAnimation();
    }
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  void _startAnimation() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HotChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentValue != widget.currentValue) {
      if (widget.animate) {
        _animationController.reset();
        _startAnimation();
      }
    }
  }

  /// Determines the status based on percentage of current value
  ValueStatus _getValueStatus() {
    final range = widget.maxValue - widget.minValue;
    final percentage = ((widget.currentValue - widget.minValue) / range * 100)
        .clamp(0.0, 100.0);

    if (percentage <= 30) {
      return ValueStatus.excellent;
    } else if (percentage <= 60) {
      return ValueStatus.regular;
    } else {
      return ValueStatus.poor;
    }
  }

  /// Gets the color for the current status based on percentage
  Color _getGradientColor() {
    switch (_getValueStatus()) {
      case ValueStatus.excellent:
        return widget.excellentColor;
      case ValueStatus.regular:
        return widget.regularColor;
      case ValueStatus.poor:
        return widget.poorColor;
    }
  }

  /// Gets the status text for the current status
  String _getStatusText() {
    switch (_getValueStatus()) {
      case ValueStatus.excellent:
        return widget.excellentStatusText;
      case ValueStatus.regular:
        return widget.regularStatusText;
      case ValueStatus.poor:
        return widget.poorStatusText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: widget.animate
          ? AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return _buildChart(_animation.value);
              },
            )
          : _buildChart(1.0),
    );
  }

  Widget _buildChart(double animationValue) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Gauge background
        CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _GaugePainter(
            currentValue: widget.currentValue,
            minValue: widget.minValue,
            maxValue: widget.maxValue,
            trackColor: widget.trackColor,
            statusColor: _getGradientColor(),
            trackWidth: widget.trackWidth,
            animationValue: animationValue,
          ),
        ),
        // Center content
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main value
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: widget.valueTextStyle.copyWith(
                color: widget.valueTextStyle.color?.withOpacity(animationValue),
              ),
              child: Text(
                widget.currentValue.toStringAsFixed(
                  widget.currentValue == widget.currentValue.roundToDouble()
                      ? 0
                      : 1,
                ),
              ),
            ),
            // Status text
            if (widget.showStatusText) ...[
              const SizedBox(height: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: widget.statusTextStyle.copyWith(
                  color: _getGradientColor().withOpacity(animationValue),
                ),
                child: Text(_getStatusText()),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// Enum to represent the status of the value
enum ValueStatus { excellent, regular, poor }

/// Custom painter for the gauge
class _GaugePainter extends CustomPainter {
  final double currentValue;
  final double minValue;
  final double maxValue;
  final Color trackColor;
  final Color statusColor;
  final double trackWidth;
  final double animationValue;

  _GaugePainter({
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
    required this.trackColor,
    required this.statusColor,
    required this.trackWidth,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - trackWidth / 2 - 10;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Create a simple linear gradient from green to red with yellow in middle
    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        const Color(0xFF10B981), // Green at left
        const Color(0xFFF59E0B), // Yellow/Orange in middle
        const Color(0xFFEF4444), // Red at right
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final trackPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackWidth
      ..strokeCap = StrokeCap.round;

    // Always draw the full gradient arc
    canvas.drawArc(
      rect,
      -pi, // Start from left side
      pi, // Draw full semicircle (180 degrees)
      false,
      trackPaint,
    );

    // Draw current value indicator (small circular marker)
    final currentNormalized = (currentValue - minValue) / (maxValue - minValue);
    final currentIndicatorAngle =
        -pi + (currentNormalized * pi * animationValue);

    // Position the indicator at the end of the progress arc
    final indicatorRadius = 5.0;
    final indicatorPosition = Offset(
      center.dx + radius * cos(currentIndicatorAngle),
      center.dy + radius * sin(currentIndicatorAngle),
    );

    // Draw indicator shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      indicatorPosition.translate(1, 1),
      indicatorRadius,
      shadowPaint,
    );

    // Draw indicator with solid white color
    final indicatorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(indicatorPosition, indicatorRadius, indicatorPaint);

    // Draw indicator border
    final indicatorBorderPaint = Paint()
      ..color = Colors.grey[300] ?? Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(indicatorPosition, indicatorRadius, indicatorBorderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
