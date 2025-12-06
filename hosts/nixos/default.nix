{ pkgs, ... }: {
  imports = [
    ../../modules/profiles/roles/cli.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "23.11";
  home.username = "useracct";
  home.homeDirectory = "/home/useracct";

  programs.home-manager.enable = true;
}
