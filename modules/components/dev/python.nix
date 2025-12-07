# Python Development Tools
# Ported from: levonk.vibeops.dev-python
# Note: Project-specific Python versions are managed via direnv + flake.nix
{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # Python package managers
    uv        # Fast Python package installer and resolver
    poetry    # Python dependency and virtualenv manager
    pipx      # Install and run Python apps in isolated envs

    # Development tools
    ruff      # Fast Python linter and formatter
    mypy      # Static type checker for Python
    black     # Opinionated code formatter (fallback)
    isort     # Import sorter for Python files

    # Virtual environment tools
    virtualenv # Create Python virtual environments
    conda      # Conda package and environment manager

    # IPython for interactive development
    python3Packages.ipython  # Enhanced interactive Python shell
  ];
}
