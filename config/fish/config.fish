set -x PATH ~/bin ~/.cargo/bin $PATH

# Colorful ls on macOS
set -x CLICOLOR 1

alias em="emacs -nw"

test -e ~/.config/fish/config.local.fish && source ~/.config/fish/config.local.fish
