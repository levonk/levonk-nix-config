{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Version Control
    git
    gh
    git-lfs

    # Networking
    curl
    wget
    rsync

    # JSON/Data Processing
    jq
    yq-go

    # Modern CLI Replacements
    ripgrep # grep replacement
    bat     # cat replacement
    fzf     # fuzzy finder
    eza     # ls replacement
    fd      # find replacement
    zoxide  # cd replacement

    # Monitoring
    htop
    bottom  # htop replacement

    # Archives
    zip
    unzip
    xz
  ];

  programs.git = {
    enable = true;
    # Config is managed by Chezmoi, but we enable it here to ensure it's installed and hooked
  };

  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.eza.enable = true;
  programs.bat.enable = true;
}
