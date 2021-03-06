# Determine OS
[[ `uname` == 'Linux'  ]] && export LINUX=1 || export LINUX=
[[ `uname` == 'Darwin'  ]] && export MACOS=1 || export MACOS=

# Prompt Setup
autoload -Uz promptinit && promptinit
prompt adam1
setopt prompt_subst
autoload colors zsh/terminfo
colors
function __rprompt {
    # Capture result of last command
    if [[ $? -eq 0 ]]; then
        RESULT="[%{$fg_no_bold[green]%}%?%{$reset_color%}]"
    else
        RESULT="[%{$fg_bold[red]%}%?%{$reset_color%}]"
    fi

    local DIRTY="%{$fg[yellow]%}"
    local CLEAN="%{$fg[green]%}"
    local UNMERGED="%{$fg[red]%}"

    local RESET="%{$terminfo[sgr0]%}"

    if [[ -n $SSH_CONNECTION ]]; then
        echo -n "[${CLEAN}SSH: $(hostname)$RESET]"
    fi

    if [[ -n $VIRTUAL_ENV ]]; then
        echo -n "["
        echo -n $CLEAN
        echo -n "VE: "
        echo -n "$(basename $VIRTUAL_ENV)"
        echo -n $RESET
        echo -n "]"
    fi

    git rev-parse --git-dir >& /dev/null
    if [[ $? == 0 ]]; then
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
        echo -n `git branch | command grep '* ' | sed 's/..//' || echo 'No Branch'`

        # Determine if need to pull or not
        UPSTREAM=${1:-'@{u}'}
        LOCAL=$(git rev-parse @ 2&>/dev/null)
        REMOTE=$(git rev-parse "$UPSTREAM" 2&>/dev/null)
        BASE=$(git merge-base @ "$UPSTREAM" 2&>/dev/null)

        if [[ $LOCAL != $REMOTE && $REMOTE != "" ]]; then
            echo -n " ("
            if [ $LOCAL = $BASE ]; then
                echo -n "v" # Need to pull
            elif [ $REMOTE = $BASE ]; then
                echo -n "^" # Need to push
            else
                echo -n "^v" # Diverged
            fi
            echo -n ")"
        fi
        echo -n $RESET
        echo -n "]"
    fi

    echo -n $RESULT
}

export RPS1='$(__rprompt)'

# Global Variables
command -v nvim >/dev/null && export VISUAL=nvim || export VISUAL=vim
export EDITOR="$VISUAL"
export OFFICE=libreoffice
export PDFVIEWER="zathura --fork"
export VIDEOVIEWER=mpv
export WINE=wine

# History
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
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
# add custom completion scripts
fpath=(~/.zsh/completion $fpath)

autoload -U compinit && compinit
zstyle ':completion:*' rehash true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:approximate:' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3 )) numeric)'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Directory Colors
[[ $LINUX == 1 ]] && eval "$(dircolors -b)"
[[ $MACOS == 1 ]] && export CLICOLOR=1

# Directory Hashes
hash -d ch=~/Documents/cheatsheets
hash -d doc=~/Documents
hash -d db=~/Dropbox
hash -d df=~/dotfiles
hash -d dl=~/Downloads
hash -d kattis=~/projects/kattis
hash -d no=~/Documents/notes
hash -d pass=~/.password-store
hash -d pics=~/Pictures
hash -d proj=~/projects
hash -d pres=~doc/presentations
hash -d tmp=~/tmp
hash -d ut=~/projects/up-tempo
hash -d vid=~db/Videos

# Projects
hash -d algo=~proj/acm/algobowl
hash -d fl=~proj/flight
hash -d gchal=~proj/google-challenge
hash -d pray=~proj/pray-app
hash -d res=~doc/resume
hash -d chai=~proj/chess-ai
hash -d stw=~proj/summation-tech-website
hash -d sws=~proj/sumnerevans.com
hash -d tef=~proj/the-evans.family
hash -d vis=~proj/acm/visplay

# School
hash -d sch=~/school
hash -d scharch=~/school/archive
hash -d acm=~sch/acm
hash -d lug=~sch/lug

# ===== ALIASES =====
alias tar="bsdtar"
alias screen='screen -DR'
alias pwd="pwd && pwd -P"

# File Type Associations
alias -s cpp=$EDITOR
alias -s doc=$OFFICE
alias -s docx=$OFFICE
alias -s exe=$WINE
alias -s h=$EDITOR
alias -s md=$EDITOR
alias -s mp4=$VIDEOVIEWER
alias -s mkv=$VIDEOVIEWER
alias -s ods=$OFFICE
alias -s odt=$OFFICE
alias -s pdf=$PDFVIEWER
alias -s ppt=$OFFICE
alias -s pptx=$OFFICE
alias -s tex=$EDITOR
alias -s txt=$EDITOR
alias -s xls=$OFFICE
alias -s xlsx=$OFFICE

##### Command Shortcuts #####
# Printing
alias alpr='ssh isengard lpr -P bb136-printer -o coallate=true'
alias alprd='ssh isengard lpr -P bb136-printer -o coallate=true -o Duplex=DuplexNoTumble'
alias lpr='lpr -o coallate=true'
alias hlpr='lpr -o Duplex=None'
alias hlprd='lpr -o Duplex=None -o Duplex=DuplexNoTumble'

