# Communication Tools
# Ported from: levonk.vibeops.comms
{ pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.packages = with pkgs; [
    # Chat/Messaging
    # (macOS versions managed by Homebrew for better integration)
  ] ++ lib.optionals isLinux [
    slack            # Slack desktop client
    discord          # Discord chat client
    signal-desktop   # Signal encrypted messenger
    telegram-desktop # Telegram desktop client

    # Video conferencing
    zoom-us          # Zoom video conferencing client

    # Linux-specific
    element-desktop  # Matrix client for federated chat
  ];
}
