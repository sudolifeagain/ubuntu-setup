# Ubuntu自動セットアップ

Ubuntu開発環境の自動インストール・設定スクリプト

## 動作確認環境

Ubuntu 24.04.3 LTS x86_64

## 📦 インストール内容

### 開発ツール
- **基本**: git, curl, wget, build-essential, gdb, valgrind, ffmpeg
- **Python**: python3, pip3, pipx, norminette
- **Node.js**: nvm + 最新LTS版
- **エディタ**: VSCode + C/C++拡張機能
- **シェル**: Zsh + エイリアス設定

### VSCode拡張機能
- C/C++ Tools (ms-vscode.cpptools)
- C/C++ Extension Pack
- 42 Header (kube.42header)
- 42 Line Counter (DoKca.42-ft-count-line)
- Norminette for 42 (MariusvanWijk-JoppeKoers.codam-norminette-3)
- Code Spell Checker
- Error Lens
- Path Intellisense

### アプリケーション
- **ブラウザ**: Brave Browser
- **メディア**: VLC, OBS Studio, Spotify
- **ドキュメント**: Typora, Obsidian
- **コミュニケーション**: Discord
- **ユーティリティ**: CopyQ, fastfetch, Bitwarden
- **日本語入力**: ibus-mozc

## 🚀 使用方法

```bash
# クローンして実行
git clone https://github.com/sudolifeagain/ubuntu-setup.git
cd ubuntu-setup
chmod +x *.sh

# 1. アプリインストール
./setup.sh

# 2. 設定適用
./configure.sh
```

## 🔧 手動設定

実行後に以下を設定してください：

1. **日本語入力**: 設定 → 地域と言語 → 入力ソース → 日本語(Mozc)
2. **SSH鍵**: `cat ~/.ssh/id_ed25519.pub` をGitHub/GitLabに登録
3. **再起動**: 設定を適用

## 注意事項

- sudo権限が必要
- 既存設定のバックアップ推奨
- 変更適用には再起動が必要

