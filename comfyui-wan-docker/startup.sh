#!/bin/bash

echo "========================================="
echo "ComfyUI Wan 2.1 - Optimized Startup"
echo "========================================="

# 1. Настройка rclone (используем переменную окружения)
mkdir -p ~/.config/rclone
if [ -z "$RCLONE_CONFIG_DATA" ]; then
    echo "ERROR: RCLONE_CONFIG_DATA is empty! Set it in Vast.ai env vars."
else
    echo "$RCLONE_CONFIG_DATA" | base64 -d > ~/.config/rclone/rclone.conf
fi

# Функция для умного копирования
smart_copy() {
    local src=$1
    local dest=$2
    local label=$3

    # Проверяем, есть ли уже файлы в папке назначения
    if [ "$(ls -A $dest 2>/dev/null)" ]; then
        echo "--> $label: Files already exist. Skipping heavy download. Use rclone to check for updates..."
        # rclone быстро проверит размеры и докачает только если что-то изменилось
        rclone copy "$src" "$dest" --progress --max-depth 1 --size-only
    else
        echo "--> $label: Directory empty. Downloading..."
        rclone copy "$src" "$dest" --progress --transfers 8
    fi
}

# 2. Создание структуры папок
mkdir -p /workspace/ComfyUI/models/checkpoints
mkdir -p /workspace/ComfyUI/models/vae
mkdir -p /workspace/ComfyUI/models/clip_vision
mkdir -p /workspace/ComfyUI/models/loras
mkdir -p /workspace/ComfyUI/custom_nodes/comfyui_controlnet_aux/ckpts

# 3. Умное копирование моделей
smart_copy "gdrive:ComfyUI-Workspace/models/checkpoints/" "/workspace/ComfyUI/models/checkpoints/" "Checkpoints"
smart_copy "gdrive:ComfyUI-Workspace/models/vae/" "/workspace/ComfyUI/models/vae/" "VAE"
smart_copy "gdrive:ComfyUI-Workspace/models/clip_vision/" "/workspace/ComfyUI/models/clip_vision/" "CLIP Vision"
smart_copy "gdrive:ComfyUI-Workspace/models/loras/" "/workspace/ComfyUI/models/loras/" "LoRAs"
smart_copy "gdrive:ComfyUI-Workspace/models/annotators/" "/workspace/ComfyUI/custom_nodes/comfyui_controlnet_aux/ckpts/" "Annotators (YOLO/DWPose)"

# 4. Проверка целостности главной модели (минимум 15GB)
MAIN_MODEL="/workspace/ComfyUI/models/checkpoints/Wan21_SteadyDancer_fp8_e4m3fn_scaled_KJ.safetensors"
if [ -f "$MAIN_MODEL" ]; then
    SIZE=$(stat -c%s "$MAIN_MODEL")
    if [ "$SIZE" -lt 15000000000 ]; then
        echo "WARNING: Main model is corrupted (too small). Re-downloading..."
        rclone copy "gdrive:ComfyUI-Workspace/models/checkpoints/" "/workspace/ComfyUI/models/checkpoints/" --progress --ignore-existing
    else
        echo "SUCCESS: Main model integrity verified ($(du -sh $MAIN_MODEL))."
    fi
fi

echo "========================================="
echo "ComfyUI is ready to dance!"
echo "========================================="
