import 'package:flutter/material.dart';
import '../theme/home_theme.dart';
import '../theme/responsive_theme.dart';
import '../models/veiculo.dart';
import 'dart:io';

class VeiculoDetalhesModal extends StatelessWidget {
  final Veiculo veiculo;

  const VeiculoDetalhesModal({
    Key? key,
    required this.veiculo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveTheme.getResponsiveSpacing(context) * 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detalhes do Veículo',
                    style: TextStyle(
                      fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
              _buildInfoRow(
                context,
                'Placa:',
                veiculo.placa,
                Icons.directions_car,
              ),
              SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
              _buildInfoRow(
                context,
                'Entrada:',
                '${veiculo.horaEntrada.day}/${veiculo.horaEntrada.month}/${veiculo.horaEntrada.year} ${veiculo.horaEntrada.hour}:${veiculo.horaEntrada.minute}',
                Icons.access_time,
              ),
              SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
              _buildInfoRow(
                context,
                'Tempo de Permanência:',
                _calcularTempoPermanencia(veiculo.horaEntrada),
                Icons.timer,
              ),
              if (veiculo.fotoPlaca != null || veiculo.fotoVeiculo != null) ...[
                SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
                Text(
                  'Fotos:',
                  style: TextStyle(
                    fontSize: ResponsiveTheme.getResponsiveFontSize(context, baseSize: 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context)),
                if (veiculo.fotoPlaca != null)
                  _buildImageContainer(context, 'Foto da Placa', veiculo.fotoPlaca!),
                if (veiculo.fotoVeiculo != null)
                  _buildImageContainer(context, 'Foto do Veículo', veiculo.fotoVeiculo!),
              ],
            ],
          ),
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
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(imagePath),
              height: ResponsiveTheme.getResponsiveImageHeight(context),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: ResponsiveTheme.getResponsiveSpacing(context) * 2),
      ],
    );
  }

  String _calcularTempoPermanencia(DateTime horaEntrada) {
    final agora = DateTime.now();
    final diferenca = agora.difference(horaEntrada);
    
    final horas = diferenca.inHours;
    final minutos = diferenca.inMinutes % 60;
    
    if (horas > 0) {
      return '$horas hora${horas > 1 ? 's' : ''} e $minutos minuto${minutos > 1 ? 's' : ''}';
    } else {
      return '$minutos minuto${minutos > 1 ? 's' : ''}';
    }
  }
} 