{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Steam
    # steam # Needs system-level config on NixOS, for home-manager it's tricky

    # Tools
    mangohud    # In-game overlay for performance metrics
    protonup-qt # Manage and install Proton-GE versions
  ];
}
