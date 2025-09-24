status is-interactive || exit

# ---- Defines the autopair characters ------
set --global autopair_left "(" "[" "{" '"' "'"
set --global autopair_right ")" "]" "}" '"' "'"
set --global autopair_pairs "()" "[]" "{}" '""' "''"

# ---- Hook into keybindings {support default and insert default modes}----
function _autopair_fish_key_bindings --on-variable fish_key_bindings
    set --query fish_key_bindings[1] || return

    test $fish_key_bindings = fish_default_key_bindings &&
        set --local mode default insert ||
        set --local mode insert default
# ---- Remaps keys ----
# Backspace (\177, \b) → handled by _autopair_backspace.
# Tab (\t) → handled by _autopair_tab.
# Each autopair char ((, ", etc.) → bound to insert both left + right.
    bind --mode $mode[-1] --erase \177 \b \t

    bind --mode $mode[1] \177 _autopair_backspace # macOS ⌫
    bind --mode $mode[1] \b _autopair_backspace
    bind --mode $mode[1] \t _autopair_tab

    printf "%s\n" $autopair_pairs | while read --local left right --delimiter ""
        bind --mode $mode[-1] --erase $left $right
        if test $left = $right
            bind --mode $mode[1] $left "_autopair_insert_same \\$left"
        else
            bind --mode $mode[1] $left "_autopair_insert_left \\$left \\$right"
            bind --mode $mode[1] $right "_autopair_insert_right \\$right"
        end
    end
end

_autopair_fish_key_bindings

# ---- Handles uninstall ----
# Removes bindings, variables, and functions when emit autopair_uninstall is called.
function _autopair_uninstall --on-event autopair_uninstall
    string collect (
        bind --all | string replace --filter --regex -- "_autopair.*" --erase
        set --names | string replace --filter --regex -- "^autopair" "set --erase autopair"
    ) | source
    functions --erase (functions --all | string match "_autopair_*")
end
