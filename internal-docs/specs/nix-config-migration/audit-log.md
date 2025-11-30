# Audit Log: Ansible to Nix Migration

**Status**: In Progress
**Source**: `levonk-ansible-galaxy`
**Target**: `levonk-nix-config`

## Core Toolset (Phase 2)

| Tool/Role | Nix Module | Status | Notes |
| :--- | :--- | :--- | :--- |
| `shell/zsh` | `modules/shells/zsh.nix` | Pending | Manage config via Chezmoi |
| `editor/vim` | `modules/editors/vim.nix` | Pending | |
| `editor/vscode` | `modules/editors/vscode.nix` | Pending | Extensions managed via Nix? |
| `lang/python` | **Mise** | Pending | Managed via `modules/languages/mise.nix` |
| `lang/node` | **Mise** | Pending | Managed via `modules/languages/mise.nix` |
| `lang/go` | **Mise** | Pending | Managed via `modules/languages/mise.nix` |
| `lang/rust` | **Mise** | Pending | Managed via `modules/languages/mise.nix` |
| `util/git` | `modules/cli/git.nix` | Pending | |
| `util/common` | `modules/cli/core.nix` | Pending | curl, wget, jq, ripgrep, bat, fzf, eza |

## Extended Toolset (Phase 4)

*To be populated by auditing `levonk-ansible-galaxy/ansible-galaxy/collections/ansible_collections/levonk/common/roles`*

| Ansible Role | Nix Equivalent | Status | Notes |
| :--- | :--- | :--- | :--- |
| `...` | `...` | Pending | |
