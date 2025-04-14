import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ComprovantePagamento extends StatelessWidget {
  final String nomeEstabelecimento;
  final String cnpj;
  final String endereco;
  final String cidadeEstadoCep;
  final String formaPagamento;
  final String data;
  final String hora;
  final String operadora;
  final String bandeira;
  final String autorizacao;
  final String nsu;
  final List<Map<String, dynamic>> produtos;
  final String qrCodeData;
  final String ticketId;

  const ComprovantePagamento({
    Key? key,
    required this.nomeEstabelecimento,
    required this.cnpj,
    required this.endereco,
    required this.cidadeEstadoCep,
    required this.formaPagamento,
    required this.data,
    required this.hora,
    required this.operadora,
    required this.bandeira,
    required this.autorizacao,
    required this.nsu,
    required this.produtos,
    required this.qrCodeData,
    required this.ticketId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = screenWidth * 0.04; // 4% da largura da tela
    final qrCodeSize = screenWidth * 0.3; // 30% da largura da tela

    return Container(
      width: screenWidth * 0.9, // 90% da largura da tela
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho
          Center(
            child: Text(
              nomeEstabelecimento.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: baseFontSize * 1.4, // 40% maior que o tamanho base
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'CNPJ: $cnpj',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: baseFontSize,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              endereco,
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: baseFontSize,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              cidadeEstadoCep,
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: baseFontSize,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '--------------------------------',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: baseFontSize,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // QR Code e ID do Ticket
          Center(
            child: Column(
              children: [
                QrImageView(
                  data: qrCodeData,
                  version: QrVersions.auto,
                  size: qrCodeSize,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  'ID: $ticketId',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: baseFontSize,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '--------------------------------',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: baseFontSize,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Forma de Pagamento
          Text(
            'FORMA DE PAGAMENTO: ${formaPagamento.toUpperCase()}',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: baseFontSize,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          // Informações de Pagamento
          Text(
            'DATA: $data',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: baseFontSize,
              height: 1.2,
            ),
          ),
          Text(
            'HORA: $hora',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: baseFontSize,
              height: 1.2,
            ),
          ),
          Text(
            'OPERADORA: $operadora',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: baseFontSize,
              height: 1.2,
            ),
          ),
          Text(
            'BANDEIRA: $bandeira',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: baseFontSize,
              height: 1.2,
            ),
          ),
          Text(
            'AUTORIZAÇÃO: $autorizacao',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: baseFontSize,
              height: 1.2,
            ),
          ),
          Text(
            'NSU: $nsu',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: baseFontSize,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '--------------------------------',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: baseFontSize,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Tabela de Produtos
          Text(
            'DESCRIÇÃO        QTD  UN  VALOR (R\$)',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: baseFontSize,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          Center(
            child: Text(
              '--------------------------------',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: baseFontSize,
                height: 1.2,
              ),
            ),
          ),
          ...produtos.map((produto) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        produto['descricao'] as String,
                        style: TextStyle(
                          fontFamily: 'Courier',
                          fontSize: baseFontSize,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${produto['quantidade']}',
                        style: TextStyle(
                          fontFamily: 'Courier',
                          fontSize: baseFontSize,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'UN',
                        style: TextStyle(
                          fontFamily: 'Courier',
                          fontSize: baseFontSize,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'R\$ ${(produto['valor'] as double).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'Courier',
                          fontSize: baseFontSize,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '--------------------------------',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: baseFontSize,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Center(
            child: Text(
              'COMPROVANTE DE PAGAMENTO',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: baseFontSize,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'HOMOLOGADO',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: baseFontSize,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 