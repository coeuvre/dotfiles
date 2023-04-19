set -x PATH ~/bin ~/.cargo/bin $PATH

# Colorful ls on macOS
set -x CLICOLOR 1

test -e ~/.config/fish/config.local.fish && source ~/.config/fish/config.local.fish
