fish_add_path ~/bin
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8

set -x EDITOR nvim

# Colorful ls on macOS
set -x CLICOLOR 1

if type -q fzf
    fzf --fish | source
end

if type -q zoxide
    zoxide init fish | source
end

if type -q jj
    jj util completion fish | source
end

