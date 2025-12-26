#!/bin/bash

# Install bash-my-aws to ${BMA_HOME:-$HOME/.bash-my-aws}
BMA_HOME="${BMA_HOME:-$HOME/.bash-my-aws}"

# Check if already installed
if [ -d "$BMA_HOME/.git" ]; then
  echo "bash-my-aws already installed at $BMA_HOME"
  exit 0
fi

# Clone the repository
echo "Installing bash-my-aws to $BMA_HOME..."
if git clone https://github.com/bash-my-aws/bash-my-aws.git "$BMA_HOME"; then
  echo "bash-my-aws installed successfully"
else
  echo "Failed to install bash-my-aws" >&2
  exit 1
fi
