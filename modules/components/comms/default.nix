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
    slack            # Slack desktop client
    discord          # Discord chat client
    signal-desktop   # Signal encrypted messenger
    telegram-desktop # Telegram desktop client

    # Video conferencing
    zoom-us          # Zoom video conferencing client
  ] ++ lib.optionals isLinux [
    # Linux-specific
    element-desktop  # Matrix client for federated chat
  ];
}
