# 🚗 App de Gerenciamento de Estacionamento

## 📚 Índice

### Guia para o Usuário
- [Apresentação do Projeto](#apresentação-do-projeto)
- [Funcionalidades Principais](#funcionalidades-principais)
- [Como Utilizar o Aplicativo](#como-utilizar-o-aplicativo)
- [Requisitos Mínimos](#requisitos-mínimos)
- [Fluxo Básico](#fluxo-básico)
- [FAQ](#faq)

### Guia para Desenvolvedores
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Configuração do Ambiente](#configuração-do-ambiente)
- [Execução do Projeto](#execução-do-projeto)
- [Boas Práticas](#boas-práticas)
- [Geração de Builds](#geração-de-builds)
- [Checklist de Testes](#checklist-de-testes)

## 👤 Guia para o Usuário

### Apresentação do Projeto
O App de Gerenciamento de Estacionamento é uma solução completa para controle de entrada, permanência e saída de veículos em estacionamentos. Desenvolvido com foco na simplicidade e eficiência, o aplicativo oferece uma interface intuitiva e funcionalidades essenciais para o gerenciamento diário de estacionamentos.

### Funcionalidades Principais
- 🚘 Registro de entrada de veículos
- 💰 Gerenciamento de pagamentos (PIX, Cartão de Crédito, Cartão de Débito, Dinheiro)
- 📝 Emissão de comprovantes
- 🔍 Busca de veículos
- 📊 Relatório de permanência
- 📱 Interface responsiva e amigável

### Como Utilizar o Aplicativo

#### 1. Tela Inicial
- Acesse o menu principal através do botão "Home"
- Visualize os veículos atualmente estacionados
- Acesse as funcionalidades através do menu inferior

#### 2. Registro de Entrada
- Toque em "Entrada" no menu inferior
- Preencha os dados do veículo
- Escolha o tempo de permanência
- Selecione a forma de pagamento
- Confirme a entrada

#### 3. Registro de Saída
- Toque em "Saída" no menu inferior
- Informe a placa do veículo
- Confirme a saída
- Receba o comprovante

#### 4. Busca de Veículos
- Toque em "Busca" no menu inferior
- Digite a placa do veículo
- Visualize os detalhes do veículo

### Requisitos Mínimos
- Android 6.0 (Marshmallow) ou superior
- 2GB de RAM
- 50MB de espaço livre
- Conexão com internet para pagamentos

### Fluxo Básico

#### Entrada
1. Acesse a tela de entrada
2. Preencha os dados do veículo
3. Escolha o tempo de permanência
4. Selecione a forma de pagamento
5. Confirme a entrada

#### Pagamento
- PIX: Escaneie o QR Code
- Cartão de Crédito: Até 2x sem juros
- Cartão de Débito: Pagamento à vista
- Dinheiro: Receba o troco

#### Saída
1. Acesse a tela de saída
2. Informe a placa do veículo
3. Confirme a saída
4. Receba o comprovante

#### Comprovantes
- Comprovante de entrada
- Comprovante de saída
- Histórico de pagamentos

### FAQ

#### Como faço para estender o tempo de permanência?
Acesse a tela de busca, localize o veículo e selecione a opção de extensão de tempo.

#### Posso pagar com mais de uma forma de pagamento?
Não, cada ticket deve ser pago com apenas uma forma de pagamento.

#### Como faço para recuperar um comprovante perdido?
Acesse a tela de busca, localize o veículo e selecione a opção de reimpressão do comprovante.

## 👨‍💻 Guia para Desenvolvedores

### Tecnologias Utilizadas
- Flutter 3.0.0+
- Dart 3.0.0+
- Hive (Banco de dados local)
- Provider (Gerenciamento de estado)
- PDF (Geração de comprovantes)
- QR Flutter (Geração de QR Code)

### Estrutura de Pastas
```
lib/
├── src/
│   ├── models/         # Modelos de dados
│   ├── screens/        # Telas do aplicativo
│   ├── services/       # Serviços e lógica de negócio
│   ├── theme/          # Temas e estilos
│   ├── widgets/        # Componentes reutilizáveis
│   └── providers/      # Gerenciadores de estado
├── assets/             # Recursos estáticos
└── main.dart           # Ponto de entrada
```

### Configuração do Ambiente

1. Instale o Flutter SDK
```bash
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"
```

2. Instale as dependências
```bash
flutter pub get
```

3. Configure o Android Studio/VS Code
- Instale as extensões do Flutter e Dart
- Configure o emulador Android

### Execução do Projeto

1. Em modo desenvolvimento:
```bash
flutter run
```

2. Para gerar APK de debug:
```bash
flutter build apk --debug
```

3. Para gerar APK de release:
```bash
flutter build apk --release
```

### Boas Práticas

#### Padrão de Código
- Siga o [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use nomes descritivos para variáveis e funções
- Documente funções complexas
- Mantenha o código organizado e limpo

#### Pull Requests
1. Crie uma branch descritiva
2. Faça commits atômicos
3. Escreva mensagens de commit claras
4. Atualize a documentação quando necessário
5. Execute os testes antes de submeter

### Geração de Builds

#### Android
1. Configure o keystore:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Gere o APK de release:
```bash
flutter build apk --release
```

### Checklist de Testes

#### Antes de Liberar Atualizações
- [ ] Testar em diferentes tamanhos de tela
- [ ] Verificar fluxos de entrada e saída
- [ ] Testar todas as formas de pagamento
- [ ] Validar geração de comprovantes
- [ ] Verificar performance
- [ ] Testar offline
- [ ] Validar segurança
- [ ] Atualizar documentação
