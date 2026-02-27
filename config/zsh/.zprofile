# Homebrew (Apple Silicon: /opt/homebrew, Intel: /usr/local, Linux: /home/linuxbrew/.linuxbrew)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv zsh)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
