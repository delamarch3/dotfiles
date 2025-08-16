PROMPT='%B%1~%b %# '
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH:$HOME/.cargo/bin"

export HOMEBREW_NO_ANALYTICS=1

JDK_VERSION="21"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-$JDK_VERSION.jdk/Contents/Home"
# export PATH="$PATH:/opt/homebrew/opt/openjdk@$JDK_VERSION/bin"

export AWS_PROFILE="default"
export AWS_DEFAULT_REGION="eu-west-2"

export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
alias ll="ls -lGFh"
alias la="ls -laGFh"

alias tf="terraform"
alias python="python3.13"
alias pip="pip3.13"
alias vim="nvim"
alias t="tmux"
alias tls="tmux ls"
alias ta="tmux attach -t"
alias got="go test ./... -race -cover"
alias brewbundle="brew update && brew bundle install --no-upgrade --cleanup --file=~/Brewfile"

# use vi key bindings
bindkey -v
export KEYTIMEOUT=1
bindkey -v '^?' backward-delete-char

zle-keymap-select() {
    case $KEYMAP in
        vicmd)
            echo -ne '\e[1 q'
            ;;
        main|viins)
            echo -ne '\e[5 q'
            ;;
    esac

    zle reset-prompt
}
zle -N zle-keymap-select

zle-line-init() {
  zle-keymap-select
}
zle -N zle-line-init

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fh - search in your command history and execute selected command
fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

word-diff() {
  echo $1 > f1
  echo $2 > f2
  git diff --word-diff --word-diff-regex=. --no-index f1 f2
  rm f1 f2
}


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/subhan/.opam/opam-init/init.zsh' ]] || source '/Users/subhan/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration
