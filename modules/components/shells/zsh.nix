{ pkgs, ... }: {
  # Just install the shell and tools, do NOT let Home Manager manage the config files
  # because we use Chezmoi and a custom ZDOTDIR (~/.config/shells/zsh).
  home.packages = with pkgs; [
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];

  # Explicitly disable program management to avoid overwriting ~/.zshenv
  programs.zsh.enable = false;
}
