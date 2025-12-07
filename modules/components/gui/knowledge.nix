# Knowledge Management Tools
# Ported from: levonk.vibeops.knowledge
{ pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.packages = with pkgs; [
    # Note-taking
    obsidian   # Markdown-based note-taking app

    # Documentation
    pandoc     # Document converter (Markdown <-> many formats)
    mdbook     # Create books and docs from Markdown

    # Diagramming
    graphviz   # Graph visualization tools
    mermaid-cli # Generate diagrams from Mermaid syntax
    plantuml   # UML diagram generator
  ];
}
