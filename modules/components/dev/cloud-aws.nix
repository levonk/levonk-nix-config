# AWS Cloud Development Tools
{ pkgs, ... }: {
  home.packages = with pkgs; [
    awscli2                   # AWS CLI v2 for managing AWS services
    aws-vault                 # Securely store and access AWS credentials
    ssm-session-manager-plugin # AWS SSM Session Manager local plugin
  ];
}
