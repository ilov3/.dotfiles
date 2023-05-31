NPROC=$(nproc --all)
RAM=$(LANG=C free -m|awk '/^Mem:/{print $2}')
MINIKUBE_RAM=$(($RAM-1536))
MINIKUBE_CPU=$(($NPROC-1))
export LC_ALL=en_US.UTF-8
export LC_TIME=en_GB.UTF-8
export LANG=en_US.UTF-8

export DEV_PROJ_DIR="$HOME/dev/"
alias zc="nano ~/.zshrc"
alias cal="nano ~/.envfile.sh"
alias tc="nano ~/.toolsrc.sh"
function mindocker() {
  eval $(minikube docker-env --shell zsh)
}
function mindockerreset() {
  eval $(minikube docker-env -u)
}
function shbootstrap() {
  PREV_DIR=$(pwd)
  cd ~/.dotfiles
  git pull || true
  cd ~
  .dotfiles/install.sh
  cd $PREV_DIR
}
alias mks="minikube start --disable-metrics --driver=docker --memory ${MINIKUBE_RAM}m --cpus ${MINIKUBE_CPU} --mount --mount-string=$HOME:$HOME"
alias jn="jupyter notebook"
alias renamectx="kubectl config rename-context minikube docker-desktop"

timez() {
  printf "%-10s %s \n" "East Coast" "$(TZ=America/New_York date)"
  printf "%-10s %s \n" "West Coast" "$(TZ=America/Los_Angeles date)"
  printf "%-10s %s \n" "Turkey" "$(TZ=Europe/Istanbul date)"
}

alias tlc="tmux source ~/.tmux.conf"
alias tec="nano ~/.tmux.conf"
