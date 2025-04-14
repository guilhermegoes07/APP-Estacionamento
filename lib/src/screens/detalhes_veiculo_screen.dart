import 'package:flutter/material.dart';
import '../models/veiculo.dart';
import '../theme/home_theme.dart';
import '../theme/responsive_theme.dart';
import 'dart:io';

class DetalhesVeiculoScreen extends StatelessWidget {
  final Veiculo veiculo;
  final int totalPassagens;

  const DetalhesVeiculoScreen({
    Key? key,
    required this.veiculo,
    required this.totalPassagens,
  }) : super(key: key);

  String _formatarHora(DateTime data) {
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: HomeTheme.backgroundGradient,
        ),
        height: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveTheme.getResponsiveSpacing(context) * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                      color: Colors.black,
                    ),
                    Text(
                      'Detalhes do Veículo',
                      style: HomeTheme.titleStyle.copyWith(
                        fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 24),
                      ),
                    ),
                    const SizedBox(width: 48), // Para manter o alinhamento central
                  ],
                ),
                SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                _buildInfoCard(
                  context,
                  'Informações do Veículo',
                  [
                    _buildInfoRow(
                      context,
                      'Placa:',
                      veiculo.placaFormatada,
                      Icons.directions_car,
                    ),
                    SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                    _buildInfoRow(
                      context,
                      'Total de Passagens:',
                      totalPassagens.toString(),
                      Icons.history,
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                _buildInfoCard(
                  context,
                  'Última Passagem',
                  [
                    _buildInfoRow(
                      context,
                      'Entrada:',
                      '${veiculo.horaEntrada.day}/${veiculo.horaEntrada.month}/${veiculo.horaEntrada.year} ${_formatarHora(veiculo.horaEntrada)}',
                      Icons.access_time,
                    ),
                    if (veiculo.horaSaida != null) ...[
                      SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                      _buildInfoRow(
                        context,
                        'Saída:',
                        '${veiculo.horaSaida!.day}/${veiculo.horaSaida!.month}/${veiculo.horaSaida!.year} ${_formatarHora(veiculo.horaSaida!)}',
                        Icons.exit_to_app,
                      ),
                    ],
                    SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                    _buildInfoRow(
                      context,
                      'Tempo de Permanência:',
                      _calcularTempoPermanencia(veiculo.horaEntrada, veiculo.horaSaida),
                      Icons.timer,
                    ),
                  ],
                ),
                if (veiculo.fotoPlaca != null || veiculo.fotoVeiculo != null) ...[
                  SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                  _buildInfoCard(
                    context,
                    'Fotos',
                    [
                      if (veiculo.fotoPlaca != null)
                        _buildImageContainer(context, 'Foto da Placa', veiculo.fotoPlaca!),
                      if (veiculo.fotoVeiculo != null)
                        _buildImageContainer(context, 'Foto do Veículo', veiculo.fotoVeiculo!),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveTheme.getResponsiveSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 18),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: ResponsiveTheme.getResponsiveIconSize(context),
          color: HomeTheme.primaryColor,
        ),
        SizedBox(width: ResponsiveTheme.getResponsiveSpacing(context)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 14),
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageContainer(BuildContext context, String label, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 14),
            color: Colors.grey,
          ),
        ),
        SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(imagePath),
              height: ResponsiveTheme.getResponsiveImageHeight(context),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  String _calcularTempoPermanencia(DateTime entrada, DateTime? saida) {
    final saidaFinal = saida ?? DateTime.now();
    final diferenca = saidaFinal.difference(entrada);
    
    final horas = diferenca.inHours;
    final minutos = diferenca.inMinutes % 60;
    
    if (horas == 0) {
      return '$minutos minutos';
    }
    
    if (minutos == 0) {
      return '$horas horas';
    }
    
    return '$horas horas e $minutos minutos';
  }
} 