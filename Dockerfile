# Use a lightweight Python base image to keep the final size small
FROM python:3.9-slim

# Set the working directory inside the container for all subsequent commands
WORKDIR /app

# Install system dependencies required for compiling mysqlclient
# We clean up apt logs afterward to reduce the image layer size
RUN apt-get update \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first to leverage Docker's build cache
COPY requirements.txt .

# Install Python dependencies and the MySQL driver for Python
RUN pip install --no-cache-dir -r requirements.txt mysqlclient

# Copy the rest of the application source code into the container
COPY . .

# Document that the container listens on port 8000
EXPOSE 8000

# Specify the default command to run your Flask or Django application
CMD ["python", "app.py"]
