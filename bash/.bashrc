# ~/.bashrc

# General configs {{{
# ---------------

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and cd_histfileSIZE in bash(1)
HISTSIZE=1000
cd_histfileSIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

BOLD_CYAN='\[\033[01;36m\]'
BOLD_GREEN='\[\033[01;32m\]'
PS_CLEAR='\[\033[0m\]'

# Source: https://coderwall.com/p/fasnya/add-git-branch-name-to-bash-prompt
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PS1="\n${BOLD_CYAN}\w${PS_CLEAR}\n${BOLD_GREEN}\$(parse_git_branch)$ "

# Reset the terminal color before bash executes the command
trap '[[ -t 1 ]] && tput sgr0' DEBUG

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# }}}

# Functions {{{
# ---------

cd_histfile_path="/home/osmc/.cd_history"
cd_histfile_maxlinecount=1000

cd() {

  # Note: requires the *tree* program

  # Part of this function is based on a script written by Petar Marinov:
  # https://linuxgazette.net/109/marinov.html

  local next_dir
  if [ -n "$1" ]; then

    arg="$@"

    if [[ $arg == "-" ]]; then
      next_dir=$( tail $cd_histfile_path | sort | uniq | fzf --height="10%")

    elif [[ $arg == "--" ]]; then
      next_dir=$( tail -n2 $cd_histfile_path | head -n1 )

    elif [[ "${arg:0:1}" == "-" ]]; then
      index=${arg:1}
      dir_stack_size=$( cat $cd_histfile_path | wc -l )

      if (( $dir_stack_size > 1 )) && (( $index < $dir_stack_size )); then
        next_dir=$( tail $cd_histfile_path | sort | uniq | head -n$index | tail -n1 )
      else
        echo "Directory stack empty!"
        return 1
      fi

    else
      next_dir="$arg"
    fi

  else
    next_dir=$HOME
  fi

  if [[ ! -d $next_dir ]]; then
    echo "No such file or directory."
    return 1
  fi

  # Change the current directory
  pushd "$next_dir" 2>/dev/null 1>/dev/null

  # Trim the stack
  stack_size=11
  popd -n +$stack_size 2>/dev/null 1>/dev/null

  # Read the top of the dir stack
  next_dir=$(pwd)

  cd_histfile_linecount=$( cat $cd_histfile_path | wc -l )
  if [[ $cd_histfile_linecount > $(( $cd_histfile_maxlinecount - 1 )) ]]; then
    # Delete first line
    sed -i "1d" $cd_histfile_path
  fi

  # Append the cwd to file
  echo $( pwd ) >> $cd_histfile_path

  # Display the dir contents
  tree -L 1 -C

  # Remove any other occurence of this dir, skipping the top of the stack
  local cnt
  for ((cnt=1; cnt <= 10; cnt++)); do
    dir=$(dirs +${cnt} 2>/dev/null)
    [[ $? -ne 0 ]] && return 0
    [[ ${dir:0:1} == "~" ]] && dir="$HOME${dir:1}"

    if [[ "$dir" == "$next_dir" ]]; then
      popd -n +$cnt 2>/dev/null 1>/dev/null
    fi
  done

  return 0
}

# }}}

# Environment variables {{{
# ---------------------
export GH="https://github.com"
export GL="https://gitlab.com"
export LC_ALL="en_US.UTF-8"

# }}}

# vi:nospell
