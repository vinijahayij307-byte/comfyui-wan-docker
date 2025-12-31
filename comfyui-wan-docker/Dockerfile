FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-devel

WORKDIR /workspace

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    nano \
    screen \
    && rm -rf /var/lib/apt/lists/*

# Установка rclone
RUN curl https://rclone.org/install.sh | bash

# Клонирование ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd ComfyUI && \
    pip install --no-cache-dir -r requirements.txt

# Установка Sage Attention для RTX 5090
RUN pip install --no-cache-dir sageattention triton

# Установка Custom Nodes
WORKDIR /workspace/ComfyUI/custom_nodes

RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git && \
    cd ComfyUI-Manager && \
    pip install --no-cache-dir -r requirements.txt

RUN git clone https://github.com/princepainter/ComfyUI-PainterI2V.git && \
    cd ComfyUI-PainterI2V && \
    pip install --no-cache-dir -r requirements.txt || true

RUN git clone https://github.com/VraethrDalkr/ComfyUI-TripleKSampler.git && \
    cd ComfyUI-TripleKSampler && \
    pip install --no-cache-dir -r requirements.txt || true

WORKDIR /workspace/ComfyUI

# Создание директорий для моделей
RUN mkdir -p models/checkpoints models/loras models/vae models/clip

# Expose port
EXPOSE 8188

# Entrypoint
CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188", "--preview-method", "taesd"]
