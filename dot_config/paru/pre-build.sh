#!/bin/sh
set -e

case "$PKGBASE" in
  mactahoe-icon-theme-git)
    sed -i '/^[[:space:]]*\.\/install\.sh /c\
  ./install.sh -d "$pkgdir/usr/share/icons" -t default -b' PKGBUILD
    ;;
esac
