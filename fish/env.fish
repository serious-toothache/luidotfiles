# fish
set -U fish_color_autosuggestion "#737373"
set -U zoxide_cmd z

# general| Sets nvim as your system-wide editor for commands that rely on $EDITOR / $VISUAL.
set -gx EDITOR "nvim"
set -gx VISUAL "nvim"

# sudo prompt
set -gx SUDO_PROMPT (string join '' \
    (tput bold) (tput setaf 1) '' \
    (tput setab 1) (tput setaf 0) 'sudo' (tput sgr0) \
    (tput bold) (tput setaf 1) ' ' \
    (tput setaf 7) 'password for %u: ' (tput sgr0))
