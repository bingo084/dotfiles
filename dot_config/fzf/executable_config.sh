export FZF_DEFAULT_COMMAND="fd --type file --color=always --hidden"
export FZF_DEFAULT_OPTS='--height 90% --layout=reverse --border --inline-info --ansi'

export FZF_COMPLETION_TRIGGER='\'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"

export FZF_ALT_C_COMMAND='fd --type d . --color=always --hidden'
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

alias bi="$HOME/.config/fzf/brew_interactive.sh"
source $HOME/.config/fzf/fzf-tab/fzf-tab.plugin.zsh

server(){
    local servers
    servers=$(cat ~/.ssh/config /etc/ssh/ssh_config 2> /dev/null \
        | grep -i -e '^host ' -e 'hostname' \
        | grep -v '[*?]' \
        | awk '/^Host/{if (NR!=1)print ""; printf $2} /Hostname/{printf "  [%s]",$2} ' \
        | sort -u)
    server=$(echo $servers | fzf)
    kitty +kitten ssh $server
}
