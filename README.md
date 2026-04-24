# dotfiles

Mi configuracion personal de desarrollo, multiplataforma (Windows, Linux, macOS).

Incluye: VS Code, PowerShell + Oh My Posh, Windows Terminal, Nerd Fonts.

## Instalacion rapida

### Windows (PowerShell como Admin)

```powershell
git clone https://github.com/ChristDev/dotfiles.git $HOME\dotfiles
cd $HOME\dotfiles
.\scripts\install.ps1
```

Para reset total de VS Code + reinstalar:

```powershell
.\scripts\install.ps1 -Reset
```

> Si PowerShell bloquea la ejecucion, habilita scripts con:
> `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned`

### Linux / macOS

```bash
git clone https://github.com/ChristDev/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x scripts/*.sh
./scripts/install.sh
```

Para reset total de VS Code + reinstalar:

```bash
./scripts/install.sh --reset
```

## Que instala cada script

### `install.ps1` (Windows)

| Paso | Que hace |
|------|----------|
| 1 | Instala PowerShell 7 (via winget) si no existe |
| 2 | Instala Oh My Posh (via winget) |
| 3 | Instala Nerd Font MesloLGL |
| 4 | Descarga pack de temas Oh My Posh |
| 5 | Instala modulos PS: PSReadLine, Terminal-Icons, z, posh-git |
| 6 | Copia perfil de PowerShell |
| 7 | Copia settings de Windows Terminal |
| 8 | Copia settings de VS Code |
| 9 | Instala extensiones de VS Code |

### `install.sh` (Linux / macOS)

| Paso | Que hace |
|------|----------|
| 1 | Instala Oh My Posh (via curl oficial) |
| 2 | Instala Nerd Font MesloLGL en la ruta correcta por SO |
| 3 | Descarga pack de temas Oh My Posh |
| 4 | Copia settings de VS Code |
| 5 | Instala extensiones de VS Code |
| 6 | Detecta shell (bash/zsh) y configura Oh My Posh + aliases |
| 7 | Copia perfil de PowerShell a `~/.config/powershell/` (si pwsh existe) |
| 8 | Detecta WSL y avisa si falta Nerd Font en Windows Terminal |

## Respaldar cambios

Despues de modificar settings desde VS Code, PowerShell o Windows Terminal:

```powershell
# Windows
.\scripts\backup.ps1
```

```bash
# Linux / macOS
./scripts/backup.sh
```

Luego:

```bash
git add .
git commit -m "update dotfiles"
git push
```

## Estructura

```
dotfiles/
├── README.md
├── .gitignore
├── vscode/
│   ├── settings.json                        # config VS Code
│   └── extensions.txt                       # extensiones
├── shell/
│   ├── config.bash                          # Oh My Posh + aliases para bash
│   └── config.zsh                           # Oh My Posh + aliases para zsh
├── powershell/
│   └── Microsoft.PowerShell_profile.ps1     # perfil Oh My Posh + modulos
├── windows-terminal/
│   └── settings.json                        # config Windows Terminal
└── scripts/
    ├── install.ps1                          # Windows: instala TODO
    ├── install.sh                           # Linux/Mac: instala lo que aplica
    ├── backup.ps1                           # Windows: respaldar configs
    └── backup.sh                            # Linux/Mac: respaldar configs
```

## Que incluye el perfil de PowerShell

- **Oh My Posh** con tema `kushal`
- **PSReadLine**: autocompletar predictivo en modo ListView
- **Terminal-Icons**: iconos en el ls
- **posh-git**: info de git en el prompt
- **z**: saltar a directorios frecuentes
- Alias utiles: `ll`, `grep`, `gs`, `ga`, `gc`, `gp`, `gl`, `glog`
- Funciones: `h` (historial), `hs` (buscar historial), `mkcd`, `..`, `...`

## Extensiones de VS Code

- `ms-dotnettools.csdevkit` — C# Dev Kit (.NET)
- `ms-dotnettools.csharp` — C# language support
- `dbaeumer.vscode-eslint` — ESLint para JS/TS
- `esbenp.prettier-vscode` — Formatter multi-lenguaje
- `angular.ng-template` — Angular Language Service
- `ms-mssql.mssql` — SQL Server
- `ms-azuretools.vscode-docker` — Docker
- `eamodio.gitlens` — Git supercharged
- `emmanuelbeziat.vscode-great-icons` — Tema de iconos

## Rutas del sistema

| Config | Windows | Linux | macOS |
|--------|---------|-------|-------|
| VS Code | `%APPDATA%\Code\User\` | `~/.config/Code/User/` | `~/Library/Application Support/Code/User/` |
| PowerShell | `$HOME\Documents\PowerShell\` | `~/.config/powershell/` | `~/.config/powershell/` |
| Windows Terminal | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_...\LocalState\` | N/A | N/A |
| Nerd Fonts | Sistema (via oh-my-posh) | `~/.local/share/fonts/` | `~/Library/Fonts/` |
| Temas Oh My Posh | `$HOME\Documents\PowerShell\posh-themes\` | `~/.poshthemes/` | `~/.poshthemes/` |

## Nota sobre Settings Sync

No uses Settings Sync de VS Code junto con este repo — elige uno solo.

Si tienes Settings Sync activo, apagalo antes:

```
Ctrl+Shift+P -> Settings Sync: Turn Off
```
