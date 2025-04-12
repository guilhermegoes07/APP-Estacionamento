import 'package:flutter/material.dart';

class ResponsiveTheme {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
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
    final screenWidth = getScreenWidth(context);
    if (screenWidth < 600) {
      return 16.0;
    } else if (screenWidth < 1200) {
      return 24.0;
    } else {
      return 32.0;
    }
  }

  static double getResponsiveFontSize(BuildContext context, {double baseSize = 16.0}) {
    final screenWidth = getScreenWidth(context);
    if (screenWidth < 600) {
      return baseSize;
    } else if (screenWidth < 1200) {
      return baseSize * 1.2;
    } else {
      return baseSize * 1.4;
    }
  }

  static double getResponsiveIconSize(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (screenWidth < 600) {
      return 24.0;
    } else if (screenWidth < 1200) {
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
    final screenWidth = getScreenWidth(context);
    if (screenWidth < 600) {
      return 8.0;
    } else if (screenWidth < 1200) {
      return 12.0;
    } else {
      return 16.0;
    }
  }

  static double getResponsiveImageHeight(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (screenWidth < 600) {
      return 120.0;
    } else if (screenWidth < 1200) {
      return 160.0;
    } else {
      return 200.0;
    }
  }
} 