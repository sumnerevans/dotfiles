# Determine OS
[[ `uname` == 'Linux'  ]] && export LINUX=1 || export LINUX=
[[ `uname` == 'Darwin'  ]] && export OSX=1 || export OSX=

# Prompt Setup
autoload -Uz promptinit && promptinit
prompt adam1
setopt prompt_subst
autoload colors zsh/terminfo
colors
function __git_prompt {
    local DIRTY="%{$fg[yellow]%}"
    local CLEAN="%{$fg[green]%}"
    local UNMERGED="%{$fg[red]%}"

    local RESET="%{$terminfo[sgr0]%}"
    git rev-parse --git-dir >& /dev/null

    if [[ $? == 0  ]]; then
        echo -n "["

        if [[ `git ls-files -u >& /dev/null` == '' ]]; then
            # If files have been modified, dirty.
            [[ `git diff` != '' ||
                `git ls-files --others --exclude-standard` != '' ||
                `git diff --staged` != '' ]] && echo -n $DIRTY || echo -n $CLEAN

            [[ `git diff --staged` != '' ]] && echo -n "+"
        else
            echo -n $UNMERGED
        fi
        echo -n `git branch | grep '* ' | sed 's/..//' || echo 'No Branch'`
        echo -n $RESET
        echo -n "]"
    fi
}

export RPS1='$(__git_prompt)'

# Global Variables
export VISUAL=vim
export EDITOR="$VISUAL"
export PDFVIEWER="zathura --fork"
export VIDEOVIEWER=vlc

# History
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
setopt appendhistory
setopt histignoredups
setopt histignorespace

# Misc Options
setopt autopushd
setopt nobeep
setopt extendedglob

# Auto-Completion
setopt autocd
setopt correct
autoload -U compinit && compinit
zstyle ':completion:*' rehash true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:approximate:' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3 )) numeric)'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
[[ $LINUX == 1 ]] && eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Directory Hashes
hash -d doc=~/Documents
hash -d db=~/Dropbox
hash -d dl=~/Downloads
hash -d gd=~/Google\ Drive
hash -d pics=~/Pictures
hash -d proj=~/projects
hash -d pres=~doc/presentations
hash -d tmp=~/tmp

# Projects
hash -d gchal=~proj/google-challenge
hash -d pray=~proj/pray-app
hash -d res=~proj/resumes
hash -d chai=~proj/chess-ai
hash -d stw=~proj/summation-tech-website
hash -d sat=~proj/show-and-tell
hash -d sws=~proj/sumner-website
hash -d tef=~proj/the-evans.family
hash -d widb=~proj/wireless-debugging

# School
hash -d sch=~/school
hash -d vr=~sch/vr-independent-study
hash -d fs=~sch/field-session

# ===== ALIASES =====
alias tar="bsdtar"
alias screen='screen -DR'
alias pwd="pwd && pwd -P"

# Todo.sh
alias todo="todo.sh -c"

# File Type Associations
alias -s cpp=$EDITOR
alias -s h=$EDITOR
alias -s md=$EDITOR
alias -s mp4=$VIDEOVIEWER
alias -s pdf=$PDFVIEWER
alias -s tex=$EDITOR
alias -s txt=$EDITOR

##### Command Shortcuts #####
# Printing
alias alpr='ssh isengard lpr -P bb136-printer -o coallate=true'
alias alprd='ssh isengard lpr -P bb136-printer -o coallate=true -o Duplex=DuplexNoTumble'
alias lpr='lpr -o coallate=true'
alias hlpr='lpr -o Duplex=None'

# Git
alias glog="git log --pretty=format:'%C(auto)%h %ad %C(green)%s%Creset %C(auto)%d [%an]' --graph --date=format:'%Y-%m-%d %H:%M' --all"
alias grhh="git reset --hard HEAD"
alias ga="git add ."
alias gca="git commit -a"
alias gd="git diff"
alias gs="git status"
alias gfetch="git fetch"
alias gpull="git pull"
alias gpush="git push"
alias gch="git checkout"

