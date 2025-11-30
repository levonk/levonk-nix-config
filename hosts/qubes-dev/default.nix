{ pkgs, ... }: {
  imports = [
    ../../modules/cli/core.nix
    ../../modules/shells/zsh.nix
    ../../modules/languages/mise.nix
    ../../modules/system/chezmoi.nix
    ../../modules/editors/vim.nix
    ../../modules/editors/vscode.nix
  ];

  home.stateVersion = "23.11";
  home.username = "user"; # Default Qubes user
  home.homeDirectory = "/home/user";

  programs.home-manager.enable = true;
}
