import 'package:flutter/material.dart';
import '../theme/home_theme.dart';
import '../theme/responsive_theme.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.all(ResponsiveTheme.getResponsiveSpacing(context)),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFooterItem(
              context,
              Icons.home,
              'Home',
              () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            _buildFooterItem(
              context,
              Icons.add_circle,
              'Entrada',
              () => Navigator.pushNamed(context, '/entrada'),
            ),
            _buildFooterItem(
              context,
              Icons.exit_to_app,
              'Saída',
              () => Navigator.pushNamed(context, '/saida'),
            ),
            _buildFooterItem(
              context,
              Icons.search,
              'Busca',
              () => Navigator.pushNamed(context, '/busca'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: ResponsiveTheme.getResponsiveIconSize(context),
            color: HomeTheme.primaryColor,
          ),
          SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 12),
              color: HomeTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
} 