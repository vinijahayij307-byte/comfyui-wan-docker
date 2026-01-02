#!/bin/bash

echo "========================================="
echo "ComfyUI Wan 2.1 Steady Dancer - Auto Setup"
echo "========================================="

# 1. Безопасная настройка rclone (через переменную окружения)
echo "Configuring rclone..."
mkdir -p ~/.config/rclone
echo "$RCLONE_CONFIG_DATA" > ~/.config/rclone/rclone.conf

# 2. Создание структуры папок для Steady Dancer
echo "Creating directories..."
mkdir -p /workspace/ComfyUI/models/clip_vision
mkdir -p /workspace/ComfyUI/models/controlnet
mkdir -p /workspace/ComfyUI/custom_nodes/comfyui_controlnet_aux/ckpts

# 3. Копирование моделей (с учетом новых файлов)
echo "Copying models from Google Drive..."

# Базовые модели
rclone copy gdrive:ComfyUI-Workspace/models/checkpoints/ /workspace/ComfyUI/models/checkpoints/ --progress --transfers 8
rclone copy gdrive:ComfyUI-Workspace/models/vae/ /workspace/ComfyUI/models/vae/ --progress
rclone copy gdrive:ComfyUI-Workspace/models/loras/ /workspace/ComfyUI/models/loras/ --progress

# Критично для Steady Dancer (Image-to-Video)
rclone copy gdrive:ComfyUI-Workspace/models/clip_vision/ /workspace/ComfyUI/models/clip_vision/ --progress

# Позеры (YOLO и DWPose), которые ты только что загрузил
rclone copy gdrive:ComfyUI-Workspace/models/annotators/ /workspace/ComfyUI/custom_nodes/comfyui_controlnet_aux/ckpts/ --
