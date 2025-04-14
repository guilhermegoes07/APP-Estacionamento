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
      await _finalizarRegistro();
      return;
    }

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Simulação de Pagamento',
                style: TextStyle(
                  fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Valor Total: R\$ ${_valorTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 24),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              if (_formaPagamento == FormaPagamento.pix)
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: QrImageView(
                      data: 'PIX_SIMULADO_${DateTime.now().millisecondsSinceEpoch}',
                      version: QrVersions.auto,
                      size: 180,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('CANCELAR'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      setState(() {
                        _pagamentoAutorizado = true;
                      });
                      await _finalizarRegistro();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('CONFIRMAR'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _finalizarRegistro() async {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Processando pagamento...',
                  style: TextStyle(
                    fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.of(context).pop();

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
        Navigator.pushNamed(
          context,
          '/comprovante',
          arguments: {
            'pagamento': pagamento,
            'veiculo': veiculo.placa,
            'horasContratadas': horas,
            'ticketId': ticket.codigo,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
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
        height: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: ResponsiveTheme.getResponsivePadding(context),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                          MediaQuery.of(context).padding.top - 
                          MediaQuery.of(context).padding.bottom - 
                          kToolbarHeight,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
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
                              child: Container(
                                height: 48,
                                child: ElevatedButton.icon(
                                  onPressed: () => _tirarFoto(true),
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: ResponsiveTheme.getResponsiveIconSize(context),
                                  ),
                                  label: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Foto da Placa',
                                      style: TextStyle(
                                        fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                                      ),
                                    ),
                                  ),
                                  style: FormTheme.elevatedButtonStyle,
                                ),
                              ),
                            ),
                            SizedBox(width: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                            Expanded(
                              child: Container(
                                height: 48,
                                child: ElevatedButton.icon(
                                  onPressed: () => _tirarFoto(false),
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: ResponsiveTheme.getResponsiveIconSize(context),
                                  ),
                                  label: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Foto do Veículo',
                                      style: TextStyle(
                                        fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                                      ),
                                    ),
                                  ),
                                  style: FormTheme.elevatedButtonStyle,
                                ),
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
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(ResponsiveTheme.getResponsiveSpacing(context) * 2),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Horas',
                                            style: TextStyle(
                                              fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 14),
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove_circle_outline),
                                                onPressed: () {
                                                  final horas = int.tryParse(_horasController.text) ?? 1;
                                                  if (horas > 1) {
                                                    _horasController.text = (horas - 1).toString();
                                                    _calcularTotal();
                                                  }
                                                },
                                              ),
                                              SizedBox(width: ResponsiveTheme.getResponsiveSpacing(context)),
                                              Text(
                                                _horasController.text,
                                                style: TextStyle(
                                                  fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 20),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: ResponsiveTheme.getResponsiveSpacing(context)),
                                              IconButton(
                                                icon: const Icon(Icons.add_circle_outline),
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
                                    Container(
                                      height: 50,
                                      width: 1,
                                      color: Colors.grey[300],
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: Text(
                                              'Valor Total',
                                              style: TextStyle(
                                                fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 14),
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Center(
                                            child: Text(
                                              'R\$ ${_valorTotal.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 20),
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
                      ],
                    ),
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