import 'package:flutter/material.dart';

class ResponsiveTheme {
  static double _maxWidth = 1200.0;
  static double _maxHeight = 800.0;

  static double get maxWidth => _maxWidth;
  static double get maxHeight => _maxHeight;

  static void setMaxResolution(double width, double height) {
    _maxWidth = width;
    _maxHeight = height;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width.clamp(0.0, _maxWidth);
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height.clamp(0.0, _maxHeight);
  }

  static bool isMobile(BuildContext context) {
    return getScreenWidth(context) < 600;
  }

  static bool isTablet(BuildContext context) {
    return getScreenWidth(context) >= 600 && getScreenWidth(context) < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return getScreenWidth(context) >= 1200;
  }

  static double getBasePadding(BuildContext context) {
    if (isMobile(context)) {
      return 16.0;
    } else if (isTablet(context)) {
      return 24.0;
    } else {
      return 32.0;
    }
  }

  static double getResponsiveFontSize(BuildContext context, {double baseSize = 16.0}) {
    if (isMobile(context)) {
      return baseSize;
    } else if (isTablet(context)) {
      return baseSize * 1.2;
    } else {
      return baseSize * 1.4;
    }
  }

  static double getResponsiveIconSize(BuildContext context) {
    if (isMobile(context)) {
      return 24.0;
    } else if (isTablet(context)) {
      return 32.0;
    } else {
      return 40.0;
    }
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    final basePadding = getBasePadding(context);
    return EdgeInsets.all(basePadding);
  }

  static EdgeInsets getResponsiveHorizontalPadding(BuildContext context) {
    final basePadding = getBasePadding(context);
    return EdgeInsets.symmetric(horizontal: basePadding);
  }

  static EdgeInsets getResponsiveVerticalPadding(BuildContext context) {
    final basePadding = getBasePadding(context);
    return EdgeInsets.symmetric(vertical: basePadding);
  }

  static double getResponsiveSpacing(BuildContext context) {
    if (isMobile(context)) {
      return 8.0;
    } else if (isTablet(context)) {
      return 12.0;
    } else {
      return 16.0;
    }
  }

  static double getResponsiveImageHeight(BuildContext context) {
    if (isMobile(context)) {
      return 120.0;
    } else if (isTablet(context)) {
      return 160.0;
    } else {
      return 200.0;
    }
  }
} 