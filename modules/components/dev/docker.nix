# Docker and Container Tools
# Ported from: levonk.vibeops.dev-docker
{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # Docker CLI and Compose
    docker
    docker-compose

    # Container management
    podman
    buildah
    skopeo

    # Container UX
    lazydocker
    dive  # Explore Docker image layers

    # Container security
    trivy  # Vulnerability scanner
  ];

  # Docker CLI configuration
  home.file.".docker/config.json".text = builtins.toJSON {
    # Enable BuildKit by default
    features.buildkit = true;
  };
}
