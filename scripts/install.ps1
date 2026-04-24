<#
.SYNOPSIS
    Instala configuracion de VS Code desde el repo dotfiles.
.PARAMETER Reset
    Borra config actual antes de instalar.
.EXAMPLE
    .\install.ps1
    .\install.ps1 -Reset
#>
param(
    [switch]$Reset
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$VSCodeUser = "$env:APPDATA\Code\User"

Write-Host "=== VS Code Setup (Windows) ===" -ForegroundColor Cyan

if ($Reset) {
    Write-Host "[!] Cerrando VS Code y borrando config..." -ForegroundColor Yellow
    Get-Process "Code" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
    Remove-Item "$env:APPDATA\Code" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$HOME\.vscode" -Recurse -Force -ErrorAction SilentlyContinue
}

# Crear carpeta User si no existe
New-Item -ItemType Directory -Path $VSCodeUser -Force | Out-Null

# Copiar settings
Write-Host "[+] Copiando settings.json..." -ForegroundColor Green
Copy-Item "$RepoRoot\vscode\settings.json" "$VSCodeUser\settings.json" -Force

# Copiar keybindings (si existe)
if (Test-Path "$RepoRoot\vscode\keybindings.json") {
    Write-Host "[+] Copiando keybindings.json..." -ForegroundColor Green
    Copy-Item "$RepoRoot\vscode\keybindings.json" "$VSCodeUser\keybindings.json" -Force
}

# Instalar extensiones
Write-Host "[+] Instalando extensiones..." -ForegroundColor Green
Get-Content "$RepoRoot\vscode\extensions.txt" | ForEach-Object {
    $ext = $_.Trim()
    if ($ext -and -not $ext.StartsWith("#")) {
        Write-Host "    -> $ext" -ForegroundColor DarkGray
        code --install-extension $ext --force 2>&1 | Out-Null
    }
}

Write-Host ""
Write-Host "[OK] Setup completo!" -ForegroundColor Green
Write-Host "    Abre VS Code y haz: Ctrl+Shift+P -> Developer: Reload Window" -ForegroundColor Cyan
