#####################################################################
# zplug
#####################################################################

# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Essential
source ~/.zplug/init.zsh

zplug "b4b4r07/enhancd", use:init.sh
zplug "supercrabtree/k"

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2

zplug "mafredri/zsh-async"
zplug "sindresorhus/pure", use:pure.zsh, as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

#####################################################################
# environment
#####################################################################
export PATH=~/.cargo/bin:$PATH
export EDITOR=vim
export LANG=en_US.UTF-8

export CLICOLOR=1
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

#####################################################################
# others
#####################################################################

# Share zsh histories
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=50000
setopt inc_append_history
setopt share_history

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
