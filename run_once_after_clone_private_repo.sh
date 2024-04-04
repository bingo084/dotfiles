#!/bin/sh
{{ range .privateRepo -}}
git clone git@github.com:bingo084/{{ .name }}.git {{ .target }}
{{ end -}}
