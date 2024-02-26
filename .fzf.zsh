# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/johnnguyen/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/johnnguyen/.fzf/bin"
fi

# Auto-completion
# ---------------
source "/Users/johnnguyen/.fzf/shell/completion.zsh"

# Key bindings
# ------------
source "/Users/johnnguyen/.fzf/shell/key-bindings.zsh"
