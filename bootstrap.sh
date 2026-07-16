#!/usr/bin/env bash
# Bootstrap this dev environment on a fresh machine (macOS or Ubuntu/Debian).
#
# Usage on a brand-new machine:
#   git clone --bare https://github.com/johnnguyencodes/dotfiles.git "$HOME/.dotfiles"
#   git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout 2>&1 \
#     | grep -E '^\s+\.' | awk '{print $1}' \
#     | xargs -I{} sh -c 'mkdir -p "$HOME/.dotfiles-backup/$(dirname {})" && mv {} "$HOME/.dotfiles-backup/{}"'
#   git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
#   bash "$HOME/bootstrap.sh"
#
# Safe to re-run: every step checks whether it's already done before acting.

set -uo pipefail

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
have() { command -v "$1" >/dev/null 2>&1; }

OS="$(uname -s)"
IS_MACOS=false
IS_LINUX=false
case "$OS" in
  Darwin) IS_MACOS=true ;;
  Linux)  IS_LINUX=true ;;
  *) warn "Unrecognized OS '$OS' -- this script only handles macOS and Linux."; exit 1 ;;
esac

# ------------------------------------------------------------------------
# 1. Homebrew (works on both macOS and Linux; used as the single package
#    source for the CLI toolset so there's one list of names, not two).
# ------------------------------------------------------------------------

find_brew() {
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -x "$candidate" ]; then
      echo "$candidate"
      return 0
    fi
  done
  return 1
}

BREW_BIN="$(find_brew || true)"
if [ -z "$BREW_BIN" ]; then
  log "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  BREW_BIN="$(find_brew || true)"
  if [ -z "$BREW_BIN" ]; then
    warn "Homebrew install finished but brew still isn't found in the usual locations. Aborting."
    exit 1
  fi
else
  log "Homebrew already installed ($BREW_BIN)"
fi
eval "$("$BREW_BIN" shellenv)"

# ------------------------------------------------------------------------
# 2. CLI toolset
#
# Installed one at a time, skipping any tool whose command already
# exists -- `brew install a b c` as a single batch will upgrade already-
# installed-but-outdated formulae as a side effect of resolving the
# other new ones, which is surprising behavior to run unprompted against
# an already-configured machine. Formula name -> command name differs
# for a couple of these (ripgrep -> rg, neovim -> nvim).
# ------------------------------------------------------------------------

install_if_missing() {
  local formula="$1" cmd="${2:-$1}"
  if have "$cmd"; then
    log "$cmd already installed, skipping"
  else
    log "Installing $formula..."
    brew install "$formula"
  fi
}

install_if_missing git
install_if_missing zsh
install_if_missing tmux
install_if_missing neovim nvim
install_if_missing ripgrep rg
install_if_missing fd
install_if_missing eza
install_if_missing zoxide
install_if_missing lazygit
install_if_missing volta
install_if_missing gh

# ------------------------------------------------------------------------
# 3. WezTerm (no Linux Homebrew cask -- casks are macOS-only. The `wezterm`
# command isn't necessarily on PATH even when installed as a cask, so check
# for the .app bundle directly on macOS rather than relying on `have`.)
# ------------------------------------------------------------------------

wezterm_installed() {
  if $IS_MACOS; then
    [ -d "/Applications/WezTerm.app" ]
  else
    have wezterm
  fi
}

if ! wezterm_installed; then
  if $IS_MACOS; then
    log "Installing WezTerm (brew cask)..."
    brew install --cask wezterm
  elif $IS_LINUX; then
    if have apt-get; then
      log "Installing WezTerm (official apt repo)..."
      curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
      echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' \
        | sudo tee /etc/apt/sources.list.d/wezterm.list >/dev/null
      sudo apt-get update
      sudo apt-get install -y wezterm
    else
      warn "No apt-get found -- install WezTerm manually: https://wezterm.org/installation.html"
    fi
  fi
else
  log "WezTerm already installed"
fi

# ------------------------------------------------------------------------
# 4. zsh as the login shell
#
# Checked against the account's actual configured shell (getent/dscl), not
# the $SHELL env var -- that reflects how this process was invoked, not
# the login shell, and is unreliable in non-interactive contexts. Only
# acts if the current login shell isn't *some* zsh at all: macOS already
# ships a perfectly fine system zsh at /bin/zsh, so a machine already
# using that as its login shell doesn't need forcing onto Homebrew's zsh
# specifically -- only a truly zsh-less login shell (e.g. bash on a
# fresh Ubuntu box) needs chsh here.
# ------------------------------------------------------------------------

