#!/bin/sh
sudo apt install -y gnupg2
sudo apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'

#set up custom sources
sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/debian stretch-cran35/" >> /etc/apt/sources.list'

sudo apt update  # To get the latest package lists

#Install tmux
sudo apt install -y tmux

#Install R
sudo apt install -y r-base
sudo apt install -y r-base-dev