# Git
alias git="hub"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit"
alias gca="git commit -a"
alias gch="git checkout"
alias gd="git diff"
alias gdc="git diff --cached"
alias gfetch="git fetch"
alias gl="git log --pretty=format:'%C(auto)%h %ad %C(green)%s%Creset %C(auto)%d [%an (%G? %GK)]' --graph --date=format:'%Y-%m-%d %H:%M' --all"
alias gpull="git pull"
alias gpush="git push"
alias grhh="git reset --hard HEAD"
alias gs="git status"
alias gst="git stash"

# Config
alias getquote="fortune ~/.mutt/quotes"
alias i3conf="vim ~/.config/i3/config"
alias muttrc='vim ~/.mutt/muttrc'
alias quotesfile="vim ~/.mutt/quotes && strfile -r ~/.mutt/quotes"
alias reload=". ~/.zshrc && echo 'ZSH Config Reloaded from ~/.zshrc'"
alias sshconf="vim ~/.ssh/config"
alias vimrc="realvim ~/.vim/vimrc"
command -v nvim >/dev/null && alias nvimrc="nvim ~/.config/nvim/init.vim"
alias vimshort="vim ~/.vim/shortcuts"
alias xresources="vim ~/.Xresources && xrdb -load ~/.Xresources && echo '~/Xresources reloaded'"
alias zshrc="vim ~/.zshrc && reload"

alias antioffice='libreoffice --headless --convert-to pdf'
alias dbs="dropbox-cli status"
alias grep="grep --color -n"
alias iftop='sudo iftop'
[[ "$LINUX" == "1" ]] && alias ls="ls --color -F"
alias la="ls -a"
alias ll="ls -lah"
alias ohea='echo "You need to either wake up or go to bed!"'
[[ "$LINUX" == "1" ]] && alias open='(thunar &> /dev/null &)'
[[ "$MACOS" == "1" ]] && alias open='open .'
alias pdflatex='pdflatex -shell-escape'
alias xelatex='xelatex -shell-escape'
alias zathura=$PDFVIEWER

# Use nvim by default if it exists
command -v nvim >/dev/null && alias realvim='command vim' && alias vim='nvim'

# Making GNU fileutils more verbose
for c in cp rm chmod chown rename; do
    alias $c="$c -v"
done

##### Custom Functions #####

# Things to perform after a directory change.
function chpwd() {
    emulate -L zsh
    la

    # Fetch Git if this is a Git repo
    [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1
    if [[ "$?" == "0" ]]; then
        echo -e "Fetching from git in the background..."
        (git fetch 2&>/dev/null &)
    fi

    # Automatically activate the virtualenv if it exists.
    current_ve=$(basename "$VIRTUAL_ENV")
    if [[ -f .virtualenv && ( ! -v "VIRTUAL_ENV" || "$(cat .virtualenv)" != "$current_ve" ) ]]; then
        echo -e "\nActivating the '$(cat .virtualenv)' virtual environment..."
        workon "$(cat .virtualenv)"
        echo -e "The '$(cat .virtualenv)' virtual environment has been activated."
    fi
}

# "delete" files (use ~/tmp as a recycle bin)
function del() {
    mv $* $HOME/tmp
}

# Convert MD files to PDF using pandoc
function md2pdf() {
    filename=$(basename "$1")
    extension="${filename##*.}"
    filename="${filename%.*}"

    [[ "$extension" != "md" ]] && echo "Must be markdown file" && return

    pandoc -V geometry:margin=1in -o $filename.pdf $1
}

# Check the spelling of a word using aspell
function spell() {
    # Default to GB spelling, or if the second param exists, use it to specify
    # a different language.
    if [[ -z "$2" ]]; then; lang="en_GB"; else; lang="$2"; fi
    echo "$1" | aspell -a -l "$lang"
}

function wgitignore() {
    wget "https://www.gitignore.io/api/$1" -O - >> .gitignore
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
    [[ $LBUFFER = *.. ]] && LBUFFER+="/.." || LBUFFER+="."
}
zle -N append-dir-up __zkey_append_dir_up

function __zkey_delete_dir_up {
    if [[ $LBUFFER = */..  ]] then
        CURSOR=CURSOR-3
        BUFFER="$LBUFFER${RBUFFER:${CURSOR+3}}"
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

# Syntax Highlighting and Auto-suggestions
if [[ $LINUX == "1" ]]; then
    if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi
    if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
        source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi
    if [[ -f /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh ]]; then
        source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh
        export YSU_HARDCORE=1
    fi

    if [[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]]; then
        source /usr/share/doc/pkgfile/command-not-found.zsh
    fi
elif [[ $MACOS == "1" ]]; then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Add to PATH
export PATH="$HOME/.gem/ruby/2.5.0/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/var/lib/snapd/snap/bin:$PATH"

# Python Virtual Environment Wrapper
export WORKON_HOME=$HOME/.virtualenvs
command -v /usr/bin/virtualenvwrapper_lazy.sh >/dev/null && source /usr/bin/virtualenvwrapper_lazy.sh

# Do the thing so rust blows up verbosely
command -v rustc >/dev/null && export RUST_BACKTRACE=1
command -v rustc >/dev/null && export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# Set fuzzy finder to use fd
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Set up the ssh-agent if necesarry
if [ ! -S ~/.ssh/ssh_auth_sock  ]; then
    eval `ssh-agent`
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l | grep "The agent has no identities" && ssh-add

# Always start with an ls -la
eval la
