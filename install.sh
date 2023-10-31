#!/usr/bin/env bash
set -e

# vars
PYTHON_VERSION="3.10.11"

force_stow() {
  cd ~/.dotfiles
  stow --adopt $1
  git restore . || true
  cd -
}

# Linux or Darwin
unameOut="$(uname -s)"

if [ "$unameOut" == "Linux" ]; then
    # install system deps and tools
    sudo sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf || true
    sudo apt update
    sudo NEEDRESTART_MODE=a DEBIAN_FRONTEND=noninteractive apt -y install build-essential libssl-dev zlib1g-dev \
      libbz2-dev libreadline-dev libsqlite3-dev ca-certificates curl gnupg python3-venv python3-pip \
      libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
      git zsh tmux stow htop tree net-tools fzf neofetch gitsome direnv
elif [ "$unameOut" == "Darwin" ]; then
    if ! command -v brew &>/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install xz stats tmux stow fzf neofetch direnv
    brew install htop || true
else
    echo "Unknown OS: ${unameOut}"
    exit 1
fi

if ! command -v docker &>/dev/null; then
  if [ "$unameOut" == "Linux" ]; then
    echo ">>> Installing docker..."
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |
      sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt update
    sudo NEEDRESTART_MODE=a DEBIAN_FRONTEND=noninteractive apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker $USER
    echo "Docker installation complete"
  else
    brew install --cask docker
  fi
fi

if ! command -v helm &>/dev/null; then
  echo ">>> Installing helm..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  echo "Helm installation complete"
fi

if ! command -v k9s &>/dev/null; then
  echo ">>> Installing k9s..."
  if [[ $(arch) == "aarch64" ]]; then
    curl -LO https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_arm64.tar.gz
    tar xzvf k9s_Linux_arm64.tar.gz
  fi

  if [[ $(arch) == "x86_64" ]]; then
    curl -LO https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz
    tar xzvf k9s_Linux_amd64.tar.gz
  fi

  if [[ $(arch) == "i386" ]]; then
    curl -LO https://github.com/derailed/k9s/releases/latest/download/k9s_Darwin_amd64.tar.gz
    tar xzvf k9s_Darwin_amd64.tar.gz
  fi

  sudo mv k9s /usr/local/bin
  echo "K9s installation complete"
fi

if ! command -v minikube &>/dev/null; then
  echo ">>> Installing minikube..."
  if [[ $(arch) == "aarch64" ]]; then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
    sudo install minikube-linux-arm64 /usr/local/bin/minikube
  fi

  if [[ $(arch) == "x86_64" ]]; then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
  fi

  if [[ $(arch) == "i386" ]]; then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
    sudo install minikube-darwin-amd64 /usr/local/bin/minikube
  fi
  echo "Minikube installation complete"
fi

if ! command -v kubectl &>/dev/null; then
  echo ">>> Installing kubectl..."
  if [[ $(arch) == "aarch64" ]]; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
  fi

  if [[ $(arch) == "x86_64" ]]; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  fi

  if [[ $(arch) == "i386" ]]; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
  fi
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  echo "Kubectl installation complete"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo ">>> Installing zsh..."
  echo $(zsh --version)
  sudo sh -c "echo $(which zsh) >> /etc/shells"
  sudo chsh -s $(which zsh) $(whoami)
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  force_stow zsh
  echo "Zsh installation complete"
fi

if [ ! -d "$HOME/.pyenv" ]; then
  echo ">>> Installing pyenv..."
  curl https://pyenv.run | bash
  source ~/.toolsrc.sh
  echo $(pyenv --version)
  echo "Pyenv installation complete"
fi

# install and set default python using pyenv
if [ ! -d "$HOME/.pyenv/versions/$PYTHON_VERSION" ]; then
  pyenv install $PYTHON_VERSION
  pyenv install 3.7
  pyenv install 3.8
  pyenv global $PYTHON_VERSION
fi

if [ ! -d "$HOME/.local/pipx" ]; then
  echo ">>> Installing pipx..."
  if [ "$unameOut" == "Linux" ]; then
    pip install pipx
  else
    brew install pipx
    pipx ensurepath
  fi
  echo "Pipx installation complete"
fi

# install python global tools
PIPX_PACKAGES="pipenv glances ipython python-dotenv tldr argcomplete poetry pgcli httpie"
for pkg in $PIPX_PACKAGES; do
  pipx install "$pkg"
done
sudo $(which activate-global-python-argcomplete) || true

# setup tpm
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

force_stow tmux
~/.tmux/plugins/tpm/scripts/install_plugins.sh
force_stow git
force_stow zsh

echo "Setup completed! To take all the effects log out and log in back."
