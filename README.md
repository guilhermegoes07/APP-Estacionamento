# Aplicativo de Gerenciamento de Estacionamento

Este é um aplicativo Flutter para gerenciamento de entrada e saída de veículos em estacionamentos, com controle de pagamentos e emissão de tickets.

## Funcionalidades

- Registro de entrada e saída de veículos
- Captura de fotos da placa e do veículo
- Múltiplas formas de pagamento (dinheiro, PIX, débito, crédito)
- Emissão de tickets
- Dashboard gerencial
- Consulta de histórico por placa

## Requisitos

- Flutter SDK (versão 3.0.0 ou superior)
- Dart SDK (versão 3.0.0 ou superior)
- Android Studio / VS Code
- Dispositivo Android ou emulador

## Instalação

1. Clone o repositório:
```bash
git clone [URL_DO_REPOSITÓRIO]
cd app_estacionamento
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o aplicativo:
```bash
flutter run
```

## Estrutura do Projeto

```
/app-estacionamento
├── /lib
│   ├── /src
│   │   ├── /models          # Classes de dados
│   │   ├── /screens         # Telas do aplicativo
│   │   ├── /services        # Serviços e lógica de negócio
│   │   ├── /widgets         # Componentes reutilizáveis
│   │   └── /utils           # Funções utilitárias
│   └── main.dart            # Ponto de entrada do aplicativo
├── /assets                  # Recursos estáticos
└── pubspec.yaml             # Configurações e dependências
```

## Tecnologias Utilizadas

- Flutter: Framework para desenvolvimento de aplicativos multiplataforma
- Provider: Gerenciamento de estado
- SQLite: Banco de dados local
- Image Picker: Captura de fotos
- QR Flutter: Geração de QR Code para PIX
- Intl: Formatação de datas e valores monetários

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.
