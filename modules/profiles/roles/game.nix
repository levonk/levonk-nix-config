{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Steam
    # steam # Needs system-level config on NixOS, for home-manager it's tricky

    # Tools
    mangohud
    protonup-qt
  ];
}
