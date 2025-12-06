{ pkgs, ... }: {
  imports = [
    ../../modules/profiles/roles/cli.nix
    ../../modules/profiles/roles/dev.nix
    ../../modules/profiles/os/win.nix
    ../../modules/security
  ];

  # Security: Baseline for dev workstation
  security.profile = "baseline";

  home.stateVersion = "23.11";
  home.username = "useracct";
  home.homeDirectory = "/home/useracct";

  programs.home-manager.enable = true;
}
