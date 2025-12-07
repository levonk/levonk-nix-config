# Multimedia Tools
# Ported from: levonk.vibeops.multimedia
{ pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.packages = with pkgs; [
    # Video/Audio processing
    ffmpeg     # Command-line audio/video toolkit
    yt-dlp     # YouTube / video downloader

    # Image processing
    imagemagick # Image conversion and processing
    gimp        # GNU Image Manipulation Program

    # Media players
    vlc        # VLC media player
    mpv        # mpv media player

    # Audio
    audacity   # Audio editor and recorder
  ] ++ lib.optionals isLinux [
    # Linux-specific
    obs-studio  # Screen recording/streaming studio
  ];
}
