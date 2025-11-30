{ pkgs, ... }: {
  imports = [
    ../../modules/cli/core.nix
    ../../modules/shells/zsh.nix
    ../../modules/languages/mise.nix
    ../../modules/system/chezmoi.nix
    ../../modules/editors/vim.nix
  ];

  # WSL Specific Configuration
  home.packages = with pkgs; [
    wsl-open # Open files in Windows from WSL
    dos2unix # Fix line endings
  ];

  home.sessionVariables = {
    BROWSER = "wsl-open";
  };

  home.stateVersion = "23.11";
  home.username = "useracct"; 
  home.homeDirectory = "/home/useracct"; 

  programs.home-manager.enable = true;
}
