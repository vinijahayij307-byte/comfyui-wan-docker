#!/bin/bash

echo "========================================="
echo "ComfyUI Wan 2.1 - Auto Setup"
echo "========================================="

# Настройка rclone для Google Drive
echo "Configuring rclone..."
mkdir -p ~/.config/rclone

# ВАЖНО: Замените YOUR_ACCESS_TOKEN и YOUR_REFRESH_TOKEN на ваши реальные токены!
cat > ~/.config/rclone/rclone.conf << 'EOF'
[gdrive]
type = drive
scope = drive
token = {"access_token":"YOUR_ACCESS_TOKEN","token_type":"Bearer","refresh_token":"YOUR_REFRESH_TOKEN","expiry":"2026-12-31T00:00:00Z"}
team_drive = 
EOF

# Копирование моделей с Google Drive
echo "Copying models from Google Drive..."
echo "This will take 5-10 minutes..."

rclone copy gdrive:ComfyUI-Workspace/models/checkpoints/ /workspace/ComfyUI/models/checkpoints/ --progress --transfers 8 --verbose
rclone copy gdrive:ComfyUI-Workspace/models/loras/ /workspace/ComfyUI/models/loras/ --progress --transfers 8 --verbose
rclone copy gdrive:ComfyUI-Workspace/models/vae/ /workspace/ComfyUI/models/vae/ --progress --transfers 8 --verbose
rclone copy gdrive:ComfyUI-Workspace/models/clip/ /workspace/ComfyUI/models/clip/ --progress --transfers 8 --verbose

echo "========================================="
echo "Models copied successfully!"
echo "========================================="

# Проверка что модели скопированы
echo "Checking models..."
ls -lh /workspace/ComfyUI/models/checkpoints/
ls -lh /workspace/ComfyUI/models/loras/

echo "========================================="
echo "ComfyUI is ready!"
echo "Access via Vast.ai port 8188"
echo "========================================="

# ComfyUI уже запущен из Docker CMD, но если нужно перезапустить:
# cd /workspace/ComfyUI
# python main.py --listen 0.0.0.0 --port 8188
