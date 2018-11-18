#####################################################################
# zplug
#####################################################################
if [ -d "$HOME/.zplug" ]; then
    source ~/.zplug/init.zsh

    zplug 'zplug/zplug', hook-build:'zplug --self-manage'

    zplug "b4b4r07/enhancd", use:init.sh

    zplug "zsh-users/zsh-autosuggestions"
    zplug "zsh-users/zsh-completions"
    zplug "zsh-users/zsh-syntax-highlighting", defer:2

    zplug mafredri/zsh-async, from:github
    zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme

    # Install plugins if there are plugins that have not been installed
    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi

    zplug load
fi

#####################################################################
# environment
#####################################################################
export PATH=~/.cargo/bin:$PATH
export EDITOR=vim
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export CLICOLOR=1
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

export WORDCHARS=${WORDCHARS/\/}

#####################################################################
# alias
#####################################################################
if [ -x "$(command -v nvim)" ]; then
    alias vim=nvim
    alias vimdiff='nvim -d'
fi

if [ -x "$(command -v exa)" ]; then
    alias ls=exa
fi

alias ll='ls -l'

#####################################################################
# others
#####################################################################

# Share zsh histories
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=50000
setopt inc_append_history
setopt share_history

#####################################################################
# fzf
#####################################################################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#####################################################################
# nvm
#####################################################################
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
