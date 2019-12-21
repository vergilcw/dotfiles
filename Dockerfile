
FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM=xterm-256color
ENV EDITOR /usr/bin/vim


# use non-root 
RUN groupadd -g 999 appuser && \
    useradd -r -u 999 -g appuser appuser
USER appuser

# Install faves and necessities
sudo apt install -y gnupg2
sudo apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'

#provides apt-add capabilities:
RUN sudo apt update && \
  sudo apt install -y software-properties-common


# CRAN R
echo "deb http://cran.rstudio.com/bin/linux/ubuntu bionic-cran35/" | sudo tee /etc/apt/sources.list.d/cran35.list


# Cloud SDK 
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
# Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -


# Common packages
RUN sudo apt update && sudo apt install -y \
      build-essential \
      #software-properties-common \
      tzdata \
      curl \
      git \
      wget \
      tmux \
      vim \
      markdown \
      zip \
      r-base
      r-base-dev
      google-cloud-sdk
      python3

      #ggmaps
      libgdal20
      libgdal-dev
      libssl-dev

      # required for cv
      texlive-xetex
      texlive-fonts-extra
      texlive-bibtex-extra
      texlive-luatex


      #to look into: 
      # lastpass-cli
      # mosh \
      # nnn \
      # python \
      # python-dev \
      # python-pip \
      # python3-dev \
      # python3-pip \
      # python-virtualenvwrapper \
      # language-pack-en \
      # docker.io \
      # docker-compose \
      # google-drive-ocamlfuse \

# Config timezone
ENV TZ America/New_York
RUN echo $TZ > /etc/timezone && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

#RUN git clone https://github.com/powerline/fonts.git --depth=1 && cd fonts && ./install.sh && cd .. && rm -rf fonts

# # Install clipboard tool (maybe later--looks cool)
# RUN cd /tmp && \ 
#   wget --quiet https://github.com/pocke/lemonade/releases/download/v1.1.1/lemonade_linux_amd64.tar.gz && \
#   tar -zxvf lemonade_linux_amd64.tar.gz && \
#   mv lemonade /usr/bin && \
#   rm -rf lemonade_linux_amd64.tar.gz

# Install kubectl
# RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add && \
#   apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-bionic main" && \
#   sudo apt install kubectl



git clone http://github.com/vergilcw/dotfiles
dotfiles/make_links.sh ~

mkdir ~/.vim/colors
wget --directory-prefix=/home/vergilcw/.vim/colors "https://raw.githubusercontent.com/jeffkreeftmeijer/vim-dim/master/colors/dim.vim"
wget --directory-prefix=/home/vergilcw/.vim/colors "https://raw.githubusercontent.com/jeffkreeftmeijer/vim-dim/master/colors/default-light.vim"

# Config vim
RUN vim +'PlugInstall --sync' +qall +silent


WORKDIR /src

VOLUME /src
VOLUME /root
VOLUME /keys

CMD ["tmux"]
