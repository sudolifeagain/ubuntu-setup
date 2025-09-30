#!/bin/bash

# Ubuntu設定ファイル適用スクリプト
# このスクリプトは各種設定ファイルを適用します

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

print_warning() {
    echo -e "\033[33m[WARNING]\033[0m $1"
}

print_info "設定ファイルの適用を開始します..."

print_info "システムパッケージを更新中..."
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
print_success "システムアップデートが完了しました"

# ラップトップ蓋閉じ時の動作設定
print_info "ラップトップ蓋閉じ時の動作設定を適用中..."
logind_conf="/etc/systemd/logind.conf"

# バックアップを作成
if [ ! -f "${logind_conf}.backup" ]; then
    sudo cp "$logind_conf" "${logind_conf}.backup"
    print_info "logind.confのバックアップを作成しました"
fi

# 設定を変更
sudo sed -i 's/^#HandleLidSwitchExternalPower=suspend/HandleLidSwitchExternalPower=ignore/' "$logind_conf"
sudo sed -i 's/^#HandleLidSwitchDocked=ignore/HandleLidSwitchDocked=ignore/' "$logind_conf"

# 設定が正しく適用されたか確認
if grep -q "^HandleLidSwitchExternalPower=ignore" "$logind_conf" && grep -q "^HandleLidSwitchDocked=ignore" "$logind_conf"; then
    print_success "蓋閉じ時の動作設定が適用されました"
else
    print_warning "設定の適用に失敗した可能性があります。手動で確認してください。"
fi

# Mozc設定ファイルの作成
print_info "Mozc設定ファイルを作成中..."
mkdir -p ~/.config/mozc
cat > ~/.config/mozc/config1.db <<EOF
[General]
preedit_method=ROMAN
session_keymap=default
default_input_mode=HIRAGANA
EOF

print_success "Mozc設定ファイルが作成されました"

# Zsh設定の適用
print_info "Zsh設定を適用中..."

# .zshrcにエイリアスを追加（既存の設定を保持）
if [ ! -f ~/.zshrc ]; then
    touch ~/.zshrc
fi

# 重複を避けるために、既存のエイリアスをチェック
if ! grep -q "alias gs=" ~/.zshrc; then
    echo 'alias gs="git status"' >> ~/.zshrc
fi

if ! grep -q "alias ll=" ~/.zshrc; then
    echo 'alias ll="ls -la"' >> ~/.zshrc
fi

if ! grep -q "alias c=" ~/.zshrc; then
    echo 'alias c="clear"' >> ~/.zshrc
fi

if ! grep -q "alias cc=" ~/.zshrc; then
    echo 'alias cc="cc -Wall -Wextra -Werror"' >> ~/.zshrc
fi

if ! grep -q "alias norm=" ~/.zshrc; then
    echo 'alias norm="norminette -R CheckForbiddenSourceHeader"' >> ~/.zshrc
fi

print_success "Zshエイリアスが設定されました"

# デフォルトシェルの変更確認
current_shell=$(echo $SHELL)
zsh_path=$(which zsh)

if [ "$current_shell" != "$zsh_path" ]; then
    print_warning "現在のデフォルトシェル: $current_shell"
    print_info "デフォルトシェルをZshに変更しますか？ (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        chsh -s "$zsh_path"
        print_success "デフォルトシェルがZshに変更されました"
        print_info "変更を適用するには再ログインが必要です"
    else
        print_info "デフォルトシェルの変更をスキップしました"
        print_info "手動で変更する場合: chsh -s \$(which zsh)"
    fi
else
    print_success "デフォルトシェルは既にZshに設定されています"
fi

# Git設定の確認
print_info "Git設定を確認中..."
git_user_name=$(git config --global user.name 2>/dev/null || echo "")
git_user_email=$(git config --global user.email 2>/dev/null || echo "")

if [ -z "$git_user_name" ] || [ -z "$git_user_email" ]; then
    print_warning "Git設定が未完了です"
    
    if [ -z "$git_user_name" ]; then
        print_info "Gitユーザー名を入力してください:"
        read -r git_name
        git config --global user.name "$git_name"
    fi
    
    if [ -z "$git_user_email" ]; then
        print_info "Gitメールアドレスを入力してください:"
        read -r git_email
        git config --global user.email "$git_email"
    fi
    
    print_success "Git設定が完了しました"
else
    print_success "Git設定済み: $git_user_name <$git_user_email>"
fi

# SSH鍵生成とpubkey表示
print_info "SSH鍵の設定を確認中..."
ssh_key_path="$HOME/.ssh/id_ed25519"

if [ ! -f "$ssh_key_path" ]; then
    print_warning "SSH鍵が見つかりません"
    print_info "SSH鍵を生成しますか？ (y/n)"
    read -r ssh_response
    
    if [[ "$ssh_response" =~ ^[Yy]$ ]]; then
        print_info "SSH鍵を生成中（ED25519アルゴリズム使用）..."
        
        # メールアドレスがある場合はそれを使用、なければユーザー名@ホスト名
        if [ -n "$git_user_email" ]; then
            ssh_email="$git_user_email"
        else
            ssh_email="$(whoami)@$(hostname)"
        fi
        
        ssh-keygen -t ed25519 -C "$ssh_email" -f "$ssh_key_path" -N ""
        
        # SSH エージェントに鍵を追加
        eval "$(ssh-agent -s)"
        ssh-add "$ssh_key_path"
        
        print_success "SSH鍵（ED25519）が生成されました"
    else
        print_info "SSH鍵の生成をスキップしました"
    fi
else
    print_success "SSH鍵は既に存在します"
fi

# SSH公開鍵の表示
if [ -f "${ssh_key_path}.pub" ]; then
    print_info "SSH公開鍵の内容:"
    echo "----------------------------------------"
    cat "${ssh_key_path}.pub"
    echo "----------------------------------------"
    print_info "この公開鍵をGitHub/GitLabなどのサービスに登録してください"
    print_info "公開鍵は以下のコマンドでいつでも確認できます:"
    echo "  cat ~/.ssh/id_ed25519.pub"
fi

print_success "🎉 設定ファイルの適用が完了しました！"
print_info "蓋閉じ時の動作設定を含め、全ての変更を完全に適用するには再起動が必要です"

# ユーザーに再起動の確認
print_info "今すぐシステムを再起動しますか？ (y/n)"
read -r reboot_response

if [[ "$reboot_response" =~ ^[Yy]$ ]]; then
    print_info "システムを再起動中..."
    sudo reboot
else
    print_warning "再起動をスキップしました"
    print_info "設定を完全に適用するには、後で手動で再起動してください: sudo reboot"
fi