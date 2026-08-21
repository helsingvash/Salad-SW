#!/bin/bash

set -e

echo "=========================================="
echo "   Instalador de Custom Nodes - ComfyUI"
echo "=========================================="
echo ""

# ============================================================
# DIRETÓRIO DO SCRIPT
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# SwarmUI está dentro do diretório onde está o script
SWARM_DIR="$SCRIPT_DIR/SwarmUI"

# ComfyUI dentro do SwarmUI
COMFY_DIR="$SWARM_DIR/dlbackend/ComfyUI"

# Venv do ComfyUI
VENV="$COMFY_DIR/venv"

# Custom nodes
CUSTOM_NODES="$COMFY_DIR/custom_nodes"

echo "📂 Diretório do script:"
echo "$SCRIPT_DIR"
echo ""

echo "📂 SwarmUI:"
echo "$SWARM_DIR"
echo ""

echo "📂 ComfyUI:"
echo "$COMFY_DIR"
echo ""

echo "📂 Venv:"
echo "$VENV"
echo ""

echo "📂 Custom Nodes:"
echo "$CUSTOM_NODES"
echo ""

# ============================================================
# VERIFICAR SWARMUI
# ============================================================

if [ ! -d "$SWARM_DIR" ]; then
    echo "❌ SwarmUI não encontrado:"
    echo "$SWARM_DIR"
    echo ""
    exit 1
fi

echo "✅ SwarmUI encontrado."
echo ""

# ============================================================
# VERIFICAR COMFYUI
# ============================================================

if [ ! -d "$COMFY_DIR" ]; then
    echo "❌ ComfyUI não encontrado:"
    echo "$COMFY_DIR"
    echo ""
    exit 1
fi

echo "✅ ComfyUI encontrado."
echo ""

# ============================================================
# VERIFICAR GIT
# ============================================================

if ! command -v git >/dev/null 2>&1; then
    echo "❌ Git não encontrado."
    exit 1
fi

echo "✅ Git:"
git --version
echo ""

# ============================================================
# VERIFICAR CURL
# ============================================================

if ! command -v curl >/dev/null 2>&1; then
    echo "❌ curl não encontrado."
    exit 1
fi

echo "✅ curl encontrado."
echo ""

# ============================================================
# VERIFICAR / INSTALAR UV
# ============================================================

if ! command -v uv >/dev/null 2>&1; then

    echo "📦 uv não encontrado."
    echo "Instalando uv..."
    echo ""

    curl -LsSf https://astral.sh/uv/install.sh | sh

    export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
fi

if ! command -v uv >/dev/null 2>&1; then
    echo "❌ uv não foi encontrado após a instalação."
    echo ""
    echo 'Tente: export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"'
    exit 1
fi

echo "✅ uv:"
uv --version
echo ""

# ============================================================
# VERIFICAR VENV
# ============================================================

if [ ! -f "$VENV/bin/python" ]; then
    echo "❌ Venv do ComfyUI não encontrado:"
    echo "$VENV"
    echo ""
    exit 1
fi

echo "✅ Venv encontrado."
echo ""

# ============================================================
# ATIVAR VENV
# ============================================================

echo "🐍 Ativando venv..."

source "$VENV/bin/activate"

echo "✅ Venv ativado."
echo ""

echo "Python:"
"$VENV/bin/python" --version

echo ""

# ============================================================
# CRIAR CUSTOM NODES
# ============================================================

mkdir -p "$CUSTOM_NODES"

echo "✅ Pasta custom_nodes:"
echo "$CUSTOM_NODES"
echo ""

# ============================================================
# FUNÇÃO PARA INSTALAR NODE
# ============================================================

install_node() {

    local REPO="$1"
    local FOLDER="$2"

    local DEST="$CUSTOM_NODES/$FOLDER"

    echo ""
    echo "=========================================="
    echo "📦 Instalando: $FOLDER"
    echo "=========================================="
    echo ""

    if [ -d "$DEST/.git" ]; then

        echo "🔄 Node já existe."
        echo "Atualizando..."

        git -C "$DEST" pull

    else

        echo "⬇️ Clonando:"
        echo "$REPO"

        git clone "$REPO" "$DEST"

    fi

    # ========================================================
    # REQUIREMENTS
    # ========================================================

    if [ -f "$DEST/requirements.txt" ]; then

        echo ""
        echo "📦 Instalando requirements.txt..."

        uv pip install \
            --python "$VENV/bin/python" \
            -r "$DEST/requirements.txt"

        echo ""
        echo "✅ Dependências instaladas."

    else

        echo ""
        echo "ℹ️ Nenhum requirements.txt encontrado."

    fi
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
# FINAL
# ============================================================

echo ""
echo "=========================================="
echo "       ✅ INSTALAÇÃO CONCLUÍDA"
echo "=========================================="
echo ""

echo "SwarmUI:"
echo "$SWARM_DIR"

echo ""
echo "ComfyUI:"
echo "$COMFY_DIR"

echo ""
echo "Custom Nodes:"
echo "$CUSTOM_NODES"

echo ""
echo "Python:"
"$VENV/bin/python" --version

echo ""
echo "uv:"
uv --version

echo ""
echo "=========================================="
echo ""
