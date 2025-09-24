# ----- Prompt -----
function fish_prompt
    set_color green
    # echo -n (whoami)'@'(hostname -s)' '
    echo -n (whoami)
    set_color blue
    echo -n (prompt_pwd)
    set_color normal
    echo -n '$ '
end

# --- sudo with auto refresh ---
function sudo --wraps=command
    command sudo -v
    command sudo $argv
end


# --- Upload file with ffsend and show QR ---
function ffsend
    if test (count $argv) -eq 0
        echo (set_color red)"[!] Usage: ffsend <file>"(set_color normal)
        return 1
    end

    set url (/usr/bin/ffsend upload -q $argv)
    if test -z "$url"
        echo (set_color red)"[!] Upload failed."(set_color normal)
        return 1
    end

    qrencode -t UTF8 --foreground=000000 --background=ffffff -l M -s 20 $url
    wl-copy "$url"
    echo (set_color green)"[+] Copied to clipboard:"(set_color normal) $url
end

# ---- For jumping between prompts in foot terminal -----
function mark_prompt_start --on-event fish_prompt
	echo -en "\e]133;A\e\\"
end


# --- Yazi + cd back to last dir ---
function r
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"

    if read -z cwd < "$tmp"; and test -n "$cwd"; and test "$cwd" != "$PWD"
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# --- Pacman/Paru updates with "important" first ---
function uppac
    printf '%b\n' (set_color green)"::"(set_color normal) " Important updates:"
    if test -f ~/.config/paru/important_packages.txt
        checkupdates | grep -Ff ~/.config/paru/important_packages.txt
    else
        echo "(no important packages file found)"
    end
    echo
    paru
end

# --- Copy system serial number to clipboard ---
function esupport
    set ESUPPORT (sudo dmidecode -t system | awk -F': ' '/Serial Number/ {print $2}')
    if test -z "$ESUPPORT"
        echo (set_color red)"[!] Could not read system serial number."(set_color normal)
        return 1
    end
    wl-copy $ESUPPORT
    echo (set_color green)"[+] Copied to clipboard:"(set_color normal) $ESUPPORT
end

# --- Clone AUR package repo ---
function dpkgb
    if test (count $argv) -eq 0
        echo (set_color red)"[!] Usage: dpkgb <package>"(set_color normal)
        return 1
    end
    git clone https://aur.archlinux.org/$argv[1].git
end


# ---- Extract -----
function extract --description "Extract almost any archive: extract file1.zip file2.tar.gz ..."
    for archive in $argv
        if test -f $archive
            switch $archive
                case '*.tar.bz2' '*.tbz2'
                    tar xvjf $archive
                case '*.tar.gz' '*.tgz'
                    tar xvzf $archive
                case '*.bz2'
                    bunzip2 $archive
                case '*.rar'
                    unrar x $archive
                case '*.gz'
                    gunzip $archive
                case '*.tar'
                    tar xvf $archive
                case '*.zip'
                    unzip $archive
                case '*.Z'
                    uncompress $archive
                case '*.7z'
                    7z x $archive
                case '*'
                    echo "extract: don't know how to extract '$archive'"
            end
        else
            echo "extract: '$archive' is not a valid file"
        end
    end
end

# ----- Yazi ------
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# For jumping between prompts in foot terminal
function mark_prompt_start --on-event fish_prompt
	echo -en "\e]133;A\e\\"
end



# --- This ensures sudo refreshes credentials before running. ---
alias sudo='sudo -v; command sudo'


alias ....='cd ../../..'
alias ...='cd ../..'
alias ..='cd ..'
alias :q='exit'
alias Q='exit'
alias acvpip="source .venv/bin/activate"
alias b='tput bel'
alias bell='tput bel'
alias clpac='sudo pacman -Qtdq | sudo pacman -Rns -'
alias cr='cargo run'
alias df="duf"
alias dir="ls"
alias find="fd"

# ====== Git =====
alias gd='git diff'
alias gc='git commit -am'
alias gl='git log'
alias gs='git status'
alias gst='git stash'
alias gsp='git stash pop'
alias gp='git push'
alias gpl='git pull'
alias gsw='git switch'
alias gsm='git switch main'
alias gb='git branch'
alias ga='git add .'
alias gitc='git commit -S'
alias gitd='git diff HEAD'
alias gitp='git push'



alias godsays='curl "https://godsays.xyz/"'
alias grep="rg"
alias hibernate='systemctl hibernate'
alias hyprpicker="hyprpicker -a"
alias inspac='paru -S'
alias ixio="curl -F 'f:1=<-' ix.io"
alias lock='key-scripts -l'
alias ls="lsd --color=auto --hyperlink=auto -Fl"
alias lsdu='du -mh --max-depth 1 | sort -rh | sed "s/\.\///g"'
alias lspac='pacman -Qqe'
alias lsserv='systemctl list-unit-files --state=enabled'
alias man="batman"
alias mkpc='makepkg -g >> PKGBUILD'
alias mkps='makepkg --printsrcinfo > .SRCINFO'
alias npm="echo 'Run bun'"
alias pac='paru'
alias q='exit'
alias qq='exit'
alias rm="rm -i"
alias rmpac='sudo pacman -Rs'
alias scr="scrcpy --keyboard=uhid --no-audio & disown && exit"
alias sd='shutdown now'
alias sensors="sensors | sed 's/.*hwmon.*/Wi-fi adapter:/g; s/.*k10.*/CPU:/g; s/amdgpu.*/GPU:/g; s/nvme.*/SSD:/g; s/vddgfx/GFX Core Voltage/g; s/vddnb/NB Voltage/g;'"
alias suspend='systemctl suspend'
alias svim="sudo nvim"
alias to0x0="0x0 -"
alias toclipboard='wl-copy'
alias todo="nvim ~/doc/notes/todo.md"
alias trash-empty="gtrash prune --day 0"
alias trash-restore="gtrash restore"
alias trash="gtrash"
alias tty-clock="termdown -f gothic -z -Z "%H:%M""
alias uefi='systemctl reboot --firmware-setup'
alias unspac='sudo pacman -Rcsn'
alias upmirror='sudo reflector --verbose --protocol https --latest 50 --sort rate --download-timeout 60 --save /etc/pacman.d/mirrorlist'
alias vi="nvim"
alias vim="nvim"
alias watchprog="sudo watch -n 0.1 progress"
alias watchsync="sudo watch -d grep -e Dirty: -e Writeback: /proc/meminfo"
alias y='r'
alias ytgetplaylist="yt-dlp --flat-playlist --print title"
