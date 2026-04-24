#!/usr/bin/env bash
# ========================================
#  dotfiles - Setup completo (Linux/Mac)
# ========================================
# Instala: Oh My Posh, Nerd Font (MesloLGL), temas posh,
# VS Code settings + extensiones, perfil PowerShell (si pwsh existe).
#
# Uso: ./install.sh [--reset]

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESET=false

for arg in "$@"; do
    case $arg in
        --reset) RESET=true ;;
    esac
done

# --- Detectar SO ---
OS="$(uname -s)"
case "$OS" in
    Linux*)
        VSCODE_USER="$HOME/.config/Code/User"
        FONT_DIR="$HOME/.local/share/fonts"
        ;;
    Darwin*)
        VSCODE_USER="$HOME/Library/Application Support/Code/User"
        FONT_DIR="$HOME/Library/Fonts"
        ;;
    *)
        echo "[X] SO no soportado: $OS"
        exit 1
        ;;
esac

echo ""
echo "========================================"
echo "  dotfiles - Setup completo ($OS)"
echo "========================================"
echo ""

# -----------------------------------------------
# 1. Reset VS Code (opcional)
# -----------------------------------------------
if [ "$RESET" = true ]; then
    echo "[!] Cerrando VS Code y borrando config..."
    pkill -f "Visual Studio Code" 2>/dev/null || true
    pkill -f "code" 2>/dev/null || true
    sleep 2
    rm -rf "$(dirname "$VSCODE_USER")"
    rm -rf "$HOME/.vscode"
    echo "    Config de VS Code eliminada."
fi

# -----------------------------------------------
# 2. Oh My Posh
# -----------------------------------------------
echo "[1/6] Oh My Posh..."
if command -v oh-my-posh &>/dev/null; then
    echo "    Ya instalado: $(oh-my-posh version)"
else
    echo "    Instalando..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
fi

# -----------------------------------------------
# 3. Nerd Font (MesloLGL)
# -----------------------------------------------
echo "[2/6] Nerd Font (MesloLGL)..."
if fc-list 2>/dev/null | grep -qi "MesloLGL Nerd" || ls "$FONT_DIR"/MesloLGL* &>/dev/null; then
    echo "    Ya instalada."
else
    echo "    Descargando..."
    mkdir -p "$FONT_DIR"
    FONT_ZIP="/tmp/MesloNerdFont.zip"
    curl -fLo "$FONT_ZIP" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
    unzip -o "$FONT_ZIP" -d "$FONT_DIR"
    rm -f "$FONT_ZIP"
    if [ "$OS" = "Linux" ]; then
        echo "    Actualizando cache de fuentes..."
        fc-cache -f 2>/dev/null || true
    fi
fi

# -----------------------------------------------
# 4. Temas Oh My Posh
# -----------------------------------------------
echo "[3/6] Temas Oh My Posh..."
THEMES_DIR="$HOME/.poshthemes"
if [ -f "$THEMES_DIR/kushal.omp.json" ]; then
    echo "    Ya descargados en $THEMES_DIR"
else
    mkdir -p "$THEMES_DIR"
    echo "    Descargando temas..."
    curl -fLo /tmp/posh-themes.zip "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip"
    unzip -o /tmp/posh-themes.zip -d "$THEMES_DIR"
    rm -f /tmp/posh-themes.zip
    chmod u+rw "$THEMES_DIR"/*.omp.* 2>/dev/null || true
fi

# -----------------------------------------------
# 5. VS Code settings + extensiones
# -----------------------------------------------
echo "[4/6] VS Code settings..."
mkdir -p "$VSCODE_USER"
cp "$REPO_ROOT/vscode/settings.json" "$VSCODE_USER/settings.json"
echo "    settings.json copiado."

if [ -f "$REPO_ROOT/vscode/keybindings.json" ]; then
    cp "$REPO_ROOT/vscode/keybindings.json" "$VSCODE_USER/keybindings.json"
    echo "    keybindings.json copiado."
fi

echo "[5/6] Extensiones de VS Code..."
if command -v code &>/dev/null; then
    while IFS= read -r ext; do
        ext=$(echo "$ext" | xargs)
        [[ -z "$ext" || "$ext" =~ ^# ]] && continue
        echo "    -> $ext"
        code --install-extension "$ext" --force &>/dev/null || true
    done < "$REPO_ROOT/vscode/extensions.txt"
else
    echo "    VS Code CLI no encontrado. Instala VS Code primero."
fi

# -----------------------------------------------
# 6. Perfil de PowerShell (si pwsh existe)
# -----------------------------------------------
echo "[6/6] Perfil de PowerShell..."
if command -v pwsh &>/dev/null; then
    PS_PROFILE_DIR="$HOME/.config/powershell"
    mkdir -p "$PS_PROFILE_DIR"
    cp "$REPO_ROOT/powershell/Microsoft.PowerShell_profile.ps1" "$PS_PROFILE_DIR/Microsoft.PowerShell_profile.ps1"
    echo "    Copiado a $PS_PROFILE_DIR/"
    echo "    Nota: el perfil referencia temas en \$HOME/Documents/PowerShell/posh-themes/"
    echo "    En Linux los temas estan en ~/.poshthemes/ - ajusta el path si usas pwsh aqui."
else
    echo "    pwsh no encontrado, saltando."
fi

# -----------------------------------------------
# Done
# -----------------------------------------------
echo ""
echo "========================================"
echo "  Setup completo!"
echo "========================================"
echo ""
echo "Siguiente paso:"
echo "  - Cierra y abre tu terminal"
echo "  - En VS Code: Ctrl+Shift+P -> Developer: Reload Window"
echo ""
