# Use the official Playwright base image which includes necessary browser dependencies
# This is crucial for running the headless browser successfully in the cloud.
FROM mcr.microsoft.com/playwright:v1.40.0-focal

# Set the working directory inside the container
WORKDIR /app

# Copy the Python dependency files
COPY requirements.txt .

# Install Python packages
RUN python3 -m pip install --no-cache-dir -r requirements.txt
# Copy the entire application code
COPY . .

# Cloud services expose environment variable PORT (e.g., 8080 or 10000).
# Gunicorn must be told to listen on this port.
# We expose a default port (8080) for container configuration.
EXPOSE 8080

# Define the command to run the production-grade server (Gunicorn)
# The server listens on 0.0.0.0 and uses the port provided by the hosting service (defaulting to 8080).
# 'app:app' means run the Flask app instance named 'app' from the file 'app.py'
CMD ["gunicorn", "--bind", "0.0.0.0:$PORT", "app:app"]