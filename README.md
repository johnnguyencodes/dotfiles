# dotfiles

Personal dev environment config, tracked as a [bare git
repo](https://www.atlassian.com/git/tutorials/dotfiles) with `$HOME` as the
work-tree. Covers Neovim, zsh, WezTerm, and tmux, plus a bootstrap script to
set all of it up on a fresh machine (macOS or Ubuntu/Debian Linux).

## What's here

- **`.config/nvim/`** -- Neovim config (lazy.nvim, LSP via mason/mason-lspconfig,
  Catppuccin theme). Used to be its own repo
  ([johnnguyencodes/nvim](https://github.com/johnnguyencodes/nvim)), which is
  still around as a permanent historical record of how it evolved, but this
  repo is the live source going forward.
- **`.zshrc`**, **`.p10k.zsh`** -- zsh + oh-my-zsh + powerlevel10k.
- **`.wezterm.lua`** -- WezTerm terminal config.
- **`.tmux.conf`** (symlink) + **`.tmux.conf.local`** -- tmux, built on the
  [gpakosz/.tmux](https://github.com/gpakosz/.tmux) framework with a
  Catppuccin status line. `.tmux.conf` is tracked here, but only as the
  symlink itself (pointing at `.tmux/.tmux.conf`) -- its target comes from
  a separate clone of the upstream framework at `~/.tmux` that
  `bootstrap.sh` sets up, so the symlink is dangling until that clone
  exists (harmless: bootstrap clones `~/.tmux` before anything checks the
  symlink, and recreates it too if it's ever missing). `.tmux.conf.local`,
  the actual customization file, is a plain tracked file.
- **`bootstrap.sh`** -- installs everything above needs (Homebrew, the CLI
  toolset, Node via Volta, WezTerm, oh-my-zsh + plugins, the tmux framework +
  TPM) and checks out this repo. Safe to re-run any time -- every step checks
  whether it's already done before acting.

**Not included:** the Catppuccin wallpaper images `.wezterm.lua` references
(`~/Catppuccin Wallpapers/landscapes/`) -- binary assets, kept out of the
repo. `.wezterm.lua` skips the background-image feature gracefully if that
folder doesn't exist, so this is optional; add your own images there if you
want it.

## Bootstrap a new machine

```sh
git clone --bare https://github.com/johnnguyencodes/dotfiles.git "$HOME/.dotfiles"
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout 2>&1 \
  | grep -E '^\s+\.' | awk '{print $1}' | while read -r f; do
    mkdir -p "$HOME/.dotfiles-backup/$(dirname "$f")"
    mv "$HOME/$f" "$HOME/.dotfiles-backup/$f"
  done
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
bash "$HOME/bootstrap.sh"
```

The middle two lines handle the standard bare-repo-dotfiles gotcha: if a
fresh machine already has conflicting files (e.g. a default `.zshrc`), the
first checkout attempt lists them instead of overwriting; that output gets
parsed to back those files up to `~/.dotfiles-backup/` before checking out
for real. On a genuinely empty home directory this is a no-op.

`bootstrap.sh` prints next-step guidance (restart your shell, let tmux's
plugin manager finish installing on first launch, etc.) when it finishes.

## Day-to-day: making changes

The `dotfiles` alias (defined in `.zshrc`) wraps git with the right
`--git-dir`/`--work-tree` flags, so it works from anywhere in `$HOME`:

```sh
dotfiles status
dotfiles add .zshrc
dotfiles commit -m "..."
dotfiles push
```

This applies to Neovim config too -- since it's folded into this repo,
`cd ~/.config/nvim && git status` won't work (there's no `.git` there
anymore); use `dotfiles` instead, same as any other tracked file.
