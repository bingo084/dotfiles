#!/bin/sh
trap 'timeout 1s qs ipc -p "$HOME/.config/quickshell" call updates end >/dev/null 2>&1 || :' 0
trap 'exit 130' INT
trap 'exit 129' HUP
trap 'exit 143' TERM

timeout 1s qs ipc -p "$HOME/.config/quickshell" call updates begin >/dev/null 2>&1 || :
paru "$@"
exit "$?"
