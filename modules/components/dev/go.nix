# Go Development Tools
# Ported from: levonk.vibeops.dev-go
{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # Go toolchain
    go             # Go compiler and standard tooling

    # Development tools
    gopls          # Go language server for editors
    golangci-lint  # Fast Go linter aggregator
    delve          # Go debugger
    gotools        # Misc Go development tools
    go-tools       # Static analysis tools (staticcheck, etc.)

    # Build tools
    goreleaser     # Build and release automation for Go projects
  ];

  home.sessionVariables = {
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
  };

  home.sessionPath = [ "$HOME/go/bin" ];
}
