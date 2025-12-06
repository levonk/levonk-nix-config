{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Container tools
    docker
    docker-compose
    podman

    # LazyDocker
    lazydocker
  ];

  # TODO: Add specific docker configuration/services if needed
}
