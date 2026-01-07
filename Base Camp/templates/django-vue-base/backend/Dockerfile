FROM ubuntu:latest
LABEL authors="ranzo"

ENTRYPOINT ["top", "-b"]
# Use the official lightweight Python image
FROM python:3.13-slim

# Set environment variables to prevent .pyc files and enable instant logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /code

# Install system dependencies for Postgres and networking
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the project files
COPY . /code/

# Expose Django's default port
EXPOSE 8000