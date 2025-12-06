# Knowledge Management Tools
# Ported from: levonk.vibeops.knowledge
{ pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.packages = with pkgs; [
    # Note-taking
    obsidian

    # Documentation
    pandoc
    mdbook

    # Diagramming
    graphviz
    mermaid-cli
    plantuml
  ];
}
