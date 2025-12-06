# AI-Assisted Development Tools
# Ported from: levonk.vibeops.dev_ai_assisted
{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # Local LLM
    ollama

    # CLI tools
    llm  # Simon Willison's LLM CLI

    # Code assistance (IDE plugins managed separately)
  ];

  # Ollama configuration
  home.sessionVariables = {
    OLLAMA_HOST = "127.0.0.1:11434";
  };
}
