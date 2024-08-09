#!/bin/bash

set -e

# Default value for FlashInfer
DEFAULT_FLASHINFER_ORG="flashinfer-ai"
DEFAULT_FLASHINFER_BRANCH="main"
DEFAULT_CUDA_ARCH="8.0"

# Read GitHub organization/username
read -p "Enter GitHub organization/username for FlashInfer (default: $DEFAULT_FLASHINFER_ORG): " FLASHINFER_ORG
FLASHINFER_ORG=${FLASHINFER_ORG:-$DEFAULT_FLASHINFER_ORG}

# Read FlashInfer branch
read -p "Enter FlashInfer branch (default: $DEFAULT_FLASHINFER_BRANCH): " FLASHINFER_BRANCH
FLASHINFER_BRANCH=${FLASHINFER_BRANCH:-$DEFAULT_FLASHINFER_BRANCH}

# Read CUDA architecture version
read -p "Enter CUDA architecture version (default: $DEFAULT_CUDA_ARCH, example: 9.0+PTX): " CUDA_ARCH
CUDA_ARCH=${CUDA_ARCH:-$DEFAULT_CUDA_ARCH}

# Clone SGL repository (using default branch)
git clone --depth=1 --single-branch https://github.com/sgl-project/sglang.git
cd sglang

# Install SGL
pip install --upgrade pip && pip install -e "python[all]"

# Install unzip
apt update && apt install unzip -y

# Install Ninja
wget https://github.com/ninja-build/ninja/releases/download/v1.12.1/ninja-linux.zip
unzip ninja-linux.zip
chmod +x ninja
mv ninja /usr/local/bin

# Clone FlashInfer repository with specified organization and branch
git clone -b "$FLASHINFER_BRANCH" "https://github.com/$FLASHINFER_ORG/flashinfer.git" --recursive
cd flashinfer/python

# Set CUDA architecture and build
export TORCH_CUDA_ARCH_LIST=$CUDA_ARCH
pip install ninja numpy
pip install --upgrade setuptools==69.5.1 wheel build
python -m build --no-isolation

echo "Build FlashInfer complete!"
