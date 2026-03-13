#!/bin/bash

# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 24

# Verify the Node.js version:
node -v # Should print "v24.14.0".

# Download and install pnpm:
corepack enable pnpm

# Verify pnpm version:
pnpm -v

sudo apt install git -y

git clone https://github.com/linuxhsj/openclaw-zero-token.git

cd openclaw-zero-token

pnpm install

pnpm build

pnpm ui:build
