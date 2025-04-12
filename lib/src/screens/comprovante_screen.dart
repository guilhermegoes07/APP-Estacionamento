import 'package:flutter/material.dart';
import '../theme/home_theme.dart';
import '../theme/responsive_theme.dart';
import '../models/pagamento.dart';
import '../models/ticket.dart';
import 'package:intl/intl.dart';

class ComprovanteScreen extends StatelessWidget {
  final Ticket ticket;

  const ComprovanteScreen({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    final formatadorMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final formatadorData = DateFormat('dd/MM/yyyy HH:mm:ss');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'COMPROVANTE',
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
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildCabecalho(),
                            const Divider(),
                            _buildDadosVeiculo(formatadorData),
                            const Divider(),
                            _buildDadosPagamento(formatadorMoeda, formatadorData),
                            if (!ticket.isEntrada) ...[
                              const Divider(),
                              _buildDadosEstabelecimento(),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                    Card(
                      child: Padding(
                        padding: ResponsiveTheme.getResponsivePadding(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Comprovante de Pagamento',
                              style: TextStyle(
                                fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 18),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                            _buildInfoRow('Valor Total:', formatadorMoeda.format(ticket.pagamento.valor)),
                            if (ticket.pagamento.formaPagamento == FormaPagamento.credito)
                              _buildInfoRow('Valor Parcela:', formatadorMoeda.format(ticket.pagamento.valorParcela)),
                            _buildInfoRow('Forma de Pagamento:', ticket.pagamento.formaPagamentoStr),
                            if (ticket.pagamento.formaPagamento == FormaPagamento.credito)
                              _buildInfoRow('Parcelas:', '${ticket.pagamento.parcelas}x'),
                            _buildInfoRow('Data/Hora:', formatadorData.format(ticket.pagamento.dataHora)),
                            _buildInfoRow('Status:', ticket.pagamento.statusPagamento),
                            if (ticket.pagamento.qrCodePix != null) ...[
                              SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                              Text(
                                'QR Code PIX',
                                style: TextStyle(
                                  fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                              Image.network(ticket.pagamento.qrCodePix!),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'FECHAR',
                        style: TextStyle(
                          fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                          fontWeight: FontWeight.bold,
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

  Widget _buildCabecalho() {
    return Column(
      children: [
        Text(
          ticket.nomeEstacionamento,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'CNPJ: ${ticket.cnpjEstacionamento}',
          style: const TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          ticket.isEntrada ? 'COMPROVANTE DE ENTRADA' : 'COMPROVANTE DE SAÍDA',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Código: ${ticket.codigo}',
          style: const TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDadosVeiculo(DateFormat formatadorData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dados do Veículo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoRow('Placa:', ticket.veiculo),
        _buildInfoRow('Data/Hora:', formatadorData.format(ticket.dataHora)),
        _buildInfoRow('Tipo:', ticket.tipo),
        _buildInfoRow('Código:', ticket.codigo),
        _buildInfoRow('Código Transação:', ticket.codigoTransacao),
      ],
    );
  }

  Widget _buildDadosPagamento(NumberFormat formatadorMoeda, DateFormat formatadorData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dados do Pagamento',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text('Valor: ${formatadorMoeda.format(ticket.pagamento.valor)}'),
        Text('Forma: ${ticket.pagamento.formaPagamento.toString().split('.').last}'),
        if (ticket.pagamento.parcelas != null)
          Text('Parcelas: ${ticket.pagamento.parcelas}'),
        Text('Data/Hora: ${formatadorData.format(ticket.pagamento.dataHora)}'),
        if (ticket.pagamento.codigoTransacao != null)
          Text('Código: ${ticket.pagamento.codigoTransacao}'),
      ],
    );
  }

  Widget _buildDadosEstabelecimento() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dados do Estabelecimento',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text('Nome: ${ticket.nomeEstacionamento}'),
        Text('CNPJ: ${ticket.cnpjEstacionamento}'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
} 