# Docker and Container Tools
# Ported from: levonk.vibeops.dev-docker
{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # Docker CLI and Compose
    docker          # Docker CLI client
    docker-compose  # Docker Compose for multi-container apps

    # Container management
    podman          # Daemonless container engine
    buildah         # Build container images
    skopeo          # Inspect/copy container images

    # Container UX
    lazydocker      # TUI for managing Docker/Podman
    dive            # Explore Docker image layers and image size

    # Container security
    trivy           # Container image vulnerability scanner
  ];

  # Docker CLI configuration
  home.file.".docker/config.json".text = builtins.toJSON {
    # Enable BuildKit by default
    features.buildkit = true;
  };
}
