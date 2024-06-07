# Use Python as the base image
FROM python:3.10-slim

# Set environment variables to prevent Python from writing .pyc files
# and buffering stdout and stderr.
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements.txt file to the working directory
COPY requirements.txt /app/

# Install the dependencies without using cache
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project to the working directory
COPY . /app/

# Expose the port that the app runs on
EXPOSE 8000

# Set the entry point for the container
ENTRYPOINT ["python", "manage.py"]

# Default command when the container starts
CMD ["runserver", "0.0.0.0:8000"]
