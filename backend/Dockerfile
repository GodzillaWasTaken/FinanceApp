FROM python:3.10-slim

# Set work directory
WORKDIR /app

RUN apt-get update \
    && apt-get -y install libpq-dev gcc

# Install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Expose port (default Django port)
EXPOSE 8000

# Start server
CMD ["python", "src/manage.py", "runserver", "0.0.0.0:8000"]