FROM apache/beam_python3.11_sdk:2.54.0

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY pipeline.py .

ENTRYPOINT ["python", "pipeline.py"]
