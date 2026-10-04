function lazygit --description 'Open Lazygit with the repository name in the terminal title' --wraps lazygit
    set -l args $argv
    if isatty stdout; and argparse --move-unknown p/path= -- $argv 2>/dev/null
        set -l repo_path $PWD
        set -q _flag_path; and set repo_path "$_flag_path"
        set -l repo_root (command git -C "$repo_path" rev-parse --show-toplevel 2>/dev/null)
        test -n "$repo_root"; and set repo_path "$repo_root"
        set -l repo_name (path basename -- "$repo_path" | string replace -ra '[[:cntrl:]]' '')
        printf '\e]2;lazygit | %s\a' "$repo_name"
    end

    command lazygit $args
end
