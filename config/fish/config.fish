###############################################################################
#
# Alias
#
###############################################################################
alias l ls
alias grep "grep --color"

switch (uname)
    case Darwin
        # alias to love
        alias love "/Applications/love.app/Contents/MacOS/love"
end

###############################################################################
#
# Environment Variable
#
###############################################################################
if test $FISH_RC_LOADED
    exit
end

set -x FISH_RC_LOADED true

set -x PATH ~/.local/bin /usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin /sbin $PATH
set -x MANPATH /usr/local/share/man $MANPATH

# C/C++
set -x C_INCLUDE_PATH ~/.local/include:/usr/local/include
set -x CPLUS_INCLUDE_PATH $C_INCLUDE_PATH
set -x LIBRARY_PATH ~/.local/lib:/usr/local/lib
set -x LD_LIBRARY_PATH $LIBRARY_PATH
set -x PKG_CONFIG_PATH ~/.local/lib/pkgconfig:/usr/local/lib/pkgconfig

switch (uname)
    case Linux
        set -x PATH ~/.linuxbrew/bin $PATH
        set -x MANPATH ~/.linuxbrew/share/man $MANPATH
        set -x INFOPATH ~/.linuxbrew/share/info $INFOPATH
    case Darwin # MAC OS X
        set -x JAVA_HOME (/usr/libexec/java_home)
        set -x DYLD_LIBRARY_PATH ~/.local/lib $DYLD_LIBRARY_PATH
    case 'CYGWIN*'
        set -x PATH ~/.local/Cellar/rust/bin $PATH
end

# SSH
set -x SSH_KEY_PATH "~/.ssh/id_rsa"
