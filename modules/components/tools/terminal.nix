# Terminal Tools and Utilities
# Ported from: levonk.vibeops.tools, levonk.user_setup.thick_shell
{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # Terminal multiplexers
    tmux
    zellij

    # Modern CLI tools
    atuin      # Shell history
    zoxide     # Smarter cd
    tealdeer   # tldr pages
    fd         # Better find
    sd         # Better sed
    procs      # Better ps
    dust       # Better du
    duf        # Better df
    bottom     # Better top
    hyperfine  # Benchmarking
    tokei      # Code statistics

    # File management
    lf         # Terminal file manager
    yazi       # Modern file manager

    # Text processing
    jq
    yq-go
    gron       # Make JSON greppable
    fx         # JSON viewer

    # Archiving
    p7zip
    unzip
    zip

    # Networking
    curl
    wget
    httpie
    xh         # HTTPie alternative

    # Git tools
    gh         # GitHub CLI
    glab       # GitLab CLI
    lazygit    # Git TUI
    git-delta  # Better diffs
    difftastic # Structural diffs
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
