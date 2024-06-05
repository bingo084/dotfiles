# Catppuccin-mocha
FZF_THEME=" \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

export FZF_DEFAULT_COMMAND="fd --type file --color=always --hidden"
export FZF_DEFAULT_OPTS="$FZF_THEME --height ~50% --reverse --border --inline-info --ansi \
  --bind=alt-d:preview-half-page-down,alt-u:preview-half-page-up \
  --select-1 --exit-0"

export FZF_COMPLETION_TRIGGER='\'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"

export FZF_ALT_C_COMMAND='fd --type d . --color=always --hidden'
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
