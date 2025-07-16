FROM gcr.io/dataflow-templates-base/python3-template-launcher-base

# Set working directory
WORKDIR /dataflow/template

# Copy pipeline code and requirements
COPY main.py .
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set the entrypoint
ENTRYPOINT ["python", "main.py"]
