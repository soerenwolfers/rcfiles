# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    #PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    PS1="\[\e]0;${debian_chroot}\u: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias tree='tree -ha'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -AlFh'
alias la='ls -A'
alias l='ll --color=always'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

PROMPT_DIRTRIM=3

shopt -s direxpand
export PATH="$PROJ/createsubmission:$PATH"
# added by Anaconda3 installer
export PATH="/usr/local/src/anaconda3/bin:$PATH"

# Needed by VSCode to find Java
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

# For OpenMPI source installation
#MPI_DIR=/usr/local/openmpi
#export PATH=$MPI_DIR/bin:$PATH
#export LD_LIBRARY_PATH=$MPI_DIR/lib:$LD_LIBRARY_PATH

# added by scilog installer
eval "$(register-python-argcomplete scilog)"

# Alt+# to surround by quotes
bind "\"\e#\": \"'\eF a'\eA"

# Source autojump
source /usr/share/autojump/autojump.sh

# Exploit ranger script feature to cd to its last directory
alias r='source ranger'
# change alias of search to alias of search_inc in ~/.config/ranger/rc.conf for incremental search in ranger
# Alternative to cd to recent ranger directory:
#alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
 

#Disable Ctrl-S freeze
stty -ixon
 
# Added by fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# Show hidden files but not .git
export FZF_DEFAULT_COMMAND='rg --hidden --files -g "!.git"'

