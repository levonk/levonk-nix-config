# Cloud Development Tools
# Ported from: levonk.vibeops.dev-cloud, levonk.vibeops.devops
{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # AWS
    awscli2
    aws-vault
    ssm-session-manager-plugin

    # Google Cloud
    google-cloud-sdk

    # Azure
    azure-cli

    # Kubernetes
    kubectl
    kubectx
    k9s
    helm
    kustomize
    stern  # Multi-pod log tailing

    # Infrastructure as Code
    terraform
    terragrunt
    pulumi

    # Other cloud tools
    flyctl  # Fly.io
  ];
}
