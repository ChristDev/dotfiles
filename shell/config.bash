# =============================================
#  Bash Config - dotfiles (Christopher)
#  Sourced from ~/.bashrc por install.sh
# =============================================

# --- Oh My Posh ---
if command -v oh-my-posh &>/dev/null; then
    POSH_THEME="$HOME/.poshthemes/kushal.omp.json"
    if [ -f "$POSH_THEME" ]; then
        eval "$(oh-my-posh init bash --config "$POSH_THEME")"
    else
        eval "$(oh-my-posh init bash)"
    fi
fi

# --- Git shortcuts ---
alias gs='git status'
alias ga='git add .'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate --all'
gc() { git commit -m "$*"; }

# --- Navegacion ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -lAh --color=auto'

# --- Funciones ---
mkcd() { mkdir -p "$1" && cd "$1"; }

# `h` = ver historial
h() { history "${1:-50}"; }

# `hs <palabra>` = buscar en historial
hs() { history | grep -i "$1"; }
