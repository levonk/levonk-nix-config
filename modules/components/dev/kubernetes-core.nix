# Kubernetes Core Tools
{ pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl        # Kubernetes CLI
    kubectx        # Switch between kubectl contexts and namespaces
    k9s            # Terminal UI for managing Kubernetes clusters
    helm           # Kubernetes package manager
    kustomize      # Kubernetes manifest customization tool
    stern          # Multi-pod log tailing for Kubernetes
  ];
}
