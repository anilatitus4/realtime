# Use official Python image as base
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy app code
COPY . .

# Set environment variable for Flask
ENV FLASK_APP=app.py

# Expose port 8080 (default for Cloud Run)
EXPOSE 8080

# Run the app
CMD ["flask", "run", "--host=0.0.0.0", "--port=8080"]
