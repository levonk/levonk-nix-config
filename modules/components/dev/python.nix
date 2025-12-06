# Python Development Tools
# Ported from: levonk.vibeops.dev-python
# Note: Project-specific Python versions are managed via direnv + flake.nix
{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # Python package managers
    uv        # Fast Python package installer
    poetry    # Dependency management
    pipx      # Install Python apps in isolation

    # Development tools
    ruff      # Fast linter and formatter
    mypy      # Static type checker
    black     # Code formatter (fallback)
    isort     # Import sorter

    # Virtual environment tools
    virtualenv

    # IPython for interactive development
    python3Packages.ipython
  ];
}
