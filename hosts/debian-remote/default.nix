{ pkgs, ... }: {
  imports = [
    ../../modules/cli/core.nix
    ../../modules/shells/zsh.nix
    ../../modules/languages/mise.nix
    ../../modules/system/chezmoi.nix
    ../../modules/editors/vim.nix
  ];

  home.stateVersion = "23.11";
  home.username = "useracct";
  home.homeDirectory = "/home/useracct";

  programs.home-manager.enable = true;
}
