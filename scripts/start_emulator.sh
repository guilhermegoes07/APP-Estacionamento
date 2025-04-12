#!/bin/bash

# Define o JAVA_HOME correto
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home"

# Verifica se o emulador já está em execução
EMULATOR_RUNNING=$(flutter devices | grep "emulator-" | wc -l)

if [ $EMULATOR_RUNNING -eq 0 ]; then
    echo "Iniciando o emulador..."
    flutter emulators --launch Medium_Phone_API_35
    
    # Aguarda o emulador iniciar completamente
    echo "Aguardando o emulador inicializar..."
    sleep 15
    echo "Emulador iniciado e pronto para uso!"
else
    echo "Emulador já está em execução!"
fi

# Verifica se o emulador está conectado
ATTEMPTS=0
while [ $ATTEMPTS -lt 5 ]; do
    DEVICE_CONNECTED=$(flutter devices | grep "emulator-" | wc -l)
    
    if [ $DEVICE_CONNECTED -gt 0 ]; then
        echo "Emulador conectado com sucesso!"
        exit 0
    fi
    
    echo "Aguardando emulador se conectar..."
    sleep 5
    ATTEMPTS=$((ATTEMPTS + 1))
done

echo "AVISO: Não foi possível detectar o emulador conectado após várias tentativas."
echo "Verifique se o emulador está funcionando corretamente."
exit 1 