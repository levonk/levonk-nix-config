# Security Module Entry Point
# Provides a `security.profile` option to select the security tier.
#
# Usage in host configuration:
#   imports = [ ../../modules/security ];
#   security.profile = "baseline"; # or "hardened" or "locked"
#
# Tier Descriptions:
#   - baseline: Core hygiene for all hosts (default)
#   - hardened: Stricter policies for servers and Qubes
#   - locked:   Maximum restrictions for high-threat environments
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security;
in
{
  options.security = {
    profile = mkOption {
      type = types.enum [ "baseline" "hardened" "locked" ];
      default = "baseline";
      description = ''
        Security profile tier to apply.

        - baseline: Core hygiene (SSH hardening, GPG, basic tools)
        - hardened: Stricter policies (service minimization, audit tools)
        - locked:   Maximum restrictions (hardware tokens, no history)
      '';
    };
  };

  config = mkMerge [
    # Always import baseline
    (mkIf (cfg.profile == "baseline") {
      imports = [ ./baseline.nix ];
    })

    # Hardened includes baseline
    (mkIf (cfg.profile == "hardened") {
      imports = [ ./hardened.nix ];
    })

    # Locked includes hardened (which includes baseline)
    (mkIf (cfg.profile == "locked") {
      imports = [ ./locked.nix ];
    })
  ];
}
