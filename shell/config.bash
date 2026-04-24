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

# `h` = buscar historial interactivo con fzf
# Ctrl+R tambien abre fzf si esta disponible
if command -v fzf &>/dev/null; then
    __fzf_history() {
        local cmd=$(HISTTIMEFORMAT= history | fzf --tac --no-sort | sed 's/^[ ]*[0-9]*[ ]*//')
        READLINE_LINE="$cmd"
        READLINE_POINT=${#cmd}
    }
    bind -x '"\C-r": __fzf_history'

    h() {
        local cmd=$(HISTTIMEFORMAT= history | fzf --tac --no-sort | sed 's/^[ ]*[0-9]*[ ]*//')
        if [[ -n "$cmd" ]]; then
            echo "$cmd"
            history -s "$cmd"
            eval "$cmd"
        fi
    }
else
    h() { history "${1:-50}"; }
fi

# `hs <palabra>` = buscar en historial
hs() { history | grep -i "$1"; }
