import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/estacionamento_service.dart';
import '../theme/home_theme.dart';
import '../theme/responsive_theme.dart';
import '../widgets/shimmer_effect.dart';
import 'entrada_screen.dart';
import 'saida_screen.dart';
import 'busca_screen.dart';
import 'relatorio_screen.dart';
import 'configuracoes_screen.dart';
import '../widgets/veiculo_detalhes_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simula um carregamento de dados
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: ResponsiveTheme.getResponsivePadding(context),
                  child: Column(
                    children: [
                      ShimmerEffect(
                        isLoading: _isLoading,
                        child: _buildStatusCard(context),
                      ),
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 3),
                      ShimmerEffect(
                        isLoading: _isLoading,
                        child: _buildActionButtons(context),
                      ),
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 3),
                      ShimmerEffect(
                        isLoading: _isLoading,
                        child: _buildDailyReport(context),
                      ),
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 3),
                      ShimmerEffect(
                        isLoading: _isLoading,
                        child: _buildVehiclesList(context),
                      ),
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 3),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveTheme.getResponsiveSpacing(context) * 2,
        vertical: ResponsiveTheme.getResponsiveSpacing(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Controle de Estacionamento',
            style: TextStyle(
              fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 20),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: HomeTheme.primaryColor,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ConfiguracoesScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Consumer<EstacionamentoService>(
      builder: (context, service, child) {
        final estatisticas = service.getEstatisticas();
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
                      'Valor Arrecadado: R\$ ${estatisticas['arrecadacaoHoje'].toStringAsFixed(2)}',
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
      crossAxisCount: 3,
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

  Widget _buildDailyReport(BuildContext context) {
    return Consumer<EstacionamentoService>(
      builder: (context, service, child) {
        final estatisticas = service.getEstatisticas();
        
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: ResponsiveTheme.getResponsivePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: ResponsiveTheme.getResponsiveIconSize(context),
                      color: Colors.purple,
                    ),
                    SizedBox(width: ResponsiveTheme.getResponsiveSpacing(context)),
                    Text(
                      'Relatório Diário',
                      style: TextStyle(
                        fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildReportItem(
                      context,
                      label: 'Entradas',
                      value: '${estatisticas['ticketsHoje']}',
                      icon: Icons.login,
                      color: Colors.blue,
                    ),
                    _buildReportItem(
                      context,
                      label: 'Veículos',
                      value: '${estatisticas['veiculosNoPatio']}',
                      icon: Icons.directions_car,
                      color: Colors.green,
                    ),
                    _buildReportItem(
                      context,
                      label: 'Total',
                      value: 'R\$ ${estatisticas['arrecadacaoHoje'].toStringAsFixed(2)}',
                      icon: Icons.attach_money,
                      color: Colors.orange,
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

  Widget _buildReportItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: ResponsiveTheme.getResponsiveIconSize(context),
          color: color,
        ),
        SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) / 2),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 14),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 12),
            fontFamily: 'Poppins',
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildVehiclesList(BuildContext context) {
    return Consumer<EstacionamentoService>(
      builder: (context, service, child) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: ResponsiveTheme.getResponsivePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      'Veículos no Pátio',
                      style: TextStyle(
                        fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: HomeTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: service.veiculosNoPatio.length,
                    itemBuilder: (context, index) {
                      final veiculo = service.veiculosNoPatio[index];
                      return Card(
                        margin: EdgeInsets.only(
                          bottom: ResponsiveTheme.getResponsiveSpacing(context),
                        ),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => VeiculoDetalhesModal(veiculo: veiculo),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsets.all(ResponsiveTheme.getResponsiveSpacing(context)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.directions_car,
                                  size: ResponsiveTheme.getResponsiveIconSize(context),
                                  color: HomeTheme.primaryColor,
                                ),
                                SizedBox(width: ResponsiveTheme.getResponsiveSpacing(context)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        veiculo.placa,
                                        style: TextStyle(
                                          fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Entrada: ${veiculo.horaEntrada.hour}:${veiculo.horaEntrada.minute}',
                                        style: TextStyle(
                                          fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 14),
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey.shade400,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Consumer<EstacionamentoService>(
      builder: (context, service, child) {
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
                'CNPJ: ${service.cnpjEstacionamento}',
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
      },
    );
  }
} 