{ pkgs, ... }: {
  home.packages = with pkgs; [
    mise
  ];

  # Hook Mise into shell
  programs.zsh.initExtra = ''
    eval "$(${pkgs.mise}/bin/mise activate zsh)"
  '';

  programs.bash.initExtra = ''
    eval "$(${pkgs.mise}/bin/mise activate bash)"
  '';
}
