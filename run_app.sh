#!/bin/bash

# Define o JAVA_HOME correto
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home"

# Inicia o emulador se não estiver rodando
EMULATOR_RUNNING=$(flutter devices | grep "emulator-" | wc -l)
if [ $EMULATOR_RUNNING -eq 0 ]; then
    echo "Iniciando o emulador..."
    flutter emulators --launch Medium_Phone_API_35
    echo "Aguardando inicialização do emulador..."
    sleep 15
fi

# Executa o aplicativo com restrições de tamanho de tela para simular um dispositivo móvel
flutter run --device-id=emulator-5554 --dart-define=ENFORCE_CONSTRAINTS=true 