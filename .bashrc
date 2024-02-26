

# Shopify Hydrogen alias to local projects
alias h2='$(npm prefix -s)/node_modules/.bin/shopify hydrogen'
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# command to override fzf find command to use ripgrep
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='gf --files --ignore-vcs --hidden'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
alias config='/usr/bin/git --git-dir=/Users/johnnguyen/dotfiles --work-tree=/Users/johnnguyen'
alias config='/usr/bin/git --git-dir=/Users/johnnguyen/dotfiles --work-tree=/Users/johnnguyen'
alias config='/usr/bin/git --git-dir=/Users/johnnguyen/.dotfiles --work-tree=/Users/johnnguyen'
alias config='/usr/bin/git --git-dir=/Users/johnnguyen/.dotfiles --work-tree=/Users/johnnguyen'
