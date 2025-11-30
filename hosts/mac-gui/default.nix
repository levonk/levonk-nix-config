{ pkgs, ... }: {
  # macOS System Defaults (managed by nix-darwin)
  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.LoginwindowText = "Managed by Nix";
    screencapture.location = "~/Pictures/screenshots";
    screensaver.askForPassword = true;
  };

  # Homebrew Integration
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap"; # Dangerous: removes apps not in this list
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    
    taps = [
      "homebrew/bundle"
      "homebrew/services"
    ];
    
    brews = [
      # "mas" # Mac App Store CLI
    ];
    
    casks = [
      # GUI Apps not available in Nix or better managed by Brew
      "1password"
      "firefox"
      "google-chrome"
      "visual-studio-code" # Often better via brew for auto-updates on mac
      "iterm2"
      "docker" # Docker Desktop
    ];
  };

  # Nix-Darwin configuration
  system.stateVersion = 4;
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

  # Define a user account for nix-darwin to manage (needed for home-manager)
  users.users.useracct = {
    name = "useracct";
    home = "/Users/useracct";
  };

  # Home Manager module
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.useracct = { pkgs, ... }: {
    imports = [
      ../../modules/cli/core.nix
      ../../modules/shells/zsh.nix
      ../../modules/languages/mise.nix
      ../../modules/system/chezmoi.nix
      ../../modules/editors/vim.nix
      # VSCode managed by Brew Cask above, but we can keep config here if needed
    ];
    
    home.stateVersion = "23.11";
  };
}
