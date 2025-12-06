# Nix Configuration Architecture

This repository uses a layered architecture to manage configuration across different operating systems and use cases. The configuration is composed of **Modules**, **Profiles**, and **Hosts**.

## Directory Structure

### `hosts/` (The Composition Layer)
This is the entry point for each machine. A "Host" file defines a specific machine by importing the necessary **OS Profile** and **Role Profiles**.
- **Example**: `hosts/wsl-dev/default.nix` imports `profiles/os/win.nix` (Platform) and `profiles/roles/dev.nix` (Function).

### `modules/profiles/` (The Abstraction Layer)
Profiles aggregate lower-level modules into high-level concepts. They are split into two categories:

### `modules/profiles/os/` (The "Where")
Defines the high-level platform selection. This is the "public API" that hosts use.
- **Why distinct from `system/`?**: This layer composes multiple low-level system modules and common components into a single, usable unit. For example, `win.nix` might import `system/wsl` AND `system/linux` AND `components/wsl-tools`.
- **`linux.nix`**: For standard Linux distributions.
- **`mac.nix`**: For macOS systems.
- **`win.nix`**: For WSL environments.
- **`posix.nix`**: A minimal base for any POSIX-compliant system (aliased to common).

#### `modules/profiles/roles/` (The "What")
Defines the capabilities or "job" of the machine. A host can import multiple roles.
- **`cli.nix`**: Essential command-line tools (shell, vim, git). The foundation for everything.
- **`dev.nix`**: Development tools (compilers, docker, languages).
- **`gui.nix`**: Desktop applications (browsers, terminals, fonts).
- **`game.nix`**: Gaming tools (Steam, Lutris).
- **`greyhat.nix`**: Security research and penetration testing tools.

### `modules/system/` (The Implementation Layer - "How")
Contains the low-level, OS-specific implementation details.
- **Why distinct from `profiles/os/`?**: These modules handle the dirty details (systemd services, XDG hacks, registry keys, launchd agents). They are "private implementation" details that you rarely import directly.
- **`linux/`**: Linux-specific settings (XDG, systemd).
- **`darwin/`**: macOS-specific settings (Homebrew, system defaults).
- **`wsl/`**: WSL-specific settings (interop, `wslu`).

### `modules/components/` (The Component Layer)
Contains the granular configuration files ("Lego bricks") that were previously at the root of `modules/`.
- **`cli/`**: Core utilities (core.nix, git.nix).
- **`editors/`**: Editor configs (vim.nix).
- **`shells/`**: Shell configs (zsh.nix).
- **`tools/`**: Specific tools (direnv.nix, docker.nix).
- **`common/`**: Aggregations of common components.

## Dependency Graph

```mermaid
graph TD
    Host[Host (e.g., wsl-dev)] --> OSProfile[OS Profile (e.g., win.nix)]
    Host --> RoleProfile[Role Profile (e.g., dev.nix)]

    OSProfile --> SystemModule[System Module (e.g., system/wsl)]
    OSProfile --> CommonComponent[Common Component]

    RoleProfile --> Component[Component (e.g. components/editors/vim.nix)]
    RoleProfile --> Component2[Component (e.g. components/tools/docker.nix)]
```
