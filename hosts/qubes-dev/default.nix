{ pkgs, ... }: {
  imports = [
    ../../modules/profiles/roles/cli.nix
    ../../modules/profiles/roles/dev.nix
    ../../modules/profiles/os/linux.nix
  ];

  # Qubes specific (placeholder)
  # home.sessionVariables = { ... };

  home.stateVersion = "23.11";
  home.username = "user"; # Default Qubes user
  home.homeDirectory = "/home/user";

  programs.home-manager.enable = true;
}
