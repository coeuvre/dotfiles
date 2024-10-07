set -x PATH ~/bin ~/.cargo/bin $PATH
set -x EDITOR nvim

set -x C_INCLUDE_PATH ~/.local/include $C_INCLUDE_PATH
set -x CPLUS_INCLUDE_PATH ~/.local/include $CPLUS_INCLUDE_PATH
set -x LIBRARY_PATH ~/.local/lib64 ~/.local/lib $LIBRARY_PATH
set -x LD_LIBRARY_PATH ~/.local/lib64 ~/.local/lib $LD_LIBRARY_PATH

# Colorful ls on macOS
set -x CLICOLOR 1

alias em="emacs -nw"

test -e ~/.config/fish/config.local.fish && source ~/.config/fish/config.local.fish

if type -q fzf
    fzf --fish | source
end

if type -q zoxide
    zoxide init fish | source
end

