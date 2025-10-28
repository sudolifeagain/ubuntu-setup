#!/bin/bash

# Ubuntu Configuration File Application Script
# This script applies various configuration files

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

print_warning() {
    echo -e "\033[33m[WARNING]\033[0m $1"
}

print_info "Starting configuration file application..."

print_info "Updating system packages..."
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
print_success "System update completed"

# Configure laptop lid close behavior
print_info "Applying laptop lid close behavior configuration..."
logind_conf="/etc/systemd/logind.conf"

# Create backup
if [ ! -f "${logind_conf}.backup" ]; then
    sudo cp "$logind_conf" "${logind_conf}.backup"
    print_info "Created backup of logind.conf"
fi

# Apply configuration
sudo sed -i 's/^#HandleLidSwitchExternalPower=suspend/HandleLidSwitchExternalPower=ignore/' "$logind_conf"
sudo sed -i 's/^#HandleLidSwitchDocked=ignore/HandleLidSwitchDocked=ignore/' "$logind_conf"

# Verify configuration was applied correctly
if grep -q "^HandleLidSwitchExternalPower=ignore" "$logind_conf" && grep -q "^HandleLidSwitchDocked=ignore" "$logind_conf"; then
    print_success "Lid close behavior configuration applied"
else
    print_warning "Configuration application may have failed. Please check manually."
fi

# Create Mozc configuration file
print_info "Creating Mozc configuration file..."
mkdir -p ~/.config/mozc
cat > ~/.config/mozc/config1.db <<EOF
[General]
preedit_method=ROMAN
session_keymap=default
default_input_mode=HIRAGANA
EOF

print_success "Mozc configuration file created"

# Apply Zsh configuration
print_info "Applying Zsh configuration..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC_TEMPLATE="$SCRIPT_DIR/.zshrc.template"

# Check if template file exists
if [ ! -f "$ZSHRC_TEMPLATE" ]; then
    print_error "Zsh configuration template not found: $ZSHRC_TEMPLATE"
    exit 1
fi

# Backup existing .zshrc if it exists
if [ -f ~/.zshrc ]; then
    cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
    print_info "Backed up existing .zshrc"
fi

# Copy template to user's home directory
cp "$ZSHRC_TEMPLATE" ~/.zshrc
print_success "Zsh configuration applied from template"

# Check default shell change
current_shell=$(echo $SHELL)
zsh_path=$(which zsh)

if [ "$current_shell" != "$zsh_path" ]; then
    print_warning "Current default shell: $current_shell"
    print_info "Change default shell to Zsh? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        chsh -s "$zsh_path"
        print_success "Default shell changed to Zsh"
        print_info "Re-login required to apply changes"
    else
        print_info "Skipped default shell change"
        print_info "To change manually: chsh -s \$(which zsh)"
    fi
else
    print_success "Default shell is already set to Zsh"
fi

# Check Git configuration
print_info "Checking Git configuration..."
git_user_name=$(git config --global user.name 2>/dev/null || echo "")
git_user_email=$(git config --global user.email 2>/dev/null || echo "")

if [ -z "$git_user_name" ] || [ -z "$git_user_email" ]; then
    print_warning "Git configuration incomplete"

    if [ -z "$git_user_name" ]; then
        print_info "Enter Git username:"
        read -r git_name
        git config --global user.name "$git_name"
    fi

    if [ -z "$git_user_email" ]; then
        print_info "Enter Git email address:"
        read -r git_email
        git config --global user.email "$git_email"
    fi

    print_success "Git configuration completed"
else
    print_success "Git already configured: $git_user_name <$git_user_email>"
fi

# SSH key generation and public key display
print_info "Checking SSH key configuration..."
ssh_key_path="$HOME/.ssh/id_ed25519"

if [ ! -f "$ssh_key_path" ]; then
    print_warning "SSH key not found"
    print_info "Generate SSH key? (y/n)"
    read -r ssh_response

    if [[ "$ssh_response" =~ ^[Yy]$ ]]; then
        print_info "Generating SSH key (using ED25519 algorithm)..."

        # Use email address if available, otherwise use username@hostname
        if [ -n "$git_user_email" ]; then
            ssh_email="$git_user_email"
        else
            ssh_email="$(whoami)@$(hostname)"
        fi

        ssh-keygen -t ed25519 -C "$ssh_email" -f "$ssh_key_path" -N ""

        # Add key to SSH agent
        eval "$(ssh-agent -s)"
        ssh-add "$ssh_key_path"

        print_success "SSH key (ED25519) generated"
    else
        print_info "Skipped SSH key generation"
    fi
else
    print_success "SSH key already exists"
fi

# Display SSH public key
if [ -f "${ssh_key_path}.pub" ]; then
    print_info "SSH public key content:"
    echo "----------------------------------------"
    cat "${ssh_key_path}.pub"
    echo "----------------------------------------"
    print_info "Register this public key to GitHub/GitLab and other services"
    print_info "You can always check the public key with this command:"
    echo "  cat ~/.ssh/id_ed25519.pub"
fi

# Configure VSCode settings
print_info "Applying VSCode user settings..."
vscode_settings_dir="$HOME/.config/Code/User"
vscode_settings_file="$vscode_settings_dir/settings.json"

# Create VSCode User directory if it doesn't exist
mkdir -p "$vscode_settings_dir"

# Create or update settings.json
if [ -f "$vscode_settings_file" ]; then
    # Backup existing settings
    cp "$vscode_settings_file" "${vscode_settings_file}.backup.$(date +%Y%m%d_%H%M%S)"
    print_info "Backed up existing VSCode settings"
fi

# Create new settings.json with desired configuration
cat > "$vscode_settings_file" <<'EOF'
{
    "github.copilot.enabled": false,
    "workbench.externalBrowser": "firefox",
    "git.confirmSync": false,
    "files.autoSave": "afterDelay",
    "editor.detectIndentation": false,
    "editor.autoIndentOnPaste": true,
    "files.trimTrailingWhitespace": true,
    "editor.insertSpaces": false,
    "files.insertFinalNewline": true,
    "files.trimFinalNewlines": true,
    "editor.comments.insertSpace": false
}
EOF

print_success "VSCode user settings configured"

print_success "🎉 Configuration file application completed!"
print_info "System restart is required to fully apply all changes including lid close behavior settings"

# Ask user for restart confirmation
print_info "Restart system now? (y/n)"
read -r reboot_response

if [[ "$reboot_response" =~ ^[Yy]$ ]]; then
    print_info "Restarting system..."
    sudo reboot
else
    print_warning "Restart skipped"
    print_info "To fully apply settings, manually restart later: sudo reboot"
fi
