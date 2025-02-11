#! /bin/bash
sudo apt install git zsh bat rofi dunst libnotify-dev gh xclip

# Zsh config
chsh -s $(which zsh)
if [ ! -s ~/.zshrc ]; then
    cp base_zshrc ~/.zshrc
fi
source ~/.zshrc
# curl -sS https://starship.rs/install.sh | sh
curl -s https://ohmyposh.dev/install.sh | bash -s

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

#Npm
sudo apt update && sudo apt install nodejs npm -y


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

