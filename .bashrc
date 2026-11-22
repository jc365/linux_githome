# ~/.bashrc: executed by bash(1) for non-login shells.
alias refres="source ~/.bashrc"
alias jc="code ~/.bashrc"

# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
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
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias oc='opencode web'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Mis aliases
alias ll="ls -la"
alias la="ls -a"
alias c="clear"
alias ..="cd .."
alias ...="cd ../.."
alias tree="tree -C"  # Con colores
alias h="cd ~" 

# Git
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git log --oneline"
alias von="source venv/bin/activate"
alias voff="deactivate"

# Proyectos: arqia, tasks
alias arqia="cd ~/Documentos/proyects/arqia"
alias tasks="cd ~/Documentos/proyects/master/TaskManager"
alias castant="cd ~/Documentos/proyects/castant/desktop"
alias castanto="cd ~/Documentos/proyects/castant/orchestration"

alias varqia="arqia && source ~/.arqia/venv/bin/activate && echo \"✅ Entorno virtual de arqIA activado\""
alias vcastant="castant && source venv/bin/activate && echo \"✅ Entorno virtual de castant activado\""

alias vtask="tasks && source .vtask/bin/activate && echo \"✅ Entorno virtual de TaskManager activado\" "

function git-init() {
    git init "$@"
    if [ -f .gitattributes ]; then
        echo "✅ .gitattributes ya existe"
    else
        cp ~/.git-templates/.gitattributes . 2>/dev/null && echo "✅ .gitattributes copiado" || echo "⚠️ No se encontró plantilla .gitattributes"
    fi
    if [ -f .gitignore ]; then
        echo "✅ .gitignore ya existe"
    else
        cp ~/.git-templates/.gitignore . 2>/dev/null && echo "✅ .gitignore copiado" || echo "⚠️ No se encontró plantilla .gitignore"
    fi
}

function k-on() {
    sudo mkdir -p /mnt/compartidoK
    echo "🔧 Reparando NTFS si necesario..."
    sudo ntfsfix /dev/nvme0n1p4
    echo "🗄️ Montando /dev/nvme0n1p4..."
    # sudo mount -t ntfs-3g /dev/sda1 /mnt/compartidoK
    sudo mount -t ntfs-3g -o uid=$(id -u),gid=$(id -g),umask=022 /dev/nvme0n1p4 /mnt/compartidoK
    echo "✅ Montado! Abriendo Nautilus..."
    nautilus /mnt/compartidoK
}

function k-off() {
    echo "🛑 Desmontando..."
    sudo umount /mnt/compartidoK
    echo "✅ Desmontado. Puedes extraer."
}

function hdd-on() {
    sudo mkdir -p /mnt/hdd_externo
    echo "🔧 Reparando NTFS si necesario..."
    sudo ntfsfix /dev/sda1
    echo "🗄️ Montando /dev/sda1..."
    sudo mount -t ntfs-3g /dev/sda1 /mnt/hdd_externo
    echo "✅ Montado! Abriendo Nautilus..."
    nautilus /mnt/hdd_externo
}

function hdd-off() {
    echo "🛑 Desmontando..."
    sudo umount /mnt/hdd_externo
    echo "✅ Desmontado. Puedes extraer."
}

export PATH="$HOME/bin:$PATH"

# # ARQIA configuration
# source ~/.arqia/config.sh
# alias arqia-info="arqia_info"

### --- Retirado el 3-10-26 porque ya no uso ARQUIA (no progresa operativamente) ---
# export PATH="$HOME/.arqia/bin:$PATH"
# # Al final de .bashrc, después de la línea anterior
# if [[ ":$PATH:" != *":$HOME/.arqia/bin:"* ]]; then
#     export PATH="$HOME/.arqia/bin:$PATH"
# fi

# Incuido el 3-10-26 tras usar el instalador oficial de OpenCode
export PATH="$HOME/.opencode/bin:$PATH"

# Add 06-08-2026
py() {
    if [ -z "$1" ]; then
        echo "Uso: py <script_sin_extension> [argumentos...]"
        return 1
    fi
    echo "lanzando ... python3 $1.py ${@:2}"
    python3 "$1.py" "${@:2}"
}

function cq() {
    copyq toggle
}

# add 20-11-2026
edit-root() {
    if [ -z "$1" ]; then
        echo "Uso: edit-root <ruta_del_archivo>"
        return 1
    fi

    local file="$1"
    local basename
    basename=$(basename "$file")
    local tmpfile="/tmp/zzz_$basename"

    # Si existe, copiarlo como root.
    if [ -f "$file" ]; then
        sudo cp -- "$file" "$tmpfile" || return 1
    else
        # Si no existe, comprobar que existe el directorio destino.
        if [ ! -d "$(dirname "$file")" ]; then
            echo "ERROR: El directorio destino no existe."
            return 1
        fi

        : > "$tmpfile" || return 1
    fi

    sudo chown "$USER:$(id -gn)" "$tmpfile"
    chmod 600 "$tmpfile"

    echo "Copia editable: $tmpfile"
    code "$tmpfile"

    echo "Cuando termines, ejecuta: save-root $file"
}

# add 20-11-2026
save-root() {
    if [ -z "$1" ]; then
        echo "Uso: save-root <ruta_del_archivo_original> [permisos]"
        return 1
    fi

    local file="$1"
    local basename
    basename=$(basename "$file")
    local tmpfile="/tmp/zzz_$basename"
    local mode

    if [ ! -f "$tmpfile" ]; then
        echo "ERROR: No se encuentra $tmpfile."
        return 1
    fi

    # Si el original existe, conservar sus permisos y crear backup.
    if [ -f "$file" ]; then
        mode=$(sudo stat -c '%a' "$file") || return 1

        sudo cp -- "$file" "${file}.bkp" || return 1
        echo "Backup creado: ${file}.bkp"
    else
        mode="644"
    fi

    # Permitir indicar permisos explícitamente.
    if [ -n "$2" ]; then
        mode="$2"
    fi

    # Instalar el fichero con propietario y permisos definitivos.
    sudo install -o root -g root -m "$mode" \
        "$tmpfile" "$file" || return 1

    rm -f "$tmpfile"

    echo
    echo "Archivo actualizado correctamente:"
    ls -l -- "$file"
}

# added 22-11-2026
# --- DOTFILES: repo bare en ~/.githome, work-tree = $HOME ---
# Alias para gestionar los ficheros versionados del home.
# Uso: githome status | githome add .bashrc | githome commit -m "..." | githome push
alias githome='/usr/bin/git --git-dir=$HOME/.githome/ --work-tree=$HOME'

# added 22-11-2026
alias bin='cd /usr/local/bin'
alias lbin='ll /usr/local/bin'

# added 22-11-2026
dns() {
    case "${1:-}" in
    init)
        sudo /usr/local/bin/adguard-dns.sh $1
        ;;
    dns_pub)
        sudo /usr/local/bin/adguard-dns.sh $1
        ;;
    adguard)
        sudo /usr/local/bin/adguard-dns.sh $1
        ;;
    watch)
        sudo /usr/local/bin/adguard-dns.sh $1
        ;;
    *)
        resolvectl status | grep -E 'DNS Server'
        echo "Para cambiar, parm: {init|adguard|dns_pub|watch}"
        echo "  init     - Vuelve a usar los DNS entregados por el router."
        echo "  adguard  - Usa AdGuard como DNS de este equipo."
        echo "  dns_pub  - Usa Cloudflare y Quad9 como DNS de este equipo."
        echo "  watch    - Usa AdGuard y vuelve al router si deja de responder."
        # exit 1
        ;;
    esac
}

