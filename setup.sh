#! /bin/bash
sudo apt update
sudo apt install git zsh bat rofi dunst libnotify-dev gh xclip htop \
    tmux

sudo apt install ripgrep \ # for live_grep
sudo apt install maim \ # for screenshots

# Installing neovim from source
if ! command -v nvim &> /dev/null; then
    sudo apt remove --purge neovim neovim-runtime -y
    sudo apt install -y ninja-build gettext cmake unzip curl build-essential
    git clone https://github.com/neovim/neovim.git --depth=1
    cd neovim
    git checkout stable
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    cd build && sudo cpack -G DEB
    sudo dpkg -i nvim-linux-x86_64.deb && echo "Neovim stable release installed"
    cd ../..
    rm -r neovim
else
    echo "Neovim is already installed."
fi


# Zsh config
chsh -s $(which zsh)
if [ ! -s ~/.zshrc ]; then
    cp base_zshrc ~/.zshrc
fi

source ~/.zshrc

git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier

if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    cd ~/Downloads 
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    rm -r lazygit
    rm -r lazygit.tar.gz
else
    echo "Lazygit is already installed."
fi


if ! command -v oh-my-posh &> /dev/null; then
    echo "Installing Oh My Posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
else
    echo "Oh My Posh is already installed."
fi

echo "Do you want to install zoxide (y/n)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    # Install fzf if not installed
    if ! command -v fzf &> /dev/null; then
        echo "Installing fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
    else
        echo "fzf is already installed."
    fi
fi

# Install zoxide if not installed
echo "Do you want to install zoxide (y/n)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
  if ! command -v zoxide &> /dev/null; then
      echo "Installing zoxide..."
      curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  else
      echo "zoxide is already installed."
  fi
fi

#Npm
echo "Do you want to install npm (y/n)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    sudo apt update && sudo apt install nodejs npm -y
fi


echo "Do you want to install fonts (y/n)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    # Clone the Nerd Fonts repository
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
    cd nerd-fonts || exit

    # Install Meslo, Fira Code, and JetBrains Mono
    ./install.sh Meslo
    ./install.sh FiraCode
    ./install.sh JetBrainsMono

    # Clean up (optional)
    cd ..
    rm -rf nerd-fonts

    # Refresh font cache
    fc-cache -fv

    echo "Meslo, Fira Code, and JetBrains Mono Nerd Fonts installed successfully!"
else
    echo "No fonts installed"
fi

