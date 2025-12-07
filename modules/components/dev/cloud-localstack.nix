{ pkgs, ... }: {
  home.packages = with pkgs; [
    localstack  # Local AWS cloud emulator
  ];
}
