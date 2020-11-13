# ~/.bash_aliases

# COMMAND EXTENSIONS {{{
#
# Commands which extend the base name of a command (e.g., grep -> grepe).
#

alias cd-="cd -"

alias greper="grep -r * -e"
alias grepe="grep * -e"

alias zipdirnow="zipdirnow"
zipdirnow () {
    # Zips a directory into a file with the current timestamp
    zip -r "$(basename $1)-$(date -I).zip" "$1"
}

# }}}

# COMMAND ABBREVIATIONS {{{

alias x="exit"

if [[ -n $(which ranger 2>/dev/null) ]]; then
    alias rg="ranger"
fi

if [[ -n $(which git 2>/dev/null) ]]; then
    alias gits="git status"
    alias gita="git add"
    alias gitc="git commit"
    alias gitd="git diff"
    alias gitl="git log --abbrev-commit"
fi

alias py="python3"

alias rmws="sed -i \"s/[[:blank:]]*$//\" "

alias sb="source ~/.bashrc && echo 'source ~/.bashrc'"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias les="less"

if [[ -n $(which youtube-dl 2>/dev/null) ]]; then
    YOUTUBE_DL_COMMAND="youtube-dl -o '%(title)s.%(ext)s'"
    alias ytd="$YOUTUBE_DL_COMMAND"
    alias ytda="$YOUTUBE_DL_COMMAND --extract-audio --audio-format mp3"
fi

if [[ -n $(which tree 2>/dev/null) ]]; then
    tree_default="tree -C -F"
    alias tre="$tree_default -L 1"
    alias tre2="$tree_default -L 2"
    alias trea="$tree_default -a -L 1"
    alias tred="$tree_default --timefmt '%Y-%m-%d %H:%M' -L 1"
    alias treles="tree -L 1 -F --dirsfirst | less"
fi

alias ll='ls -alF'
alias la='ls -A'

# }}}

# COMMAND OVERRIDES {{{

# Make potentially dangerous commands require confirmation
alias mv="mv -i"
alias rm="rm -i"
alias cp="cp -i"

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# }}}

# vi:nospell
