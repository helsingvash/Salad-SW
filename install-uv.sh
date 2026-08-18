#!/bin/bash
set -e

echo "🚀 Iniciando instalação do SwarmUI..."

# =========================
# Atualização do sistema
# =========================

sudo apt update -y
sudo apt upgrade -y
sudo apt install -y sudo

# =========================
# Dependências do sistema
# =========================

sudo apt install -y \
    libcairo2-dev \
    libgl1 \
    libglib2.0-0 \
    pkg-config \
    libjpeg-turbo8-dev \
    libpng-dev \
    unzip \
    wget \
    curl \
    git \
    nano \
    ca-certificates

# =========================
# Instalar uv
# =========================

echo "📦 Instalando uv..."

curl -LsSf https://astral.sh/uv/install.sh | sh

# Disponibiliza uv nesta sessão
export PATH="$HOME/.local/bin:$PATH"

# Verifica instalação
uv --version

# =========================
# Clonar SwarmUI
# =========================

if [ ! -d "SwarmUI" ]; then
    echo "📥 Clonando SwarmUI..."
    git clone https://github.com/mcmonkeyprojects/SwarmUI.git
else
    echo "📁 SwarmUI já existe, pulando clone."
fi

# =========================
# Ambiente Python
# =========================

cd SwarmUI

echo "🐍 Criando ambiente virtual Python com uv..."

if [ ! -d ".venv" ]; then
    uv venv .venv
else
    echo "📁 Ambiente virtual .venv já existe."
fi

# Ativa o ambiente virtual
source .venv/bin/activate

# =========================
# Atualizar pip / ferramentas Python
# =========================

echo "⬆️ Atualizando ferramentas Python..."

uv pip install --upgrade pip
uv pip install --upgrade ipykernel

# =========================
# Instalar dependências Python
# =========================

# Caso exista requirements.txt no projeto:
if [ -f "requirements.txt" ]; then
    echo "📦 Instalando requirements.txt com uv..."
    uv pip install -r requirements.txt
fi

# =========================
# Instalar .NET
# =========================

cd ..

echo "⬇️ Instalando .NET 10.0.101..."

wget -q https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh \
    -O dotnet-install.sh

chmod +x dotnet-install.sh

./dotnet-install.sh --version 10.0.101

# Adiciona dotnet ao PATH
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$PATH:$HOME/.dotnet"

# =========================
# Instalar zrok
# =========================

echo "🌐 Instalando zrok..."
apt install -y gnupg
curl -sSf https://get.openziti.io/install.bash | bash -s zrok

# =========================
# Finalização
# =========================

echo ""
echo "======================================"
echo "✅ Instalação do SwarmUI concluída!"
echo "======================================"
echo ""
echo "Python:"
python --version

echo ""
echo "uv:"
uv --version

echo ""
echo ".NET:"
dotnet --version

echo ""
echo "Ambiente virtual:"
echo "$PWD/SwarmUI/.venv"

echo ""
echo "Para utilizar o ambiente posteriormente:"
echo "source SwarmUI/.venv/bin/activate"

echo ""
echo "ℹ️ Se necessário, reinicie o terminal ou execute:"
echo "source ~/.bashrc"
