!#/bin/bash
locale=en_US.UTF-8
layout=us
sudo raspi-config nonint do_change_locale $locale
sudo raspi-config nonint do_configure_keyboard $layout

echo -n " consoleblank=300" >> /boot/cmdline.txt
echo "hdmi_blanking=300" >> /boot/config.txt
echo "display_rotate=1" >> /boot/config.txt
# must disable dtoverlay
sed -i 's/dtoverlay=vc4-kms-v3d/#dtoverlay=vc4-kms-v3d/' /boot/config/txt


#setup dotfiles
bash dotfiles/bootstrap.sh

type -p curl >/dev/null || sudo apt install curl -y
19 curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && sudo chmod    go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive   -keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && sudo apt update && sudo a   pt install gh -y
# gh auth login

apt install vlock # for locking terminal


git config --global user.name "Vergil Weatherford"
git config --global user.email "vergilcw@gmail.com"
git config --global pull.ff only

git clone https://github.com/vergilcw/epson-es300w-autoscan

curl -fsSL https://tailscale.com/install.sh | sh


