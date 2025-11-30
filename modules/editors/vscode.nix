{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    # Extensions are tricky to manage declaratively because they update frequently.
    # We can either list them here or let VS Code sync handle them.
    # For now, we enable VS Code installation.
  };
}
