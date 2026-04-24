<#
.SYNOPSIS
    Respalda config actual al repo dotfiles.
    Incluye: VS Code, perfil PowerShell, Windows Terminal.
#>
$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot

Write-Host ""
Write-Host "=== dotfiles Backup (Windows) ===" -ForegroundColor Cyan
Write-Host ""

# --- VS Code ---
$VSCodeUser = "$env:APPDATA\Code\User"

if (Test-Path "$VSCodeUser\settings.json") {
    Copy-Item "$VSCodeUser\settings.json" "$RepoRoot\vscode\settings.json" -Force
    Write-Host "[+] vscode/settings.json" -ForegroundColor Green
}

if (Test-Path "$VSCodeUser\keybindings.json") {
    Copy-Item "$VSCodeUser\keybindings.json" "$RepoRoot\vscode\keybindings.json" -Force
    Write-Host "[+] vscode/keybindings.json" -ForegroundColor Green
}

if (Get-Command code -ErrorAction SilentlyContinue) {
    code --list-extensions | Out-File "$RepoRoot\vscode\extensions.txt" -Encoding utf8NoBOM
    Write-Host "[+] vscode/extensions.txt" -ForegroundColor Green
}

# --- PowerShell profile ---
if (Test-Path $PROFILE) {
    Copy-Item $PROFILE "$RepoRoot\powershell\Microsoft.PowerShell_profile.ps1" -Force
    Write-Host "[+] powershell/Microsoft.PowerShell_profile.ps1" -ForegroundColor Green
}

# --- Windows Terminal ---
$wtSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $wtSettings) {
    Copy-Item $wtSettings "$RepoRoot\windows-terminal\settings.json" -Force
    Write-Host "[+] windows-terminal/settings.json" -ForegroundColor Green
}

Write-Host ""
Write-Host "[OK] Backup completo. Ahora:" -ForegroundColor Cyan
Write-Host "  git add ." -ForegroundColor White
Write-Host "  git commit -m `"update dotfiles`"" -ForegroundColor White
Write-Host "  git push" -ForegroundColor White
Write-Host ""
