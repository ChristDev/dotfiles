#!/usr/bin/env bash
# ========================================
#  dotfiles Backup (Linux/Mac)
# ========================================
# Respalda config actual al repo dotfiles.

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

case "$(uname -s)" in
    Linux*)  VSCODE_USER="$HOME/.config/Code/User" ;;
    Darwin*) VSCODE_USER="$HOME/Library/Application Support/Code/User" ;;
    *) echo "[X] SO no soportado"; exit 1 ;;
esac

echo ""
echo "=== dotfiles Backup ($(uname -s)) ==="
echo ""

# --- VS Code ---
if [ -f "$VSCODE_USER/settings.json" ]; then
    cp "$VSCODE_USER/settings.json" "$REPO_ROOT/vscode/settings.json"
    echo "[+] vscode/settings.json"
fi

if [ -f "$VSCODE_USER/keybindings.json" ]; then
    cp "$VSCODE_USER/keybindings.json" "$REPO_ROOT/vscode/keybindings.json"
    echo "[+] vscode/keybindings.json"
fi

if command -v code &>/dev/null; then
    code --list-extensions > "$REPO_ROOT/vscode/extensions.txt"
    echo "[+] vscode/extensions.txt"
fi

# --- PowerShell profile (si pwsh existe) ---
if command -v pwsh &>/dev/null; then
    PS_PROFILE="$HOME/.config/powershell/Microsoft.PowerShell_profile.ps1"
    if [ -f "$PS_PROFILE" ]; then
        cp "$PS_PROFILE" "$REPO_ROOT/powershell/Microsoft.PowerShell_profile.ps1"
        echo "[+] powershell/Microsoft.PowerShell_profile.ps1"
    fi
fi

echo ""
echo "[OK] Backup completo. Ahora:"
echo "  git add ."
echo "  git commit -m \"update dotfiles\""
echo "  git push"
echo ""
