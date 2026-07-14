#!/bin/bash

set -e

# =========================
# Setup inicial
# =========================
sudo apt-get update -qq
sudo apt-get install -y -qq unzip wget aria2

# =========================
# Corrigir Python e HF Hub
# =========================
python -m pip install -q --upgrade pip

python -m pip uninstall -y huggingface_hub huggingface-hub filelock || true
python -m pip install -q huggingface-hub filelock==3.16.1

# =========================
# Login Hugging Face
# =========================

read -rsp "Cole seu token do Hugging Face: " HF_TOKEN
echo

hf auth login --token "$HF_TOKEN"
unset HF_TOKEN

# =========================
# Criar diretórios
# =========================
mkdir -p SwarmUI/Models/Lora
mkdir -p SwarmUI/Models/Stable-Diffusion
mkdir -p SwarmUI/Models/yolov8

# =========================
# YOLOv8 (mantidos)
# =========================

wget -nc -P SwarmUI/Models/yolov8 \
https://github.com/tobecwb/facial-features-yolo8x-seg/releases/download/v1.0/facial_features_yolo8x-seg.pt

wget -nc -P SwarmUI/Models/yolov8 \
https://huggingface.co/ashllay/YOLO_Models/resolve/e07b01219ff1807e1885015f439d788b038f49bd/bbox/female-breast-v4.0-fantasy.pt

wget -nc -P SwarmUI/Models/yolov8 \
https://huggingface.co/AunyMoons/loras-pack/resolve/main/foot-yolov8l.pt

# =========================
# Modelo Krea 2
# =========================

wget -nc -O SwarmUI/Models/Stable-Diffusion/krea2_raw_fp8_scaled.safetensors \
https://huggingface.co/Comfy-Org/Krea-2/resolve/main/diffusion_models/krea2_raw_fp8_scaled.safetensors

# =========================
# LoRA - Krea 2 Turbo Distill
# =========================

wget -nc -O SwarmUI/Models/Lora/krea2_turbo_distill_r256.safetensors \
https://huggingface.co/TheDivergentAI/krea2-turbo-distill-lora/resolve/main/krea2_turbo_distill_r256.safetensors

# =========================
# LoRA - Krea Filter Bypass
# =========================

wget -nc -O SwarmUI/Models/Lora/krea2filterbypass.safetensors \
https://huggingface.co/Kutches/Kr3a/resolve/c28120b6ebfff2629d475dcde0bbdbf45cbc06e9/krea2filterbypass.safetensors

# =========================
# Verificação final
# =========================

echo ""
echo "✅ Downloads concluídos!"
echo ""

echo "=== Stable-Diffusion ==="
ls -lh SwarmUI/Models/Stable-Diffusion

echo ""
echo "=== LoRAs ==="
ls -lh SwarmUI/Models/Lora

echo ""
echo "=== YOLO ==="
ls -lh SwarmUI/Models/yolov8
