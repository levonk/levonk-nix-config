{ pkgs, ... }: {
  imports = [
    ../../components/browsers/default.nix
    ../../components/comms/default.nix
    ../../components/multimedia/default.nix
    ../../components/tools/knowledge.nix
  ];

  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack

    # Terminals
    alacritty
    kitty
    wezterm
  ];

  fonts.fontconfig.enable = true;
}
