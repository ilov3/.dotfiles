if command -v minikube &>/dev/null; then
  source <(minikube completion zsh)
fi
if command -v kubectl &>/dev/null; then
  source <(kubectl completion zsh)
fi
if command -v pipx &>/dev/null; then
  eval "$(register-python-argcomplete pipx)"
fi
