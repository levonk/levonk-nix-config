{ config, pkgs, lib, ... }:

{
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
    lynis   # Security auditing tool for UNIX systems

    # File encryption
    age     # Simple, modern file encryption
    sops    # Secrets management tool with YAML/JSON editing

    # Secure delete
    srm     # Secure file deletion utility

    # Network security
    nmap    # Network scanner and mapper
    tcpdump # Packet capture and analysis tool

    # Process monitoring
    htop    # Interactive process viewer
    btop    # Resource monitor with rich UI
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

  # On macOS, ensure the LuLu firewall is installed via Homebrew when the
  # hardened profile is active. This extends any existing cask list instead of
  # replacing it, and is a no-op on non-Darwin systems.
  homebrew.casks =
    (config.homebrew.casks or [])
    ++ lib.optionals pkgs.stdenv.isDarwin [ "lulu" ];
}
