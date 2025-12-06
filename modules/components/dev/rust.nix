# Rust Development Tools
# Ported from: levonk.vibeops.dev-rust
{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # Rust toolchain (use rustup for version management)
    rustup

    # Common Rust tools
    cargo-edit     # cargo add/rm/upgrade
    cargo-watch    # Watch for changes
    cargo-audit    # Security audit
    cargo-outdated # Check for outdated deps
    cargo-bloat    # Find code bloat
    cargo-nextest  # Better test runner

    # Rust analyzer for IDE support
    rust-analyzer
  ];

  # Rustup configuration
  home.sessionVariables = {
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";
  };

  home.sessionPath = [ "$HOME/.cargo/bin" ];
}
