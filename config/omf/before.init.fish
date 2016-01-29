switch (uname)
    case Darwin
        set -g Z_SCRIPT_PATH (brew --prefix)/etc/profile.d/z.sh
    case '*'
        set -g Z_SCRIPT_PATH ~/.local/Cellar/z/z.sh
end
