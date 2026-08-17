```bash
#!/bin/bash

set -e

DEST="SwarmUI/dlbackend"
REPO="https://github.com/comfyanonymous/ComfyUI.git"
VENV="venv"

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
# Criar pasta de destino
# =========================

mkdir -p "$DEST"
cd "$DEST"

# =========================
# Clonar ou atualizar ComfyUI
# =========================

if [ -d "ComfyUI/.git" ]; then
    echo "🔄 Atualizando ComfyUI..."

    cd ComfyUI
    git pull
else
    echo "📥 Clonando ComfyUI..."

    git clone "$REPO"
    cd ComfyUI
fi

# =========================
# Criar ambiente virtual
# =========================

if [ ! -d "$VENV" ]; then
    echo "🐍 Criando ambiente virtual com uv..."
    echo "Local: $(pwd)/$VENV"

    uv venv "$VENV"
else
    echo "📁 Ambiente virtual já existe:"
    echo "$(pwd)/$VENV"
fi

# =========================
# Ativar ambiente virtual
# =========================

if [ -f "$VENV/bin/activate" ]; then
    echo "⚡ Ativando ambiente virtual..."
    source "$VENV/bin/activate"
else
    echo "❌ Erro: não foi possível encontrar o ambiente virtual em:"
    echo "$(pwd)/$VENV"
    exit 1
fi

# =========================
# Atualizar ferramentas Python
# =========================

echo "⬆️ Atualizando pip, setuptools e wheel..."

uv pip install --upgrade \
    pip \
    setuptools \
    wheel

# =========================
# Instalar dependências
# =========================

if [ -f "requirements.txt" ]; then
    echo "📦 Instalando dependências do ComfyUI com uv..."

    uv pip install -r requirements.txt
else
    echo "❌ Erro: requirements.txt não encontrado."
    exit 1
fi

# =========================
# Finalização
# =========================

echo ""
echo "=========================================="
echo "✅ Instalação concluída com sucesso!"
echo "=========================================="
echo ""
echo "ComfyUI:"
echo "$(pwd)"
echo ""
echo "Venv:"
echo "$(pwd)/$VENV"
echo ""
echo "Python:"
python --version
echo ""
echo "uv:"
uv --version
echo ""
echo "Para ativar manualmente:"
echo "source $(pwd)/$VENV/bin/activate"
echo "=========================================="
```
