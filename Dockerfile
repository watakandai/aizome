# Use a specific digest of the Python image to ensure reproducibility
ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION}-slim as base

# Install required system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    graphviz \
    curl \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install uv using the official script
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Add uv to PATH
ENV PATH="/root/.local/bin:$PATH"

# Set the working directory
WORKDIR /home/specless

# Copy necessary project files
COPY pyproject.toml /home/specless/

# Install Python dependencies from pyproject.toml
RUN uv pip install .

# Generate Jupyter configuration (if needed)
RUN jupyter notebook --generate-config \
    && mkdir -p /home/specless/.jupyter \
    && echo "c.NotebookApp.ip = '0.0.0.0'\nc.NotebookApp.allow_root = True\nc.NotebookApp.open_browser = False" >> /home/specless/.jupyter/jupyter_notebook_config.py

# Expose Jupyter's default port
EXPOSE 8888

# Default command
CMD ["jupyter", "notebook", "--notebook-dir=/home/specless", "--no-browser", "--allow-root"]