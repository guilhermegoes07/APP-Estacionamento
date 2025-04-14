import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import '../services/estacionamento_service.dart';
import '../models/veiculo.dart';
import '../models/ticket.dart';
import '../theme/home_theme.dart';
import '../theme/form_theme.dart';
import '../theme/responsive_theme.dart';

class SaidaScreen extends StatefulWidget {
  const SaidaScreen({super.key});

  @override
  State<SaidaScreen> createState() => _SaidaScreenState();
}

class _SaidaScreenState extends State<SaidaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _codigoController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _placaController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  Future<void> _uploadPDF() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null) return;

      setState(() => _isLoading = true);

      final file = result.files.first;
      final service = Provider.of<EstacionamentoService>(context, listen: false);

      // Extrair nome do arquivo (que contém o ID do ticket)
      final fileName = file.name;
      final idMatch = RegExp(r'([A-Za-z0-9-]+)\.pdf$').firstMatch(fileName);

      if (idMatch != null) {
        final ticket = await service.buscarTicket(idMatch.group(1)!);

        if (ticket != null) {
          setState(() {
            _placaController.text = ticket.veiculo;
            _codigoController.text = ticket.codigo;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ticket não encontrado'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nome do arquivo inválido'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao processar arquivo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _registrarSaida() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final service = Provider.of<EstacionamentoService>(context, listen: false);
      final veiculo = await service.buscarVeiculo(_placaController.text);

      if (veiculo == null) {
        throw Exception('Veículo não encontrado no pátio');
      }

      await service.registrarSaida(veiculo.placa);

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Saída Registrada',
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
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: ResponsiveTheme.getResponsiveIconSize(context) * 2,
                  ),
                  SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                  Text(
                    'Veículo liberado com sucesso!',
                    style: TextStyle(
                      fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                    ),
                    textAlign: TextAlign.center,
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
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao registrar saída: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Fechar',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
          'Registrar Saída',
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
                        'Registrar Saída',
                        style: HomeTheme.titleStyle.copyWith(
                          fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 24),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 4),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _uploadPDF,
                        style: FormTheme.elevatedButtonStyle,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.upload_file),
                        label: Text(
                          _isLoading ? 'Processando...' : 'Upload do Ticket (PDF)',
                          style: TextStyle(
                            fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 3),
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
                      TextFormField(
                        controller: _codigoController,
                        decoration: FormTheme.inputDecoration(
                          labelText: 'Código do Ticket',
                          hintText: 'Digite o código do ticket',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o código do ticket';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 4),
                      ElevatedButton(
                        onPressed: _registrarSaida,
                        style: FormTheme.elevatedButtonStyle,
                        child: Text(
                          'Registrar Saída',
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