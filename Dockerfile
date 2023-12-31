# Official Python runtime as a parent image
FROM python:3.9

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# The purpose of copying the requirements.txt file first is to leverage Docker's build cache. 
# This step ensures that Docker will cache the layers up to this point if the requirements.txt file hasn't changed. 
# This helps speed up the Docker build process for subsequent builds, especially when the dependencies haven't changed. 
# If the dependencies change, Docker will invalidate the cache from this point onward, and it will re-run the steps involving the dependencies.
COPY requirements.txt /app/

# Install any dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the content of the local src directory to the working directory
COPY . /app/

RUN pre-commit install

# Run the application
# For production (Does not support serving static files)
# CMD ["gunicorn", "--bind", "0.0.0.0:8000", "gemini_api.wsgi:application", "--reload"] # --reload for listening to source code changes and restart right after

# OR

# Lightweight django inbuilt server for development (Not recommended for production)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
