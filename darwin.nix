{ config, pkgs, ... }:

let
  USER = "${builtins.getEnv "USER"}";
in
{
  environment = { shells = [ pkgs.zsh ]; };

  # enable flakes - https://zimbatm.com/NixFlakes/#other-systems
  nix = {
    # https://daiderd.com/nix-darwin/manual/index.html#opt-nix.extraOptions
    extraOptions = ''experimental-features = nix-command flakes'';

    # use more recent version of nix with flake support
    package = pkgs.nixFlakes;

    # required to use flakes on multi-user macOS system
    trustedUsers = [ USER ];
  };

  # create /etc/zshrc that activates the nix-darwin environment on shell load
  programs.zsh.enable = true;

  # auto upgrade nix package and the daemon service
  services.nix-daemon.enable = true;

  users.users."${USER}" = {
    # home key here requed for home-manager config to apply
    home = "/Users/${USER}";
    packages = with pkgs; [ bat ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
