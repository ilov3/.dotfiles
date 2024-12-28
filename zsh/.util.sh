force_stow() {
  cd ~/.dotfiles
  stow --adopt $1
  git restore . || true
  cd -
}

is_linux() {
  if [ "$(uname -s | tr '[:upper:]' '[:lower:]')" == "linux" ];
  then return 0
  else return 1
  fi
}

is_fedora() {
  if uname -a | tr '[:upper:]' '[:lower:]' | grep fedora > /dev/null;
  then return 0
  else return 1
  fi
}

is_ubuntu() {
  if uname -a | tr '[:upper:]' '[:lower:]' | grep ubuntu > /dev/null;
  then return 0
  else return 1
  fi
}

is_mac() {
  if [ "$(uname -s | tr '[:upper:]' '[:lower:]')" == "darwin" ];
  then return 0
  else return 1
  fi
}

is_linux_64() {
  if [ "$(uname -s | tr '[:upper:]' '[:lower:]')" == "linux" ] && [ "$(arch)" == "x86_64" ];
  then return 0
  else return 1
  fi
}

is_linux_arm() {
  if [ "$(uname -s | tr '[:upper:]' '[:lower:]')" == "linux" ] && [ "$(arch)" == "aarch64" ];
  then return 0
  else return 1
  fi
}

is_mac_64() {
  if [ "$(uname -s | tr '[:upper:]' '[:lower:]')" == "darwin" ] && [ "$(arch)" == "i386" ];
  then return 0
  else return 1
  fi
}

is_mac_arm() {
  if [ "$(uname -s | tr '[:upper:]' '[:lower:]')" == "darwin" ] && [ "$(arch)" == "aarch64" ];
  then return 0
  else return 1
  fi
}
