# Implementation Plan - nix-config-migration

**Feature**: Recreate Personal Environment with Nix+Flakes
**Spec**: [internal-docs/specs/nix-config-migration/spec.md](./spec.md)
**Status**: Draft

## 1. Technical Context

**Architecture Pattern**: Declarative System Configuration (Nix Flakes)
**Key Technologies**:
*   **Nix Flakes**: Dependency management and reproducible inputs.
*   **Home Manager**: User environment (dotfiles, packages).
*   **Nix-Darwin**: macOS system configuration.
*   **Chezmoi**: Secret management and complex dotfiles.
*   **GitHub Actions**: CI for build verification.

**Constraints**:
*   Must support 5 distinct profiles (wsl-dev, mac-gui, debian-remote, debian-gui, qubes-dev).
*   Must replicate extensive Ansible toolset (Audit required).
*   Must integrate with Chezmoi without conflict.
*   Repo root must remain clean (subdirectories only).

## 2. Constitution Check

**Compliance**:
*   **Reproducibility**: High (Nix guarantees this).
*   **Security**: High (Secrets managed by Chezmoi/1Password, not world-readable Nix store).
*   **Cleanliness**: High (Strict subdirectory rule).

**Gates**:
*   [ ] Security Review: Secrets strategy (Chezmoi) approved.
*   [ ] Architecture Review: Flake output structure approved.
*   [ ] CI/CD: Build workflow defined.

## 3. Phasing Strategy

### Phase 1: Scaffolding & Base Logic
**Goal**: Establish the repository structure, `flake.nix` entry point, and CI pipeline.
**Deliverables**:
*   Clean repo structure (`hosts/`, `modules/`, `lib/`).
*   Working `flake.nix` with 5 placeholder outputs.
*   GitHub Actions workflow that builds (and fails/passes) these outputs.
*   `audit-log.md` initialized.

### Phase 2: Core Modules Implementation
**Goal**: Implement the "Core Toolset" defined in Spec 3.3.
**Deliverables**:
*   `modules/cli/core.nix`: git, curl, wget, etc.
*   `modules/shells/zsh.nix`: Home Manager module for Zsh (integrating with Chezmoi).
*   `modules/editors/vim.nix` & `vscode.nix`.
*   **Mise Integration**: `modules/languages/mise.nix`. Installs `mise` and configures shell hooks.
*   **Note**: Global language modules (python.nix, node.nix) are **NOT** created; Mise handles this.
*   Profiles updated to import these modules.

### Phase 3: Host-Specific Logic (OS Integration)
**Goal**: Make the configurations actually work on their target OS.
**Deliverables**:
*   **mac-gui**: `nix-darwin` configuration (system defaults, Homebrew bundle).
*   **qubes-dev**: Qubes-specific module (if any special handling needed for appVMs).
*   **wsl-dev**: WSL config (wsl-open, etc.).

### Phase 4: Extended Audit & Migration
**Goal**: Port the "Long Tail" of Ansible roles.
**Deliverables**:
*   Iterate through `audit-log.md`.
*   Create `modules/docker.nix`, `modules/cloud/aws.nix`, etc.
*   Mark roles as "Ported" in audit log.

### Phase 5: Security Hardening
**Goal**: Implement the "Flexible Hardening Levels".
**Deliverables**:
*   `modules/security/hardening.nix`.
*   SSH hardening, Firewall rules (for Linux/Mac profiles).
*   Toggle mechanism (`security.profile = "hardened"`).

## 4. Detailed Implementation Steps

### 4.1. Scaffolding (Phase 1)
1.  Initialize `flake.nix` using a standard template (e.g., `nix-community/templates`).
2.  Create directory structure: `hosts/`, `modules/`, `lib/`, `pkgs/`.
3.  Create dummy `home.nix` for each profile.
4.  Create `.github/workflows/ci.yml`.

### 4.2. Core Modules (Phase 2)
1.  Create `modules/common/default.nix` to bundle universal tools.
2.  Implement `modules/system/chezmoi.nix` to ensure Chezmoi installation and hook.

### 4.3. Mac Integration (Phase 3)
1.  Add `nix-darwin` input to flake.
2.  Create `hosts/mac-gui/default.nix`.
3.  Port Homebrew list from Ansible to `homebrew.nix`.

### 4.4. Migration Audit (Phase 4)
1.  Script/Tool to list all Ansible roles.
2.  Manual mapping of Role -> Nix Package/Module.
3.  Execute porting batch by batch.

## 5. Verification Plan

*   **Automated**: CI builds must pass for all 5 outputs on every commit.
*   **Manual**:
    *   Boot a fresh WSL2 instance -> Run bootstrap -> Verify tools.
    *   Run `darwin-rebuild switch` on Mac -> Verify settings.
    *   Check `audit-log.md` for completeness.
