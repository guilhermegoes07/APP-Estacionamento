import 'package:http/http.dart' as http;
import 'dart:convert';

class QrCodeService {
  static Future<String> gerarQrCodePix({
    required double valor,
    required String chavePix,
    required String nomeBeneficiario,
  }) async {
    // Simula a geração de um QR Code para PIX
    final payload = {
      'valor': valor.toStringAsFixed(2),
      'chavePix': chavePix,
      'nomeBeneficiario': nomeBeneficiario,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    // Simula uma chamada a uma API de geração de QR Code
    await Future.delayed(const Duration(seconds: 1));

    // Retorna uma URL de imagem de QR Code fictícia
    return 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${Uri.encodeComponent(jsonEncode(payload))}';
  }
} 