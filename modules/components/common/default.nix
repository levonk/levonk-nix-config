{ ... }: {
  imports = [
    ../cli/core.nix
    ../../system/chezmoi.nix
    ../tools/direnv.nix
    ../nix/settings.nix
    ../nix/cache.nix
  ];
}
