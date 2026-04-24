# =============================================
#  PowerShell Profile - Christopher
# =============================================

# --- Oh My Posh ---
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    if ($IsWindows) {
        $PoshThemePath = "$HOME\Documents\PowerShell\posh-themes\kushal.omp.json"
    } else {
        $PoshThemePath = "$HOME/.poshthemes/kushal.omp.json"
    }
    if (Test-Path $PoshThemePath) {
        oh-my-posh init pwsh --config $PoshThemePath | Invoke-Expression
    } else {
        oh-my-posh init pwsh | Invoke-Expression
    }
}

# --- Módulos ---
if (Get-Module -ListAvailable -Name PSReadLine) { Import-Module PSReadLine }
if (Get-Module -ListAvailable -Name Terminal-Icons) { Import-Module Terminal-Icons }
if (Get-Module -ListAvailable -Name posh-git) { Import-Module posh-git }
if (Get-Module -ListAvailable -Name z) { Import-Module z }

# --- PSReadLine (solo si se cargo) ---
if (Get-Module PSReadLine) {
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineOption -HistoryNoDuplicates:$true
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineOption -MaximumHistoryCount 10000

    # --- Keybindings útiles ---
    # Tab = autocompletar menu interactivo
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

    # Flechas arriba/abajo = buscar en historial filtrando por lo que escribiste
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

    # Ctrl+D = borrar carácter o salir si está vacío
    Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

    # Flecha derecha = aceptar sugerencia completa
    Set-PSReadLineKeyHandler -Key RightArrow -Function ForwardChar

    # Ctrl+F = aceptar solo la próxima palabra de la sugerencia
    Set-PSReadLineKeyHandler -Key Ctrl+f -Function ForwardWord
}

# --- Alias útiles ---
Set-Alias ll Get-ChildItem
Set-Alias grep Select-String
Set-Alias which Get-Command
Set-Alias touch New-Item

# --- Funciones personalizadas ---

# `h` = ver historial con números (para luego ejecutar con Invoke-History)
function h {
    param([int]$count = 50)
    Get-History -Count $count | Format-Table -AutoSize
}

# `hs <palabra>` = buscar en historial
function hs {
    param([string]$search)
    Get-History | Where-Object { $_.CommandLine -like "*$search*" } | Format-Table -AutoSize
}

# `r <id>` = re-ejecutar comando del historial por ID
function r {
    param([int]$id)
    Invoke-History -Id $id
}

# `mkcd` = crear directorio y entrar
function mkcd {
    param([string]$path)
    New-Item -ItemType Directory -Path $path -Force | Out-Null
    Set-Location $path
}

# `..` y `...` para subir directorios
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }

# Git shortcuts rápidos
function gs { git status }
function ga { git add . }
function gc { param($msg) git commit -m $msg }
function gp { git push }
function gl { git pull }
function glog { git log --oneline --graph --decorate --all }

# --- Mensaje de bienvenida opcional ---
# Write-Host "PowerShell listo papi" -ForegroundColor Cyan
