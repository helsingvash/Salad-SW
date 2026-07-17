#!/bin/bash

set -e

DEST="SwarmUI/dlbackend"
REPO="https://github.com/comfyanonymous/ComfyUI.git"
VENV="../venv"    # ajuste se o venv estiver em outro local

mkdir -p "$DEST"
cd "$DEST"

if [ -d "ComfyUI/.git" ]; then
    echo "Atualizando ComfyUI..."
    cd ComfyUI
    git pull
else
    echo "Clonando ComfyUI..."
    git clone "$REPO"
    cd ComfyUI
fi

# Ativa o ambiente virtual
if [ -f "$VENV/bin/activate" ]; then
    echo "Ativando venv..."
    source "$VENV/bin/activate"
else
    echo "Erro: venv não encontrado em $VENV"
    exit 1
fi

echo "Instalando dependências..."
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

echo "Concluído!"
