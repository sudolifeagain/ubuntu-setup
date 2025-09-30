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

# Python関連
print_info "Python関連ツールをインストール中..."
pipx install norminette
pipx ensurepath

# Microsoft公式リポジトリの追加とVSCodeインストール
print_info "VSCodeをインストール中..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code
rm -f microsoft.gpg

# VSCode拡張機能のインストール
print_info "VSCode拡張機能をインストール中..."
code --install-extension ms-vscode.cpptools

print_success "VSCode関連のセットアップ完了"

# Braveブラウザのインストール
print_info "Braveブラウザをインストール中..."
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser

print_success "Braveブラウザのインストール完了"

# メディア関連アプリケーション
print_info "メディア関連アプリケーションをインストール中..."
sudo apt install -y vlc

# OBS Studio（公式PPA使用）
sudo add-apt-repository -y ppa:obsproject/obs-studio
sudo apt update
sudo apt install -y obs-studio

print_success "メディア関連アプリケーションのインストール完了"

# Typoraのインストール
print_info "Typoraをインストール中..."
wget -qO - https://typora.io/linux/public-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/typora.gpg
echo "deb [signed-by=/usr/share/keyrings/typora.gpg] https://typora.io/linux ./" | sudo tee /etc/apt/sources.list.d/typora.list
sudo apt update
sudo apt install -y typora

print_success "Typoraのインストール完了"

# Obsidianのインストール
print_info "Obsidianをインストール中..."
OBSIDIAN_DEB="obsidian_latest_amd64.deb"
wget -O "$OBSIDIAN_DEB" "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.9.12/obsidian_1.9.12_amd64.deb"
sudo dpkg -i "$OBSIDIAN_DEB"
sudo apt-get install -f -y  # 依存関係の修正
rm -f "$OBSIDIAN_DEB"

print_success "Obsidianのインストール完了"

# Spotifyのインストール
print_info "Spotifyをインストール中..."
sudo snap install spotify

print_success "Spotifyのインストール完了"

# 日本語入力システム（Mozc）のインストール
print_info "日本語入力システム（Mozc）をインストール中..."
sudo apt install -y ibus-mozc

print_success "🎉 Ubuntu自動セットアップが完了しました！"