ZSH_BIN="$(command -v zsh)"
if $IS_MACOS; then
  CURRENT_LOGIN_SHELL="$(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')"
else
  CURRENT_LOGIN_SHELL="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7)"
fi

if [ "$(basename "${CURRENT_LOGIN_SHELL:-}")" = "zsh" ]; then
  log "Login shell is already zsh ($CURRENT_LOGIN_SHELL)"
else
  log "Setting zsh as the login shell..."
  if ! grep -qx "$ZSH_BIN" /etc/shells 2>/dev/null; then
    echo "$ZSH_BIN" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s "$ZSH_BIN" "$USER" || warn "chsh failed -- set your login shell to $ZSH_BIN manually"
fi

# ------------------------------------------------------------------------
# 5. oh-my-zsh + plugins
# ------------------------------------------------------------------------

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  log "oh-my-zsh already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
clone_zsh_plugin() {
  local name="$1" url="$2" dest="$ZSH_CUSTOM/plugins/$1"
  if [ ! -d "$dest" ]; then
    log "Cloning zsh plugin: $name"
    git clone --depth=1 "$url" "$dest"
  fi
}
clone_zsh_theme() {
  local dest="$ZSH_CUSTOM/themes/powerlevel10k"
  if [ ! -d "$dest" ]; then
    log "Cloning powerlevel10k theme"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$dest"
  fi
}
clone_zsh_theme
clone_zsh_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
clone_zsh_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting

# ------------------------------------------------------------------------
# 6. gpakosz/.tmux framework + symlink
# ------------------------------------------------------------------------

if [ ! -d "$HOME/.tmux/.git" ]; then
  log "Cloning gpakosz/.tmux..."
  git clone --depth=1 https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
else
  log "gpakosz/.tmux already cloned"
fi
if [ ! -e "$HOME/.tmux.conf" ]; then
  ln -s .tmux/.tmux.conf "$HOME/.tmux.conf"
fi
# .tmux.conf.local itself comes from the dotfiles checkout, not this clone.

# ------------------------------------------------------------------------
# 7. TPM (tmux plugin manager)
# ------------------------------------------------------------------------

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  log "Cloning TPM..."
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  log "TPM already cloned"
fi

# ------------------------------------------------------------------------
# 8. Dotfiles bare repo (no-op if already checked out, e.g. when this
#    script is being run as part of the checkout it came from)
# ------------------------------------------------------------------------

DOTFILES_REPO="https://github.com/johnnguyencodes/dotfiles.git"
dotfiles() { git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"; }

if [ ! -d "$HOME/.dotfiles" ]; then
  log "Cloning dotfiles bare repo..."
  git clone --bare "$DOTFILES_REPO" "$HOME/.dotfiles"
  dotfiles config status.showUntrackedFiles no

  log "Checking out dotfiles (backing up any conflicting existing files)..."
  checkout_output="$(dotfiles checkout 2>&1)"
  if echo "$checkout_output" | grep -q "^\s*\."; then
    backup_dir="$HOME/.dotfiles-backup"
    mkdir -p "$backup_dir"
    echo "$checkout_output" | grep -E "^\s+\." | awk '{print $1}' | while read -r f; do
      mkdir -p "$backup_dir/$(dirname "$f")"
      mv "$HOME/$f" "$backup_dir/$f"
    done
    dotfiles checkout
    warn "Pre-existing files that conflicted with the dotfiles checkout were backed up to $backup_dir"
  fi
else
  log "Dotfiles already checked out"
fi

# ------------------------------------------------------------------------
# Done
# ------------------------------------------------------------------------

log "Bootstrap complete. Next steps:"
echo "  1. Restart your shell (or open a new terminal) so zsh/oh-my-zsh takes effect."
echo "  2. Open tmux and wait a few seconds for TPM to finish installing plugins"
echo "     (tmux-copycat, tmux-cpu, tmux-battery, tmux-resurrect, tmux-continuum,"
echo "     tmux-sessionx, tmux-floax) -- this happens automatically on first launch."
echo "  3. Open WezTerm and confirm the font (JetBrains Mono) and colors look right."
echo "  4. Run 'nvim' -- lazy.nvim will bootstrap itself and install all plugins"
echo "     on first launch."
echo "  5. Optional: run 'p10k configure' to customize the prompt, or add your own"
echo "     wallpapers to ~/Catppuccin Wallpapers/landscapes/ (not tracked in this"
echo "     repo) if you want the daily-wallpaper WezTerm feature."
