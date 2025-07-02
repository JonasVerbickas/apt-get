# Ubuntu Setup Scripts

Tested on Ubuntu 24.04 Desktop (ARM/x64).

## CLI Setup (Development Tools Only)
```bash
./setup-cli.sh
```

Installs core development tools:
- Git (with configuration)
- Neovim (built from source with Kickstart config)
- Terminal tools (tmux, btop, enhanced history search, Bash-it)
- Python3-Poetry
- Node.js Version Manager (NVM)
- Podman with NVIDIA support (if GPU detected)

## GUI Setup (Complete Desktop Environment)
```bash
./setup-gui.sh
```

Runs CLI setup plus additional desktop applications:
- KeePassXC password manager
- VSCode (architecture-specific download with dependencies)
- Google Chrome browser
- Signal messenger
- Keyboard mapping (CAPS → Escape)

