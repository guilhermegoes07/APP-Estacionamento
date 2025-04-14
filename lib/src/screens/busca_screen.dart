import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/estacionamento_service.dart';
import '../models/veiculo.dart';
import '../theme/home_theme.dart';
import '../theme/responsive_theme.dart';
import '../theme/form_theme.dart';
import 'detalhes_veiculo_screen.dart';
import '../widgets/footer_widget.dart';

class BuscaScreen extends StatefulWidget {
  const BuscaScreen({super.key});

  @override
  State<BuscaScreen> createState() => _BuscaScreenState();
}

class _BuscaScreenState extends State<BuscaScreen> {
  final _placaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Veiculo> _veiculos = [];
  bool _isLoading = false;
  bool _showAllVehicles = false;

  @override
  void initState() {
    super.initState();
    _loadAllVehicles();
  }

  @override
  void dispose() {
    _placaController.dispose();
    super.dispose();
  }

  String _formatarHora(DateTime data) {
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  Future<void> _loadAllVehicles() async {
    setState(() => _isLoading = true);
    try {
      final service = Provider.of<EstacionamentoService>(context, listen: false);
      final veiculos = await service.buscarHistoricoCompleto();
      setState(() {
        _veiculos = veiculos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar veículos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _buscarVeiculo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final service = Provider.of<EstacionamentoService>(context, listen: false);
      final historico = await service.buscarHistorico(_placaController.text);
      setState(() {
        _veiculos = historico;
        _isLoading = false;
        _showAllVehicles = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao buscar veículo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: HomeTheme.backgroundGradient,
        ),
        height: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
          child: SingleChildScrollView(
                  padding: EdgeInsets.all(ResponsiveTheme.getResponsiveSpacing(context) * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                            color: Colors.black,
                          ),
                          Text(
                            'Buscar Veículo',
                            style: HomeTheme.titleStyle.copyWith(
                              fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 24),
                            ),
                          ),
                          const SizedBox(width: 48), // Para manter o alinhamento central
                        ],
                      ),
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(ResponsiveTheme.getResponsiveSpacing(context) * 2),
                          child: Form(
                            key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _placaController,
                        decoration: FormTheme.inputDecoration(
                          labelText: 'Placa do Veículo',
                          hintText: 'ABC-1234 ou ABC1D23',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe a placa do veículo';
                          }
                          final regex = RegExp(
                            r'^[A-Z]{3}-?\d{4}$|^[A-Z]{3}\d[A-Z]\d{2}$',
                          );
                          if (!regex.hasMatch(value)) {
                            return 'Placa inválida';
                          }
                          return null;
                        },
                      ),
                                SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _isLoading ? null : _buscarVeiculo,
                                        style: FormTheme.elevatedButtonStyle,
                                        child: _isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              )
                                            : const Text('Buscar'),
                                      ),
                                    ),
                                    SizedBox(width: ResponsiveTheme.getResponsiveSpacing(context)),
                      ElevatedButton(
                                      onPressed: _isLoading ? null : () {
                                        setState(() => _showAllVehicles = !_showAllVehicles);
                                        if (_showAllVehicles) {
                                          _loadAllVehicles();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _showAllVehicles ? Colors.grey : Colors.blue,
                                      ),
                                      child: Text(_showAllVehicles ? 'Ocultar Todos' : 'Mostrar Todos'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (_veiculos.isEmpty)
                        Center(
                          child: Text(
                            'Nenhum veículo encontrado',
                            style: TextStyle(
                              fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                              color: Colors.grey,
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _veiculos.length,
                          itemBuilder: (context, index) {
                            final veiculo = _veiculos[index];
                            return Card(
                              margin: EdgeInsets.only(
                                bottom: ResponsiveTheme.getResponsiveSpacing(context),
                              ),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  final service = Provider.of<EstacionamentoService>(context, listen: false);
                                  if (mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetalhesVeiculoScreen(
                                          veiculo: veiculo,
                                          totalPassagens: veiculo.totalPassagens,
                                        ),
                                      ),
                                    );
                                  }
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
                                              veiculo.placaFormatada,
                                              style: TextStyle(
                                                fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              'Entrada: ${veiculo.horaEntrada.day}/${veiculo.horaEntrada.month}/${veiculo.horaEntrada.year} ${_formatarHora(veiculo.horaEntrada)}',
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
                    ],
                  ),
                ),
              ),
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
} 