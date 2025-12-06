# Browser Collection
# Ported from: levonk.vibeops.browsers
{ pkgs, lib, config, ... }:

let
  # Platform detection
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.packages = with pkgs; [
    # Primary browsers (cross-platform)
    firefox
    chromium

    # Privacy-focused
    librewolf
    tor-browser-bundle-bin
  ] ++ lib.optionals isLinux [
    # Linux-only browsers
    brave
    ungoogled-chromium
  ];

  # Firefox configuration via Home Manager
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        # Privacy settings
        "privacy.trackingprotection.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "browser.send_pings" = false;

        # Security
        "dom.security.https_only_mode" = true;
        "network.cookie.cookieBehavior" = 1;

        # Performance
        "gfx.webrender.all" = true;
      };
    };
  };
}
