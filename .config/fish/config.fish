# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish

# Theme
set fish_theme robbyrussell

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-fish/plugins/*)
# Custom plugins may be added to ~/.oh-my-fish/custom/plugins/
# Example format: set fish_plugins autojump bundler

# Path to your custom folder (default path is $FISH/custom)
#set fish_custom $HOME/dotfiles/oh-my-fish

# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish

# Environment Variable

set -x PATH /usr/local/bin /usr/local/sbin /usr/bin /bin /usr/sbin /sbin

# C/C++
set -x C_INCLUDE_PATH ~/.local/include /usr/local/include
set -x CPLUS_INCLUDE_PATH $C_INCLUDE_PATH
set -x LIBRARY_PATH ~/.local/lib /usr/local/lib
set -x LD_LIBRARY_PATH $LIBRARY_PATH
set -x PKG_CONFIG_PATH ~/.local/lib/pkgconfig /usr/local/lib/pkgconfig

# Java
set -x JAVA_HOME (/usr/libexec/java_home -v ‘1.7*’)

alias vim "mvim -v"
alias l ls