# Config
alias i3conf="vim ~/.config/i3/config"
alias muttrc='vim ~/.mutt/muttrc'
alias reload=". ~/.zshrc && echo 'ZSH Config Reloaded from ~/.zshrc'"
alias sshconf="vim ~/.ssh/config"
alias vimrc="vim ~/.vim/vimrc"
alias vimshort="vim ~/.vim/shortcuts"
alias xresources="vim ~/.Xresources && xrdb -load .Xresources && echo 'Xresources reloaded'"
alias zshrc="vim ~/.zshrc && reload"

alias asmr='(vlc $(find $HOME/Documents/asmr -type f | shuf -n 1) &>/dev/null &)'
alias backupzshrc='scp ~/.zshrc tef:/home/evansfamilywebsite/the-evans.family/sumner'
alias dbs="dropbox-cli status"
alias extmon="xrandr --output DP-3 --mode 1920x1200 --right-of DP-2 --scale 1.5x1.5"
alias gcall="g++ -Wall *.cpp -o a.out && ./a.out"
alias iftop='sudo iftop'
alias lclean="rm -rf *.aux & rm -rf *.log & rm -rf *.out & rm -rf _minted*"
[[ "$LINUX" == "1" ]] && alias ls="ls --color -F"
alias la="ls -a"
alias ll="ls -lah"
alias ohea='echo "You need to either wake up or go to bed!"'
alias open="(thunar &> /dev/null &)"
alias pdflatex='pdflatex -shell-escape'
alias xelatex='xelatex -shell-escape'

# Making GNU fileutils more verbose
for c in cp rm chmod chown rename; do
    alias $c="$c -v"
done

##### Custom Functions #####

# Always ls -a after cd
function chpwd() {
    emulate -L zsh
    la
}

function wgitignore() {
    wget "https://www.gitignore.io/api/$1" -O - >> .gitignore
}

function md2pdf() {
    filename=$(basename "$1")
    extension="${filename##*.}"
    filename="${filename%.*}"

    [[ "$extension" != "md" ]] && echo "Must be markdown file" && return

    pandoc -V geometry:margin=1in -o $filename.pdf $1
}

function del() {
    mv $* $HOME/tmp
}

# Custom Key Widgets
function __zkey_prepend_man {
    if [[ $BUFFER != "man "*  ]]; then
        BUFFER="man $BUFFER"
        CURSOR+=4
    else
        BUFFER="${BUFFER:4}"
    fi
}
zle -N prepend-man __zkey_prepend_man

function __zkey_prepend_sudo {
    if [[ $BUFFER != "sudo "*  ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR+=5
    else
        BUFFER="${BUFFER:5}"
    fi
}
zle -N prepend-sudo __zkey_prepend_sudo

function __zkey_prepend_vim {
    if [[ $BUFFER != "vim "*  ]]; then
        BUFFER="vim $BUFFER"
        CURSOR+=4
    else
        BUFFER="${BUFFER:4}"
    fi
}
zle -N prepend-vim __zkey_prepend_vim

function __zkey_append_dir_up {
    if [[ $BUFFER = *..  ]]; then
        BUFFER="$BUFFER/.."
        CURSOR+=3
    else
        BUFFER="$LBUFFER.$RBUFFER"
        CURSOR+=1
    fi
}
zle -N append-dir-up __zkey_append_dir_up

function __zkey_delete_dir_up {
    if [[ $BUFFER = */..  ]] then
        CURSOR=CURSOR-3
        BUFFER="$LBUFFER"
    else
        # Move the cursor back and reset delete the previous character from the buffer.
        CURSOR=CURSOR-1
        BUFFER="$LBUFFER${RBUFFER:${CURSOR+1}}"
    fi
}
zle -N delete-dir-up __zkey_delete_dir_up

# Key Bindings
bindkey -v
bindkey -M vicmd q push-line
bindkey -M vicmd "m" prepend-man
bindkey -M vicmd "s" prepend-sudo
bindkey -M vicmd "v" prepend-vim
bindkey "." append-dir-up
bindkey "^?" delete-dir-up
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "\e[3~" delete-char

# Up arrow search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# Syntax Highlighting
if [[ $LINUX == "1" ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ $OSX == "1" ]]; then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Add to PATH
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.4.0/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Do the thing so rust blows up verbosely
export RUST_BACKTRACE=1

# Set up the ssh-agent if necesarry
if [ ! -S ~/.ssh/ssh_auth_sock  ]; then
    eval `ssh-agent`
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l | grep "The agent has no identities" && ssh-add

# Always start with an ls -la
eval la
