# Levonk's Nix Configuration

## Overview
This repository manages the system configuration and user environments for my personal infrastructure using **Nix Flakes**. It replaces the legacy Ansible-based setup (`levonk-ansible-galaxy`).

### Architectures
*   **Nix Flakes**: Declarative dependency management and inputs.
*   **Home Manager**: Manages user-space tools, dotfiles, and CLI environment.
*   **Nix-Darwin**: Manages macOS system settings and Homebrew integration.
*   **Mise**: Manages language runtimes (Node, Python, Go, Rust) on a per-project basis.
*   **Chezmoi**: Manages secrets and complex dotfiles (`.zshrc`, `.ssh/config`).

## Supported Hosts

| Host | OS | Description |
| :--- | :--- | :--- |
| `wsl-dev` | Linux (WSL2) | Primary development environment on Windows. |
| `mac-aarch64` | macOS (Apple Silicon) | GUI development machine (VS Code, Browsers). |
| `mac-x86_64` | macOS (Intel) | GUI development machine (VS Code, Browsers). |
| `debian-remote` | Linux (Debian) | Minimal remote server config (Headless). |
| `debian-gui` | Linux (Debian) | Native Linux desktop environment. |
| `qubes-dev` | Linux (Fedora/Debian) | Qubes AppVM ephemeral environment. |

## Quick Start

### 1. Prerequisites
*   **Nix**: Ensure Nix is installed (multi-user mode recommended).
    ```bash
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    ```
*   **Experimental Features**: Enable flakes.
    ```bash
    mkdir -p ~/.config/nix
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
    ```

### 2. Apply Configuration

#### Linux / WSL
To apply the Home Manager configuration for the current user:

```bash
# For WSL
nix run home-manager/master -- switch --flake .#wsl-dev

# For Remote Server
nix run home-manager/master -- switch --flake .#debian-remote
```

#### macOS
To apply the Darwin system configuration:

```bash
# Apple Silicon
nix run nix-darwin -- switch --flake .#mac-aarch64

# Intel
nix run nix-darwin -- switch --flake .#mac-x86_64
```

## Development Guidelines

### Directory Structure
*   `flake.nix`: Entry point.
*   `hosts/`: Host-specific configurations.
*   `modules/`: Reusable modules grouped by category.
    *   `cli/`: CLI tools (git, ripgrep).
    *   `editors/`: Editor configs (vim, vscode).
    *   `languages/`: Runtime managers (Mise).
    *   `shells/`: Shell configs (zsh).
    *   `system/`: System integrations (chezmoi).
*   `pkgs/`: Custom packages not in nixpkgs.

### Adding a New Tool
1.  **System Tool** (e.g., `jq`, `ripgrep`): Add to `modules/cli/core.nix`.
2.  **Language Runtime** (e.g., Node 20): **DO NOT** add to Nix. Use `mise use node@20` in your project folder.
3.  **GUI App** (Mac): Add to `casks` in `hosts/mac-aarch64/aarch64.nix` and mirror any Intel-only casks within `hosts/mac-x86_64/x86_64.nix`.

### Secrets Management
Secrets are NOT stored in this repo.
1.  Nix installs `chezmoi` and `1password-cli`.
2.  Run `chezmoi apply` manually after the initial Nix bootstrap to inject secrets.

## CI/CD
GitHub Actions validates the flake on every push:
*   Checks flake syntax (`nix flake check`).
*   Dry-runs the build for all 5 host profiles.
