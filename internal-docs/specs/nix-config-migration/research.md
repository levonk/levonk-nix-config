# Nix Configuration Research

**Feature**: nix-config-migration
**Date**: 2025-11-29

## 1. Nix-Darwin Integration
**Decision**: Use `nix-darwin` with `home-manager` as a module.
**Rationale**: Provides the tightest integration with macOS system settings (defaults write) while keeping user package management consistent with Linux platforms via Home Manager.
**Reference**: [nix-darwin repository](https://github.com/LnL7/nix-darwin)

## 2. Secrets Management
**Decision**: Use Chezmoi for secrets, Nix for structure.
**Rationale**: Keeping Nix stores public/world-readable is safer. Chezmoi handles runtime injection of secrets from 1Password/Bitwarden into config files.
**Alternatives Considered**:
*   `sops-nix`: Good for NixOS, but adds complexity for non-NixOS (WSL/Mac) and requires encrypting secrets in the repo.
*   `git-crypt`: Brittle binary diffs.

## 3. CI/CD Strategy
**Decision**: GitHub Actions with `cachix/install-nix-action` and `magic-nix-cache` (or similar).
**Rationale**: Standard, free, and effective for checking build validity.
**Inputs**: Flake inputs will be public (per user decision), simplifying the CI auth story.

## 4. Directory Structure
**Decision**: Categorized Folders (`modules/<category>/<tool>.nix`).
**Rationale**: User requested "subdirectories" to avoid root pollution but "flat-ish" structure. Categories (cli, gui, languages) provide a good balance.

## 5. Qubes OS Strategy
**Decision**: Treat Qubes AppVMs as generic "Linux" targets (`home-manager` standalone).
**Rationale**: Dom0 manages the kernel/isolation. We just need the user environment inside the VM.

## 6. Language Runtimes (Mise)
**Decision**: Use **Mise** (installed via Nix) for language versions (Node, Python, Go).
**Rationale**: Separation of concerns. Nix handles the "Base OS" and "Utility Tools". Mise handles "Project Runtimes". This avoids Nix cache misses when switching Node versions and aligns with existing `.tool-versions` usage.
