# ----- Stage 1: Builder -----
FROM python:3.10-slim AS builder

# Create non-root user
RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup

WORKDIR /app

# Install dependencies in a separate layer
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# ----- Stage 2: Runtime -----
FROM python:3.10-slim

WORKDIR /app

# Copy installed dependencies from builder
COPY --from=builder /root/.local /root/.local

# Add our code
COPY app.py .

# Set PATH for user-installed packages
ENV PATH=/root/.local/bin:$PATH

# Run as non-root
#USER appuser

EXPOSE 5000
CMD ["python", "app.py"]

