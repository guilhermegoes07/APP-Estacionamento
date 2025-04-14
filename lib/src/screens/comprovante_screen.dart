import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/comprovante_pagamento.dart';
import '../services/estacionamento_service.dart';
import '../models/pagamento.dart';
import '../models/veiculo.dart';

class ComprovanteScreen extends StatelessWidget {
  final Pagamento pagamento;
  final Veiculo veiculo;
  final int horasContratadas;

  const ComprovanteScreen({
    Key? key,
    required this.pagamento,
    required this.veiculo,
    required this.horasContratadas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final estacionamentoService = Provider.of<EstacionamentoService>(context);
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Comprovante de Pagamento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // TODO: Implementar impressão do comprovante
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ComprovantePagamento(
            nomeEstabelecimento: estacionamentoService.nomeEstacionamento,
            cnpj: estacionamentoService.cnpjEstacionamento,
            endereco: estacionamentoService.endereco,
            cidadeEstadoCep: estacionamentoService.cidadeEstadoCep,
            formaPagamento: pagamento.formaPagamentoStr,
            data: dateFormat.format(pagamento.dataHora),
            hora: timeFormat.format(pagamento.dataHora),
            operadora: 'MERCADO PAGO', // TODO: Adicionar ao modelo de pagamento
            bandeira: 'VISA', // TODO: Adicionar ao modelo de pagamento
            autorizacao: pagamento.codigoTransacao.substring(0, 6),
            nsu: pagamento.codigoTransacao.substring(6, 12),
            produtos: [
              {
                'descricao': 'VAGA ESTACIONAMENTO',
                'quantidade': horasContratadas,
                'valor': pagamento.valor,
              },
            ],
            qrCodeData: pagamento.codigoTransacao,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Fechar'),
          ),
        ),
      ),
    );
  }
} 