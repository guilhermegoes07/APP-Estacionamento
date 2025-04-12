import 'package:flutter/material.dart';
import '../theme/home_theme.dart';
import '../theme/responsive_theme.dart';
import '../theme/form_theme.dart';
import '../models/pagamento.dart';
import '../services/qr_code_service.dart';
import 'comprovante_screen.dart';

class PagamentoScreen extends StatefulWidget {
  final double valor;
  final Function(Pagamento) onPagamentoConfirmado;

  const PagamentoScreen({
    super.key,
    required this.valor,
    required this.onPagamentoConfirmado,
  });

  @override
  State<PagamentoScreen> createState() => _PagamentoScreenState();
}

class _PagamentoScreenState extends State<PagamentoScreen> {
  FormaPagamento _formaPagamento = FormaPagamento.dinheiro;
  int _parcelas = 1;
  bool _isLoading = false;
  bool _pagamentoAutorizado = false;

  Future<void> _simularPagamento() async {
    setState(() => _isLoading = true);

    // Simula o processamento do pagamento
    await Future.delayed(const Duration(seconds: 2));

    final pagamento = Pagamento(
      valor: widget.valor,
      formaPagamento: _formaPagamento,
      parcelas: _parcelas,
      dataHora: DateTime.now(),
      autorizado: _pagamentoAutorizado,
    );

    widget.onPagamentoConfirmado(pagamento);
  }

  Future<void> _mostrarDialogAutorizacao() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Autorização de Pagamento'),
        content: const Text('Deseja autorizar o pagamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Negar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Autorizar'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() => _pagamentoAutorizado = result);
      if (result) {
        await _simularPagamento();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pagamento',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: ResponsiveTheme.getResponsivePadding(context),
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
                            Text(
                              'R\$ ${widget.valor.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 24),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                    Card(
                      child: Padding(
                        padding: ResponsiveTheme.getResponsivePadding(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Forma de Pagamento',
                              style: TextStyle(
                                fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                            RadioListTile<FormaPagamento>(
                              title: const Text('Dinheiro'),
                              value: FormaPagamento.dinheiro,
                              groupValue: _formaPagamento,
                              onChanged: (value) {
                                setState(() => _formaPagamento = value!);
                              },
                            ),
                            RadioListTile<FormaPagamento>(
                              title: const Text('PIX'),
                              value: FormaPagamento.pix,
                              groupValue: _formaPagamento,
                              onChanged: (value) {
                                setState(() => _formaPagamento = value!);
                              },
                            ),
                            RadioListTile<FormaPagamento>(
                              title: const Text('Cartão de Débito'),
                              value: FormaPagamento.debito,
                              groupValue: _formaPagamento,
                              onChanged: (value) {
                                setState(() => _formaPagamento = value!);
                              },
                            ),
                            RadioListTile<FormaPagamento>(
                              title: const Text('Cartão de Crédito'),
                              value: FormaPagamento.credito,
                              groupValue: _formaPagamento,
                              onChanged: (value) {
                                setState(() => _formaPagamento = value!);
                              },
                            ),
                            if (_formaPagamento == FormaPagamento.credito) ...[
                              SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                              Text(
                                'Parcelas',
                                style: TextStyle(
                                  fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DropdownButtonFormField<int>(
                                value: _parcelas,
                                items: [1, 2].map((value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text('$value'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() => _parcelas = value!);
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 4),
                    if (_formaPagamento == FormaPagamento.pix) ...[
                      Card(
                        child: Padding(
                          padding: ResponsiveTheme.getResponsivePadding(context),
                          child: Column(
                            children: [
                              Text(
                                'QR Code PIX',
                                style: TextStyle(
                                  fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                              FutureBuilder<String>(
                                future: QrCodeService.gerarQrCodePix(
                                  valor: widget.valor,
                                  chavePix: '123.456.789-00',
                                  nomeBeneficiario: 'Estacionamento',
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Erro: ${snapshot.error}');
                                  }
                                  return Image.network(snapshot.data!);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                    ],
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_formaPagamento == FormaPagamento.dinheiro) {
                                _simularPagamento();
                              } else {
                                _mostrarDialogAutorizacao();
                              }
                            },
                      style: FormTheme.elevatedButtonStyle,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              _formaPagamento == FormaPagamento.dinheiro
                                  ? 'Confirmar Pagamento'
                                  : 'Simular Pagamento',
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
    );
  }
} 