#!/usr/bin/env zsh
# Fully manage brew installation and suppression, and then some.
# needs zsh, jq, bat
# Inspired by:
# - https://github.com/raycast/extensions/tree/main/extensions/brew
# - https://github.com/junegunn/fzf/wiki/examples#dnf

readonly wait_click="echo $'\n\e[34mPress any key to continue...' && read -rsk 1"
readonly jq_all='
	(. | map(.cask_tokens) | flatten | map(split("/")[-1] + " (cask)"))[]
	, (. | map(.formula_names) | flatten)[]
'

readonly jq_installed='(.formulae[] | .name), (.casks[] | .token + " (cask)")'

readonly tmp_file="$(mktemp)"
trap "rm -f $tmp_file" EXIT

readonly reload="reload%case \$(cat $tmp_file) in
	install) { echo Install mode; brew tap-info --json --installed | jq --raw-output '$jq_all' | sort } ;;
	*) { echo Remove mode; brew info --json=v2 --installed | jq --raw-output '$jq_installed' | sort } ;;
esac%"

readonly state="cat $tmp_file"

readonly nextstate="execute-silent%case \$(cat $tmp_file) in install) echo rm > $tmp_file ;; *) echo install > $tmp_file ;; esac%"

echo install > $tmp_file

{ echo "Install mode"; brew tap-info --json --installed | jq --raw-output "$jq_all" | sort } |
	fzf --header-lines=1 --header-first\
        --bind="enter:execute(
			if [[ '{2}' == '(cask)' ]]; then
				brew \$($state) --cask {1}
			else
				brew \$($state) {1}
			fi
			$wait_click)+$reload" \
		--bind="tab:$nextstate+$reload" \
		--bind="?:execute:brew home {1}" \
		--preview='brew info {1} | bat --color=always --language=Markdown --style=plain' \
		--preview-window='bottom,wrap,<13(right)'
