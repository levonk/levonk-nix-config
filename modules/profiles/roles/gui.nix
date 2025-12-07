{ pkgs, ... }: {
  imports = [
    ../../components/browsers/default.nix
    ../../components/comms/default.nix
    ../../components/multimedia/default.nix
    ../../components/gui/knowledge.nix
  ];

  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.jetbrains-mono # JetBrains Mono Nerd Font
    nerd-fonts.fira-code      # Fira Code Nerd Font
    nerd-fonts.hack           # Hack Nerd Font

    # Terminals
    alacritty  # GPU-accelerated terminal emulator
    kitty      # Feature-rich, GPU-accelerated terminal
    wezterm    # Modern GPU terminal with multiplexing
  ];

  fonts.fontconfig.enable = true;
}
