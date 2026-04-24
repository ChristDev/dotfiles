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

# `h` = buscar historial interactivo con fzf (si existe), sino lista
if command -v fzf &>/dev/null; then
    h() {
        local cmd=$(history | fzf --tac | sed 's/^[ ]*[0-9]*[ ]*//')
        if [[ -n "$cmd" ]]; then
            # Poner el comando en la linea de input para editar/confirmar
            bind '"\e[0n": redraw-current-line'
            READLINE_LINE="$cmd"
            READLINE_POINT=${#cmd}
        fi
    }
else
    h() { history "${1:-50}"; }
fi

# `hs <palabra>` = buscar en historial
hs() { history | grep -i "$1"; }
