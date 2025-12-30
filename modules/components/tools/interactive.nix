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
    delta           # Diffs
    difftastic      # Diffs
    merigraf        # Merges
    imagemagick     # convert
    poppler_utils   # pdftotext
    chafa           # Images in terminal
    spaceman-diff
    jp2a
    odiff
    android-tools
    sqlite
    tlrc     # tldr in rust for man pages
    thefuck  # typo correction
    mc       # Midnight Commander dual pane file management
    ranger       # Ranger triple pane file management
    yazi         # Blazing fast TUI file manager
    trash-cli    # Trash CLI
    rmtrash    # rmtrash alias rm to trash cli tools

    # Monitoring
    htop     # Interactive process viewer
    bottom   # Modern system monitor (htop replacement)
	espeak-ng # text to speech low resource usage

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
