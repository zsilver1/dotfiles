# =============
#    BASICS
# =============
export EDITOR="emacs -nw -q"

# =============
#    HISTORY
# =============

## Command history configuration
if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=1000
SAVEHIST=1000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
# ignore duplication command history list
setopt hist_ignore_dups 
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
# share command history data
setopt share_history

# up and down arrow search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# =============
#    PROMPT
# =============
autoload -U colors && colors
setopt promptsubst

local ret_status="%(?:%{$fg_bold[green]%}$:%{$fg_bold[green]%}$)"
PROMPT='${ret_status} %{$fg[default]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%U%{$fg_bold[cyan]%}git:(%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[cyan]%})%u %{$fg[red]%}●"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[cyan]%})%u %{$fg[green]%}●"

# Outputs current branch info in prompt format
function git_prompt_info() {
  local ref
  if [[ "$(command git config --get customzsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# Checks if working tree is dirty
function parse_git_dirty() {
  local STATUS=''
  local FLAGS
  FLAGS=('--porcelain')

  if [[ "$(command git config --get customzsh.hide-dirty)" != "1" ]]; then
    FLAGS+='--ignore-submodules=dirty'
    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
  fi

  if [[ -n $STATUS ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# ===================
#    AUTOCOMPLETION
# ===================
# enable completion
autoload -Uz compinit
compinit

zmodload -i zsh/complist

WORDCHARS=''

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end

# autocompletion with an arrow-key driven interface
zstyle ':completion:*:*:*:*:*' menu select

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

zstyle '*' single-ignored show

# Automatically update PATH entries
zstyle ':completion:*' rehash true

# Keep directories and files separated
zstyle ':completion:*' list-dirs-first true


# ===================
#    COLORS
# ===================

if (( terminfo[colors] >= 8 )); then

  # ls Colours
  if (( ${+commands[dircolors]} )); then
    # GNU

    (( ! ${+LS_COLORS} )) && if [[ -s ${HOME}/.dir_colors ]]; then
      eval "$(dircolors --sh ${HOME}/.dir_colors)"
    else
      export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=31:bd=1;36:cd=1;33:su=30;41:sg=30;46:tw=30;42:ow=30;43'
    fi

    alias ls='ls --group-directories-first --color=auto'
  else
    # BSD

    (( ! ${+LSCOLORS} )) && export LSCOLORS='ExfxcxdxbxGxDxabagacad'

    # stock OpenBSD ls does not support colors at all, but colorls does.
    if [[ ${OSTYPE} == openbsd* ]]; then
      if (( ${+commands[colorls]} )); then
        alias ls='colorls -G'
      fi
    else
      alias ls='ls -G'
    fi
  fi

  # grep Colours
  (( ! ${+GREP_COLOR} )) && export GREP_COLOR='37;45'               #BSD
  (( ! ${+GREP_COLORS} )) && export GREP_COLORS="mt=${GREP_COLOR}"  #GNU
  if [[ ${OSTYPE} == openbsd* ]]; then
    (( ${+commands[ggrep]} )) && alias grep='ggrep --color=auto'
  else
   alias grep='grep --color=auto'
  fi

  # less Colours
  if [[ ${PAGER} == 'less' ]]; then
    (( ! ${+LESS_TERMCAP_mb} )) && export LESS_TERMCAP_mb=$'\E[1;31m'   # Begins blinking.
    (( ! ${+LESS_TERMCAP_md} )) && export LESS_TERMCAP_md=$'\E[1;31m'   # Begins bold.
    (( ! ${+LESS_TERMCAP_me} )) && export LESS_TERMCAP_me=$'\E[0m'      # Ends mode.
    (( ! ${+LESS_TERMCAP_se} )) && export LESS_TERMCAP_se=$'\E[0m'      # Ends standout-mode.
    (( ! ${+LESS_TERMCAP_so} )) && export LESS_TERMCAP_so=$'\E[7m'      # Begins standout-mode.
    (( ! ${+LESS_TERMCAP_ue} )) && export LESS_TERMCAP_ue=$'\E[0m'      # Ends underline.
    (( ! ${+LESS_TERMCAP_us} )) && export LESS_TERMCAP_us=$'\E[1;32m'   # Begins underline.
  fi
fi


# ============
# ALIASES
# ============

alias ll='ls -lh'         # long format and human-readable sizes
alias l='ll -A'           # long format, all files
alias lr='ll -R'          # long format, recursive
alias lk='ll -Sr'         # long format, largest file size last
alias lt='ll -tr'         # long format, newest modification time last
alias lc='lt -c'          # long format, newest status change (ctime) last
[[ -n ${PAGER} ]] && alias lm="l | ${PAGER}" # long format, all files, use pager

alias df='df -h'
alias du='du -h'

if (( ${+commands[dircolors]} )); then
  alias chmod='chmod --preserve-root -v'
  alias chown='chown --preserve-root -v'
fi

if (( ${+commands[safe-rm]} && ! ${+commands[safe-rmdir]} )); then
  alias rm='safe-rm'
fi

# order of preference: aria2c, axel, wget, curl. This order is derrived from speed based on personal tests.
if (( ${+commands[aria2c]} )); then
  alias get='aria2c --max-connection-per-server=5 --continue'
elif (( ${+commands[axel]} )); then
  alias get='axel --num-connections=5 --alternate'
elif (( ${+commands[wget]} )); then
  alias get='wget --continue --progress=bar --timestamping'
elif (( ${+commands[curl]} )); then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
fi


# ================
# Other Functions
# ================


# Creates archive files
function archive() {
    if (( ${#} != 2 )); then
        print "usage: ${0} [archive_name.ext] [/path/to/include/in/archive]" >&2
        return 1
    fi
    local archive_name="${1:t}"
    local dir_to_archive="${2}"
    if [[ ! -e "${dir_to_archive}" ]]; then
        print "${0}: file or directory not valid: ${dir_to_archive}" >&2
        return 1
    fi
    case "${archive_name}" in
        (*.tar.gz|*.tgz) tar -cvf "${archive_name}" --use-compress-program="gzip" "${dir_to_archive}" ;;
        (*.tar.bz2|*.tbz|*.tbz2) tar -cvf "${archive_name}" --use-compress-program="bzip2" "${dir_to_archive}" ;;
        (*.tar.xz|*.txz) tar --xz --help &>/dev/null && tar -cvJf "${archive_name}" "${dir_to_archive}" ;;
        (*.tar.lzma|*.tlz) tar --lzma --help &>/dev/null && tar -cvf "${archive_name}" --lzma "${dir_to_archive}" ;;
        (*.tar) tar -cvf "${archive_name}" "${dir_to_archive}" ;;
        (*.zip) zip -r "${archive_name}" "${dir_to_archive}" ;;
        (*.rar) rar a "${archive_name}" "${dir_to_archive}" ;;
        (*.7z) 7za a "${archive_name}" "${dir_to_archive}" ;;
        (*.gz) print "${0}: .gz is only useful for single files, and does not capture permissions. Use .tar.gz" ;;
        (*.bz2) print "${0}: .bzip2 is only useful for single files, and does not capture permissions. Use .tar.bz2" ;;
        (*.xz) print "${0}: .xz is only useful for single files, and does not capture permissions. Use .tar.xz" ;;
        (*.lzma) print "${0}: .lzma is only useful for single files, and does not capture permissions. Use .tar.lzma" ;;
        (*) print "${0}: unknown archive type: ${archive_name}" ;;
    esac
}


# Unarchives files
function unarchive() {
    if (( ${#} != 1 )); then
        print "usage: ${0} [archive.ext]" >&2
        return 1
    fi

    if [[ ! -s ${1} ]]; then
        print "archive \"${1}\" was not found or has size 0." >&2
        return 1
    fi
    local archive_name="${1:t}"
    case "${archive_name}" in
        (*.tar.gz|*.tgz) tar -xvzf "${archive_name}" ;;
        (*.tar.bz2|*.tbz|*.tbz2) tar -xvjf "${archive_name}" ;;
        (*.tar.xz|*.txz) tar --xz --help &>/dev/null && tar --xz -xvf "${archive_name}" \
                                   || xzcat "${archive_name}" | tar xvf - ;;
        (*.tar.lzma|*.tlz) tar --lzma --help &>/dev/null && tar --lzma -xvf "${archive_name}" \
                                     || lzcat "${archive_name}" | tar xvf - ;;
        (*.tar) tar xvf "${archive_name}" ;;
        (*.gz) gunzip "${archive_name}" ;;
        (*.bz2) bunzip2 "${archive_name}" ;;
        (*.xz) unxz "${archive_name}" ;;
        (*.lzma) unlzma "${archive_name}" ;;
        (*.Z) uncompress "${archive_name}" ;;
        (*.zip) unzip "${archive_name}";;
        (*.rar) (( $+{commands[unrar]} )) && unrar x -ad "${archive_name}" \
                        || rar x -ad "${archive_name}" ;;
        (*.7z|*.001) 7za x "${archive_name}" ;;
        (*) print "${0}: unknown archive type: ${archive_name}" ;;
    esac
}
