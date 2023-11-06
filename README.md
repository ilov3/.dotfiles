## Personal Linux/Mac dev env bootstrap scripts

Uses GNU [stow](https://www.gnu.org/software/stow/) to manage dotfiles

Installs and configures following programs, dev tools and utils (for a full list inspect [install.sh](install.sh)):
```
zsh
tmux
direnv
docker
minikube
helm
k9s
pyenv (also sets python3.10.x as a global default)
pipx
...
```

### Usage

```shell
cd ~
git clone git@github.com:ilov3/.dotfiles.git
.dotfiles/install.sh
```
