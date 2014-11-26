# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish

# Theme
function _remote_hostname
  if test -n "$SSH_CONNECTION"
    echo (whoami)@(hostname)
  end
end

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function fish_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  if test $last_status = 0
      set arrow "$green➜ "
  else
      set arrow "$red➜ "
  end
  set -l cwd $cyan(_remote_hostname)' '(basename (prompt_pwd))

  if [ (_git_branch_name) ]
    set -l git_branch $red(_git_branch_name)
    set git_info "$blue git:($git_branch$blue)"

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗"
      set git_info "$git_info$dirty"
    end
  end

  echo -n -s $arrow $cyan $cwd $git_info $normal ' '
end

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-fish/plugins/*)
# Custom plugins may be added to ~/.oh-my-fish/custom/plugins/
# Example format: set fish_plugins autojump bundler

# Path to your custom folder (default path is $FISH/custom)
#set fish_custom $HOME/dotfiles/oh-my-fish

# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish

# Environment Variable

set -x PATH ~/.local/bin $PATH

# C/C++
set -x C_INCLUDE_PATH ~/.local/include /usr/local/include $C_INCLUDE_PATH
set -x CPLUS_INCLUDE_PATH $C_INCLUDE_PATH $CPLUS_INCLUDE_PATH
set -x LIBRARY_PATH ~/.local/lib /usr/local/lib $LIBRARY_PATH
set -x LD_LIBRARY_PATH $LIBRARY_PATH $LD_LIBRARY_PATH
set -x PKG_CONFIG_PATH ~/.local/lib/pkgconfig /usr/local/lib/pkgconfig $PKG_CONFIG_PATH

alias l ls

switch (uname)
    case Linux
        set -x PATH ~/.linuxbrew/bin $PATH
        set -x MANPATH ~/.linuxbrew/share/man $MANPATH
        set -x INFOPATH ~/.linuxbrew/share/info $INFOPATH
    case Darwin # MAC OS X
        set -x JAVA_HOME (/usr/libexec/java_home -v ‘1.7*’)
        #set -x DYLD_LIBRARY_PATH ~/.local/lib
end
