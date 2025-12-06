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
    slack
    discord
    signal-desktop
    telegram-desktop

    # Video conferencing
    zoom-us
  ] ++ lib.optionals isLinux [
    # Linux-specific
    element-desktop  # Matrix client
  ];
}
