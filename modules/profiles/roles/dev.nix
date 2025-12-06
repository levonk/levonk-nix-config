{ pkgs, ... }: {
  imports = [
    ../../components/dev/docker.nix
    ../../components/dev/python.nix
    ../../components/dev/node.nix
    ../../components/dev/rust.nix
    ../../components/dev/go.nix
    ../../components/dev/cloud.nix
    ../../components/dev/ai.nix
    ../../components/tools/terminal.nix
  ];

  # Additional dev-specific configuration
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
