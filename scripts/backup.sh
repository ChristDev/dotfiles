#!/usr/bin/env bash
# Respalda config actual de VS Code al repo dotfiles.

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

case "$(uname -s)" in
    Linux*)  VSCODE_USER="$HOME/.config/Code/User" ;;
    Darwin*) VSCODE_USER="$HOME/Library/Application Support/Code/User" ;;
    *) echo "[X] SO no soportado"; exit 1 ;;
esac

echo "=== VS Code Backup ($(uname -s)) ==="

cp "$VSCODE_USER/settings.json" "$REPO_ROOT/vscode/settings.json"
echo "[+] settings.json respaldado"

if [ -f "$VSCODE_USER/keybindings.json" ]; then
    cp "$VSCODE_USER/keybindings.json" "$REPO_ROOT/vscode/keybindings.json"
    echo "[+] keybindings.json respaldado"
fi

code --list-extensions > "$REPO_ROOT/vscode/extensions.txt"
echo "[+] extensions.txt actualizado"

echo ""
echo "[OK] Backup completo. No olvides hacer git commit + push."
