
#!/usr/bin/env bash

languages=$(echo "js html css" | tr " " "\n")
core_utils=$(echo "find xargs sed awk jq" | tr " " "\n")
selected=$(echo "$languages\n$core_utils" | fzf)

read -p "PROVIDE QUERY: " query

if echo "$languages" | grep -qs $selected; then
  tmux split-window -p 25 -h bash -c "curl cht.sh/$selected/$(echo "$query" | tr " " "+") | less"
else
  tmux split-window -p 25 -h bash -c "curl cht.sh/$selected~$query | less" 
fi  
