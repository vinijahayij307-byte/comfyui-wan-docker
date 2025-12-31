# ComfyUI Wan 2.1 Docker Image

Docker образ для запуска ComfyUI с Wan 2.1 Steady Dancer на Vast.ai и других GPU cloud платформах.

## 🚀 Возможности

- ✅ ComfyUI с предустановленными custom nodes
- ✅ Поддержка RTX 5090 (Sage Attention)
- ✅ ComfyUI-PainterI2V (fix slow motion)
- ✅ ComfyUI-TripleKSampler
- ✅ ComfyUI-Manager
- ✅ CUDA 12.4 + cuDNN 9
- ✅ PyTorch 2.5.1

## 📦 Включенные компоненты

- **Base:** PyTorch 2.5.1 + CUDA 12.4
- **ComfyUI:** Latest version
- **Custom Nodes:**
  - ComfyUI-Manager
  - ComfyUI-PainterI2V
  - ComfyUI-TripleKSampler
- **Оптимизации:**
  - Sage Attention для RTX 5090
  - Triton

## 🔧 Использование на Vast.ai

### 1. Получите токен Google Drive

На локальном компьютере:
```bash
rclone authorize "drive"
```

Скопируйте JSON токен.

### 2. Настройте Vast.ai Instance

**Docker Image:**
```
ghcr.io/ВАШ_USERNAME/comfyui-wan-docker:latest
```

**On-start Script:** (вставьте содержимое startup.sh с вашим токеном)

### 3. Подключитесь

После запуска instance:
```
http://ВАШ_IP:8188
```

## 📂 Структура Google Drive

```
ComfyUI-Workspace/
└── models/
    ├── checkpoints/
    │   └── Wan21_SteadyDancer_fp8_e4m3fn_scaled_KJ.safetensors
    ├── loras/
    │   ├── 2.2-Lightning-I2V-1030-H.safetensors
    │   ├── 2.2-Lightning-I2V-1022-L.safetensors
    │   └── pusa_v1.safetensors
    ├── vae/
    └── clip/
        └── clip_vision_model.safetensors
```

## ⏱️ Время запуска

- Pull Docker image (первый раз): 5-8 мин
- Запуск контейнера: 30 сек
- Копирование моделей: 5-10 мин
- **ИТОГО:** ~10-15 минут

## 🔨 Локальная сборка

```bash
git clone https://github.com/ВАШ_USERNAME/comfyui-wan-docker.git
cd comfyui-wan-docker
docker build -t comfyui-wan .
docker run -p 8188:8188 comfyui-wan
```

## 📝 Лицензия

MIT License

## 🙏 Благодарности

- ComfyUI
- Wan Video Team
- LightX2V
- PainterI2V
