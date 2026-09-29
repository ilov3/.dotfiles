# Cache generated completions; regenerate only when the tool binary changes.
_cache_completion() {
  local name=$1 bin cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completion-$1.zsh
  shift
  bin=$(command -v $name) || return
  if [[ ! -s $cache || $bin -nt $cache ]]; then
    mkdir -p ${cache:h}
    "$@" > $cache 2>/dev/null
  fi
  source $cache
}
_cache_completion minikube minikube completion zsh
_cache_completion kubectl kubectl completion zsh
_cache_completion pipx register-python-argcomplete pipx
unfunction _cache_completion
# nvm completion; loaded here (after oh-my-zsh) so it doesn't run its own compinit
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
