#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# CONFIGURAÇÕES
# ---------------------------------------------------------------------------
SWARMUI_PORT=7801
SWARMUI_SCRIPT=(SwarmUI/launch-linux.sh --port "${SWARMUI_PORT}")

# Usa o zrok do sistema
ZROK_BIN="$(command -v zrok)"

# ---------------------------------------------------------------------------
# VERIFICAÇÕES
# ---------------------------------------------------------------------------
if [ -z "$ZROK_BIN" ]; then
    echo "[ERRO] zrok não encontrado no sistema"
    exit 1
fi

if [ ! -x "${SWARMUI_SCRIPT[0]}" ]; then
    echo "[ERRO] launch-linux.sh não encontrado ou sem permissão em SwarmUI"
    ls -l SwarmUI || true
    exit 1
fi

# ---------------------------------------------------------------------------
# ZROK
# ---------------------------------------------------------------------------

echo "[INFO] Desabilitando zrok (se existir)..."
"$ZROK_BIN" disable || true

read -rsp "Cole seu token do zrok: " ZROK_TOKEN
echo

echo "[INFO] Habilitando zrok..."
"$ZROK_BIN" enable "$ZROK_TOKEN" || {
    echo "[ERRO] Falha ao habilitar o zrok"
    unset ZROK_TOKEN
    exit 1
}

unset ZROK_TOKEN

sleep 3

# ---------------------------------------------------------------------------
# INICIAR SWARMUI
# ---------------------------------------------------------------------------
echo "[INFO] Iniciando SwarmUI..."
"${SWARMUI_SCRIPT[@]}" &
SWARMUI_PID=$!

sleep 5

# ---------------------------------------------------------------------------
# ABRIR TÚNEL
# ---------------------------------------------------------------------------
echo "[INFO] Abrindo túnel público..."
ZROK_OUTPUT=$("$ZROK_BIN" share public "http://127.0.0.1:${SWARMUI_PORT}")

echo
echo "====================================="
echo " SwarmUI disponível em:"
echo "$ZROK_OUTPUT"
echo "====================================="
