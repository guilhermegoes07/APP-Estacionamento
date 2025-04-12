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
          gradient: HomeTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: ResponsiveTheme.getResponsivePadding(context),
            child: Column(
              children: [
                _buildStatusCard(context),
                SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 4),
                _buildActionButtons(context),
                SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 4),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Consumer<EstacionamentoService>(
      builder: (context, service, child) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: ResponsiveTheme.getResponsivePadding(context),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Veículos no Pátio: ${service.veiculosNoPatio.length}',
                      style: TextStyle(
                        fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                      ),
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
                Text(
                  'Valor Arrecadado: R\$ ${service.totalArrecadado.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                    fontWeight: FontWeight.bold,
                  ),
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: ResponsiveTheme.getResponsivePadding(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: ResponsiveTheme.getResponsiveIconSize(context) * 2,
          ),
          SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Text(
          'CNPJ: 00.000.000/0001-00',
          style: TextStyle(
            fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 12),
            color: Colors.grey,
          ),
        ),
        SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
        Text(
          'v1.0.0',
          style: TextStyle(
            fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 12),
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
} 