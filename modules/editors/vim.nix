{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Neovim
    neovim
    # Vim (sometimes needed for lightweight editing)
    vim
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # Configuration is managed by Chezmoi/NvChad/LazyVim
  };
}
