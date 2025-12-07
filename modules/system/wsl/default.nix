{ pkgs, ... }: {
  imports = [
    ../linux/default.nix
  ];

  # WSL-specific configuration
  home.sessionVariables = {
    # Fix for some GUI apps in WSL
    LIBGL_ALWAYS_INDIRECT = "1";
    # Ensure browser opens in Windows
    BROWSER = "wslview";
  };

  home.packages = with pkgs; [
    wslu  # WSL Utilities (wslview, wslact, etc.)
  ];
}
