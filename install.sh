#!/bin/sh

# Change Debian to SID Branch
cp /etc/apt/sources.list /etc/apt/sources.list.bak
cp sources.list /etc/apt/sources.list 

# Copy Fonts etc
rm -rf /usr/share/fonts
cp -aR fonts /usr/share
cp -aR main.py /usr/bin
ln -s /usr/bin/main.py /usr/bin/autotiling
chmod +x /usr/bin/main.py /usr/bin/autotiling


# Install sudo and required package
apt update
apt install nala -y
nala upgrade -y
nala install sudo wget curl zsh apt-transport-https software-properties-common gpg lsb-release ca-certificates -y
nala install git gcc build-essential libpam0g-dev libxcb-xkb-dev meson dh-autoreconf libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev libxcb-shape0 libxcb-shape0-dev libxfce4ui-2-dev libpolkit-agent-1-dev -y

# Clone i3Gaps
mkdir Git
cd Git
git clone https://github.com/Airblader/i3 i3-gaps

# Clone Xfce polkit
git clone https://github.com/ncopa/xfce-polkit.git

# Clone Ly dispaly manager
git clone --recurse-submodules https://github.com/fairyglade/ly

# Add aditional repo
# Add Brave repo
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Add PHP Surya repo
echo "deb https://packages.sury.org/php/ bullseye main" | sudo tee /etc/apt/sources.list.d/sury-php.list
wget -qO - https://packages.sury.org/php/apt.gpg | sudo apt-key add -

# Add Visual Studio Code repo
cp -aR vscode.list /etc/apt/sources.list.d/
cp -aR microsoft.gpg /etc/apt/trusted.gpg.d/

#install aditional pacakge
nala upgrade -y
nala install rofi libnm-dev network-manager-gnome xclip nitrogen polybar -y
nala install thunar brave-browser code geany kitty viewnior vlc ranger xarchiver lxappearance mpd mpc ncmpcpp python3-pip pavucontrol -y
nala install composer network-manager libnss3-tools jq xsel php8.1-cli php8.1-curl php8.1-mbstring php8.1-mcrypt php8.1-xml php8.1-zip php8.1-sqlite3 php8.1-mysql php8.1-pgsql php8.1-fpm -y

# install Themes and icons
nala install papirus-icon-theme -y
git clone https://github.com/EliverLara/Nordic.git /usr/share/themes/Nordic

# Install Fonts emoji
nala install fonts-noto-color-emoji -y
fc-cache -vf

# Install Liquorix kernel
echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub
curl 'https://liquorix.net/add-liquorix-repo.sh' | sudo bash

# Install I3gaps 
cd i3-gaps
mkdir -p build
cd build
meson --prefix /usr/local
ninja
sudo ninja install
cd ..
cd ..

# Install Xfce polkit
cd xfce-polkit
mkdir build
cd build
meson --prefix=/usr ..
ninja
ninja install
cd ..
cd ..

# Install Ly display manager
cd ly
make
make install installsystemd
systemctl enable ly.service

sudo usermod -aG sudo $USER
nala upgrade -y

