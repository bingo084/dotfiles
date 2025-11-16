#!/bin/sh

# Not running in the chezmoi init, exit
[ "$CHEZMOI_COMMAND" != "init" ] && exit 0

# Check if 'rbw' command exists
if command -v rbw >/dev/null 2>&1; then
  echo ":: rbw is already installed, proceeding to initialize..."
else
  echo ":: Installing rbw..."

  # Determine the OS and install rbw
  case "$(uname -s)" in
  Darwin)
    brew install rbw
    ;;
  Linux)
    # Check if the system is Arch Linux
    if [ -f /etc/arch-release ] || grep -qi 'ID=arch' /etc/os-release; then
      sudo pacman -S --noconfirm rbw
    else
      echo ":: Unsupported Linux distribution"
      exit 1
    fi
    ;;
  *)
    echo ":: Unsupported OS"
    exit 1
    ;;
  esac
fi

if [ -z "$VAULTWARDEN_URL" ]; then
  read -rp "Enter vaultwarden domain: " VAULTWARDEN_DOMAIN
fi

if [ -z "$VAULTWARDEN_EMAIL" ]; then
  read -rp "Enter vaultwarden email: " VAULTWARDEN_EMAIL
fi

# Initialize rbw with the provided configuration
echo ":: Initializing rbw..."
rbw config set base_url "https://$VAULTWARDEN_DOMAIN"
rbw config set email "$VAULTWARDEN_EMAIL"

echo ":: rbw setup completed."
