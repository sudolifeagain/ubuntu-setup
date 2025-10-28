# Ubuntu Automatic Setup

Automated installation and configuration script for Ubuntu development environment

## Tested Environment

Ubuntu 24.04.3 LTS x86_64

## 📦 Installation Contents

### Development Tools
- **Basic**: git, curl, wget, gnupg, gpg, software-properties-common, build-essential, gdb, valgrind, ffmpeg, jq, acpi
- **Compilers**: gcc-11, g++-11, clang-12 (configured to match 42 school environment)
- **Python**: python3, python3-pip, python3-setuptools, pipx, norminette
- **Node.js**: nvm + latest LTS version
- **Editor**: VSCode + C/C++ extensions
- **Shell**: Zsh + comprehensive configuration template

### Compiler Configuration (42 School Compatible)
- **gcc-11**: Version 11.4.0 (default gcc, g++, cc)
- **clang-12**: Version 12.0.1
- Configured using update-alternatives for easy switching

### VSCode Extensions
- C/C++ Tools (ms-vscode.cpptools)
- C/C++ Extension Pack (ms-vscode.cpptools-extension-pack)
- 42 Header (kube.42header)
- 42 Line Counter (DoKca.42-ft-count-line)
- Norminette for 42 (MariusvanWijk-JoppeKoers.codam-norminette-3)
- Code Spell Checker (streetsidesoftware.code-spell-checker)
- Error Lens (usernamehw.errorlens)
- Path Intellisense (christian-kohler.path-intellisense)
- PDF (tomoki1207.pdf)

### Applications
- **Browser**: Brave Browser
- **Media**: VLC, OBS Studio, Spotify (snap)
- **Documents**: Typora, Obsidian
- **Communication**: Discord
- **Utilities**: CopyQ, fastfetch, Bitwarden (snap)
- **Japanese Input**: ibus-mozc

## 🚀 Usage

```bash
# Clone and execute
git clone https://github.com/sudolifeagain/ubuntu-setup.git
cd ubuntu-setup
chmod +x *.sh

# 1. Install applications
./setup.sh

# 2. Apply configurations
./configure.sh
```

## 🔧 Automatic Configuration Contents

### System Settings
- **Laptop lid close behavior**: No suspend when external power connected or docked
- **System updates**: Package updates and removal of unnecessary packages

### Development Environment Settings
- **Compiler setup**: gcc-11, clang-12 configured as default compilers
- **Git configuration**: Username and email address setup (interactive)
- **SSH keys**: ED25519 key generation and public key display
- **VSCode settings**: Automatic configuration of user settings for 42 development
- **Zsh configuration**: Complete shell setup with aliases, NVM, pipx, and Copilot workspace functions
  - Basic aliases: `gs`, `ll`, `c`, `ccc`, `norm`
  - NVM integration for Node.js management
  - Workspace-specific Copilot control functions (`copilot-on`, `copilot-off`)
- **Default shell**: Change to Zsh (interactive)

### Japanese Input Settings
- **Mozc configuration**: ROMAN input mode, default input mode set to hiragana

### VSCode Settings
- **Editor preferences**: Tabs over spaces, auto-save, trailing whitespace handling
- **Git integration**: Disabled sync confirmation
- **GitHub Copilot**: Disabled by default (use workspace functions to enable)

## 🔧 Manual Configuration

Please configure the following after execution:

1. **Japanese input**: Settings → Region & Language → Input Sources → Japanese (Mozc)
2. **SSH keys**: Register displayed public key to GitHub/GitLab
3. **Restart**: Apply all settings (selectable in configure.sh)

## 📁 File Structure

- [`setup.sh`](setup.sh): Application and tool installation
- [`configure.sh`](configure.sh): Configuration application and initialization
- [`.zshrc.template`](.zshrc.template): Zsh configuration template with aliases and functions
- [`README.md`](README.md): This document

## 🛠️ Technical Specifications

### Package Management
- **APT**: Basic packages, compilers, and repository additions
- **Snap**: Spotify, Bitwarden
- **Direct download**: Obsidian, Discord, fastfetch
- **PPA**: OBS Studio
- **Official repositories**: VSCode, Brave Browser, Typora

### Compiler Alternatives System
Uses `update-alternatives` to manage multiple compiler versions:
- gcc-11 set as default gcc, g++, and cc
- clang-12 set as default clang
- Priority: gcc-11 (110), clang-12 (120)

### Installation Verification
- Existing installation check functionality
- Duplicate installation avoidance
- Error handling and automatic dependency fixes

## Notes

- sudo privileges required
- Existing settings automatically backed up
- Internet connection required
- System restart required for complete setting application
- Cannot run unattended due to interactive input

## Troubleshooting

### Common Issues
1. **Permission errors**: Grant execution permissions with `sudo chmod +x *.sh`
2. **Network errors**: Check internet connection
3. **Dependency errors**: Fix with `sudo apt update && sudo apt install -f`
4. **SSH key not found**: Re-run configure.sh to generate keys
5. **Compiler version mismatch**: Run `sudo update-alternatives --config gcc` or `sudo update-alternatives --config clang`

### Verifying Compiler Installation
```bash
gcc --version    # Should show gcc 11.4.0
cc --version     # Should show cc 11.4.0
clang --version  # Should show clang 12.0.1
```

### Log Checking
If errors occur, check error messages and manually install the relevant packages.
