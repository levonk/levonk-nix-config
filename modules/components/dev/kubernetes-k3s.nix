{ pkgs, ... }: {
  home.packages = with pkgs; [
    k3s  # Lightweight Kubernetes distribution
    k3d  # Run k3s clusters in Docker
  ];
}
