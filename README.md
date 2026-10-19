# dotfiles

i3 + polybar + ghostty/tmux + zsh + neovim setup for Ubuntu (24.04 or newer). Theme: rose-pine / catppuccin.

## Install on a fresh Ubuntu

```bash
sudo apt update && sudo apt install -y git
git clone https://github.com/artursil/dotfiles ~/dotfiles
cd ~/dotfiles && ./install.sh
```

Then log out, choose **i3** at the login screen (cog icon), and log back in.

The repo must live at `~/dotfiles`, because stow links each package into the parent folder (`~`).

### What `install.sh` does

It runs these sections in order. Each step skips anything already installed, so the script is safe to run again.

| Section    | Installs |
|------------|----------|
| `base`     | git, curl, stow, zsh, tmux, ripgrep, fd, bat, lsd, btop, fastfetch, gh, tldr, ranger, pipx, flatpak + Flathub, timeshift, mpv |
| `desktop`  | i3, polybar, picom, rofi, dunst, feh, maim, playerctl, brightnessctl, pavucontrol, nm-applet, dex, xss-lock, xautolock, i3lock-color, betterlockscreen |
| `terminal` | ghostty, kitty, Nerd Fonts (FiraCode, Meslo, JetBrainsMono) |
| `dev`      | neovim (latest stable, in `/opt`), rust + rust-analyzer, node/npm, go, uv, docker, oh-my-posh, zoxide, fzf, lazygit, tmux tpm, tmuxifier |
| `apps`     | chrome, vscode, tidal (tidal-hifi), whatsapp, zotero, obs, nordvpn, nvidia driver (only if an NVIDIA GPU is found) |
| `link`     | stows all configs into `~`, clones the qutebrowser theme, copies the wallpaper, installs tmux and nvim plugins, makes zsh the login shell |

You can run only some sections, or pick which apps to install:

```bash
./install.sh base dev link
APPS="tidal vscode" ./install.sh apps
```

If a real file is in the way of a link (for example the default `~/.zshrc`), the script moves it to `~/.dotfiles-backup/` before linking.

### Per-machine settings

Project aliases, conda and CUDA paths go in `~/.zshrc.local`. That file is not tracked; `.zshrc` sources it if it exists. Start from `zshrc.local.example`.

### After install

- `docker` without sudo works after you log out and back in.
- In tmux, press `prefix + I` if any plugins are missing.
- To change the theme, edit `ohmyposh/.config/ohmyposh/cat.json`, `polybar/.config/polybar/rose-pine.ini` and `kitty/.config/kitty/current-theme.conf`.

## Layout

Each top-level folder is a [GNU stow](https://www.gnu.org/software/stow/) package that mirrors `$HOME`:

```
zshrc/.zshrc                 -> ~/.zshrc
tmux/.tmux.conf              -> ~/.tmux.conf
nvim/.config/nvim/           -> ~/.config/nvim/
i3/ polybar/ picom/ rofi/ dunst/ ghostty/ kitty/ ohmyposh/ qutebrowser/ ranger/
```

To link one package by hand: `cd ~/dotfiles && stow nvim`.

---

# Cheatsheet

## i3  (`mod` = **Alt**)

| Keys | Action |
|------|--------|
| `mod+Enter` | ghostty with tmux |
| `mod+p` | app launcher (rofi) |
| `mod+d` | switch window (rofi) |
| `mod+Shift+q` | close window |
| `mod+h/j/k/l` or arrows | focus left / down / up / right |
| `mod+Shift+j/k/l/;` or arrows | move window left / down / up / right |
| `mod+q w e r t y u i o 0` | go to workspace 1–10 |
| `mod+Shift+1…0` | move window to workspace 1–10 |
| `mod+f` | fullscreen |
| `mod+z` / `mod+x` / `mod+c` | stacking / tabbed / toggle split |
| `mod+Shift+space` | toggle floating |
| `mod+a` | focus parent |
| `mod+s` | resize mode (`j k l ;` or arrows, `Esc` to leave) |
| `mod+Shift+x` | lock screen |
| `Print` | screenshot of an area to the clipboard |
| `Shift+Print` | screenshot of an area to `~/Pictures` |
| `mod+Print` | screenshot of the whole screen to the clipboard |
| `mod+Shift+c` / `mod+Shift+r` | reload / restart i3 |
| `mod+Shift+e` | exit i3 |

Caps Lock is remapped to Ctrl. The screen locks after 1 minute idle.

## tmux  (prefix = **Ctrl+s**)

| Keys | Action |
|------|--------|
| `prefix r` | reload config |
| `prefix c` | new window (current dir) |
| `prefix %` / `prefix "` | split left-right / top-bottom (current dir) |
| `prefix -` | small split at the bottom (20%) |
| `prefix m` | zoom the pane |
| `prefix h/j/k/l` | select pane |
| `Ctrl+h/j/k/l` | move between panes **and** nvim splits |
| `prefix [` then `v` / `Ctrl+v` / `y` | copy mode: select / block select / copy |
| `prefix I` | install plugins (tpm) |

## Neovim  (leader = **Space**)

Movement is shifted one key right: **`j k l ;` = left, down, up, right**.

| Keys | Action |
|------|--------|
| `Ctrl+p` / `<leader>ff` | find files |
| `<leader>fg` | live grep |
| `<leader>fu` | recent files |
| `<leader>e` | file tree (neo-tree) |
| `<leader>,` | buffer list |
| `gd` / `K` | go to definition / hover |
| `<leader>gr` | references |
| `<leader>ca` | code action |
| `<leader>d` | show diagnostics |
| `<leader>fo` | format |
| `Ctrl+/` | toggle comment |
| `<leader><leader>w` / `b` | hop to a word forward / back |
| `<leader>gp` / `<leader>gt` | git hunk preview / line blame |
| `<leader>t` `T` `a` `l` `g` | test nearest / file / suite / last / visit |
| `<leader>h` | clear search highlight |
| visual `Alt+j` / `Alt+l` | move the selection down / up |
| visual `Ctrl+c`, normal `Ctrl+Shift+v` | copy to / paste from the system clipboard |
| `<space>x` / `<space>c` | Jupynium: run / clear cell |
| `<space>ns` | Jupynium: start and attach to the server |

## zsh

| Command | Action |
|---------|--------|
| `Ctrl+f` | accept autosuggestion |
| `Ctrl+r` | fuzzy history (fzf) |
| `z <dir>` | jump to a directory (zoxide) |
| `vim` | nvim |
| `inv` | fzf-pick files and open them in nvim |
| `fcd` | fzf-pick a directory and cd into it |
| `ll`, `c`, `rr` | ls -alh / clear / ranger |
| `zs` | reload `.zshrc` |
| `goh`, `dotfiles`, `vconf` | cd to home / dotfiles / nvim config |
| `Esc` | vi mode (zsh-vi-mode) |

## Other

- `lazygit` is the git TUI.
- `tmuxifier` keeps tmux session layouts (`tmuxifier new-session name`).
- `betterlockscreen -u ~/Pictures/wallpaper_1.jpg` sets the lock screen image.
