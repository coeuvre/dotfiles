fish_add_path ~/bin
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

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

