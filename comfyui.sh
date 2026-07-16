#!/bin/bash

# Diretório destino
DEST="SwarmUI/dlbackend"

# Repositório oficial do ComfyUI
REPO="https://github.com/comfyanonymous/ComfyUI.git"

echo "Criando diretório destino..."
mkdir -p "$DEST"

echo "Entrando em $DEST..."
cd "$DEST" || exit 1

# Verifica se já existe
if [ -d "ComfyUI" ]; then
    echo "ComfyUI já existe em $DEST/ComfyUI"
    echo "Atualizando repositório..."
    cd ComfyUI
    git pull
else
    echo "Clonando ComfyUI..."
    git clone "$REPO"
fi

echo "Concluído!"
