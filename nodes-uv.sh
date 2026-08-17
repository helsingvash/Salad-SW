```bash
#!/bin/bash

set -e

COMFY_DIR="SwarmUI/dlbackend/ComfyUI"
VENV="$COMFY_DIR/venv"
CUSTOM_NODES="$COMFY_DIR/custom_nodes"

echo "====================================="
echo " Instalando Custom Nodes do ComfyUI"
echo "====================================="

# =========================
# Verificar uv
# =========================

if ! command -v uv &> /dev/null; then
    echo "📦 uv não encontrado. Instalando..."

    curl -LsSf https://astral.sh/uv/install.sh | sh

    export PATH="$HOME/.local/bin:$PATH"
fi

echo "uv: $(uv --version)"

# =========================
# Verificar ComfyUI
# =========================

if [ ! -d "$COMFY_DIR" ]; then
    echo "❌ ComfyUI não encontrado:"
    echo "$COMFY_DIR"
    exit 1
fi

# =========================
# Ativar venv
# =========================

if [ -f "$VENV/bin/activate" ]; then
    echo "🐍 Ativando venv do ComfyUI..."
    source "$VENV/bin/activate"
else
    echo "❌ Venv não encontrado:"
    echo "$VENV"
    exit 1
fi

# =========================
# Criar pasta custom_nodes
# =========================

mkdir -p "$CUSTOM_NODES"

# =========================
# Função para instalar node
# =========================

install_node () {
    REPO="$1"
    FOLDER="$2"

    DEST="$CUSTOM_NODES/$FOLDER"

    if [ -d "$DEST/.git" ]; then
        echo ""
        echo "🔄 Atualizando $FOLDER..."

        git -C "$DEST" pull
    else
        echo ""
        echo "⬇️ Clonando $FOLDER..."

        git clone "$REPO" "$DEST"
    fi

    # =========================
    # Instalar requirements
    # =========================

    if [ -f "$DEST/requirements.txt" ]; then
        echo "📦 Instalando dependências de $FOLDER..."

        uv pip install -q -r "$DEST/requirements.txt"
    else
        echo "ℹ️ $FOLDER não possui requirements.txt."
    fi
}

# =========================
# Custom Nodes
# =========================

install_node \
    https://github.com/kijai/ComfyUI-SUPIR.git \
    ComfyUI-SUPIR

install_node \
    https://github.com/prodogape/ComfyUI-clip-interrogator.git \
    ComfyUI-clip-interrogator

install_node \
    https://github.com/Fannovel16/comfyui_controlnet_aux.git \
    comfyui_controlnet_aux

install_node \
    https://github.com/huchenlei/ComfyUI-openpose-editor.git \
    openpose-editor

install_node \
    https://github.com/ClownsharkBatwing/RES4LYF.git \
    RES4LYF

# =========================
# Finalização
# =========================

echo ""
echo "====================================="
echo "✅ Todos os nodes foram instalados/"
echo "   atualizados com sucesso!"
echo "====================================="
echo ""
echo "ComfyUI:"
echo "$COMFY_DIR"
echo ""
echo "Custom Nodes:"
echo "$CUSTOM_NODES"
echo ""
echo "Python:"
python --version
echo ""
echo "uv:"
uv --version
echo ""
echo "Venv:"
echo "$VENV"
echo "====================================="
```
