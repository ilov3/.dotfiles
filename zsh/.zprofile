if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  # same as `pyenv init --path`, without the slow rehash
  export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
# static equivalent of `eval "$(/opt/homebrew/bin/brew shellenv)"`
export HOMEBREW_PREFIX="/opt/homebrew" HOMEBREW_CELLAR="/opt/homebrew/Cellar" HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fpath[1,0]="/opt/homebrew/share/zsh/site-functions"
[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
export NVM_DIR="$HOME/.nvm"
        # --no-use skips nvm's slow default-version resolution; put the default on PATH ourselves
        [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" --no-use # This loads nvm
        if [ -s "$NVM_DIR/alias/default" ]; then
          _nvm_default=( $NVM_DIR/versions/node/v$(<$NVM_DIR/alias/default)*(N/nOn[1]) )
          if [ -n "$_nvm_default" ]; then
            export PATH="$_nvm_default/bin:$PATH"
          else
            nvm use --silent default
          fi
          unset _nvm_default
        fi
fi
