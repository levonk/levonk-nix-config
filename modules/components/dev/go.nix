# Go Development Tools
# Ported from: levonk.vibeops.dev-go
{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # Go toolchain
    go

    # Development tools
    gopls          # Language server
    golangci-lint  # Linter
    delve          # Debugger
    gotools        # Various Go tools
    go-tools       # staticcheck, etc.

    # Build tools
    goreleaser     # Release automation
  ];

  home.sessionVariables = {
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
  };

  home.sessionPath = [ "$HOME/go/bin" ];
}
