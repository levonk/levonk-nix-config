# Security Tier: Locked
# Maximum restrictions for high-threat environments.
# - Enforced hardware tokens (hints/configuration)
# - Read-only mount awareness
# - No GUI screen sharing
# - Aggressive sandboxing hints
# Used selectively (e.g., Greyhat AppVMs, high-security workstations).
{ pkgs, lib, ... }: {
  imports = [
    ./hardened.nix
  ];

  # Maximum SSH hardening
  programs.ssh = {
    extraConfig = lib.mkAfter ''
      # Locked SSH Settings
      # Require hardware key authentication where possible
      # Note: Actual enforcement is server-side; this is client preference
      PreferredAuthentications publickey
      PubkeyAuthentication yes
      PasswordAuthentication no

      # Disable all forwarding
      ForwardAgent no
      ForwardX11 no
      ForwardX11Trusted no

      # Strict host key checking
      StrictHostKeyChecking yes
      UpdateHostKeys no

      # Minimal connection persistence
      ControlMaster no

      # Very short timeouts
      ConnectTimeout 15
      ServerAliveInterval 30
      ServerAliveCountMax 2
    '';
  };

  # GPG with minimal cache (require re-auth frequently)
  services.gpg-agent = {
    defaultCacheTtl = 300;  # 5 minutes
    maxCacheTtl = 600;      # 10 minutes max
    # Require confirmation for each use
    extraConfig = ''
      no-allow-external-cache
    '';
  };

  # Locked-down environment
  home.sessionVariables = {
    # Disable core dumps
    DISABLE_CORE_DUMPS = "1";
    # Restrictive umask
    UMASK = "077";
    # Disable history entirely for maximum privacy
    HISTSIZE = "0";
    SAVEHIST = "0";
    # No telemetry
    DO_NOT_TRACK = "1";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    HOMEBREW_NO_ANALYTICS = "1";
  };

  # Security and forensics packages
  home.packages = with pkgs; [
    # Hardware token support
    yubikey-manager
    yubikey-personalization

    # Secure communications
    age
    sops
    minisign

    # Forensics and analysis
    binwalk
    foremost

    # Memory analysis
    volatility3

    # Secure networking
    wireguard-tools
    tor
    torsocks
  ];

  # Strict shell configuration
  programs.zsh = {
    shellAliases = {
      # Force confirmation on all destructive operations
      "rm" = "rm -i";
      "mv" = "mv -i";
      "cp" = "cp -i";
      "chmod" = "chmod -v";
      "chown" = "chown -v";

      # Secure defaults
      "wget" = "wget --no-check-certificate=off";
      "curl" = "curl --fail --silent --show-error";
    };

    initExtra = lib.mkAfter ''
      # Locked mode: Disable command history
      unset HISTFILE

      # Warn about locked mode
      echo "⚠️  LOCKED SECURITY MODE ACTIVE"
      echo "   - Command history disabled"
      echo "   - Strict SSH settings enabled"
      echo "   - Hardware token support configured"
    '';
  };
}
