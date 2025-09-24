if status is-interactive
    # Starship custom prompt
    starship init fish | source

    # Disable greeting
    set fish_greeting

    # Custom colours
    #cat ~/.local/state/caelestia/sequences.txt 2> /dev/null
end

fish_add_path /home/stickyfluid/.spicetify
