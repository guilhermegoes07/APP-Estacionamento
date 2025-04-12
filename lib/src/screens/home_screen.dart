import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/estacionamento_service.dart';
import '../theme/home_theme.dart';
import '../theme/responsive_theme.dart';
import 'entrada_screen.dart';
import 'saida_screen.dart';
import 'busca_screen.dart';
import 'relatorio_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Controle de Estacionamento',
          style: TextStyle(
            fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 20),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implementar tela de configurações
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFF5F5F5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: ResponsiveTheme.getResponsivePadding(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatusCard(context),
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 3),
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Consumer<EstacionamentoService>(
      builder: (context, service, child) {
        return Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: ResponsiveTheme.getResponsivePadding(context),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.directions_car,
                          size: ResponsiveTheme.getResponsiveIconSize(context),
                          color: HomeTheme.primaryColor,
                        ),
                        SizedBox(width: ResponsiveTheme.getResponsiveSpacing(context)),
                        Text(
                          'Veículos no Pátio: ${service.veiculosNoPatio.length}',
                          style: TextStyle(
                            fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        // TODO: Implementar atualização
                      },
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: ResponsiveTheme.getResponsiveIconSize(context),
                      color: Colors.green,
                    ),
                    SizedBox(width: ResponsiveTheme.getResponsiveSpacing(context)),
                    Text(
                      'Valor Arrecadado: R\$ ${service.totalArrecadado.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: ResponsiveTheme.getResponsiveSpacing(context) * 2,
      crossAxisSpacing: ResponsiveTheme.getResponsiveSpacing(context) * 2,
      children: [
        _buildActionButton(
          context,
          icon: Icons.add_circle_outline,
          label: 'Nova Entrada',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EntradaScreen()),
          ),
          color: Colors.blue,
        ),
        _buildActionButton(
          context,
          icon: Icons.exit_to_app,
          label: 'Registrar Saída',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SaidaScreen()),
          ),
          color: Colors.green,
        ),
        _buildActionButton(
          context,
          icon: Icons.search,
          label: 'Buscar Veículo',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BuscaScreen()),
          ),
          color: Colors.orange,
        ),
        _buildActionButton(
          context,
          icon: Icons.bar_chart,
          label: 'Relatório Diário',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RelatorioScreen()),
          ),
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveTheme.getResponsiveSpacing(context) * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: ResponsiveTheme.getResponsiveIconSize(context) * 1.5,
                color: color,
              ),
              SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
              Text(
                label,
                style: TextStyle(
                  fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 14),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveTheme.getResponsiveSpacing(context),
        horizontal: ResponsiveTheme.getResponsiveSpacing(context) * 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'CNPJ: 00.000.000/0001-00',
            style: TextStyle(
              fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 12),
              fontFamily: 'Poppins',
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) / 2),
          Text(
            'v1.0.0',
            style: TextStyle(
              fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 12),
              fontFamily: 'Poppins',
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
} 