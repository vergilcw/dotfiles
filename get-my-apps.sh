#!/bin/sh

#this file is set up to help get up and running on crostini. 
#TODO: adapt this into a docker-based workflow, so it works anywhere docker does.

sudo apt install -y gnupg2
sudo apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'

#set up custom sources

# CRAN R
echo "deb http://cran.rstudio.com/bin/linux/debian stretch-cran35/" | sudo tee /etc/apt/sources.list.d/cran35.list
# Cloud SDK 
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
# Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Update the package list and install the Cloud SDK
sudo apt-get update && sudo apt-get install google-cloud-sdk

sudo apt update  # To get the latest package lists

#Install tmux
sudo apt install -y tmux

#Install R
sudo apt install -y r-base
sudo apt install -y r-base-dev

#Install gcloud SDK
sudo apt-get install google-cloud-sdk

#install latest docker (instructions from https://docs.docker.com/install/linux/docker-ce/debian/)
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

echo "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list

sudo apt-get install docker-ce docker-ce-cli containerd.io
#make it so you don't have to run sudo for every docker command
#(requires a full restart to take effect)
sudo groupadd docker
sudo usermod -aG docker vergilcw

#install miniconda:
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
