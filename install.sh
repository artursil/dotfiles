#!/usr/bin/env bash
# One-shot setup for a fresh Ubuntu install (24.04+).
#
#   ./install.sh                 # everything
#   ./install.sh base dev link   # only some sections
#   APPS="tidal vscode" ./install.sh apps
#
# Sections run in this order: base desktop terminal dev apps link.
# Every step is safe to re-run: things already installed are skipped.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALL_SECTIONS=(base desktop terminal dev apps link)
ALL_APPS=(chrome vscode tidal whatsapp zotero obs nordvpn nvidia)
read -r -a APPS <<< "${APPS:-${ALL_APPS[*]}}"
STOW_PACKAGES=(zshrc tmux nvim i3 polybar picom rofi dunst ghostty kitty ohmyposh qutebrowser ranger)
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.fzf/bin:$PATH"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

log()  { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
have() { command -v "$1" &>/dev/null; }
apt_install() { sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"; }
gh_latest() { curl -fsSL "https://api.github.com/repos/$1/releases/latest" | grep -Po '"tag_name": *"v?\K[^"]*'; }

# ---------------------------------------------------------------- base
section_base() {
    log "Base packages"
    sudo apt-get update
    apt_install git curl wget stow zsh tmux build-essential cmake unzip jq \
        ripgrep fd-find bat lsd btop htop fastfetch xclip gh tldr ranger \
        python3-pip python3-venv pipx software-properties-common \
        flatpak snapd timeshift mpv 7zip imagemagick
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    mkdir -p ~/.local/bin ~/Pictures ~/Downloads
    # Ubuntu names these binaries batcat / fdfind
    ln -sf /usr/bin/batcat ~/.local/bin/bat
    ln -sf /usr/bin/fdfind ~/.local/bin/fd
}

# ---------------------------------------------------------------- desktop (i3)
section_desktop() {
    log "i3 desktop"
    apt_install i3 polybar picom rofi dunst libnotify-bin feh maim \
        playerctl brightnessctl pavucontrol pulseaudio-utils \
        network-manager-gnome dex xss-lock xautolock x11-xserver-utils arandr

    if ! i3lock --version 2>&1 | grep -q color; then
        log "i3lock-color (needed by betterlockscreen)"
        sudo apt-get purge -y i3lock || true
        apt_install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev \
            libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev \
            libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev \
            libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev \
            libjpeg-dev libgif-dev
        git clone --depth 1 https://github.com/Raymo111/i3lock-color.git "$TMP/i3lock-color"
        (cd "$TMP/i3lock-color" && ./install-i3lock-color.sh)
    fi
    if ! have betterlockscreen; then
        apt_install bc
        wget -qO- https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh | sudo bash -s system
    fi
}

# ---------------------------------------------------------------- terminal
section_terminal() {
    log "Terminals and fonts"
    apt_install kitty
    have ghostty || sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"

    local fontdir=~/.local/share/fonts
    mkdir -p "$fontdir"
    for font in FiraCode Meslo JetBrainsMono; do
        if [ ! -d "$fontdir/$font" ]; then
            mkdir -p "$fontdir/$font"
            curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.tar.xz" \
                | tar -xJ -C "$fontdir/$font"
        fi
    done
    fc-cache -f
}

# ---------------------------------------------------------------- dev tools
section_dev() {
    log "Dev tools"
    apt_install nodejs npm golang luarocks docker.io docker-compose-v2
    sudo usermod -aG docker "$USER"

    if ! have nvim || [ "$(readlink -f "$(command -v nvim)")" != /opt/nvim-linux-x86_64/bin/nvim ]; then
        log "Neovim (latest stable)"
        sudo apt-get purge -y neovim neovim-runtime || true
        curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
            | sudo tar -xz -C /opt
        sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    fi

    if [ ! -x ~/.cargo/bin/rustup ]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    fi
    ~/.cargo/bin/rustup component add rust-analyzer

    have uv || curl -LsSf https://astral.sh/uv/install.sh | sh
    have oh-my-posh || curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
    have zoxide || curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

    # apt fzf is too old for `fzf --zsh`; .zshrc puts ~/.fzf/bin on PATH
    [ -d ~/.fzf ] || git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --bin

    if ! have lazygit; then
        local v; v="$(gh_latest jesseduffield/lazygit)"
        curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v$v/lazygit_${v}_Linux_x86_64.tar.gz" \
            | tar -xz -C "$TMP" lazygit
        sudo install "$TMP/lazygit" -D -t /usr/local/bin/
    fi

    [ -d ~/.tmux/plugins/tpm ] || git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    [ -d ~/.tmuxifier ] || git clone --depth 1 https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
}

# ---------------------------------------------------------------- apps
install_deb_url() {  # $1 = name, $2 = url
    curl -fsSL -o "$TMP/$1.deb" "$2"
    apt_install "$TMP/$1.deb"
}
app_chrome()   { have google-chrome || install_deb_url chrome https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb; }
app_vscode()   { have code || install_deb_url vscode "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"; }
app_whatsapp() { sudo snap install whatsapp-linux-app; }
app_nordvpn()  { sudo snap install nordvpn; }
app_tidal()    { sudo flatpak install -y flathub com.mastermindzh.tidal-hifi; }
app_obs() {
    have obs && return
    sudo add-apt-repository -y ppa:obsproject/obs-studio
    apt_install obs-studio
}
app_zotero() {
    [ -x /opt/zotero/zotero ] && return
    apt_install libgtk-3-0t64 libdbus-glib-1-2 libxss1 || apt_install libgtk-3-0 libdbus-glib-1-2 libxss1
    sudo mkdir -p /opt/zotero
    curl -fsSL "https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64" \
        | sudo tar -xj -C /opt/zotero --strip-components=1
    sudo ln -sf /opt/zotero/zotero /usr/local/bin/zotero
    sudo /opt/zotero/set_launcher_icon || true
    ln -sf /opt/zotero/zotero.desktop ~/.local/share/applications/zotero.desktop
}
app_nvidia() {
    lspci | grep -qi nvidia || { echo "No NVIDIA GPU, skipping driver"; return; }
    apt_install ubuntu-drivers-common nvtop
    sudo ubuntu-drivers install
}

section_apps() {
    mkdir -p ~/.local/share/applications
    for app in "${APPS[@]}"; do
        log "App: $app"
        "app_$app" || echo "!! $app failed, continuing"
    done
}

# ---------------------------------------------------------------- link configs
section_link() {
    log "Linking configs with stow"
    cd "$DOTFILES"
    for pkg in "${STOW_PACKAGES[@]}"; do
        # Move real files that would block stow into ~/.dotfiles-backup
        stow -n -v -t "$HOME" "$pkg" 2>&1 | sed -nE 's/.*existing target is [^:]*: (.*)$/\1/p; s/.*over existing target (\S+) since.*/\1/p' | while read -r f; do
            mkdir -p ~/.dotfiles-backup/"$(dirname "$f")"
            mv ~/"$f" ~/.dotfiles-backup/"$f"
            echo "backed up ~/$f"
        done
        stow -R -t "$HOME" "$pkg"
    done

    local cat=qutebrowser/.config/qutebrowser/catppuccin
    [ -f "$cat/__init__.py" ] || { rm -rf "$cat"; git clone --depth 1 https://github.com/catppuccin/qutebrowser.git "$cat"; }

    [ -f ~/Pictures/wallpaper_1.jpg ] || cp "$DOTFILES/wallpapers/wallpaper_1.jpg" ~/Pictures/
    touch ~/.Xresources

    ~/.tmux/plugins/tpm/bin/install_plugins || true
    nvim --headless "+Lazy! restore" +qa || true

    [ "$(getent passwd "$USER" | cut -d: -f7)" = "$(command -v zsh)" ] || sudo chsh -s "$(command -v zsh)" "$USER"
}

# ---------------------------------------------------------------- main
sections=("$@")
[ ${#sections[@]} -eq 0 ] && sections=("${ALL_SECTIONS[@]}")
sudo -v
for s in "${sections[@]}"; do "section_$s"; done
log "Done. Log out and pick the i3 session at the login screen."
