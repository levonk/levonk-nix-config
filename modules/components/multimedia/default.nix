# Multimedia Tools
# Ported from: levonk.vibeops.multimedia
{ pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.packages = with pkgs; [
    # Video/Audio processing
    ffmpeg
    yt-dlp

    # Image processing
    imagemagick
    gimp

    # Media players
    vlc
    mpv

    # Audio
    audacity
  ] ++ lib.optionals isLinux [
    # Linux-specific
    obs-studio  # Screen recording/streaming
  ];
}
