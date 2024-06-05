if status is-login
  if type -q /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
  end
  fish_add_path $HOME/bin
  fish_add_path $HOME/bin/clash
  fish_add_path $HOME/bin/statusbar
  fish_add_path $HOME/bin/rime
  set -gx TERMINAL kitty
  set -gx EDITOR nvim
  set -gx PAGER "less -R"
end
if status is-interactive
  set -g fish_greeting
  # starship
  starship init fish | source
  set -gx STARSHIP_CONFIG "$HOME/.config/starship/config.toml"

  # fzf
  fzf --fish | source
  set -gx FZF_DEFAULT_COMMAND "fd --type file --color=always --hidden"
  set FZF_THEME " \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
  set -gx FZF_DEFAULT_OPTS "$FZF_THEME --height ~50% --reverse --border --inline-info --ansi \
    --bind=alt-d:preview-half-page-down,alt-u:preview-half-page-up \
    --select-1 --exit-0"
  set -gx FZF_COMPLETION_TRIGGER "\\"
  set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
  set -gx FZF_CTRL_T_OPTS "--preview 'bat --color=always --line-range :500 {}'"
  set -gx FZF_ALT_C_COMMAND 'fd --type d . --color=always --hidden'
  set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --color always {} | head -200'"

  # atuin
  atuin init fish | source

  # zoxide
  zoxide init --cmd cd fish | source
  set -gx _ZO_ECHO "1"
  set -gx _ZO_FZF_OPTS "$FZF_DEFAULT_OPTS \
    --exact --no-sort --bind=ctrl-z:ignore --cycle --keep-right \
    --preview='command eza --color=always {2..}' \
    --preview-window=down,30%"

  # alias
  abbr -a s "kitty +kitten ssh"
  abbr -a lg "lazygit"
  abbr -a ld "lazydocker"
  abbr -a fm "yazi"
  abbr -a cat "bat"
  # alias eza
  abbr -a ls "eza"
  abbr -a tree "eza --tree"
  abbr -a lsa "eza -a"
  abbr -a ll "eza -l"
  abbr -a lla "eza -la"
  # alias chezmoi
  set chezmoi_path $(chezmoi source-path)
  abbr -a cha "chezmoi add"
  abbr -a chc "cd $chezmoi_path"
  abbr -a chd "chezmoi diff"
  abbr -a chf "yazi $chezmoi_path"
  abbr -a chfg "chezmoi forget"
  abbr -a chg "lazygit -p $chezmoi_path"
  abbr -a chh "chezmoi help | $PAGER"
  abbr -a chm "chezmoi merge"
  abbr -a chma "chezmoi merge-all"
  abbr -a chp "chezmoi apply"
  abbr -a chra "chezmoi re-add"
  abbr -a chrm "chezmoi remove"
  abbr -a chs "chezmoi status"
  abbr -a cht "chezmoi execute-template"
  abbr -a chu "chezmoi update"
  # alias systemctl
  if type -q systemctl
    abbr -a sst "sudo systemctl start"
    abbr -a sss "sudo systemctl status"
    abbr -a srt "sudo systemctl restart"
    abbr -a ssp "sudo systemctl stop"
    abbr -a see "sudo systemctl enable"
    abbr -a sen "sudo systemctl enable --now"
    abbr -a sust "systemctl --user start"
    abbr -a suss "systemctl --user status"
    abbr -a surt "systemctl --user restart"
    abbr -a susp "systemctl --user stop"
    abbr -a suee "systemctl --user enable"
    abbr -a suen "systemctl --user enable --now"
  end
end
