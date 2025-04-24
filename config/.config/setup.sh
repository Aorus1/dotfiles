#!/usr/bin/env bash
set -e

# Install npm-based language servers
for pkg in bash-language-server dockerfile-language-server-nodejs yaml-language-server; do
    if ! npm list -g --depth=0 | grep -q "$pkg"; then
        npm install -g "$pkg"
    else
        echo "$pkg already installed"
    fi
done

# Install lua-language-server if missing
if ! command -v lua-language-server &> /dev/null; then
    brew install lua-language-server
else
    echo "lua-language-server already installed"
fi
