FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1
# Tesseract enables OCR of photographed reports; libgomp is needed by LightGBM
RUN apt-get update && apt-get install -y --no-install-recommends tesseract-ocr libgomp1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
# Train inside the image so model files always match the installed library versions
RUN python -m ml.train_all --fast && python -m scripts.generate_sample_reports

RUN useradd -m appuser && mkdir -p /app/instance && chown -R appuser /app
USER appuser
ENV PORT=8000
EXPOSE 8000
HEALTHCHECK CMD python -c "import os,urllib.request;urllib.request.urlopen(f'http://127.0.0.1:{os.environ.get(\"PORT\",\"8000\")}/api/health')" || exit 1
# PORT is injected by Render / Hugging Face Spaces / Railway; defaults to 8000
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000} --proxy-headers --forwarded-allow-ips='*'"]
