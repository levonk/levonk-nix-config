{ pkgs, ... }: {
  imports = [
    ../../modules/profiles/roles/cli.nix
    ../../modules/profiles/os/linux.nix
    ../../modules/security
  ];

  # Security: Hardened for remote servers
  security.profile = "hardened";

  home.stateVersion = "23.11";
  home.username = "useracct";
  home.homeDirectory = "/home/useracct";

  programs.home-manager.enable = true;
}
