{ pkgs, ... }: {
  # Common Linux configuration
  targets.genericLinux.enable = true;

  # XDG Base Directory standards
  xdg.enable = true;

  # Common Linux packages that might not be in the minimal POSIX set
  home.packages = with pkgs; [
    # System utilies often missing in minimal containers
    iproute2
    util-linux
    procps
  ];
}
