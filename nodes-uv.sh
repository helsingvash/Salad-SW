#!/bin/bash

set -e

# ============================================================
# CONFIGURAÇÃO
# ============================================================

# Diretório onde este script está localizado
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# SwarmUI está na mesma pasta deste script
SWARM_DIR="$SCRIPT_DIR"

# ComfyUI dentro do SwarmUI
COMFY_DIR="$SWARM_DIR/dlbackend/ComfyUI"

# Venv do ComfyUI
VENV="$COMFY_DIR/venv"

# Custom nodes
CUSTOM_NODES="$COMFY_DIR/custom_nodes"

echo ""
echo "=========================================="
echo "   Instalador de Custom Nodes - ComfyUI"
echo "=========================================="
echo ""
echo "Script:"
echo "$SCRIPT_DIR"
echo ""
echo "ComfyUI:"
echo "$COMFY_DIR"
echo ""
echo "Venv:"
echo "$VENV"
echo ""
echo "Custom Nodes:"
echo "$CUSTOM_NODES"
echo ""

# ============================================================
# VERIFICAR COMANDOS BÁSICOS
# ============================================================

echo "🔎 Verificando dependências..."

if ! command -v git >/dev/null 2>&1; then
    echo "❌ Git não encontrado."
    echo "Instale o Git antes de continuar."
    exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
    echo "❌ curl não encontrado."
    echo "Instale o curl antes de continuar."
    exit 1
fi

echo "✅ Git encontrado: $(git --version)"
echo "✅ curl encontrado"
echo ""

# ============================================================
# VERIFICAR UV
# ============================================================

if ! command -v uv >/dev/null 2>&1; then

    echo "📦 uv não encontrado."
    echo "Instalando uv..."
    echo ""

    curl -LsSf https://astral.sh/uv/install.sh | sh

    # Adicionar possíveis locais do uv ao PATH
    export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

fi

# Verificar novamente
if ! command -v uv >/dev/null 2>&1; then
    echo ""
    echo "❌ Não foi possível encontrar o uv após a instalação."
    echo ""
    echo "Tente manualmente:"
    echo ""
    echo 'export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"'
    echo ""
    exit 1
fi

echo "✅ uv encontrado:"
uv --version
echo ""

# ============================================================
# VERIFICAR COMFYUI
# ============================================================

echo "🔎 Verificando ComfyUI..."

if [ ! -d "$COMFY_DIR" ]; then

    echo ""
    echo "❌ ComfyUI não encontrado!"
    echo ""
    echo "Procurado em:"
    echo "$COMFY_DIR"
    echo ""
    echo "Estrutura esperada:"
    echo ""
    echo "$SWARM_DIR/"
    echo "├── nodes-uv.sh"
    echo "└── dlbackend/"
    echo "    └── ComfyUI/"
    echo ""
    exit 1

fi

echo "✅ ComfyUI encontrado."
echo ""

# ============================================================
# VERIFICAR VENV
# ============================================================

echo "🔎 Verificando ambiente virtual..."

if [ ! -f "$VENV/bin/python" ]; then

    echo ""
    echo "❌ Python do venv não encontrado:"
    echo "$VENV/bin/python"
    echo ""

    if [ -d "$VENV" ]; then
        echo "A pasta venv existe, mas não parece ser um ambiente virtual válido."
    else
        echo "A pasta venv não existe."
    fi

    echo ""
    exit 1
fi

echo "✅ Venv encontrado."
echo ""

# ============================================================
# ATIVAR VENV
# ============================================================

echo "🐍 Ativando venv do ComfyUI..."

source "$VENV/bin/activate"

echo "✅ Venv ativado."
echo ""

echo "Python:"
python --version

echo "Python utilizado:"
which python

echo ""

# ============================================================
# VERIFICAR UV COM VENV
# ============================================================

echo "🔎 Verificando uv + Python do ComfyUI..."

uv pip --python "$VENV/bin/python" --version

echo ""

# ============================================================
# CRIAR CUSTOM_NODES
# ============================================================

echo "📁 Verificando custom_nodes..."

mkdir -p "$CUSTOM_NODES"

echo "✅ Custom nodes:"
echo "$CUSTOM_NODES"
echo ""

# ============================================================
# FUNÇÃO DE INSTALAÇÃO
# ============================================================

install_node() {

    local REPO="$1"
    local FOLDER="$2"

    local DEST="$CUSTOM_NODES/$FOLDER"

    echo ""
    echo "=========================================="
    echo "📦 Node: $FOLDER"
    echo "=========================================="
    echo ""

    # --------------------------------------------------------
    # ATUALIZAR OU CLONAR
    # --------------------------------------------------------

    if [ -d "$DEST/.git" ]; then

        echo "🔄 Node já existe."
        echo "Atualizando repositório..."
        echo ""

        git -C "$DEST" pull

    elif [ -d "$DEST" ]; then

        echo "⚠️ A pasta existe, mas não é um repositório Git:"
        echo "$DEST"
        echo ""

        echo "Pulando clone para evitar apagar arquivos existentes."

    else

        echo "⬇️ Clonando:"
        echo "$REPO"
        echo ""

        git clone "$REPO" "$DEST"

    fi

    # --------------------------------------------------------
    # REQUIREMENTS
    # --------------------------------------------------------

    if [ -f "$DEST/requirements.txt" ]; then

        echo ""
        echo "📦 Encontrado requirements.txt"
        echo "Instalando dependências..."
        echo ""

        uv pip install \
            --python "$VENV/bin/python" \
            -r "$DEST/requirements.txt"

        echo ""
        echo "✅ Dependências de $FOLDER instaladas."

    else

        echo ""
        echo "ℹ️ $FOLDER não possui requirements.txt."
        echo "Nenhuma dependência adicional será instalada."

    fi

    echo ""
}

# ============================================================
# CUSTOM NODES
# ============================================================

install_node \
    "https://github.com/kijai/ComfyUI-SUPIR.git" \
    "ComfyUI-SUPIR"

install_node \
    "https://github.com/prodogape/ComfyUI-clip-interrogator.git" \
    "ComfyUI-clip-interrogator"

install_node \
    "https://github.com/Fannovel16/comfyui_controlnet_aux.git" \
    "comfyui_controlnet_aux"

install_node \
    "https://github.com/huchenlei/ComfyUI-openpose-editor.git" \
    "openpose-editor"

install_node \
    "https://github.com/ClownsharkBatwing/RES4LYF.git" \
    "RES4LYF"

# ============================================================
# FINALIZAÇÃO
# ============================================================

echo ""
echo "=========================================="
echo "        ✅ INSTALAÇÃO CONCLUÍDA"
echo "=========================================="
echo ""

echo "📂 ComfyUI:"
echo "$COMFY_DIR"
echo ""

echo "📂 Custom Nodes:"
echo "$CUSTOM_NODES"
echo ""

echo "🐍 Python:"
"$VENV/bin/python" --version
echo ""

echo "📦 uv:"
uv --version
echo ""

echo "🐍 Python utilizado:"
"$VENV/bin/python" -c 'import sys; print(sys.executable)'
echo ""

echo "📁 Venv:"
echo "$VENV"
echo ""

echo "=========================================="
echo "       Todos os nodes foram instalados"
echo "          ou atualizados com sucesso!"
echo "=========================================="
echo ""
