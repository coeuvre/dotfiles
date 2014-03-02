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

set -x C_INCLUDE_PATH /usr/local/include $C_INCLUDE_PATH
set -x CPLUS_INCLUDE_PATH $C_INCLUDE_PATH
set -x LIBRARY_PATH /usr/local/lib $LIBRARY_PATH
set -x LD_LIBRARY_PATH /usr/local/lib $LIBRARY_PATH

alias vim "mvim -v"
