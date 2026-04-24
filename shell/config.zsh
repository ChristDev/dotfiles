# =============================================
#  Zsh Config - dotfiles (Christopher)
#  Sourced from ~/.zshrc por install.sh
# =============================================

# --- Oh My Posh (solo si no hay otro prompt manager como p10k) ---
if ! typeset -f p10k &>/dev/null && ! [[ -v POWERLEVEL9K_INSTANT_PROMPT ]]; then
    if command -v oh-my-posh &>/dev/null; then
        POSH_THEME="$HOME/.poshthemes/kushal.omp.json"
        if [ -f "$POSH_THEME" ]; then
            eval "$(oh-my-posh init zsh --config "$POSH_THEME")"
        else
            eval "$(oh-my-posh init zsh)"
        fi
    fi
fi

# --- Git shortcuts ---
alias gs='git status'
alias ga='git add .'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate --all'
unalias gc 2>/dev/null; function gc() { git commit -m "$*"; }

# --- Navegacion ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -lAh --color=auto 2>/dev/null || ls -lAhG'

# --- Funciones ---
mkcd() { mkdir -p "$1" && cd "$1"; }

# `h` = ver historial (zsh usa -N para las ultimas N entradas)
h() { history -${1:-50}; }

# `hs <palabra>` = buscar en historial
hs() { history 1 | grep -i "$1"; }
