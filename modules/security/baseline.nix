# Security Tier: Baseline
# Core hygiene applied to every host by default.
# - Firewall defaults (where applicable)
# - Auto-updates hints
# - Logging configuration
# - Basic SSH tightening
{ pkgs, lib, ... }: {
  # SSH Client Hardening (Home Manager manages ~/.ssh/config)
  programs.ssh = {
    enable = true;
    # Use strong ciphers and key exchange algorithms
    extraConfig = ''
      # Baseline SSH Hardening
      HashKnownHosts yes
      StrictHostKeyChecking ask
      VisualHostKey yes

      # Prefer modern key exchange and ciphers
      KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
      Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com
      MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com

      # Connection settings
      ServerAliveInterval 60
      ServerAliveCountMax 3
      AddKeysToAgent yes
    '';
  };

  # GPG Agent for signing commits
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = false; # SSH keys managed separately
    defaultCacheTtl = 3600;
    maxCacheTtl = 7200;
  };

  # Environment variables for security awareness
  home.sessionVariables = {
    # Disable history for sensitive commands
    HISTIGNORE = "*password*:*secret*:*token*:*key*";
  };

  # Security-focused packages
  home.packages = with pkgs; [
    # Password/Secret management CLI
    pass
    gopass

    # File integrity
    rhash

    # Network diagnostics (non-invasive)
    mtr
    whois
  ];
}
