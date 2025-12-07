{ pkgs, ... }: {
  # Common Linux configuration
  targets.genericLinux.enable = true;

  # XDG Base Directory standards
  xdg.enable = true;

  # Common Linux packages that might not be in the minimal POSIX set
  home.packages = with pkgs; [
    # System utilies often missing in minimal containers
    iproute2   # IP routing and network utilities
    util-linux # Misc core Linux userland utilities
    procps     # Process monitoring tools (ps, top, etc.)
  ];
}
