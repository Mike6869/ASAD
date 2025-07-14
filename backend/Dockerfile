FROM python:3.8-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Установка системных зависимостей через apt-get
RUN apt-get update && apt-get install -y \
    inkscape \
    gcc \
    python3-dev \
    libxml2-dev \
    libxslt-dev \
    && rm -rf /var/lib/apt/lists/*

# Копирование и установка Python-зависимостей
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    python -m nltk.downloader stopwords punkt

# Копирование приложения
COPY app/ app/

# Запуск через Gunicorn
CMD [ "python3", "-m" , "gunicorn", "-w", "2", "app:app", "-b", "0.0.0.0:5000", "--timeout", "300"]