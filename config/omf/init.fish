###############################################################################
#
# Environment Variable
#
###############################################################################
set -x PATH ~/.multirust/toolchains/nightly/cargo/bin ~/.local/bin /usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin /sbin
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
        set -x JAVA_HOME (/usr/libexec/java_home -v '1.7*')
        set -x DYLD_LIBRARY_PATH ~/.local/lib $DYLD_LIBRARY_PATH
    case 'CYGWIN*'
        set -x PATH "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TestWindow"\
                    "C:\Program Files (x86)\MSBuild\14.0\bin"\
                    "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE"\
                    "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\BIN"\
                    "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools"\
                    "C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319"\
                    "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\VCPackages"\
                    "C:\Program Files (x86)\HTML Help Workshop"\
                    "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Team Tools\Performance Tools"\
                    "C:\Program Files (x86)\Windows Kits\8.1\bin\x86"\
                    "C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6.1 Tools"\
                    $PATH
        set -x INCLUDE "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\INCLUDE;C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\ATLMFC\INCLUDE;C:\Program Files (x86)\Windows Kits\10\include\10.0.10240.0\ucrt;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6.1\include\um;C:\Program Files (x86)\Windows Kits\8.1\include\\shared;C:\Program Files (x86)\Windows Kits\8.1\include\\um;C:\Program Files (x86)\Windows Kits\8.1\include\\winrt;"
        set -x LIB "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\LIB;C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\ATLMFC\LIB;C:\Program Files (x86)\Windows Kits\10\lib\10.0.10240.0\ucrt\x86;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6.1\lib\um\x86;C:\Program Files (x86)\Windows Kits\8.1\lib\winv6.3\um\x86;"
        set -x=LIBPATH "C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319;C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\LIB;C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\ATLMFC\LIB;C:\Program Files (x86)\Windows Kits\8.1\References\CommonConfiguration\Neutral;\Microsoft.VCLibs\14.0\References\CommonConfiguration\neutral;"
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

