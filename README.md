# Ubuntu自動セットアップ

Ubuntu開発環境の自動インストール・設定スクリプト

## 動作確認環境

Ubuntu 24.04.3 LTS x86_64

## 📦 インストール内容

### 開発ツール
- **基本**: git, curl, wget, gnupg, gpg, software-properties-common, build-essential, gdb, valgrind, ffmpeg
- **Python**: python3, python3-pip, python3-setuptools, pipx, norminette
- **Node.js**: nvm + 最新LTS版
- **エディタ**: VSCode + C/C++拡張機能
- **シェル**: Zsh + エイリアス設定

### VSCode拡張機能
- C/C++ Tools (ms-vscode.cpptools)
- C/C++ Extension Pack (ms-vscode.cpptools-extension-pack)
- 42 Header (kube.42header)
- 42 Line Counter (DoKca.42-ft-count-line)
- Norminette for 42 (MariusvanWijk-JoppeKoers.codam-norminette-3)
- Code Spell Checker (streetsidesoftware.code-spell-checker)
- Error Lens (usernamehw.errorlens)
- Path Intellisense (christian-kohler.path-intellisense)
- PDF (tomoki1207.pdf)

### アプリケーション
- **ブラウザ**: Brave Browser
- **メディア**: VLC, OBS Studio, Spotify (snap)
- **ドキュメント**: Typora, Obsidian
- **コミュニケーション**: Discord
- **ユーティリティ**: CopyQ, fastfetch, Bitwarden (snap)
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

## 🔧 自動設定内容

### システム設定
- **ラップトップ蓋閉じ時の動作**: 外部電源接続時・ドッキング時はサスペンドしない
- **システムアップデート**: パッケージの更新と不要パッケージの削除

### 開発環境設定
- **Git設定**: ユーザー名・メールアドレスの設定（対話式）
- **SSH鍵**: ED25519鍵の生成と公開鍵の表示
- **Zshエイリアス**:
  - `gs` → `git status`
  - `ll` → `ls -la`
  - `c` → `clear`
  - `cc` → `cc -Wall -Wextra -Werror`
  - `norm` → `norminette -R CheckForbiddenSourceHeader`
- **デフォルトシェル**: Zshへの変更（対話式）

### 日本語入力設定
- **Mozc設定**: ROMAN入力モード、デフォルト入力モードをひらがなに設定

## 🔧 手動設定

実行後に以下を設定してください：

1. **日本語入力**: 設定 → 地域と言語 → 入力ソース → 日本語(Mozc)
2. **SSH鍵**: 表示される公開鍵をGitHub/GitLabに登録
3. **再起動**: 全ての設定を適用（configure.shで選択可能）

## 📁 ファイル構成

- [`setup.sh`](setup.sh): アプリケーションとツールのインストール
- [`configure.sh`](configure.sh): 各種設定の適用と初期化
- [`README.md`](README.md): このドキュメント

## 🛠️ 技術仕様

### パッケージ管理
- **APT**: 基本パッケージとリポジトリ追加
- **Snap**: Spotify, Bitwarden
- **直接ダウンロード**: Obsidian, Discord, fastfetch
- **PPA**: OBS Studio
- **公式リポジトリ**: VSCode, Brave Browser, Typora

### インストール検証
- 既存インストールの確認機能
- 重複インストールの回避
- エラーハンドリングと依存関係の自動修正

## 注意事項

- sudo権限が必要
- 既存設定は自動でバックアップ
- インターネット接続が必要
- 設定の完全適用には再起動が必要
- 対話式入力が含まれるため、無人実行不可

## トラブルシューティング

### よくある問題
1. **権限エラー**: `sudo chmod +x *.sh` で実行権限を付与
2. **ネットワークエラー**: インターネット接続を確認
3. **依存関係エラー**: `sudo apt update && sudo apt install -f` で修復
4. **SSH鍵が見つからない**: configure.shを再実行して鍵を生成

### ログ確認
エラーが発生した場合は、エラーメッセージを確認して該当パッケージを手動でインストールしてください。

