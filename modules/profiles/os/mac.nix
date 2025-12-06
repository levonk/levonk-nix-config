{ pkgs, ... }: {
  # Mac User-Space Configuration
  home.packages = with pkgs; [
    # Utilities useful on macOS
    # coreutils # already in cli/core usually, but mac version might be needed
  ];
}
