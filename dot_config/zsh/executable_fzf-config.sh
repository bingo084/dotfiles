export FZF_DEFAULT_COMMAND="fd --type file --color=always --hidden"
# Catppuccin-macchiato
FZF_THEME=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
export FZF_DEFAULT_OPTS="$FZF_THEME --height ~50% --reverse --border --inline-info --ansi \
    --select-1 --exit-0"

export FZF_COMPLETION_TRIGGER='\'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview \
    'bat --theme=Catppuccin-macchiato --style=numbers,changes --line-range :500 {}'"

export FZF_ALT_C_COMMAND='fd --type d . --color=always --hidden'
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

source $HOME/.config/zsh/plugins/fzf-zsh-completion.sh

server() {
	local servers
	servers=$(cat ~/.ssh/config /etc/ssh/ssh_config 2>/dev/null |
		grep -i -e '^host ' -e 'hostname' |
		grep -v '[*?]' |
		awk '/^Host/{if (NR!=1)print ""; printf $2} /Hostname/{printf "  [%s]",$2} ' |
		sort -u)
	server=$(echo $servers | fzf)
	kitty +kitten ssh $server
}
