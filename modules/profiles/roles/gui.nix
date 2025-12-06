{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Browsers
    firefox
    # google-chrome # unfree

    # Fonts
    nerd-fonts.jetbrains-mono

    # Terminals
    alacritty
    # kitty # (managed by config?)
  ];

  fonts.fontconfig.enable = true;
}
