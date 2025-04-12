import 'package:flutter/material.dart';
import '../theme/home_theme.dart';
import '../theme/responsive_theme.dart';

class RelatorioScreen extends StatelessWidget {
  const RelatorioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Relatório Diário',
          style: TextStyle(
            fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 20),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: HomeTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: ResponsiveTheme.getResponsivePadding(context),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveTheme.isDesktop(context) ? 800 : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCard(
                      context,
                      title: 'Veículos Hoje',
                      value: '0',
                      icon: Icons.directions_car,
                    ),
                    SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                    _buildCard(
                      context,
                      title: 'Arrecadação Hoje',
                      value: 'R\$ 0,00',
                      icon: Icons.attach_money,
                    ),
                    SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                    _buildCard(
                      context,
                      title: 'Tempo Médio',
                      value: '0 min',
                      icon: Icons.timer,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: ResponsiveTheme.getResponsivePadding(context),
        child: Row(
          children: [
            Icon(
              icon,
              size: ResponsiveTheme.getResponsiveIconSize(context) * 2,
              color: HomeTheme.primaryColor,
            ),
            SizedBox(width: ResponsiveTheme.getResponsiveSpacing(context) * 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 24),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 