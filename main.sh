#!/bin/bash

#いろいろいんすこ
sudo apt update
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy -y
sudo apt update
sudo apt install tmux -y

#ここから設定

# tmux.confのパス
TMUX_CONF="$HOME/.tmux.conf"

# dupe確認
if ! grep -q "^set-option -g mouse on" "$TMUX_CONF" 2>/dev/null; then
  # 設定追加
  echo "set-option -g mouse on" >> "$TMUX_CONF"
  echo "setting comp"
else
  echo "setting is already here"
fi

# 設定反映
tmux source-file "$TMUX_CONF"
echo "setting reload"

#ここからせっしょん

# セッションつくる
if ! tmux has-session -t server 2>/dev/null; then
  tmux new-session -d -s server
  
  # 分割
  tmux split-window -h -t server:0
  tmux split-window -v -t server:0
fi

# アタッチ
tmux attach -t server