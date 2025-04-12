import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/estacionamento_service.dart';
import '../models/veiculo.dart';
import '../theme/home_theme.dart';
import '../theme/form_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _placaController = TextEditingController();
  List<Veiculo> _historico = [];
  bool _carregando = false;

  @override
  void dispose() {
    _placaController.dispose();
    super.dispose();
  }

  Future<void> _buscarHistorico() async {
    if (_placaController.text.isEmpty) return;

    setState(() {
      _carregando = true;
    });

    final service = Provider.of<EstacionamentoService>(context, listen: false);
    final historico = await service.buscarHistorico(_placaController.text);

    setState(() {
      _historico = historico;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: HomeTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Dashboard',
                  style: HomeTheme.titleStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _buildResumoDia(context),
                const SizedBox(height: 32),
                _buildConsultaHistorico(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResumoDia(BuildContext context) {
    return Consumer<EstacionamentoService>(
      builder: (context, service, child) {
        return Container(
          decoration: FormTheme.imageContainerDecoration,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Resumo do Dia',
                style: HomeTheme.titleStyle,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetrica(
                    'Veículos no Pátio',
                    '${service.veiculosNoPatio.length}',
                    Icons.directions_car,
                    HomeTheme.primaryColor,
                  ),
                  _buildMetrica(
                    'Total Arrecadado',
                    'R\$ ${service.totalArrecadado.toStringAsFixed(2)}',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetrica(String titulo, String valor, IconData icone, Color cor) {
    return Column(
      children: [
        Icon(
          icone,
          size: 32,
          color: cor,
        ),
        const SizedBox(height: 8),
        Text(
          titulo,
          style: HomeTheme.subtitleStyle,
        ),
        const SizedBox(height: 8),
        Text(
          valor,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
      ],
    );
  }

  Widget _buildConsultaHistorico() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Consulta de Histórico',
          style: HomeTheme.titleStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _placaController,
          decoration: FormTheme.inputDecoration(
            labelText: 'Placa do Veículo',
            hintText: 'ABC-1234 ou ABC1D23',
            suffixIcon: const Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _carregando ? null : _buscarHistorico,
          style: FormTheme.elevatedButtonStyle,
          child: _carregando
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Buscar Histórico'),
        ),
        const SizedBox(height: 24),
        if (_historico.isNotEmpty)
          Container(
            decoration: FormTheme.imageContainerDecoration,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Histórico de Entradas/Saídas',
                  style: HomeTheme.titleStyle,
                ),
                const SizedBox(height: 16),
                ..._historico.map((veiculo) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Placa: ${veiculo.placa}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Entrada: ${DateFormat('dd/MM/yyyy HH:mm').format(veiculo.horaEntrada)}',
                          style: HomeTheme.subtitleStyle,
                        ),
                        if (veiculo.horaSaida != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Saída: ${DateFormat('dd/MM/yyyy HH:mm').format(veiculo.horaSaida!)}',
                            style: HomeTheme.subtitleStyle,
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
      ],
    );
  }
} 