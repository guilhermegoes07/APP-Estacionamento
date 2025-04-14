# 🚗 App de Gerenciamento de Estacionamento

- [Download do aplicativo](https://drive.usercontent.google.com/download?id=1ZNjv2dzHkcJK_uvrIPVzzyuB-nnNfpvL&export=download&authuser=0)

## 📚 Índice

### Documentação para Usuários
- [O que é o App?](#o-que-é-o-app)
- [Funcionalidades Principais](#funcionalidades-principais)
- [Como Usar](#como-usar)

### Documentação para Desenvolvedores
- [Sobre o Projeto](#sobre-o-projeto)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Tecnologias](#tecnologias)
- [Configuração do Ambiente](#configuração-do-ambiente)
- [Padrões do Projeto](#padrões-do-projeto)
- [Principais Funcionalidades](#principais-funcionalidades)

## 👤 Documentação para Usuários

### O que é o App?
O App de Gerenciamento de Estacionamento é uma solução simples e eficiente para controlar a entrada e saída de veículos em estacionamentos. Com ele, você pode registrar veículos, gerenciar pagamentos e emitir comprovantes de forma rápida e organizada.

### Funcionalidades Principais
- 🚘 Registro de entrada de veículos
- 💰 Múltiplas formas de pagamento (PIX, Cartão, Dinheiro)
- 📝 Emissão de comprovantes
- 🔍 Busca de veículos
- 📱 Interface simples e intuitiva

### Como Usar

#### 1. Registro de Entrada
- Toque em "Entrada" no menu inferior
- Preencha a placa do veículo
- Escolha o tempo de permanência
- Selecione a forma de pagamento
- Confirme a entrada

#### 2. Registro de Saída
- Toque em "Saída" no menu inferior
- Digite a placa do veículo
- Confirme a saída
- Receba o comprovante

#### 3. Busca de Veículos
- Toque em "Busca" no menu inferior
- Digite a placa do veículo
- Visualize os detalhes do veículo

## 👨‍💻 Documentação para Desenvolvedores

### Sobre o Projeto
Este é um aplicativo Flutter para gerenciamento de estacionamentos, desenvolvido com foco em simplicidade e eficiência. O projeto utiliza arquitetura limpa e boas práticas de desenvolvimento.

### Estrutura do Projeto
```
lib/
├── src/
│   ├── models/         # Modelos de dados (Veiculo, Pagamento, Ticket)
│   ├── screens/        # Telas do aplicativo
│   ├── services/       # Lógica de negócio e persistência
│   ├── theme/          # Temas e estilos
│   ├── widgets/        # Componentes reutilizáveis
│   └── providers/      # Gerenciamento de estado
├── assets/             # Recursos estáticos (imagens, fontes)
└── main.dart           # Ponto de entrada
```

### Tecnologias
- Flutter 3.0.0+
- Dart 3.0.0+
- Hive (Banco de dados local)
- Provider (Gerenciamento de estado)
- PDF (Geração de comprovantes)
- QR Flutter (Geração de QR Code)

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

3. Execute o projeto
```bash
flutter run
```

### Padrões do Projeto

#### Código
- Siga o [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use nomes descritivos para variáveis e funções
- Documente funções complexas
- Mantenha o código organizado e limpo

#### Commits
- Use o padrão [Conventional Commits](https://www.conventionalcommits.org/)
- Exemplo: `feat: adiciona nova funcionalidade`

### Principais Funcionalidades

#### Entrada de Veículos
- Local: `lib/src/screens/entrada_screen.dart`
- Serviço: `lib/src/services/estacionamento_service.dart`

#### Saída de Veículos
- Local: `lib/src/screens/saida_screen.dart`
- Serviço: `lib/src/services/estacionamento_service.dart`

#### Pagamentos
- Modelo: `lib/src/models/pagamento.dart`
- Serviço: `lib/src/services/estacionamento_service.dart`

#### Geração de PDFs
- Local: `lib/src/screens/comprovante_screen.dart`
- Widget: `lib/src/widgets/comprovante_pagamento.dart`

#### Busca de Veículos
- Local: `lib/src/screens/busca_screen.dart`
- Serviço: `lib/src/services/estacionamento_service.dart`
