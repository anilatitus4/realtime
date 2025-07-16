# Use official Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy files
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Use Gunicorn to serve Flask app
CMD ["gunicorn", "-b", ":8080", "app:app"]
