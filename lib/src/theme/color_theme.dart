import 'package:flutter/material.dart';

class ColorTheme {
  // Cores principais
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFF8BC34A);
  
  // Cores de texto
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);
  
  // Cores de fundo
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF212121);
  
  // Cores de status
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF2196F3);
  
  // Cores de borda
  static const Color borderColor = Color(0xFFE0E0E0);
  
  // Cores de sombra
  static const Color shadowColor = Color(0x40000000);
  
  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, secondaryColor],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentColor, secondaryColor],
  );
  
  // Opacidade
  static const double opacityLow = 0.3;
  static const double opacityMedium = 0.6;
  static const double opacityHigh = 0.9;
  
  // Cores de estado
  static const Color disabledColor = Color(0xFFBDBDBD);
  static const Color hoverColor = Color(0xFFE8F5E9);
  static const Color focusColor = Color(0xFFC8E6C9);
  
  // Cores de ícones
  static const Color iconColor = Color(0xFF757575);
  static const Color iconActiveColor = primaryColor;
  
  // Cores de cards
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color cardShadowColor = Color(0x1A000000);
  
  // Cores de input
  static const Color inputBorderColor = Color(0xFFE0E0E0);
  static const Color inputFocusBorderColor = primaryColor;
  static const Color inputErrorBorderColor = errorColor;
  
  // Cores de botão
  static const Color buttonTextColor = Color(0xFFFFFFFF);
  static const Color buttonDisabledTextColor = Color(0xFFBDBDBD);
  static const Color buttonBackgroundColor = primaryColor;
  static const Color buttonDisabledBackgroundColor = Color(0xFFE0E0E0);
} 