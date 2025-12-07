# Node.js Development Tools
# Ported from: levonk.vibeops.dev-js
# Note: Project-specific Node versions are managed via direnv + flake.nix
{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # Package managers
    nodejs_22  # Node.js 22 LTS fallback runtime
    pnpm       # Fast, disk-efficient Node package manager
    yarn       # Alternative Node package manager
    bun        # All-in-one JS runtime, bundler, and test runner

    # Development tools
    typescript                # TypeScript compiler
    typescript-language-server # LSP server for TypeScript
    nodePackages.prettier     # Opinionated code formatter
    nodePackages.eslint       # JavaScript/TypeScript linter

    # Build tools
    esbuild   # Extremely fast JS/TS bundler
    turbo     # Turborepo build system/monorepo task runner
  ];
}
