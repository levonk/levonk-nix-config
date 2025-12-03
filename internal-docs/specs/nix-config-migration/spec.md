# Specification: Nix+Flake Configuration Migration

**Feature**: Recreate Personal Environment with Nix+Flakes
**Status**: Draft
**Owner**: User (Levonk)
**Created**: 2025-11-29

## 1. Overview

This project aims to migrate the user's personal environment configuration from an Ansible-based setup (`levonk-ansible-galaxy`) to a declarative **Nix + Flakes** architecture. This new configuration will reside in the `levonk-nix-config` repository and will manage software installation and system configuration across four distinct computing environments.

**Key architectural decisions:**
*   **Nix Flakes** as the source of truth for dependencies and inputs.
*   **Home Manager** for managing user-space packages and dotfile generation (where dynamic generation is preferred over static files).
*   **Nix-Darwin** for macOS system configuration.
*   **Chezmoi** remains the tool of choice for managing complex, secret-laden, or template-heavy dotfiles (`.zshrc`, `.ssh/config`, etc.). Nix will ensure Chezmoi is installed, but Chezmoi will handle the actual file placement for those specific configs.

## 2. User Scenarios

### 2.1. Bootstrap Dev Debian (WSL2)
**Actor**: Developer (User)
**Trigger**: Provisioning a new WSL2 instance or migrating an existing one.
**Action**: User clones the repo and runs the bootstrap command targeting the `wsl-dev` flake output.
**Outcome**:
*   Nix package manager is installed (if not present).
*   Core development tools (git, node, python, etc.) are installed via Home Manager.
*   WSL-specific utilities (wsl-open, integration tools) are configured.
*   GUI applications are **excluded** to keep the image light.

### 2.2. Maintain GUI Dev Mac
**Actor**: Developer (User)
**Trigger**: Routine system update or configuration change.
**Action**: User runs either `darwin-rebuild switch --flake .#mac-aarch64` (Apple Silicon) or `.#mac-x86_64` (Intel) depending on hardware.
**Outcome**:
*   macOS system settings (dock, finder defaults) are applied via Nix-Darwin.
*   Homebrew bundle integration installs Mac-specific apps (if configured).
*   Development tools and GUI applications (VS Code, Terminal) are installed/updated.

### 2.3. Provision Remote Access Debian
**Actor**: Sysadmin (User)
**Trigger**: Setting up a generic remote server (VPS or physical).
**Action**: User runs `home-manager switch --flake .#debian-remote`.
**Outcome**:
*   Minimal set of administration tools (htop, curl, git, vim) are installed.
*   No development language stacks (Node/Rust/Go) are installed to reduce attack surface and size.
*   No GUI applications.

### 2.4. Maintain GUI Dev Debian
**Actor**: Developer (User)
**Trigger**: Routine system update on a Linux workstation.
**Action**: User runs `home-manager switch --flake .#debian-gui`.
**Outcome**:
*   Full development suite installed.
*   Linux-native GUI applications (VS Code, browsers, terminal emulators) are installed.
*   Desktop environment tweaks (fonts, themes) are applied.

### 2.5. Provision Qubes AppVM
**Actor**: Qubes User
**Trigger**: Creating a new AppVM for development.
**Action**: User runs `home-manager switch --flake .#qubes-dev` (inside the AppVM or Template).
**Outcome**:
*   Development tools installed.
*   Integration with `qvm-*` tools where relevant (though usually pre-installed).
*   Config optimized for ephemeral/compartmentalized usage.

## 3. Functional Requirements

### 3.1. Repository Structure
*   **Root Cleanliness**: The repository root MUST be kept clean. Configuration logic should reside in subdirectories (e.g., `hosts/`, `modules/`, `lib/`). Only essential files (`flake.nix`, `flake.lock`, `README.md`) should be in the root.
*   **Modularity**: Configuration MUST be broken down into reusable modules (e.g., `modules/dev/python.nix`, `modules/cli/core.nix`) rather than monolithic host files.

