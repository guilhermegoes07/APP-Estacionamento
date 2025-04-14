import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import '../widgets/comprovante_pagamento.dart';
import '../services/estacionamento_service.dart';
import '../models/pagamento.dart';
import '../models/veiculo.dart';

class ComprovanteScreen extends StatelessWidget {
  final Pagamento pagamento;
  final String veiculo;
  final int horasContratadas;
  final String ticketId;

  const ComprovanteScreen({
    super.key,
    required this.pagamento,
    required this.veiculo,
    required this.horasContratadas,
    required this.ticketId,
  });

  Future<Uint8List> _generateQrCodeImage(String data) async {
    final qrPainter = QrPainter(
      data: data,
      version: QrVersions.auto,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.black,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Colors.black,
      ),
    );

    final image = await qrPainter.toImage(200);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _gerarPDF(BuildContext context) async {
    try {
      final pdf = pw.Document();
      final estacionamentoService = Provider.of<EstacionamentoService>(context, listen: false);
      final dateFormat = DateFormat('dd/MM/yyyy');
      final timeFormat = DateFormat('HH:mm');

      // Gerar QR Code como imagem
      final qrCodeImage = await _generateQrCodeImage(pagamento.codigoTransacao);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    estacionamentoService.nomeEstacionamento.toUpperCase(),
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Text('CNPJ: ${estacionamentoService.cnpjEstacionamento}'),
                ),
                pw.SizedBox(height: 4),
                pw.Center(
                  child: pw.Text(estacionamentoService.endereco),
                ),
                pw.SizedBox(height: 4),
                pw.Center(
                  child: pw.Text(estacionamentoService.cidadeEstadoCep),
                ),
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Text('--------------------------------'),
                ),
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Container(
                        width: 200,
                        height: 200,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Image(
                          pw.MemoryImage(qrCodeImage),
                          fit: pw.BoxFit.contain,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'ID: $ticketId',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Text('--------------------------------'),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'FORMA DE PAGAMENTO: ${pagamento.formaPagamentoStr.toUpperCase()}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text('DATA: ${dateFormat.format(pagamento.dataHora)}'),
                pw.Text('HORA: ${timeFormat.format(pagamento.dataHora)}'),
                pw.Text('PLACA: $veiculo'),
                pw.Text('OPERADORA: MERCADO PAGO'),
                pw.Text('BANDEIRA: VISA'),
                pw.Text('AUTORIZAÇÃO: ${pagamento.codigoTransacao.substring(0, 6)}'),
                pw.Text('NSU: ${pagamento.codigoTransacao.substring(6, 12)}'),
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Text('--------------------------------'),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'DESCRIÇÃO        QTD  UN  VALOR (R\$)',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Center(
                  child: pw.Text('--------------------------------'),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text('VAGA ESTACIONAMENTO'),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        '$horasContratadas',
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        'UN',
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        'R\$ ${pagamento.valor.toStringAsFixed(2)}',
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Salvar o PDF usando o método de compartilhamento
      final bytes = await pdf.save();
      await Printing.sharePdf(
        bytes: bytes,
        filename: '$ticketId.pdf',
      );

      // Mostrar mensagem de sucesso
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF gerado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
            onPressed: () async {
              try {
                await _gerarPDF(context);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao gerar PDF: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
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
            placa: veiculo,
            operadora: 'MERCADO PAGO',
            bandeira: 'VISA',
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
            ticketId: ticketId,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/home',
                (route) => false,
              );
            },
            child: const Text('Fechar'),
          ),
        ),
      ),
    );
  }
} 