# =============================================
#  Zsh Config - dotfiles (Christopher)
#  Sourced from ~/.zshrc por install.sh
# =============================================
# Nota: si ya tienes un .zshrc completo (Oh My Zsh, p10k, aliases),
# este archivo solo agrega Oh My Posh cuando no hay otro prompt manager.
# No sobreescribe aliases ni funciones existentes.

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
