<#
.SYNOPSIS
    Instala configuracion completa del entorno dev desde el repo dotfiles.
    Incluye: PowerShell 7, Oh My Posh, Nerd Font, modulos PS, perfil PS,
    Windows Terminal settings, VS Code settings + extensiones.
.PARAMETER Reset
    Borra config actual de VS Code antes de instalar.
.EXAMPLE
    .\install.ps1
    .\install.ps1 -Reset
#>
param(
    [switch]$Reset
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  dotfiles - Setup completo (Windows)  " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------------
# 1. Reset VS Code (opcional)
# -----------------------------------------------
if ($Reset) {
    Write-Host "[!] Cerrando VS Code y borrando config..." -ForegroundColor Yellow
    Get-Process "Code" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
    Remove-Item "$env:APPDATA\Code" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$HOME\.vscode" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "    Config de VS Code eliminada." -ForegroundColor DarkGray
}

# -----------------------------------------------
# 2. PowerShell 7
# -----------------------------------------------
Write-Host "[1/9] PowerShell 7..." -ForegroundColor Green
if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    Write-Host "    Ya instalado: $(pwsh --version)" -ForegroundColor DarkGray
} else {
    Write-Host "    Instalando via winget..." -ForegroundColor DarkGray
    winget install --id Microsoft.PowerShell --source winget --accept-source-agreements --accept-package-agreements
    # Refrescar PATH para que pwsh esté disponible
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# -----------------------------------------------
# 3. Oh My Posh
# -----------------------------------------------
Write-Host "[2/9] Oh My Posh..." -ForegroundColor Green
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    Write-Host "    Ya instalado: $(oh-my-posh version)" -ForegroundColor DarkGray
} else {
    Write-Host "    Instalando via winget..." -ForegroundColor DarkGray
    winget install JanDeDobbeleer.OhMyPosh --source winget --accept-source-agreements --accept-package-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# -----------------------------------------------
# 4. Nerd Font (MesloLGL)
# -----------------------------------------------
Write-Host "[3/9] Nerd Font (MesloLGL)..." -ForegroundColor Green
$fontCheck = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -ErrorAction SilentlyContinue |
    Get-Member -MemberType NoteProperty |
    Where-Object { $_.Name -like "*MesloLGL Nerd*" -or $_.Name -like "*MesloLGLNerdFont*" }

if ($fontCheck) {
    Write-Host "    Ya instalada." -ForegroundColor DarkGray
} else {
    Write-Host "    Instalando via oh-my-posh..." -ForegroundColor DarkGray
    oh-my-posh font install Meslo
}

# -----------------------------------------------
# 5. Pack de temas Oh My Posh
# -----------------------------------------------
Write-Host "[4/9] Temas Oh My Posh..." -ForegroundColor Green
$ThemesDir = "$HOME\Documents\PowerShell\posh-themes"
if (Test-Path "$ThemesDir\kushal.omp.json") {
    Write-Host "    Ya descargados en $ThemesDir" -ForegroundColor DarkGray
} else {
    New-Item -ItemType Directory -Path $ThemesDir -Force | Out-Null
    $themesZip = "$env:TEMP\posh-themes.zip"
    Write-Host "    Descargando temas..." -ForegroundColor DarkGray
    Invoke-WebRequest -Uri "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip" -OutFile $themesZip
    Expand-Archive -Path $themesZip -DestinationPath $ThemesDir -Force
    Remove-Item $themesZip -ErrorAction SilentlyContinue
    Write-Host "    Temas extraidos en $ThemesDir" -ForegroundColor DarkGray
}

# -----------------------------------------------
# 6. Modulos de PowerShell
# -----------------------------------------------
Write-Host "[5/9] Modulos de PowerShell..." -ForegroundColor Green
$modules = @('PSReadLine', 'Terminal-Icons', 'z', 'posh-git')
foreach ($mod in $modules) {
    if (Get-Module -ListAvailable -Name $mod -ErrorAction SilentlyContinue) {
        Write-Host "    $mod - ya instalado" -ForegroundColor DarkGray
    } else {
        Write-Host "    $mod - instalando..." -ForegroundColor DarkGray
        Install-Module $mod -Scope CurrentUser -Force -AllowClobber -SkipPublisherCheck
    }
}

# -----------------------------------------------
# 7. Perfil de PowerShell
# -----------------------------------------------
Write-Host "[6/9] Perfil de PowerShell..." -ForegroundColor Green
$profileDir = Split-Path $PROFILE
New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
Copy-Item "$RepoRoot\powershell\Microsoft.PowerShell_profile.ps1" $PROFILE -Force
Write-Host "    Copiado a $PROFILE" -ForegroundColor DarkGray

# -----------------------------------------------
# 8. Windows Terminal settings
# -----------------------------------------------
Write-Host "[7/9] Windows Terminal..." -ForegroundColor Green
$wtSettingsDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
if (Test-Path $wtSettingsDir) {
    Copy-Item "$RepoRoot\windows-terminal\settings.json" "$wtSettingsDir\settings.json" -Force
    Write-Host "    Settings copiados." -ForegroundColor DarkGray
} else {
    Write-Host "    Windows Terminal no encontrado, saltando." -ForegroundColor Yellow
}

# -----------------------------------------------
# 9. VS Code settings
# -----------------------------------------------
Write-Host "[8/9] VS Code settings..." -ForegroundColor Green
$VSCodeUser = "$env:APPDATA\Code\User"
New-Item -ItemType Directory -Path $VSCodeUser -Force | Out-Null
Copy-Item "$RepoRoot\vscode\settings.json" "$VSCodeUser\settings.json" -Force
Write-Host "    settings.json copiado." -ForegroundColor DarkGray

if (Test-Path "$RepoRoot\vscode\keybindings.json") {
    Copy-Item "$RepoRoot\vscode\keybindings.json" "$VSCodeUser\keybindings.json" -Force
    Write-Host "    keybindings.json copiado." -ForegroundColor DarkGray
}

# -----------------------------------------------
# 10. Extensiones de VS Code
# -----------------------------------------------
Write-Host "[9/9] Extensiones de VS Code..." -ForegroundColor Green
if (Get-Command code -ErrorAction SilentlyContinue) {
    Get-Content "$RepoRoot\vscode\extensions.txt" | ForEach-Object {
        $ext = $_.Trim()
        if ($ext -and -not $ext.StartsWith("#")) {
            Write-Host "    -> $ext" -ForegroundColor DarkGray
            code --install-extension $ext --force 2>&1 | Out-Null
        }
    }
} else {
    Write-Host "    VS Code CLI no encontrado. Instala VS Code primero." -ForegroundColor Yellow
}

# -----------------------------------------------
# Done
# -----------------------------------------------
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup completo!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Siguiente paso:" -ForegroundColor Cyan
Write-Host "  1. Cierra y abre Windows Terminal" -ForegroundColor White
Write-Host "  2. En VS Code: Ctrl+Shift+P -> Developer: Reload Window" -ForegroundColor White
Write-Host ""
