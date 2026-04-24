<#
.SYNOPSIS
    Respalda config actual de VS Code al repo dotfiles.
#>
$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$VSCodeUser = "$env:APPDATA\Code\User"

Write-Host "=== VS Code Backup (Windows) ===" -ForegroundColor Cyan

Copy-Item "$VSCodeUser\settings.json" "$RepoRoot\vscode\settings.json" -Force
Write-Host "[+] settings.json respaldado" -ForegroundColor Green

if (Test-Path "$VSCodeUser\keybindings.json") {
    Copy-Item "$VSCodeUser\keybindings.json" "$RepoRoot\vscode\keybindings.json" -Force
    Write-Host "[+] keybindings.json respaldado" -ForegroundColor Green
}

code --list-extensions | Out-File "$RepoRoot\vscode\extensions.txt" -Encoding utf8
Write-Host "[+] extensions.txt actualizado" -ForegroundColor Green

Write-Host ""
Write-Host "[OK] Backup completo. No olvides hacer git commit + push." -ForegroundColor Cyan
