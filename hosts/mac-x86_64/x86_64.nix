{ pkgs, ... }: {
  imports = [
    ../../modules/system/darwin/defaults.nix
    ../../modules/system/darwin/homebrew.nix
  ];

  # Nix-Darwin configuration
  system.stateVersion = 4;
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

  # Define a user account for nix-darwin to manage (needed for home-manager)
  users.users.useracct = {
    name = "useracct";
    home = "/Users/useracct";
  };

  # Home Manager module
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.useracct = { pkgs, ... }: {
    imports = [
      ../../modules/profiles/roles/cli.nix
      ../../modules/profiles/roles/gui.nix
      ../../modules/profiles/roles/dev.nix
      ../../modules/profiles/os/mac.nix
      ../../modules/security
    ];

    # Security: Baseline for dev workstation
    security.profile = "baseline";

    home.stateVersion = "23.11";
  };
}
