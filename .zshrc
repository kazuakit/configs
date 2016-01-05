# Enable Emacs keybindings
bindkey -e

# Enable command and path completion with <tab> key.
autoload -U compinit; compinit

# Automatically add the cd directory to dir stack(=history)
setopt auto_pushd
setopt pushd_ignore_dups

# Enable glob (#, ~, ^ are treated as glob patterns)
setopt extended_glob

# history file
HISTFILE=~/.zsh_history

# history size
HISTSIZE=10000
SAVEHIST=10000

# Ignore duplicate history
setopt hist_ignore_all_dups

# Share history inter-terminal
setopt      share_history

# Enable path completion
zstyle ':completion:*:default' menu select=1

# Enable case ignore completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


# Set chars of word
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Prompt Setting
# http://zsh.sourceforge.net/Doc/Release/zsh_12.html#SEC40
PROMPT='%n@%m> '
RPROMPT='[%~]'

# Set ls
case "${OSTYPE}" in
    freebsd*|darwin*)
        alias ls="ls -G -w"
        alias em="open -a Emacs.app"
        ;;
    linux*|cygwin*)
        alias ls="ls --color"
        ;;
    solaris*)
        alias ls='gls -F --color=auto '
esac
alias ll='ls -la'
# http://journal.mycom.co.jp/column/zsh/009/index.html
export LSCOLORS=gxfxcxdxbxegedabagacad

# Set Terminal
case "${TERM}" in
    xterm)
        export TERM=xterm-color
        ;;
    kterm)
        export TERM=kterm-color
    # set BackSpace control character
        stty erase
        ;;
    cons25|linux)
        unset LANG
        ;;
esac
