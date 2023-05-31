# pyenv
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# pipx
export PATH=$PATH:$HOME/.local/bin
export PIPX_DEFAULT_PYTHON="$HOME/.pyenv/versions/3.10.11/bin/python"
