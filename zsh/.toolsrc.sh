# pyenv
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  # pyenv init is slow; cache its output until pyenv itself is updated
  _pyenv_cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/pyenv-init.zsh
  if [[ ! -s $_pyenv_cache || $(command -v pyenv) -nt $_pyenv_cache ]]; then
    mkdir -p ${_pyenv_cache:h}
    { pyenv init - --no-rehash zsh; pyenv virtualenv-init - zsh; } > $_pyenv_cache
  fi
  source $_pyenv_cache
  unset _pyenv_cache
  # The stock pyenv-virtualenv hook runs pyenv (~2-3s) before every prompt. This does the
  # same activation (.python-version -> VIRTUAL_ENV + prompt prefix) in pure zsh.
  _pyenv_venv_deactivate() {
    unset PYENV_VIRTUAL_ENV VIRTUAL_ENV
    if [[ -n ${_OLD_VIRTUAL_PATH-} ]]; then export PATH=$_OLD_VIRTUAL_PATH; unset _OLD_VIRTUAL_PATH; fi
    if [[ -n ${_OLD_VIRTUAL_PYTHONHOME-} ]]; then export PYTHONHOME=$_OLD_VIRTUAL_PYTHONHOME; unset _OLD_VIRTUAL_PYTHONHOME; fi
    if [[ -n ${_OLD_VIRTUAL_PS1-} ]]; then PS1=$_OLD_VIRTUAL_PS1; unset _OLD_VIRTUAL_PS1; fi
  }
  _pyenv_virtualenv_hook_fast() {
    local ret=$? d=$PWD name venv
    # manual `pyenv activate` / `pyenv shell`: defer to the stock hook
    if [[ -n ${PYENV_VERSION-} ]]; then _pyenv_virtualenv_hook; return $ret; fi
    while [[ ! -f $d/.python-version && $d != / ]]; do d=${d:h}; done
    if [[ -f $d/.python-version ]]; then
      read -r name < $d/.python-version
      name=${name//[[:space:]]/}
      [[ -n $name && -f $PYENV_ROOT/versions/$name/pyvenv.cfg ]] && venv=${${:-$PYENV_ROOT/versions/$name}:A}
    fi
    [[ $venv == ${PYENV_VIRTUAL_ENV-} ]] && return $ret
    [[ -n ${PYENV_VIRTUAL_ENV-} ]] && _pyenv_venv_deactivate
    if [[ -n $venv ]]; then
      export PYENV_VIRTUAL_ENV=$venv VIRTUAL_ENV=$venv
      export _OLD_VIRTUAL_PS1=${PS1-}
      PS1="($name) ${PS1-}"
    fi
    return $ret
  }
  precmd_functions=(${precmd_functions:#_pyenv_virtualenv_hook} _pyenv_virtualenv_hook_fast)
fi

# pipx
export PATH=$PATH:$HOME/.local/bin
export PIPX_DEFAULT_PYTHON="$HOME/.pyenv/versions/3.10.11/bin/python"
