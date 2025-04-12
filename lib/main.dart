import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'src/screens/home_screen.dart';
import 'src/services/estacionamento_service.dart';
import 'src/providers/vehicle_provider.dart';
import 'src/theme/app_theme.dart';

// Constantes para restrições de tamanho
final bool enforceConstraints = const String.fromEnvironment('ENFORCE_CONSTRAINTS', defaultValue: 'false') == 'true';
final double widthConstraint = 411.0;  // Largura padrão para celular
final double heightConstraint = 731.0; // Altura padrão para celular

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configura a orientação para retrato
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Inicializa o serviço de estacionamento
  final estacionamentoService = EstacionamentoService();
  await estacionamentoService.initDatabase();

  runApp(
    ChangeNotifierProvider.value(
      value: estacionamentoService,
      child: ChangeNotifierProvider(
        create: (context) => VehicleProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estacionamento App',
      theme: AppTheme.theme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Se as restrições estiverem ativadas, aplica uma caixa de tamanho fixo
        if (enforceConstraints) {
          return Center(
            child: AspectRatio(
              aspectRatio: widthConstraint / heightConstraint,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    size: Size(widthConstraint, heightConstraint),
                    devicePixelRatio: 2.75,
                    textScaleFactor: 1.0,
                    padding: EdgeInsets.zero,
                  ),
                  child: child!,
                ),
              ),
            ),
          );
        }
        
        // Caso contrário, apenas retorna o child com algumas configurações básicas
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: child!,
        );
      },
    );
  }
}
