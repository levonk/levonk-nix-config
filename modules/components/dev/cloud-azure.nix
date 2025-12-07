# Azure Cloud Development Tools
{ pkgs, ... }: {
  home.packages = with pkgs; [
    azure-cli  # Azure CLI for managing Azure resources
  ];
}
