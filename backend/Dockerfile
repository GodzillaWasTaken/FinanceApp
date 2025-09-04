FROM python:3.10-slim

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update \
    && apt-get -y install libpq-dev gcc \
    && apt-get clean

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Cloud Run expects PORT env var
ENV PORT=8080

# Expose port (not strictly needed for Cloud Run, but useful locally)
EXPOSE 8080

# Start Gunicorn server
# adding /app/src to PYTHONPATH to ensure Django can find the project modules
ENV PYTHONPATH=/app/src  
CMD sh -c "gunicorn config.wsgi:application --bind 0.0.0.0:$PORT --workers 3"



