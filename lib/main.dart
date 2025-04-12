import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'src/screens/home_screen.dart';
import 'src/services/estacionamento_service.dart';
import 'src/providers/vehicle_provider.dart';
import 'src/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configura a orientação para retrato
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Inicializa o serviço de estacionamento
  final estacionamentoService = EstacionamentoService(
    cnpjEstacionamento: '12.345.678/0001-90',
    nomeEstacionamento: 'Estacionamento Exemplo',
  );
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
