# Use the official Playwright base image which includes necessary browser dependencies
# This is crucial for running the headless browser successfully in the cloud.
FROM mcr.microsoft.com/playwright:v1.40.0-focal

# Set the working directory inside the container
WORKDIR /app

# Copy the Python dependency files
COPY requirements.txt .

# --- CRITICAL FIX: Install Python's package manager (pip) ---
# The base image has Python 3 but often lacks the pip module, causing the "No module named pip" error.
# This command updates the package list and installs python3-pip.
RUN apt-get update && apt-get install -y python3-pip

# Install Python packages using the corrected command
RUN python3 -m pip install --no-cache-dir -r requirements.txt

# Copy the entire application code
COPY . .

# Cloud services expose environment variable PORT (e.g., 8080 or 10000).
# We expose a default port (8080) for container configuration.
EXPOSE 8080

# Define the command to run the production-grade server (Gunicorn)
# The server listens on 0.0.0.0 and uses the port provided by the hosting service (defaulting to 8080).
# 'app:app' means run the Flask app instance named 'app' from the file 'app.py'
CMD ["gunicorn", "--bind", "0.0.0.0:$PORT", "app:app"]