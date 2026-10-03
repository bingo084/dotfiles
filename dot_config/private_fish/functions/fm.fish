function fm --description 'Open Yazi and change to its last directory' --wraps yazi
    set -l tmp (mktemp -t yazi-cwd.XXXXXX); or return
    command yazi $argv --cwd-file="$tmp"
    set -l result $status
    if read -zl cwd <"$tmp"; and test "$cwd" != "$PWD"; and test -d "$cwd"
        builtin cd -- "$cwd"; or set result $status
    end
    command rm -f -- "$tmp"
    return $result
end
