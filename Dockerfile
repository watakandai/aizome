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

# Set the PYTHONPATH for the project
ENV PYTHONPATH="/home:/home/specless:/home/cbfkit/src"

# Install Python dependencies
RUN uv pip install .

# Default command
CMD ["bash"]
