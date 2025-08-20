import 'package:flutter/material.dart';

/// A customizable filter button widget with smooth animations
///
/// This widget provides a styled button that can be used for filtering data
/// with customizable colors, borders, shadows, and text styles.
class ChartFilterButton extends StatelessWidget {
  /// The text to display on the button
  final String label;

  /// Whether the button is currently selected
  final bool selected;

  /// Callback function when the button is tapped
  final VoidCallback? onTap;

  // Color customization for selected state
  /// Background color when the button is selected
  final Color? selectedBackgroundColor;

  /// Border color when the button is selected
  final Color? selectedBorderColor;

  /// Text color when the button is selected
  final Color? selectedTextColor;

  /// Shadow color when the button is selected
  final Color? selectedShadowColor;

  // Color customization for unselected state
  /// Background color when the button is not selected
  final Color? unselectedBackgroundColor;

  /// Border color when the button is not selected
  final Color? unselectedBorderColor;

  /// Text color when the button is not selected
  final Color? unselectedTextColor;

  // Animation and styling
  /// Duration of the transition animation between states
  final Duration animationDuration;

  /// Border radius of the button
  final double borderRadius;

  /// Padding inside the button
  final EdgeInsets padding;

  /// Margin around the button
  final EdgeInsets margin;

  const ChartFilterButton({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    // Selected state colors
    this.selectedBackgroundColor,
    this.selectedBorderColor,
    this.selectedTextColor,
    this.selectedShadowColor,
    // Unselected state colors
    this.unselectedBackgroundColor,
    this.unselectedBorderColor,
    this.unselectedTextColor,
    // Styling
    this.animationDuration = const Duration(milliseconds: 200),
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.margin = const EdgeInsets.only(right: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: animationDuration,
          decoration: BoxDecoration(
            color: selected
                ? (selectedBackgroundColor ?? Colors.blue)
                : (unselectedBackgroundColor ?? Colors.white),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: selected
                  ? (selectedBorderColor ?? Colors.blue.shade700)
                  : (unselectedBorderColor ?? Colors.grey.shade300),
              width: 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: (selectedShadowColor ?? Colors.blue).withOpacity(
                        0.3,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          padding: padding,
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? (selectedTextColor ?? Colors.white)
                  : (unselectedTextColor ?? Colors.grey.shade700),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
