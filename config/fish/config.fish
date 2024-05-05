set -x PATH ~/bin ~/.cargo/bin $PATH
set -x EDITOR nvim

# Colorful ls on macOS
set -x CLICOLOR 1

alias em="emacs -nw"

if type -q fzf
    fzf --fish | source
end

if type -q zoxide
    zoxide init fish | source
end

test -e ~/.config/fish/config.local.fish && source ~/.config/fish/config.local.fish
