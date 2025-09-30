#!/bin/bash

# Ubuntu自動セットアップスクリプト
# このスクリプトは開発環境とアプリケーションを一括でインストールします

set -e  # エラーが発生したら停止

# 色付きメッセージ用の関数
print_info() {
    echo -e "\033[36m[INFO]\033[0m $1"
}

print_success() {
    echo -e "\033[32m[SUCCESS]\033[0m $1"
}

print_error() {
    echo -e "\033[31m[ERROR]\033[0m $1"
}

print_info "Ubuntu自動セットアップを開始します..."

# システムアップデート
print_info "システムパッケージを更新中..."
sudo apt update && sudo apt upgrade -y

# 基本ツールのインストール
print_info "基本ツールをインストール中..."

# 個別に重要なツールをチェック
tools_to_check=("git" "zsh" "ffmpeg" "copyq")
missing_tools=()

for tool in "${tools_to_check[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        missing_tools+=("$tool")
    else
        print_success "$tool は既にインストールされています"
    fi
done

if [ ${#missing_tools[@]} -gt 0 ]; then
    print_info "不足している基本ツールをインストール中..."
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
    print_success "基本ツールのインストール完了"
else
    print_success "基本ツールは全てインストール済みです"
fi

# Python関連
if command -v norminette &> /dev/null; then
    print_success "norminetteは既にインストールされています"
else
    print_info "Python関連ツールをインストール中..."
    pipx install norminette
    pipx ensurepath
    print_success "norminetteのインストール完了"
fi

# Microsoft公式リポジトリの追加とVSCodeインストール
if command -v code &> /dev/null; then
    print_success "VSCodeは既にインストールされています"
else
    print_info "VSCodeをインストール中..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code
    rm -f microsoft.gpg
    print_success "VSCodeのインストール完了"
fi

# VSCode拡張機能のインストール
print_info "VSCode拡張機能をインストール中..."

# 拡張機能のリスト
extensions=(
    "ms-vscode.cpptools"
    "DoKca.42-ft-count-line"
    "kube.42header"
    "ms-vscode.cpptools-extension-pack"
    "streetsidesoftware.code-spell-checker"
    "usernamehw.errorlens"
    "christian-kohler.path-intellisense"
    "MariusvanWijk-JoppeKoers.codam-norminette-3"
)

# 各拡張機能をインストール
for extension in "${extensions[@]}"; do
    if code --list-extensions | grep -q "^$extension$"; then
        print_success "$extension は既にインストールされています"
    else
        print_info "$extension をインストール中..."
        code --install-extension "$extension"
        print_success "$extension のインストール完了"
    fi
done

print_success "VSCode関連のセットアップ完了"

# Braveブラウザのインストール
if command -v brave-browser &> /dev/null; then
    print_success "Braveブラウザは既にインストールされています"
else
    print_info "Braveブラウザをインストール中..."
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install -y brave-browser
    print_success "Braveブラウザのインストール完了"
fi

# メディア関連アプリケーション
print_info "メディア関連アプリケーションをインストール中..."

# VLCのインストール
if command -v vlc &> /dev/null; then
    print_success "VLCは既にインストールされています"
else
    print_info "VLCをインストール中..."
    sudo apt install -y vlc
    print_success "VLCのインストール完了"
fi

# OBS Studio（公式PPA使用）
if command -v obs &> /dev/null; then
    print_success "OBS Studioは既にインストールされています"
else
    print_info "OBS Studioをインストール中..."
    sudo add-apt-repository -y ppa:obsproject/obs-studio
    sudo apt update
    sudo apt install -y obs-studio
    print_success "OBS Studioのインストール完了"
fi

print_success "メディア関連アプリケーションのインストール完了"

# Typoraのインストール
if command -v typora &> /dev/null; then
    print_success "Typoraは既にインストールされています"
else
    print_info "Typoraをインストール中..."
    wget -qO - https://typora.io/linux/public-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/typora.gpg
    echo "deb [signed-by=/usr/share/keyrings/typora.gpg] https://typora.io/linux ./" | sudo tee /etc/apt/sources.list.d/typora.list
    sudo apt update
    sudo apt install -y typora
    print_success "Typoraのインストール完了"
fi

# Obsidianのインストール
if command -v obsidian &> /dev/null; then
    print_success "Obsidianは既にインストールされています"
else
    print_info "Obsidianをインストール中..."
    OBSIDIAN_DEB="obsidian_latest_amd64.deb"
    wget -O "$OBSIDIAN_DEB" "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.9.12/obsidian_1.9.12_amd64.deb"
    sudo dpkg -i "$OBSIDIAN_DEB"
    sudo apt-get install -f -y  # 依存関係の修正
    rm -f "$OBSIDIAN_DEB"
    print_success "Obsidianのインストール完了"
fi

# Spotifyのインストール
if snap list spotify &> /dev/null; then
    print_success "Spotifyは既にインストールされています"
else
    print_info "Spotifyをインストール中..."
    sudo snap install spotify
    print_success "Spotifyのインストール完了"
fi

# Bitwardenのインストール
if snap list bitwarden &> /dev/null; then
    print_success "Bitwardenは既にインストールされています"
else
    print_info "Bitwardenをインストール中..."
    sudo snap install bitwarden
    print_success "Bitwardenのインストール完了"
fi

# Discordのインストール
if command -v discord &> /dev/null; then
    print_success "Discordは既にインストールされています"
else
    print_info "Discordをインストール中..."
    DISCORD_DEB="discord-latest.deb"
    wget -O "$DISCORD_DEB" "https://discord.com/api/download?platform=linux"
    sudo dpkg -i "$DISCORD_DEB"
    sudo apt-get install -f -y  # 依存関係の修正
    rm -f "$DISCORD_DEB"
    print_success "Discordのインストール完了"
fi

# fastfetchのインストール
if command -v fastfetch &> /dev/null; then
    print_success "fastfetchは既にインストールされています"
else
    print_info "fastfetchをインストール中..."
    FASTFETCH_DEB="fastfetch-latest.deb"
    # アーキテクチャを取得（amd64, arm64等）
    ARCH=$(dpkg --print-architecture)
    wget -O "$FASTFETCH_DEB" "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-${ARCH}.deb"
    sudo dpkg -i "$FASTFETCH_DEB"
    sudo apt-get install -f -y  # 依存関係の修正
    rm -f "$FASTFETCH_DEB"
    print_success "fastfetchのインストール完了"
fi

# 日本語入力システム（Mozc）のインストール
if dpkg -l | grep -q ibus-mozc; then
    print_success "ibus-mozcは既にインストールされています"
else
    print_info "日本語入力システム（Mozc）をインストール中..."
    sudo apt install -y ibus-mozc
    print_success "ibus-mozcのインストール完了"
fi

print_success "🎉 Ubuntu自動セットアップが完了しました！"