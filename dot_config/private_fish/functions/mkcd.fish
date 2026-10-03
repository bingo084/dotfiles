function mkcd --description 'Create a directory and enter it'
    if test (count $argv) -ne 1
        printf 'Usage: mkcd DIRECTORY\n' >&2
        return 2
    end
    command mkdir -p -- "$argv[1]"
    and builtin cd -- "$argv[1]"
end
