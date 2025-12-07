# Google Cloud Development Tools
{ pkgs, ... }: {
  home.packages = with pkgs; [
    google-cloud-sdk  # Google Cloud SDK (gcloud, gsutil, bq)
  ];
}