### 3.2. Host Configurations
The Flake MUST export configurations for the following four profiles:
1.  **`wsl-dev`**: Linux/x86_64. Focus: Performance, CLI dev tools, Docker integration.
2.  **`mac-aarch64`**: Darwin/aarch64 (Apple Silicon). Focus: macOS integration, GUI apps, Dev tools.
3.  **`mac-x86_64`**: Darwin/x86_64 (Intel). Focus: macOS integration, GUI apps, Dev tools.
3.  **`debian-remote`**: Linux/x86_64. Focus: Minimalism, Admin tools, Stability.
4.  **`debian-gui`**: Linux/x86_64. Focus: Full Desktop experience, Dev tools.
5.  **`qubes-dev`**: Linux/x86_64 (Fedora/Debian based). Focus: Qubes integration, compartmentalized workflows.

### 3.3. Software Parity
The Nix configuration MUST provide a full migration of the existing toolset defined in `levonk-ansible-galaxy`. This includes:
*   **Core Toolset**: Shell (Zsh), Editors (Vim/Neovim, VS Code (where applicable)).
*   **Languages**: **Mise** MUST be the primary tool for managing language runtimes (Python, Node.js, Go, Rust). Nix will install Mise; Mise will manage the specific versions via `.tool-versions` or `mise.toml`.
*   **Utilities**: git, curl, wget, jq, ripgrep, bat, fzf, eza.
*   **Extended Toolset**: All other roles/tools currently managed by Ansible MUST be audited and ported to their Nix equivalent (e.g., Docker, Kubernetes tools, cloud CLIs, specific dev libraries).
*   **Audit Log**: A migration audit log MUST be maintained to track which Ansible roles have been ported to Nix modules.

### 3.4. Integration with Chezmoi
*   Nix MUST install `chezmoi`.
*   Nix SHOULD NOT overwrite files managed by Chezmoi (e.g., `~/.zshrc` should be sourced or symlinked, not fully generated, unless transitioning logic to Nix).
*   **Strategy**: Nix provides the binary `chezmoi`; User runs `chezmoi apply` manually or via a hook.

### 3.5. Security & Hardening
*   **Flexible Hardening Levels**: The configuration MUST support toggleable security profiles (e.g., `standard`, `hardened`).
*   **Scope**: Hardening modules will manage SSH configurations, firewall rules (where applicable via NixOS/Darwin), and package restrictions.
*   **Qubes Compatibility**: Hardening profiles must recognize Qubes-specific constraints (e.g., no direct hardware access, specialized networking).

### 3.6. Testing & Validation
*   The Flake MUST include a `checks` output to validate configuration syntax and basic compilability.
*   **CI Requirement**: A GitHub Actions workflow MUST be configured to:
    *   Lint Nix files.
    *   Build all 5 host configurations (dry-run) to ensure dependency resolution.
    *   Cache Nix store paths to speed up subsequent builds.

## 4. Success Criteria

*   **Build Success**: All 5 host configurations build successfully without errors.
*   **Tool Availability**: Key tools (verified via `which git`, `which node`, etc.) are available in the user path after activation.
*   **Idempotency**: Running the switch command multiple times results in no changes or safe no-ops.
*   **Clean Root**: Repository root contains fewer than 5 files/directories (excluding `.git`).

## 5. Assumptions & Constraints

*   **Nix Installed**: The target system is assumed to have Nix installed (multi-user or single-user).
*   **Internet Access**: Build process requires access to `cache.nixos.org` and GitHub.
*   **Secrets**: Secrets are managed by Chezmoi/1Password, NOT Nix. Nix stores are world-readable; no secrets in Nix files.

## 7. Clarifications

### Session 2025-11-29
- Q: How comprehensive should the initial migration be? → A: **Full Parity Audit** (Audit the entire Ansible repo and port every single tool/role).
- Q: How should private repos be accessed? → A: **Public Inputs** (All flake inputs assumed public).
- Q: Should CI be implemented immediately? → A: **Include in Scope** (Setup GitHub Actions now).

## 6. Open Questions / Needs Clarification

*   **Resolved**: Q1 - Using `nix-darwin` for macOS management.
*   **Resolved**: Q2 - Using Categorized Folders (`modules/category/tool.nix`) for organization.
