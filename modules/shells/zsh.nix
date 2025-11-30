{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Oh-My-Zsh plugin management via Nix is safer/faster than git cloning at runtime
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "sudo" ];
      theme = "robbyrussell"; # Fallback theme, Chezmoi likely overrides this via .zshrc
    };
  };
}
