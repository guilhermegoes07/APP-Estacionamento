import 'package:flutter/material.dart';
import 'color_theme.dart';

class TextTheme {
  // Estilos de texto para títulos
  static const TextStyle titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: ColorTheme.textPrimary,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: ColorTheme.textPrimary,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: ColorTheme.textPrimary,
  );
  
  // Estilos de texto para corpo
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: ColorTheme.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: ColorTheme.textPrimary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: ColorTheme.textPrimary,
  );
  
  // Estilos de texto para botões
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: ColorTheme.buttonTextColor,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: ColorTheme.buttonTextColor,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: ColorTheme.buttonTextColor,
  );
  
  // Estilos de texto para input
  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    color: ColorTheme.textPrimary,
  );
  
  static const TextStyle inputLabel = TextStyle(
    fontSize: 14,
    color: ColorTheme.textSecondary,
  );
  
  static const TextStyle inputError = TextStyle(
    fontSize: 12,
    color: ColorTheme.errorColor,
  );
  
  // Estilos de texto para cards
  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: ColorTheme.textPrimary,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 14,
    color: ColorTheme.textSecondary,
  );
  
  static const TextStyle cardBody = TextStyle(
    fontSize: 14,
    color: ColorTheme.textPrimary,
  );
  
  // Estilos de texto para status
  static const TextStyle statusSuccess = TextStyle(
    fontSize: 14,
    color: ColorTheme.successColor,
  );
  
  static const TextStyle statusError = TextStyle(
    fontSize: 14,
    color: ColorTheme.errorColor,
  );
  
  static const TextStyle statusWarning = TextStyle(
    fontSize: 14,
    color: ColorTheme.warningColor,
  );
  
  static const TextStyle statusInfo = TextStyle(
    fontSize: 14,
    color: ColorTheme.infoColor,
  );
} 