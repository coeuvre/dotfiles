###############################################################################
#
# Environment Variable
#
###############################################################################
set -x PATH ~/.local/bin /usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin /sbin
set -x MANPATH /usr/local/share/man $MANPATH

# C/C++
set -x C_INCLUDE_PATH ~/.local/include /usr/local/include $C_INCLUDE_PATH
set -x CPLUS_INCLUDE_PATH $C_INCLUDE_PATH $CPLUS_INCLUDE_PATH
set -x LIBRARY_PATH ~/.local/lib /usr/local/lib $LIBRARY_PATH
set -x LD_LIBRARY_PATH $LIBRARY_PATH $LD_LIBRARY_PATH
set -x PKG_CONFIG_PATH ~/.local/lib/pkgconfig /usr/local/lib/pkgconfig $PKG_CONFIG_PATH

switch (uname)
    case Linux
        set -x PATH ~/.linuxbrew/bin $PATH
        set -x MANPATH ~/.linuxbrew/share/man $MANPATH
        set -x INFOPATH ~/.linuxbrew/share/info $INFOPATH
    case Darwin # MAC OS X
        set -x JAVA_HOME (/usr/libexec/java_home -v '1.7*')
        set -x DYLD_LIBRARY_PATH ~/.local/lib $DYLD_LIBRARY_PATH
end

# SSH
set -x SSH_KEY_PATH "~/.ssh/id_rsa"

###############################################################################
#
# Alias
#
###############################################################################
alias l ls
alias grep "grep --color"

