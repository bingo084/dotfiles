fish_add_path --global $HOME/bin $HOME/go/bin
set -gx TERMINAL kitty
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx LESS -R

# rbw SSH agent.
begin
    set -l sock "$XDG_RUNTIME_DIR/rbw/ssh-agent-socket"
    if not test -S "$sock"; and set -q TMPDIR
        set sock "$TMPDIR/rbw-$(id -u)/ssh-agent-socket"
    end
    if test -S "$sock"
        set -gx SSH_AUTH_SOCK "$sock"
    end
end

status is-interactive; or return
set -g fish_greeting
fish_config theme choose catppuccin-mocha

if command -q starship
    set -gx STARSHIP_CONFIG "$HOME/.config/starship/config.toml"
    starship init fish | source
end

if command -q fzf
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git --color=never'
    set -gx FZF_DEFAULT_OPTS (string join ' ' -- \
    '--height=40%' --reverse --border=rounded --inline-info \
    '--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8' \
    '--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc' \
    '--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8' \
    '--bind=alt-d:preview-half-page-down,alt-u:preview-half-page-up' \
    '--bind=ctrl-d:half-page-down,ctrl-u:half-page-up' \
    --select-1 --exit-0)
end

if command -q atuin
    atuin init fish | source
end

if command -q zoxide
    set -gx _ZO_FZF_OPTS (string join ' ' -- "$FZF_DEFAULT_OPTS" \
    --exact --no-sort --bind=ctrl-z:ignore --cycle --keep-right \
    "--preview='eza --color=always -- {2..}'" --preview-window=down,30%)
    zoxide init --cmd cd fish | source
end

abbr -a v nvim
abbr -a s 'kitty +kitten ssh'
abbr -a lg lazygit
abbr -a ld lazydocker
if command -q bat
    abbr -a cat bat
    set -gx MANPAGER "sh -c 'col -bx | bat -p -lman'"
end
if command -q eza
    abbr -a ls 'eza --icons=auto'
    abbr -a tree 'eza --tree'
    abbr -a lsa 'eza --icons=auto -a'
    abbr -a ll 'eza --icons=auto -l'
    abbr -a lla 'eza --icons=auto -la'
end

set -l chezmoi_path (string escape -- "$HOME/.local/share/chezmoi")
abbr -a cha 'chezmoi add'
abbr -a chc "cd $chezmoi_path"
abbr -a chd 'chezmoi diff'
abbr -a che 'chezmoi edit'
abbr -a chf "fm $chezmoi_path"
abbr -a chfg 'chezmoi forget'
abbr -a chg "lazygit -p $chezmoi_path"
abbr -a chh 'chezmoi help | less'
abbr -a chls 'chezmoi managed'
abbr -a chm 'chezmoi merge'
abbr -a chma 'chezmoi merge-all'
abbr -a chp 'chezmoi apply'
abbr -a chpkg "nvim $chezmoi_path/.chezmoidata/packages.toml"
abbr -a chra 'chezmoi re-add'
abbr -a chrm 'chezmoi destroy'
abbr -a chs 'chezmoi status'
abbr -a cht 'chezmoi execute-template'
abbr -a chu 'chezmoi update'

if command -q systemctl
    abbr -a sc 'systemctl cat'
    abbr -a sst 'sudo systemctl start'
    abbr -a sss 'sudo systemctl status'
    abbr -a srt 'sudo systemctl restart'
    abbr -a ssp 'sudo systemctl stop'
    abbr -a see 'sudo systemctl enable'
    abbr -a sen 'sudo systemctl enable --now'
    abbr -a sd 'sudo systemctl disable'
    abbr -a sdn 'sudo systemctl disable --now'
    abbr -a sust 'systemctl --user start'
    abbr -a suss 'systemctl --user status'
    abbr -a surt 'systemctl --user restart'
    abbr -a susp 'systemctl --user stop'
    abbr -a suee 'systemctl --user enable'
    abbr -a suen 'systemctl --user enable --now'
    abbr -a sud 'systemctl --user disable'
    abbr -a sudn 'systemctl --user disable --now'
    abbr -a suc 'systemctl --user cat'
end
if command -q journalctl
    abbr -a jf 'journalctl -f'
    abbr -a juf 'journalctl -f --user-unit'
end
