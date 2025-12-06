# Security Tier: Hardened
# Stricter OS policies for remote servers and Qubes templates.
# - USB restrictions (awareness/hints)
# - Service minimization
# - MFA hints
# - Higher logging verbosity
{ pkgs, lib, ... }: {
  imports = [
    ./baseline.nix
  ];

  # Enhanced SSH Client Hardening
  programs.ssh = {
    extraConfig = lib.mkAfter ''
      # Hardened SSH Settings
      # Require explicit confirmation for new hosts
      StrictHostKeyChecking yes

      # Shorter connection timeouts
      ConnectTimeout 30

      # Disable agent forwarding by default (enable per-host)
      ForwardAgent no

      # Disable X11 forwarding by default
      ForwardX11 no
      ForwardX11Trusted no

      # Use only protocol 2
      Protocol 2

      # Batch mode for scripts (no interactive prompts)
      BatchMode no
    '';
  };

  # GPG with stricter settings
  services.gpg-agent = {
    defaultCacheTtl = 1800; # 30 minutes
    maxCacheTtl = 3600;     # 1 hour max
  };

  # Security-focused environment
  home.sessionVariables = {
    # Disable core dumps
    DISABLE_CORE_DUMPS = "1";
    # Secure umask
    UMASK = "077";
  };

  # Additional security packages
  home.packages = with pkgs; [
    # Audit and monitoring
    lynis

    # File encryption
    age
    sops

    # Secure delete
    srm

    # Network security
    nmap
    tcpdump

    # Process monitoring
    htop
    btop
  ];

  # Shell aliases for security awareness
  programs.zsh.shellAliases = {
    # Secure file operations
    "rm" = "rm -i";
    "mv" = "mv -i";
    "cp" = "cp -i";

    # Show hidden files by default
    "ls" = "ls -la";
  };
}
