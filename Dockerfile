FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

LABEL container = "praca-inzynierska"

ARG PYTHON_VERSION=3.11
ARG JAVA_VERSION=17

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64 \
    PYSPARK_PYTHON=python3.11 \
    PYSPARK_DRIVER_PYTHON=python3.11

RUN apt-get update && apt-get install -y --no-install-recommends \
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-dev \
    python3-pip \
    openjdk-${JAVA_VERSION}-jdk-headless \
    curl \
    wget \
    git \
    vim \
    build-essential \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python \
    /usr/bin/python${PYTHON_VERSION} 1

WORKDIR /workspace

COPY requirements.txt .

RUN python -m pip install --upgrade pip && \
    python -m pip install torch==2.3.0 --index-url https://download.pytorch.org/whl/cu121 && \
    python -m pip install -r requirements.txt

RUN python -m pip install https://github.com/explosion/spacy-models/releases/download/es_core_news_md-3.7.0/es_core_news_md-3.7.0.tar.gz

EXPOSE 8888 6006

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", \
     "--no-browser", "--allow-root", "--NotebookApp.token=''"]
