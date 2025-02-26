#! /bin/bash

INSTALL_METHOD="snap"  # Options: snap, flatpak

sudo apt update

# Install obs
sudo add-apt-repository ppa:obsproject/obs-studio

sudo apt install obs-studio

install_zotero() {
  # Zotero installation
  sudo apt update && sudo apt install -y libgtk-3-0 libdbus-glib-1-2 libxss1
  ZOTERO_URL="https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64&version=7.0.11"
  INSTALL_DIR="/opt/zotero"

  cd ~/Downloads    
  wget -O zotero.tar.bz2 "$ZOTERO_URL"
  sudo mkdir -p "$INSTALL_DIR"
  sudo tar -xvjf zotero.tar.bz2 -C "$INSTALL_DIR" --strip-components=1
  rm zotero.tar.bz2

  sudo ln -sf "$INSTALL_DIR/zotero" /usr/local/bin/zotero

}


install_whatsapp() {
    echo "Installing WhatsApp..."
    if [ "$INSTALL_METHOD" == "snap" ]; then
        sudo apt install -y snapd
        sudo snap install whatsapp-linux-app
    elif [ "$INSTALL_METHOD" == "flatpak" ]; then
        sudo apt install -y flatpak
        remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        flatpak install -y flathub org.whatsapp.WhatsApp
    else
        echo "Invalid installation method. Please choose 'snap' or 'flatpak'."
        exit 1
    fi
    echo "WhatsApp installation completed!"
}

install_vscode() {
  cd ~./Downloads
  wget -O code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
  sudo dpkg -i code.deb
  sudo apt -f install
  rm code.deb
}

install_spotify() {
    sudo snap install spotify
}

PROGRAMS=("Zotero" "WhatsApp" "Vscode" "Spotify")
INSTALL_FUNCTIONS=("install_zotero" "install_whatsapp" "install_vscode" "install_spotify")


read -p "Do you want to install all programs? (yes/no) " INSTALL_ALL


for i in "${!PROGRAMS[@]}"; do
    if [ "$INSTALL_ALL" == "yes" ]; then
        ${INSTALL_FUNCTIONS[$i]}
    else
        read -p "Do you want to install ${PROGRAMS[$i]}? (yes/no) " INSTALL_CHOICE
        if [ "$INSTALL_CHOICE" == "yes" ]; then
            ${INSTALL_FUNCTIONS[$i]}
        fi
    fi
done

echo "Installation process completed!"