# Opener using fzf
create() {
    read -ep "Name: " new
    if [ "$new" ]
    then
        if [[ "$new" == */ ]]
        then
            if [[ -f "${new: : -1}" ]]
            then
                echo "Cannot create directory $new; is already a file"
                return
            fi
            if [ ! -d "$new" ]
            then
                mkdir -p "$new" || return
                echo Created "$new"
            fi
            o "$new"
        else
            if [ -d "$new" ] 
            then
                echo "Cannot create file $new; is already a directory"
                return
            fi
            if [ ! -f "$new" ]
            then
                local new_dir=$(dirname "$new")
                mkdir -p "$new_dir" || return
                touch "$new" || return
                echo "Created $new"
            fi
            o "$new"
        fi
    fi
}
autoopen() {
    #prettypath is a prettier version of $1 but has same functionality
    local prettypath=""
    if [ $(basename "$1") == "<NEW>" ]
    then 
        prettypath="\"<NEW>\"" 
    else
        prettypath=$(printf "%q" "$1")
        prettypath=$(echo "$prettypath"|sed "s|^$HOME\(/.*\)\?$|~\1|")
        shopt -s extglob
        prettypath=${prettypath//\/+(\/)//}
        if [ "$2" ]
        then
            prettypath="$prettypath -- $(printf "%q" "$2")"
        fi
    fi
    if [[ ! -t 1 ]]
    then
        echo o "$prettypath"
    else
        history -s o "$prettypath"
        if [[ $(basename "$1") == "<NEW>" ]]
        then
            create 
        elif [[ -d "$1" ]]
        then 
            cd "$1"
            #F: only scroll when necsesary, R: still show if scroll not necessary (not needed for more recent versinos of less), X: show colors
            l|less -FRX 
        else
            if [ "$2" ]
            then
                ($2 "$1" 2>&1) & disown
            else
                local expanded=$(readlink -f "$1")
                if [ ! "$expanded" ]
                then
                    expanded="$1"
                fi
                if [[ $(file -i $expanded|grep "x-empty\| text\|application/postscript") ]]
                then
                    if [ -w "$1" ]; then
                        vim "$1"
                    else
                        sudo vim "$1"
                    fi
                else
                    (xdg-open "$1" > /dev/null 2>&1) & disown
                fi
            fi
        fi
    fi
}
preview() {
    if [ "$2" == "<NEW>" ]
    then
        echo "Create new file or directory"
        exit
    fi
    local path="$1"/"$2"
    if [ -d "$path" ]
    then
        if [[ "$2" != "." ]]
        then
            bold=$(tput bold)
            normal=$(tput sgr0)
            echo 
            echo "         Directory ${bold}$2${normal}"
            echo 
            ls -hA --color "$path"|awk '{print "\t " $0}'
        fi
    else
        if [[ "$2" == *.png ]]
        then
            img2txt "$path" 
        else
            if [[ -x "$(command -v bat)" ]]
            then
                bat --color "always" "$path"
            else
                echo 
                echo "         File ${bold}$2${normal}"
                echo 
                cat "$path" |awk '{print "\t " $0}'
            fi
        fi
    fi
}
export -f preview
o() {
    local inp=""
    local count="1"
    local search_folder=""
    local search_command=""
    local choice=""
    local file_query=""
    local ext_command=""
    local suffix=""
    local started=""
    for i
    do
        count=$((count+1))
        if [[ "$i" == '--' ]]
        then
            ext_command="${@:count}"
            break
        else
            if [[ "$i" == -* ]];
            then
               search_folder=${i#*-}
            else
                if [ ! "$started" ]
                then
                    inp="$i"
                    started=1
                else
                    inp="$inp $i"
                fi
            fi
        fi
    done
    # && [ "$inp" ]
    if [[ ( -f "$inp" ) || ( -d "$inp" ) ]]
	then
		autoopen "$inp" "$ext_command"
	else
        if [[ "$search_folder" ]]
        then
            file_query="$inp"
        else
            search_folder=$(dirname "$inp")
            file_query=$(basename "$inp")
            if [ ! -d "$search_folder" ]
            then
                search_folder=$(autojump $search_folder)
            fi
        fi
        search_folder="${search_folder/#\~/$HOME}"
        if [ "$search_folder" == "." ]
        then
            search_folder="$(pwd)"
            search_command="echo '<NEW>';"
        fi
        search_command="$search_command find $(printf "%q" "$search_folder") -mindepth 1 2> /dev/null | sed 's|^${search_folder}/\?||'"
        choice=$(eval "$search_command"|fzf -q "$file_query" -1 --preview "preview $search_folder {}")
		if  [ "$choice" ]	
		then
            choice="$search_folder"/"$choice"
            autoopen "$choice" "$ext_command"
		fi
	fi
}


-() {
    cd - > /dev/null
}

c() {
    if [ "$1" == "-" ]
    then
        cd -
    else
        if [ "$1" ]
        then
            mkdir -p "$1" &> /dev/null
            cd "$1"
        else
            cd
        fi
    fi
}

explain_colors() {
    eval $(echo "no:global default;fi:normal file;di:directory;ln:symbolic link;pi:named pipe;so:socket;do:door;bd:block device;cd:character device;or:orphan symlink;mi:missing file;su:set uid;sg:set gid;tw:sticky other writable;ow:other writable;st:sticky;ex:executable;"|sed -e 's/:/="/g; s/\;/"\n/g')
    {
      IFS=:
      for i in $LS_COLORS
      do
        echo -e "\e[${i#*=}m$( x=${i%=*};[ "${x:0:1}" != "*" ] && [ "${!x}" ] && echo "${!x}" || echo "$x" )\e[m"
      done
    }
}

export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1

# Turn git aliases into shell aliases
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
    source /usr/share/bash-completion/completions/git
fi
function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}
for al in `__git_aliases`; do
    alias g$al="git $al"
    complete_func=_git_$(__git_aliased_command $al)
    function_exists $complete_fnc && __git_complete g$al $complete_func
done
__git_aliases()
{
__git_get_config_variables "alias"
}

# differentiate by first column
diffcol()
{
	awk 'NR==FNR{c[$1]++;next};c[$1] == 0' $2 $1      
	awk 'NR==FNR{c[$1]++;next};c[$1] == 0' $1 $2      
}
diffdir()
{
	diffcol <(find "$1" -type f -exec md5sum{} + | sort) <(find "$2" -type f -exec md5sum {} | sort)
}

alias diff='git diff --no-index --word-diff'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Fzf key bindings
# ------------
__fzf_select__() {
  #local cmd='find / 2>/dev/null'
  find / 2>/dev/null | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
    printf '%q ' "$item"
  done
  echo
}
__fzf_select_local__() {
    find 2>/dev/null | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
    printf '%q ' "$item"
  done
  echo
}

fzf-file-widget() {
  local selected="$(__fzf_select__)"
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}
fzf-file-widget-local() {
  local selected="$(__fzf_select_local__)"
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}

__fzf_cd__() {
  local cmd dir
  cmd='find / -mindepth 0 -type d 2>/dev/null'
  dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" fzf +m) && printf 'cd %q' "$dir"
}
__fzf_cd_local__() {
  local cmd dir
  cmd='find . -mindepth 1 -type d 2>/dev/null'
  dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" fzf +m) && printf 'cd %q' "$dir"
}

__fzf_history__() (
  local line
  shopt -u nocaseglob nocasematch
  line=$(
    HISTTIMEFORMAT= history |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS --tac --sync -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS +m" fzf |
    command grep '^ *[0-9]') &&
    if [[ $- =~ H ]]; then
      sed 's/^ *\([0-9]*\)\** .*/!\1/' <<< "$line"
    else
      sed 's/^ *\([0-9]*\)\** *//' <<< "$line"
    fi
)

# We'd usually use "\e" to enter vi-movement-mode so we can do our magic,
# but this incurs a very noticeable delay of a half second or so,
# because many other commands start with "\e".
# Instead, we bind an unused key, "\C-x\C-a",
# to also enter vi-movement-mode,
# and then use that thereafter.
# (We imagine that "\C-x\C-a" is relatively unlikely to be in use.)
bind '"\C-x\C-a": vi-movement-mode'
bind '"\C-x\C-e": shell-expand-line'
bind '"\C-x\C-r": redraw-current-line'
bind '"\C-x^": history-expand-line'

# Alt-O - Open file 
bind '"\eo":" \C-x\C-axddi`o \C-x\C-apa`\C-x\C-e\C-x\C-r\C-m"'
bind '"\eO":" \C-x\C-axddi`o -/ \C-x\C-apa`\C-x\C-e\C-x\C-r\C-m"'
bind -m vi-command '"\eo":"i\eo"'
bind -m vi-command '"\eO":"i\eO"'

# Alt-I - Paste the selected file path into the command line
# - FIXME: Selected items are attached to the end regardless of cursor position
bind -x '"\ei": "fzf-file-widget-local"'
bind -x '"\eI": "fzf-file-widget"'
bind -m vi-command '"\ei": "i\ei"'
bind -m vi-command '"\eI": "i\eI"'

# ALT-R - Paste the selected command from history into the command line
bind '"\er": "\C-x\C-addi`__fzf_history__`\C-x\C-e\C-x\C-r\C-x^\C-x\C-a$a"'
bind -m vi-command '"\er": "i\er"'

# ALT-J - cd into the selected directory
bind '"\ej": "\C-x\C-addi`__fzf_cd_local__`\C-x\C-e\C-x\C-r\C-m"'
bind -m vi-command '"\ej": "ddi`__fzf_cd_local__`\C-x\C-e\C-x\C-r\C-m"'
bind '"\eJ": "\C-x\C-addi`__fzf_cd__`\C-x\C-e\C-x\C-r\C-m"'
bind -m vi-command '"\eJ": "ddi`__fzf_cd__`\C-x\C-e\C-x\C-r\C-m"'

