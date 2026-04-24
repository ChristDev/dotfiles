#!/usr/bin/env bash
# Instala configuracion de VS Code desde el repo dotfiles.
# Uso: ./install.sh [--reset]

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESET=false

# Parse args
for arg in "$@"; do
    case $arg in
        --reset) RESET=true ;;
    esac
done

# Detectar SO y carpeta de VS Code
case "$(uname -s)" in
    Linux*)  VSCODE_USER="$HOME/.config/Code/User" ;;
    Darwin*) VSCODE_USER="$HOME/Library/Application Support/Code/User" ;;
    *) echo "[X] SO no soportado"; exit 1 ;;
esac

echo "=== VS Code Setup ($(uname -s)) ==="

if [ "$RESET" = true ]; then
    echo "[!] Cerrando VS Code y borrando config..."
    pkill -f "Visual Studio Code" || true
    pkill -f "code" || true
    sleep 2
    rm -rf "$(dirname "$VSCODE_USER")"
    rm -rf "$HOME/.vscode"
fi

# Crear carpeta User
mkdir -p "$VSCODE_USER"

# Copiar settings
echo "[+] Copiando settings.json..."
cp "$REPO_ROOT/vscode/settings.json" "$VSCODE_USER/settings.json"

# Copiar keybindings si existe
if [ -f "$REPO_ROOT/vscode/keybindings.json" ]; then
    echo "[+] Copiando keybindings.json..."
    cp "$REPO_ROOT/vscode/keybindings.json" "$VSCODE_USER/keybindings.json"
fi

# Instalar extensiones
echo "[+] Instalando extensiones..."
while IFS= read -r ext; do
    ext=$(echo "$ext" | xargs)  # trim whitespace
    # Ignorar líneas vacías y comentarios
    [[ -z "$ext" || "$ext" =~ ^# ]] && continue
    echo "    -> $ext"
    code --install-extension "$ext" --force &>/dev/null
done < "$REPO_ROOT/vscode/extensions.txt"

echo ""
echo "[OK] Setup completo!"
echo "    Abre VS Code y haz: Ctrl+Shift+P -> Developer: Reload Window"
