import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/estacionamento_service.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({Key? key}) : super(key: key);

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cnpjController;
  late TextEditingController _valorHoraController;

  @override
  void initState() {
    super.initState();
    final estacionamentoService = Provider.of<EstacionamentoService>(context, listen: false);
    _cnpjController = TextEditingController(text: estacionamentoService.cnpjEstacionamento);
    _valorHoraController = TextEditingController(
      text: estacionamentoService.valorHora.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _cnpjController.dispose();
    _valorHoraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estacionamentoService = Provider.of<EstacionamentoService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _cnpjController,
                decoration: const InputDecoration(
                  labelText: 'CNPJ',
                  hintText: '00.000.000/0000-00',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CNPJ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valorHoraController,
                decoration: const InputDecoration(
                  labelText: 'Valor da Hora (R\$)',
                  hintText: '0,00',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor da hora';
                  }
                  final valor = double.tryParse(value.replaceAll(',', '.'));
                  if (valor == null || valor <= 0) {
                    return 'Por favor, insira um valor válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final novoValorHora = double.parse(
                      _valorHoraController.text.replaceAll(',', '.'),
                    );
                    await estacionamentoService.atualizarValorHora(novoValorHora);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Configurações salvas com sucesso!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Salvar Configurações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 