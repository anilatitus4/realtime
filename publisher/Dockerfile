# Use Python base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirement and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your app code
COPY app.py .

# ✅ Expose port 8080 for Cloud Run
EXPOSE 8080

# ✅ Run Flask directly
CMD ["python", "app.py"]
