# Tasks: nix-config-migration

**Feature**: Recreate Personal Environment with Nix+Flakes
**Status**: Planning
**Spec**: [spec.md](./spec.md)
**Plan**: [plan.md](./plan.md)

## Implementation Strategy
We will follow a layered approach:
1.  **Scaffolding**: Repo structure and CI.
2.  **Foundational**: Core modules (CLI, Editors, Shells) and Capability Profiles (CLI, GUI, Dev).
3.  **User Stories**: Implement specific host configurations (WSL, Mac, Debian, Qubes) consuming the core profiles.
4.  **Refinement**: Security hardening and full audit/porting of the legacy Ansible stack.

## Dependencies
- Phase 1 (Setup) -> Phase 2 (Foundational)
- Phase 2 (Foundational) -> All User Story Phases (3-7)
- User Story Phases can be parallelized to some extent, but share common module dependencies.
- Security Hardening (Phase 8) applies to all hosts.

---

## Phase 1: Setup
**Goal**: Initialize repository structure, Flake entry point, and CI pipeline.

- [x] T001 Initialize `flake.nix` with standard template and basic inputs (nixpkgs, home-manager) in `flake.nix`
- [x] T002 Create directory structure (`hosts/`, `modules/`, `lib/`, `pkgs/`)
- [x] T003 Create CI workflow for flake checks and build verification in `.github/workflows/ci.yml`
- [x] T004 Initialize `audit-log.md` to track migration of Ansible roles in `internal-docs/specs/nix-config-migration/audit-log.md`

## Phase 2: Foundational Modules & Profiles
**Goal**: Implement core reusable logic and capability profiles required by all hosts.

### Core Modules
- [x] T005 [P] Create `modules/components/common/default.nix` for universal utils
- [x] T006 [P] Implement `modules/components/cli/core.nix` (git, curl, wget, jq, ripgrep, bat, fzf, eza)
- [x] T007 [P] Implement `modules/components/shells/zsh.nix` with Home Manager and Chezmoi integration hooks
- [x] T008 [P] Implement `modules/components/editors/vim.nix` and `modules/components/editors/vscode.nix`
- [x] T009 [P] Implement `modules/components/tools/direnv.nix` for project-local environments (replaces mise)
- [x] T010 [P] Implement `modules/system/chezmoi.nix` ensuring Chezmoi installation
- [x] T010.1 [P] Configure Artifact Caching (Harmonia + NCPS + Public) in `modules/components/nix/cache.nix`
- [x] T010.2 [P] Configure Remote Dev Settings (keep-outputs, keep-derivations) in `modules/components/nix/settings.nix`

### Capability Profiles
- [x] T011 Implement `modules/profiles/roles/cli.nix` (imports core CLI, shell defaults)
- [x] T012 Implement `modules/profiles/roles/gui.nix` (fonts, desktop apps, browsers)
- [x] T013 Implement `modules/profiles/roles/dev.nix` (direnv, container tools)
- [x] T014 Implement `modules/profiles/roles/game.nix` (Steam, GPU tools)
- [x] T015 Implement `modules/profiles/roles/greyhat.nix` (offensive tooling)
- [x] T015.1 Refactor architecture: Separate `profiles/os`, `profiles/roles`, and move components to `modules/components/`

## Phase 3: US1 - Bootstrap Dev Debian (WSL2)
**Goal**: Provision a development environment on WSL2 (CLI + Dev, No GUI).

- [x] T016 [US1] Create `hosts/wsl-dev/default.nix` importing `cli` and `dev` profiles
- [x] T017 [US1] Configure WSL-specific utilities (wsl-open) in `hosts/wsl-dev/default.nix` or a module
- [x] T018 [US1] Register `wsl-dev` output in `flake.nix`
- [ ] T019 [US1] Verify build of `wsl-dev` output locally or via CI

## Phase 4: US2 - Maintain GUI Dev Mac
**Goal**: Provision macOS environment with System Settings and GUI apps.

- [x] T020 [US2] Add `nix-darwin` input to `flake.nix`
- [x] T021 [US2] Create `hosts/mac-gui/default.nix` (handling aarch64 and x86_64)
- [x] T022 [US2] Import `cli`, `gui`, `dev` profiles in `hosts/mac-gui/default.nix`
- [x] T023 [US2] Implement `modules/system/darwin/defaults.nix` for macOS system settings
- [x] T024 [US2] Implement `modules/system/darwin/homebrew.nix` for Mac-specific apps
- [x] T025 [US2] Register `mac-aarch64` and `mac-x86_64` outputs in `flake.nix`

## Phase 5: US3 - Provision Remote Access Debian
**Goal**: Provision a minimal remote server environment (CLI only, Admin tools).

- [x] T026 [US3] Create `hosts/debian-remote/default.nix` importing `cli` profile only
- [x] T027 [US3] Ensure no heavy dev stacks are included (verify dependency tree)
- [x] T028 [US3] Register `debian-remote` output in `flake.nix`

## Phase 6: US4 - Maintain GUI Dev Debian
**Goal**: Provision a full Linux Desktop development environment.

- [x] T029 [US4] Create `hosts/debian-gui/default.nix` importing `cli`, `gui`, `dev` profiles
- [x] T030 [US4] Configure Linux-specific desktop settings (fonts, gtk themes) in `hosts/debian-gui/default.nix`
- [x] T031 [US4] Register `debian-gui` output in `flake.nix`

## Phase 7: US5 - Provision Qubes AppVM
**Goal**: Provision a Qubes-compatible development environment.

- [x] T032 [US5] Create `hosts/qubes-dev/default.nix` importing `cli` and `dev` profiles
- [x] T033 [US5] Add Qubes-specific integration (if any) in `hosts/qubes-dev/default.nix`
- [x] T034 [US5] Register `qubes-dev` output in `flake.nix`

## Phase 8: Security Hardening
**Goal**: Implement layered security profiles.

- [ ] T035 Create `modules/security/baseline.nix` (firewall, auto-updates, logging)
- [ ] T036 Create `modules/security/hardened.nix` (USB restrictions, service minimization)
- [ ] T037 Create `modules/security/locked.nix` (hardware tokens, sandbox)
- [ ] T038 Expose `security.profile` option and apply defaults to hosts in `flake.nix` or host modules

## Phase 9: Migration & Polish
**Goal**: Complete the migration from Ansible by auditing and porting remaining roles.

- [ ] T039 Create script to list Ansible roles and update `audit-log.md`
- [ ] T040 Port remaining "Extended Toolset" roles to Nix modules (Batch 1)
- [ ] T041 Port remaining "Extended Toolset" roles to Nix modules (Batch 2)
- [ ] T042 Verify `audit-log.md` is 100% complete
- [ ] T043 Final "Clean Root" verification (ensure no clutter in repo root)
