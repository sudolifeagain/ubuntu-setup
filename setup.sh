#!/bin/bash

# Ubuntu Automatic Setup Script
# This script installs development environment and applications in batch

set -e  # Stop on error

# Functions for colored messages
print_info() {
    echo -e "\033[36m[INFO]\033[0m $1"
}

print_success() {
    echo -e "\033[32m[SUCCESS]\033[0m $1"
}

print_error() {
    echo -e "\033[31m[ERROR]\033[0m $1"
}

print_info "Starting Ubuntu automatic setup..."

# System update
print_info "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install basic tools
print_info "Installing basic tools..."

# Check important tools individually
tools_to_check=("git" "zsh" "ffmpeg" "copyq")
missing_tools=()

for tool in "${tools_to_check[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        missing_tools+=("$tool")
    else
        print_success "$tool is already installed"
    fi
done

if [ ${#missing_tools[@]} -gt 0 ]; then
    print_info "Installing missing basic tools..."
    sudo apt install -y \
        curl \
        wget \
        gnupg \
        gpg \
        software-properties-common \
        build-essential \
        gdb \
        valgrind \
        git \
        zsh \
        ffmpeg \
        copyq \
        python3 \
        python3-pip \
        python3-setuptools \
        pipx
    print_success "Basic tools installation completed"
else
    print_success "All basic tools are already installed"
fi

# Python related
if command -v norminette &> /dev/null; then
    print_success "norminette is already installed"
else
    print_info "Installing Python related tools..."
    pipx install norminette
    pipx ensurepath
    print_success "norminette installation completed"
fi

# Node.js installation (via nvm)
if command -v node &> /dev/null; then
    print_success "Node.js is already installed ($(node -v))"
else
    print_info "Installing Node.js (via nvm)..."
    # Download and install nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

    # Load nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    # Install latest LTS version
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*

    print_success "Node.js installation completed ($(node -v))"
    print_success "npm installation completed ($(npm -v))"
fi

# Add Microsoft official repository and install VSCode
if command -v code &> /dev/null; then
    print_success "VSCode is already installed"
else
    print_info "Installing VSCode..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code
    rm -f microsoft.gpg
    print_success "VSCode installation completed"
fi

# Install VSCode extensions
print_info "Installing VSCode extensions..."

# List of extensions
extensions=(
    "ms-vscode.cpptools"
    "DoKca.42-ft-count-line"
    "kube.42header"
    "ms-vscode.cpptools-extension-pack"
    "streetsidesoftware.code-spell-checker"
    "usernamehw.errorlens"
    "christian-kohler.path-intellisense"
    "MariusvanWijk-JoppeKoers.codam-norminette-3"
    "tomoki1207.pdf"
)

# Install each extension
for extension in "${extensions[@]}"; do
    if code --list-extensions | grep -q "^$extension$"; then
        print_success "$extension is already installed"
    else
        print_info "Installing $extension..."
        code --install-extension "$extension"
        print_success "$extension installation completed"
    fi
done

print_success "VSCode related setup completed"

# Install Brave browser
if command -v brave-browser &> /dev/null; then
    print_success "Brave browser is already installed"
else
    print_info "Installing Brave browser..."
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install -y brave-browser
    print_success "Brave browser installation completed"
fi

# Media related applications
print_info "Installing media related applications..."

# Install VLC
if command -v vlc &> /dev/null; then
    print_success "VLC is already installed"
else
    print_info "Installing VLC..."
    sudo apt install -y vlc
    print_success "VLC installation completed"
fi

# OBS Studio (using official PPA)
if command -v obs &> /dev/null; then
    print_success "OBS Studio is already installed"
else
    print_info "Installing OBS Studio..."
    sudo add-apt-repository -y ppa:obsproject/obs-studio
    sudo apt update
    sudo apt install -y obs-studio
    print_success "OBS Studio installation completed"
fi

print_success "Media related applications installation completed"

# Install Typora
if command -v typora &> /dev/null; then
    print_success "Typora is already installed"
else
    print_info "Installing Typora..."
    wget -qO - https://typora.io/linux/public-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/typora.gpg
    echo "deb [signed-by=/usr/share/keyrings/typora.gpg] https://typora.io/linux ./" | sudo tee /etc/apt/sources.list.d/typora.list
    sudo apt update
    sudo apt install -y typora
    print_success "Typora installation completed"
fi

# Install Obsidian
if command -v obsidian &> /dev/null; then
    print_success "Obsidian is already installed"
else
    print_info "Installing Obsidian..."
    OBSIDIAN_DEB="obsidian_latest_amd64.deb"
    wget -O "$OBSIDIAN_DEB" "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.9.12/obsidian_1.9.12_amd64.deb"
    sudo dpkg -i "$OBSIDIAN_DEB"
    sudo apt-get install -f -y  # Fix dependencies
    rm -f "$OBSIDIAN_DEB"
    print_success "Obsidian installation completed"
fi

# Install Spotify
if snap list spotify &> /dev/null; then
    print_success "Spotify is already installed"
else
    print_info "Installing Spotify..."
    sudo snap install spotify
    print_success "Spotify installation completed"
fi

# Install Bitwarden
if snap list bitwarden &> /dev/null; then
    print_success "Bitwarden is already installed"
else
    print_info "Installing Bitwarden..."
    sudo snap install bitwarden
    print_success "Bitwarden installation completed"
fi

# Install Discord
if command -v discord &> /dev/null; then
    print_success "Discord is already installed"
else
    print_info "Installing Discord..."
    DISCORD_DEB="discord-latest.deb"
    wget -O "$DISCORD_DEB" "https://discord.com/api/download?platform=linux"
    sudo dpkg -i "$DISCORD_DEB"
    sudo apt-get install -f -y  # Fix dependencies
    rm -f "$DISCORD_DEB"
    print_success "Discord installation completed"
fi

# Install fastfetch
if command -v fastfetch &> /dev/null; then
    print_success "fastfetch is already installed"
else
    print_info "Installing fastfetch..."
    FASTFETCH_DEB="fastfetch-latest.deb"
    # Get architecture (amd64, arm64, etc.)
    ARCH=$(dpkg --print-architecture)
    wget -O "$FASTFETCH_DEB" "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-${ARCH}.deb"
    sudo dpkg -i "$FASTFETCH_DEB"
    sudo apt-get install -f -y  # Fix dependencies
    rm -f "$FASTFETCH_DEB"
    print_success "fastfetch installation completed"
fi

# Install Japanese input system (Mozc)
if dpkg -l | grep -q ibus-mozc; then
    print_success "ibus-mozc is already installed"
else
    print_info "Installing Japanese input system (Mozc)..."
    sudo apt install -y ibus-mozc
    print_success "ibus-mozc installation completed"
fi

print_success "🎉 Ubuntu automatic setup completed!"
