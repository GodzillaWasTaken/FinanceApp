# Base image
FROM python:3.10-slim

# Set work directory
WORKDIR /app

# Install system dependencies needed for building Python packages
RUN apt-get update \
    && apt-get -y install libpq-dev gcc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Fix setuptools version issue (false positive vulnerability alert)
RUN python -m ensurepip --upgrade && pip install --upgrade pip setuptools

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Remove build dependencies to reduce image size
RUN apt-get remove -y gcc \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the rest of the project files
COPY . .

# Cloud Run expects PORT env var
ENV PORT=8080

# Expose port (optional locally)
EXPOSE 8080

# Ensure Django can find project modules
ENV PYTHONPATH=/app/src

# Start Gunicorn server
CMD ["sh", "-c", "gunicorn config.wsgi:application --bind 0.0.0.0:$PORT --workers 3"]

