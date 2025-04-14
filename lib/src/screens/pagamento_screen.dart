import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/estacionamento_service.dart';
import '../models/veiculo.dart';
import '../models/pagamento.dart';
import 'comprovante_screen.dart';
import '../theme/home_theme.dart';
import '../theme/responsive_theme.dart';

class PagamentoScreen extends StatefulWidget {
  final Veiculo veiculo;

  const PagamentoScreen({
    Key? key,
    required this.veiculo,
  }) : super(key: key);

  @override
  State<PagamentoScreen> createState() => _PagamentoScreenState();
}

class _PagamentoScreenState extends State<PagamentoScreen> {
  int _horasSelecionadas = 1;
  FormaPagamento _formaPagamento = FormaPagamento.dinheiro;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final estacionamentoService = Provider.of<EstacionamentoService>(context);
    final valorTotal = estacionamentoService.calcularValorTotal(_horasSelecionadas);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento'),
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
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Veículo: ${widget.veiculo.placa}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Valor da Hora: R\$ ${estacionamentoService.valorHora.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selecione o número de horas:',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (_horasSelecionadas > 1) {
                                      setState(() {
                                        _horasSelecionadas--;
                                      });
                                    }
                                  },
                                ),
                                Text(
                                  '$_horasSelecionadas',
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      _horasSelecionadas++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Forma de Pagamento:',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<FormaPagamento>(
                              value: _formaPagamento,
                              items: FormaPagamento.values.map((forma) {
                                return DropdownMenuItem(
                                  value: forma,
                                  child: Text(forma.toString().split('.').last),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _formaPagamento = value;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Resumo do Pagamento',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Valor Total:',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  'R\$ ${valorTotal.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final pagamento = Pagamento(
                            valor: valorTotal,
                            formaPagamento: _formaPagamento,
                            parcelas: 1,
                            dataHora: DateTime.now(),
                            autorizado: true,
                            data: DateTime.now(),
                          );

                          await estacionamentoService.registrarPagamento(pagamento);
                          widget.veiculo.tempoPago = _horasSelecionadas;
                          await widget.veiculo.save();

                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ComprovanteScreen(
                                  pagamento: pagamento,
                                  veiculo: widget.veiculo,
                                  horasContratadas: _horasSelecionadas,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Confirmar Pagamento'),
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
} 