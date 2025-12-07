{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Version Control
    git       # Distributed version control
    gh        # GitHub CLI
    git-lfs   # Git Large File Storage extension

    # Networking
    curl      # HTTP client
    wget      # Non-interactive network downloader
    rsync     # Fast incremental file transfer

    # JSON/Data Processing
    jq        # Command-line JSON processor
    yq-go     # YAML processor with jq-style syntax

    # Modern CLI Replacements
    ripgrep  # Fast recursive search (grep replacement)
    bat      # Syntax-highlighting cat replacement
    fzf      # Fuzzy finder for interactive selection
    eza      # Modern ls replacement
    fd       # Simple, fast find alternative
    zoxide   # Smarter cd with frecency

    # Monitoring
    htop     # Interactive process viewer
    bottom   # Modern system monitor (htop replacement)

    # Archives
    zip      # Create ZIP archives
    unzip    # Extract ZIP archives
    xz       # LZMA compressor
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
