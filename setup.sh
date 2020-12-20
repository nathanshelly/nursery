#! /usr/bin/env bash

# shellcheck disable=SC1091,SC2016

echo "Starting Nix setup"

true | sh <(curl -L https://nixos.org/nix/install) \
  --daemon \
  --darwin-use-unencrypted-nix-store-volume

echo "Nix installed"

# initialize `nix` for next steps - same line added to /etc/zshrc by installer
. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'

# TODO: avoid needing to recreate channels owned by root
rm -rf ~/.nix-defexpr
nix-channel --update

nix-build \
  https://github.com/LnL7/nix-darwin/archive/master.tar.gz \
  -A installer > /dev/null

if ./result/bin/darwin-installer; then
  echo '`nix-darwin` installed'
else
  echo '`nix-darwin` installer failed. Please fix any issues and try again.'
  exit 1
fi
