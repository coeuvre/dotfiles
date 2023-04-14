fish_config theme choose tokyonight_day

set -x PATH ~/bin ~/.cargo/bin $PATH

test -e config.local.fish && source config.local.fish
