import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/estacionamento_service.dart';
import '../models/veiculo.dart';
import '../models/pagamento.dart';
import '../models/ticket.dart';
import '../theme/home_theme.dart';
import '../theme/form_theme.dart';
import '../theme/responsive_theme.dart';
import 'dart:io';

class EntradaScreen extends StatefulWidget {
  const EntradaScreen({super.key});

  @override
  State<EntradaScreen> createState() => _EntradaScreenState();
}

class _EntradaScreenState extends State<EntradaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  File? _fotoPlaca;
  File? _fotoVeiculo;
  FormaPagamento _formaPagamento = FormaPagamento.dinheiro;
  int _parcelas = 1;
  bool _pagamentoAutorizado = false;

  @override
  void dispose() {
    _placaController.dispose();
    super.dispose();
  }

  Future<void> _tirarFoto(bool isPlaca) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        if (isPlaca) {
          _fotoPlaca = File(image.path);
        } else {
          _fotoVeiculo = File(image.path);
        }
      });
    }
  }

  Future<void> _processarPagamento() async {
    if (_formaPagamento == FormaPagamento.dinheiro) {
      setState(() {
        _pagamentoAutorizado = true;
      });
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Simulação de Pagamento',
          style: TextStyle(
            fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 18),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_formaPagamento == FormaPagamento.pix)
              Container(
                decoration: FormTheme.imageContainerDecoration,
                padding: ResponsiveTheme.getResponsivePadding(context),
                child: QrImageView(
                  data: 'PIX_SIMULADO_${DateTime.now().millisecondsSinceEpoch}',
                  version: QrVersions.auto,
                  size: ResponsiveTheme.getResponsiveImageHeight(context) * 1.5,
                ),
              ),
            SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _pagamentoAutorizado = true;
                    });
                    Navigator.pop(context);
                  },
                  style: FormTheme.elevatedButtonStyle,
                  child: Text(
                    'AUTORIZAR',
                    style: TextStyle(
                      fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: FormTheme.elevatedButtonStyle.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: Text(
                    'NEGAR',
                    style: TextStyle(
                      fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registrarEntrada() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_pagamentoAutorizado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Realize o pagamento primeiro'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final veiculo = Veiculo(
      placa: _placaController.text,
      horaEntrada: DateTime.now(),
    );

    final pagamento = Pagamento(
      valor: 10.0,
      formaPagamento: _formaPagamento,
      parcelas: _formaPagamento == FormaPagamento.credito ? _parcelas : null,
      dataHora: DateTime.now(),
    );

    final ticket = Ticket(
      veiculo: veiculo,
      pagamento: pagamento,
      codigo: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    final service = Provider.of<EstacionamentoService>(context, listen: false);
    final sucesso = await service.registrarEntrada(veiculo);
    await service.registrarPagamento(pagamento);

    if (sucesso) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Ticket Gerado',
            style: TextStyle(
              fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 18),
            ),
          ),
          content: Container(
            decoration: FormTheme.imageContainerDecoration,
            padding: ResponsiveTheme.getResponsivePadding(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Placa: ${ticket.veiculo.placa}',
                  style: TextStyle(
                    fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                  ),
                ),
                SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                Text(
                  'Entrada: ${ticket.veiculo.horaEntrada}',
                  style: TextStyle(
                    fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                  ),
                ),
                SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                Text(
                  'Forma de Pagamento: ${ticket.pagamento.formaPagamento}',
                  style: TextStyle(
                    fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                  ),
                ),
                SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                Text(
                  'Código: ${ticket.codigo}',
                  style: TextStyle(
                    fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: FormTheme.textButtonStyle,
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veículo já está no pátio'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Registrar Entrada',
          style: TextStyle(
            fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 20),
          ),
        ),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Registrar Entrada',
                        style: HomeTheme.titleStyle.copyWith(
                          fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 24),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 4),
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
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 3),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _tirarFoto(true),
                              icon: Icon(
                                Icons.camera_alt,
                                size: ResponsiveTheme.getResponsiveIconSize(context),
                              ),
                              label: Text(
                                'Foto da Placa',
                                style: TextStyle(
                                  fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                                ),
                              ),
                              style: FormTheme.elevatedButtonStyle,
                            ),
                          ),
                          SizedBox(width: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _tirarFoto(false),
                              icon: Icon(
                                Icons.camera_alt,
                                size: ResponsiveTheme.getResponsiveIconSize(context),
                              ),
                              label: Text(
                                'Foto do Veículo',
                                style: TextStyle(
                                  fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                                ),
                              ),
                              style: FormTheme.elevatedButtonStyle,
                            ),
                          ),
                        ],
                      ),
                      if (_fotoPlaca != null || _fotoVeiculo != null)
                        SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 3),
                      if (_fotoPlaca != null)
                        Container(
                          decoration: FormTheme.imageContainerDecoration,
                          child: Image.file(
                            _fotoPlaca!,
                            height: ResponsiveTheme.getResponsiveImageHeight(context),
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (_fotoVeiculo != null)
                        Container(
                          decoration: FormTheme.imageContainerDecoration,
                          child: Image.file(
                            _fotoVeiculo!,
                            height: ResponsiveTheme.getResponsiveImageHeight(context),
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 3),
                      DropdownButtonFormField<FormaPagamento>(
                        value: _formaPagamento,
                        decoration: FormTheme.inputDecoration(
                          labelText: 'Forma de Pagamento',
                        ),
                        items: FormaPagamento.values.map((forma) {
                          return DropdownMenuItem(
                            value: forma,
                            child: Text(
                              forma.toString().split('.').last,
                              style: TextStyle(
                                fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _formaPagamento = value!;
                            _pagamentoAutorizado = false;
                          });
                        },
                      ),
                      if (_formaPagamento == FormaPagamento.credito) ...[
                        SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 3),
                        DropdownButtonFormField<int>(
                          value: _parcelas,
                          decoration: FormTheme.inputDecoration(
                            labelText: 'Parcelas',
                          ),
                          items: List.generate(12, (index) {
                            return DropdownMenuItem(
                              value: index + 1,
                              child: Text(
                                '${index + 1}x',
                                style: TextStyle(
                                  fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                                ),
                              ),
                            );
                          }),
                          onChanged: (value) {
                            setState(() {
                              _parcelas = value!;
                            });
                          },
                        ),
                      ],
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 4),
                      ElevatedButton(
                        onPressed: _processarPagamento,
                        style: FormTheme.elevatedButtonStyle,
                        child: Text(
                          'Processar Pagamento',
                          style: TextStyle(
                            fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                      ElevatedButton(
                        onPressed: _registrarEntrada,
                        style: FormTheme.elevatedButtonStyle,
                        child: Text(
                          'Registrar Entrada',
                          style: TextStyle(
                            fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 