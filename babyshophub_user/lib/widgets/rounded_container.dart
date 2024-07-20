import 'package:BabyShopHub/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoundedContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double? radius;
  final bool showBorder;
  final bool isDarkMode;
  final Color borderColor;
  final Widget? child;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const RoundedContainer({
    super.key,
    this.width,
    this.height,
    this.radius = 24,
    this.showBorder = false,
    this.borderColor = Colors.white30,
    this.backgroundColor = Colors.blue,
    this.padding,
    this.margin,
    required this.isDarkMode,
    this.child,
    });

  @override
  Widget build(BuildContext context) {
      final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey[800]!.withOpacity(0.7)
              : const Color(0xFFF2F7EB),
          borderRadius: BorderRadius.circular(24),
          border: showBorder ? Border.all(color: borderColor) : null),
      child: child,
    );
  }
}