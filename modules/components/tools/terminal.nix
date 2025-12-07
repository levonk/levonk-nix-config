# Terminal Tools and Utilities
# Ported from: levonk.vibeops.tools, levonk.user_setup.thick_shell
{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # Terminal multiplexers
    tmux       # Terminal multiplexer
    zellij     # Modern terminal workspace/multiplexer

    # Modern CLI tools
    atuin      # Encrypted, searchable shell history
    zoxide     # Smarter cd with frecency
    tealdeer   # tldr pages for quick command examples
    fd         # Better find
    sd         # Intuitive sed replacement
    procs      # Modern ps replacement
    dust       # Disk usage analyzer (du replacement)
    duf        # Disk usage/free space viewer (df replacement)
    bottom     # Modern system monitor (top replacement)
    hyperfine  # Command-line benchmarking tool
    tokei      # Code statistics and line counting

    # File management
    lf         # Terminal file manager
    yazi       # Blazing fast terminal file manager

    # Text processing
    jq         # JSON processor
    yq-go      # YAML processor
    gron       # Make JSON greppable
    fx         # Interactive JSON viewer

    # Archiving
    p7zip      # 7-Zip compatible archiver
    unzip      # Extract ZIP archives
    zip        # Create ZIP archives

    # Networking
    curl       # HTTP client
    wget       # Non-interactive downloader
    httpie     # User-friendly HTTP client
    xh         # Fast HTTPie-like client

    # Git tools
    gh         # GitHub CLI
    glab       # GitLab CLI
    lazygit    # Terminal UI for Git
    git-delta  # Syntax-highlighted diff pager
    difftastic # Structural diff tool
  ];

  # Atuin configuration
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = false;
      sync_frequency = "0";
      search_mode = "fuzzy";
      filter_mode = "global";
    };
  };

  # Zoxide configuration
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
