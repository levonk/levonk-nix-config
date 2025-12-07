# Cloud Development Tools (aggregator)
# Ported from: levonk.vibeops.dev-cloud, levonk.vibeops.devops
{ pkgs, lib, ... }: {
  imports = [
    ./cloud-aws.nix
    ./cloud-gcloud.nix
    ./cloud-azure.nix
    ./kubernetes-core.nix
  ];

  # Shared tools across cloud providers
  home.packages = with pkgs; [
    # Infrastructure as Code
    opentofu  # Terraform-compatible IaC engine
    terragrunt # DRY wrapper and orchestration for Terraform/Tofu
    pulumi    # IaC using general-purpose languages

    # Other cloud tools
    flyctl   # Fly.io CLI for deploying applications
  ];
}
