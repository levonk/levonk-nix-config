# Node.js Development Tools
# Ported from: levonk.vibeops.dev-js
# Note: Project-specific Node versions are managed via direnv + flake.nix
{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # Package managers
    nodejs_22  # LTS version as fallback
    pnpm
    yarn
    bun

    # Development tools
    typescript
    typescript-language-server
    nodePackages.prettier
    nodePackages.eslint

    # Build tools
    esbuild
    turbo
  ];
}
