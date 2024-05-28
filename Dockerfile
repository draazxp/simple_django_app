# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variables to prevent Python from writing .pyc files
# and buffering stdout and stderr.
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Update package lists and install necessary dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements.txt file to the working directory
COPY requirements.txt /app/

# Install the dependencies without using cache
RUN pip3 install --upgrade pip \
    && pip3 install --no-cache-dir -r requirements.txt

# Copy the entire project to the working directory
COPY . /app/

# Expose the port that the app runs on
EXPOSE 8000

# Set the entry point for the container
ENTRYPOINT ["python3", "manage.py"]

# Default command when the container starts
CMD ["runserver", "0.0.0.0:8000"]
