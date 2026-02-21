# --- Stage 1: Builder ---
FROM python:3.11-slim AS builder

WORKDIR /build

# Install dependencies into a local folder
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


# --- Stage 2: Final Runtime ---
FROM python:3.11-slim

# Copy the installed packages from the builder stage
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy the application code
WORKDIR /app
COPY app.py .
COPY requirements.txt .

# Inform Docker that the container listens on 5001
EXPOSE 5001

# Run app
CMD ["python", "app.py"]