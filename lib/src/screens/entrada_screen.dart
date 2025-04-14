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
import 'package:uuid/uuid.dart';
import 'comprovante_screen.dart';

class EntradaScreen extends StatefulWidget {
  const EntradaScreen({super.key});

  @override
  State<EntradaScreen> createState() => _EntradaScreenState();
}

class _EntradaScreenState extends State<EntradaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _horasController = TextEditingController(text: '1');
  File? _fotoPlaca;
  File? _fotoVeiculo;
  FormaPagamento _formaPagamento = FormaPagamento.dinheiro;
  int _parcelas = 1;
  bool _pagamentoAutorizado = false;
  double _valorTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _calcularTotal();
  }

  @override
  void dispose() {
    _placaController.dispose();
    _horasController.dispose();
    super.dispose();
  }

  void _calcularTotal() {
    final service = Provider.of<EstacionamentoService>(context, listen: false);
    final horas = int.tryParse(_horasController.text) ?? 1;
    setState(() {
      _valorTotal = service.calcularValorTotal(horas);
    });
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
      _registrarEntrada();
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
                    _registrarEntrada();
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

    try {
      final service = Provider.of<EstacionamentoService>(context, listen: false);
      final horas = int.parse(_horasController.text);
      
      final pagamento = Pagamento(
        valor: _valorTotal,
        formaPagamento: _formaPagamento,
        parcelas: _parcelas,
        dataHora: DateTime.now(),
        autorizado: true,
        data: DateTime.now(),
      );

      final veiculo = Veiculo(
        placa: _placaController.text,
        horaEntrada: DateTime.now(),
        fotoPlaca: _fotoPlaca?.path,
        fotoVeiculo: _fotoVeiculo?.path,
        isNoPatio: true,
        tempoPago: horas,
      );

      final ticket = await service.registrarEntradaComTicket(
        placa: veiculo.placa,
        pagamento: pagamento,
        fotoPlaca: veiculo.fotoPlaca,
        fotoVeiculo: veiculo.fotoVeiculo,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComprovanteScreen(
              pagamento: pagamento,
              veiculo: veiculo,
              horasContratadas: horas,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<EstacionamentoService>(context);
    
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
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(ResponsiveTheme.getResponsiveSpacing(context)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Horas',
                                      style: TextStyle(
                                        fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            final horas = int.tryParse(_horasController.text) ?? 1;
                                            if (horas > 1) {
                                              _horasController.text = (horas - 1).toString();
                                              _calcularTotal();
                                            }
                                          },
                                        ),
                                        Text(
                                          _horasController.text,
                                          style: TextStyle(
                                            fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 24),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            final horas = int.tryParse(_horasController.text) ?? 1;
                                            _horasController.text = (horas + 1).toString();
                                            _calcularTotal();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(ResponsiveTheme.getResponsiveSpacing(context)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Valor Total',
                                style: TextStyle(
                                  fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'R\$ ${_valorTotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 24),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
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