# dotfiles

Mi configuración personal de VS Code, multiplataforma (Windows, Linux, macOS).

## Instalación rápida

### Windows (PowerShell)

```powershell
git clone https://github.com/ChristDev/dotfiles.git $HOME\dotfiles
cd $HOME\dotfiles
.\scripts\install.ps1
```

Para reset total + reinstalar:

```powershell
.\scripts\install.ps1 -Reset
```

> Si PowerShell bloquea la ejecución, habilita scripts con:
> `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned`

### Linux / macOS

```bash
git clone https://github.com/ChristDev/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x scripts/*.sh
./scripts/install.sh
```

Para reset total + reinstalar:

```bash
./scripts/install.sh --reset
```

## Respaldar cambios

Después de instalar nuevas extensiones o modificar settings desde VS Code:

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
git commit -m "update vscode config"
git push
```

## Estructura

```
dotfiles/
├── README.md
├── vscode/
│   ├── settings.json     # configuración principal
│   └── extensions.txt    # extensiones esenciales
└── scripts/
    ├── install.ps1       # Windows - instalar
    ├── install.sh        # Linux/Mac - instalar
    ├── backup.ps1        # Windows - respaldar
    └── backup.sh         # Linux/Mac - respaldar
```

## Extensiones incluidas

- `ms-dotnettools.csdevkit` — C# Dev Kit (.NET 8)
- `ms-dotnettools.csharp` — C# language support
- `dbaeumer.vscode-eslint` — ESLint para JS/TS
- `esbenp.prettier-vscode` — Formatter multi-lenguaje
- `angular.ng-template` — Angular Language Service
- `ms-mssql.mssql` — SQL Server
- `ms-azuretools.vscode-docker` — Docker
- `eamodio.gitlens` — Git supercharged
- `emmanuelbeziat.vscode-great-icons` — Tema de íconos

## Rutas por sistema operativo

VS Code guarda la config del usuario en:

- **Windows:** `%APPDATA%\Code\User\`
- **Linux:** `~/.config/Code/User/`
- **macOS:** `~/Library/Application Support/Code/User/`

Los scripts detectan el SO automáticamente, no hay que preocuparse.

## Nota sobre Settings Sync

No uses Settings Sync de VS Code junto con este repo — elige uno solo. Este repo reemplaza Settings Sync con control manual vía Git.

Si tienes Settings Sync activo, apágalo antes:

```
Ctrl+Shift+P → Settings Sync: Turn Off
```
