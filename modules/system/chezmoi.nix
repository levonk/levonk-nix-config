{ pkgs, ... }: {
  home.packages = with pkgs; [
    chezmoi  # Dotfile manager
  ];

  # Note: We do NOT run 'chezmoi apply' automatically here.
  # That is a user-initiated action to prevent race conditions or overwrites.
}
