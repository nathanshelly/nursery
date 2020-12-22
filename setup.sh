#! /usr/bin/env bash

# shellcheck disable=SC1091,SC2016

echo "Starting Nix setup"

true | sh <(curl -L https://nixos.org/nix/install) \
  --daemon \
  --darwin-use-unencrypted-nix-store-volume

echo "Nix installed"

# initialize `nix` for next steps - same line added to /etc/zshrc by installer
. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'

nix-build \
  https://github.com/LnL7/nix-darwin/archive/master.tar.gz \
  -A installer > /dev/null

if ./result/bin/darwin-installer; then
  echo '`nix-darwin` installed'
else
  echo '`nix-darwin` installer failed. Please fix any issues and try again.'
  exit 1
fi

printf "\n\nnix-darwin setup complete\n\n"

# make just installed `darwin-rebuild` command available in current script
[ -f /etc/static/bashrc ] && source /etc/static/bashrc

# move nix.conf file so it can be recreated and subsequently owned by nix-darwin
if [[ -f /etc/nix/nix.conf ]] && ! grep --quiet flakes < /etc/nix/nix.conf; then
  sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.bak
fi

printf "\n\nbuilding first darwin generation\n\n"
darwin-rebuild switch -I darwin-config="./darwin.nix"

printf "\n\nNIX version: %s\n\n" "$(nix --version)"

printf "\n\nbuilding w/ flakes\n\n"
darwin-rebuild switch --flake ".#default" --impure --show-trace

echo "flakes setup"
