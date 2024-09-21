force_stow() {
  cd ~/.dotfiles
  stow --adopt $1
  git restore . || true
  cd -
}

is_linux() {
  if [ "$(uname -s)" == "Linux" ];
  then return 0
  else return 1
  fi
}

is_fedora() {
  if uname -a | grep fedora > /dev/null;
  then return 0
  else return 1
  fi
}

is_ubuntu() {
  if uname -a | grep ubuntu > /dev/null;
  then return 0
  else return 1
  fi
}

is_mac() {
  if [ "$(uname -s)" == "Darwin" ];
  then return 0
  else return 1
  fi
}

is_linux_64() {
  if [ "$(uname -s)" == "Linux" ] && [ "$(arch)" == "x86_64" ];
  then return 0
  else return 1
  fi
}

is_linux_arm() {
  if [ "$(uname -s)" == "Linux" ] && [ "$(arch)" == "aarch64" ];
  then return 0
  else return 1
  fi
}

is_mac_64() {
  if [ "$(uname -s)" == "Darwin" ] && [ "$(arch)" == "i386" ];
  then return 0
  else return 1
  fi
}

is_mac_arm() {
  if [ "$(uname -s)" == "Darwin" ] && [ "$(arch)" == "aarch64" ];
  then return 0
  else return 1
  fi
}
