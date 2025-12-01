import os
import yaml
import glob

ANSIBLE_ROOT = "/home/micro/p/gh/levonk/levonk-ansible-galaxy/ansible-galaxy/collections/ansible_collections"
OUTPUT_FILE = "/home/micro/p/gh/levonk/levonk-nix-config/internal-docs/specs/nix-config-migration/audit-log.md"

def find_roles():
    # Correct glob: namespace/collection/roles/role_name
    roles = glob.glob(f"{ANSIBLE_ROOT}/*/*/roles/*")
    return sorted(roles)

def parse_tasks(role_path):
    # Recursive glob to find all YAML files in tasks/ and subdirectories
    tasks_files = glob.glob(f"{role_path}/tasks/**/*.yml", recursive=True) + \
                  glob.glob(f"{role_path}/tasks/**/*.yaml", recursive=True)
    installs = []
    configs = []

    for task_file in tasks_files:
        try:
            with open(task_file, 'r') as f:
                content = f.read()
                # Detect standard modules AND the custom wrapper
                if any(x in content for x in ['package:', 'apt:', 'dnf:', 'homebrew:', 'levonk.common.package']):
                    installs.append(os.path.basename(task_file))
                if any(x in content for x in ['template:', 'copy:', 'lineinfile:', 'file:']):
                    configs.append(os.path.basename(task_file))
        except Exception as e:
            print(f"Error reading {task_file}: {e}")

    return installs, configs

def generate_markdown(roles):
    with open(OUTPUT_FILE, 'w') as f:
        f.write("# Audit Log: Ansible to Nix Migration\n\n")
        f.write("**Status**: In Progress\n")
        f.write("**Source**: `levonk-ansible-galaxy`\n")
        f.write("**Target**: `levonk-nix-config`\n\n")

        f.write("## Core Toolset (Phase 2) - [See Plan](plan.md)\n\n")

        f.write("## Extended Toolset (Phase 4)\n\n")
        f.write("| Role | Installs (Tasks) | Configs (Tasks) | Nix Module | Status | Notes |\n")
        f.write("| :--- | :--- | :--- | :--- | :--- | :--- |\n")

        # Hardcode Xcode requirement as requested
        f.write("| `system/xcode` | `manual` | - | `hosts/mac-gui` | Pending | **Critical**: Ensure Xcode Command Line Tools |\n")

        for role in roles:
            role_name = role.split('/')[-1]
            namespace = role.split('/')[-4]
            collection = role.split('/')[-3]
            full_name = f"{namespace}.{collection}.{role_name}"

            installs, configs = parse_tasks(role)

            install_str = ", ".join(installs) if installs else "-"
            config_str = ", ".join(configs) if configs else "-"

            f.write(f"| `{full_name}` | `{install_str}` | `{config_str}` | `modules/...` | Pending | |\n")

if __name__ == "__main__":
    roles = find_roles()
    generate_markdown(roles)
    print(f"Generated audit log with {len(roles)} roles.")
