#!/bin/bash
set -euo pipefail

# bootstrap-nix.bash
#
# This script bootstraps the installation of the Nix Package Manager using Ansible.
# It performs the following steps:
# 1. Installs Ansible using the system's package manager.
# 2. Installs the 'geerlingguy.nix' role from Ansible Galaxy.
# 3. runs a temporary Ansible playbook to install Nix.

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 1. Check for existing Nix installation
check_nix_installed() {
    if command -v nix >/dev/null 2>&1; then
        log_info "Nix is already installed."
        if nix-env --version >/dev/null 2>&1; then
            log_success "Nix is installed and working correctly."
            exit 0
        else
            log_error "Nix command exists but appears broken. Attempting to reinstall/repair..."
        fi
    fi
}

# 2. Install Ansible
install_ansible() {
    # Check if Ansible is installed and working
    if command -v ansible-playbook >/dev/null 2>&1 && ansible-playbook --version >/dev/null 2>&1; then
        log_info "Ansible is already installed and working."
        return
    fi

    if command -v ansible-playbook >/dev/null 2>&1; then
        log_error "Ansible command exists but appears broken. Attempting to reinstall/fix via system package manager..."
    fi

    log_info "Installing Ansible..."
    if [ -f /etc/alpine-release ]; then
        # Alpine Linux
        if [ "$EUID" -eq 0 ]; then
             apk add --no-cache ansible git curl
        else
             sudo apk add --no-cache ansible git curl
        fi
    elif [ -f /etc/debian_version ]; then
        # Debian/Ubuntu/Kali/WSL (usually)
        sudo apt-get update
        sudo apt-get install -y ansible curl git
    elif [ -f /etc/redhat-release ]; then
        # RHEL/CentOS/Fedora
        if command -v dnf >/dev/null 2>&1; then
             sudo dnf install -y ansible curl git
        else
             sudo yum install -y ansible curl git
        fi
    elif [ "$(uname)" == "Darwin" ]; then
        # macOS
        if ! command -v brew >/dev/null 2>&1; then
            log_info "Homebrew not found. Checking for other package managers..."
            if command -v port >/dev/null 2>&1; then
                log_info "MacPorts detected. Installing Ansible via MacPorts..."
                sudo port install ansible
            elif command -v pkgin >/dev/null 2>&1; then
                 log_info "pkgsrc (pkgin) detected. Installing Ansible via pkgin..."
                 sudo pkgin install ansible
            else
                log_info "No compatible package manager found. Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

                # Add Homebrew to PATH for the current session
                if [ -f "/opt/homebrew/bin/brew" ]; then
                    eval "$(/opt/homebrew/bin/brew shellenv)"
                elif [ -f "/usr/local/bin/brew" ]; then
                    eval "$(/usr/local/bin/brew shellenv)"
                fi

                brew install ansible
            fi
        else
             brew install ansible
        fi
    else
        log_error "Unsupported operating system. Please install Ansible manually."
        exit 1
    fi

    # Verify installation
    if ! ansible-playbook --version >/dev/null 2>&1; then
        log_error "Ansible installation failed or the broken version is still shadowing the system install."
        log_error "Please remove the broken Ansible (e.g., from ~/.local/bin) or ensure /usr/bin/ansible-playbook is in your PATH."
        exit 1
    fi

    log_success "Ansible installed successfully."
}

# 4. Install Nix Configuration (Optional)
install_nix_config() {
    log_info "Attempting to install Nix configuration from this repository..."

    # Determine repo root (assuming script is in scripts/ subdir)
    local SCRIPT_DIR
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local REPO_ROOT
    REPO_ROOT="$(dirname "$SCRIPT_DIR")"

    if [ ! -f "$REPO_ROOT/flake.nix" ]; then
        log_error "Could not find flake.nix in $REPO_ROOT. Skipping configuration install."
        return
    fi

    # Check if we need to source nix profile
    if ! command -v nix >/dev/null 2>&1; then
        if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
            . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
        elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
            . "$HOME/.nix-profile/etc/profile.d/nix.sh"
        fi
    fi

    if ! command -v nix >/dev/null 2>&1; then
        log_error "Nix command not found even after installation. You may need to restart your shell."
        return
    fi

    log_info "Applying Nix configuration (Home Manager switch)..."
    # Attempt to use home-manager if available, or run via nix run
    # Adjust this command based on your specific entry point (e.g., home-manager switch --flake .)
    # Assuming 'nix run home-manager/master -- switch --flake .' or similar generic bootstrap

    # For now, we'll try a generic flake switch if a 'default' app or overlay isn't obvious,
    # but usually it's `home-manager switch --flake .`
    # If home-manager isn't in path, run it from nixpkgs/unstable or the flake input

    if nix run home-manager -- switch --flake "$REPO_ROOT" --impure; then
         log_success "Nix configuration installed successfully!"
    else
         log_error "Failed to apply Nix configuration."
         log_info "You can try manually running: nix run home-manager -- switch --flake $REPO_ROOT"
    fi
}

# 3. Run the bootstrap
main() {
    local SKIP_CONFIG_INSTALL=false
    local REPO_URL="https://github.com/levonk/levonk-nix-config.git"
    local CLONE_DIR="$HOME/p/gh/levonk/levonk-nix-config"

    for arg in "$@"; do
        case $arg in
            --help|-h)
                echo "Usage: $0 [options]"
                echo "Bootstraps Nix installation using Ansible."
                echo ""
                echo "Direct usage (clone & run):"
                echo "  curl -fsSL https://raw.githubusercontent.com/levonk/levonk-nix-config/main/scripts/bootstrap-nix.bash | bash"
                echo ""
                echo "Options:"
                echo "  --no-install-config   Skip installing/applying the Nix configuration from this repo after bootstrap."
                echo "  --help, -h            Show this help message."
                exit 0
                ;;
            --no-install-config)
                SKIP_CONFIG_INSTALL=true
                ;;
        esac
    done

    # Self-bootstrap logic for curl | bash
    # If this script is running from a pipe or not inside the repo, we need to clone it first.
    # We verify 'inside repo' by checking for flake.nix in a relative path.

    local SCRIPT_DIR
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local EXPECTED_REPO_ROOT
    EXPECTED_REPO_ROOT="$(dirname "$SCRIPT_DIR")"

    if [ ! -f "$EXPECTED_REPO_ROOT/flake.nix" ]; then
        log_info "Running in standalone mode (e.g. curl | bash)."
        log_info "Cloning levonk-nix-config to $CLONE_DIR..."

        if [ -d "$CLONE_DIR" ]; then
            log_info "Directory $CLONE_DIR already exists. Updating..."
            git -C "$CLONE_DIR" pull
        else
            if ! command -v git >/dev/null 2>&1; then
                 # Git might not be installed yet, but install_ansible handles git installation for most OSs.
                 # However, we need git *now* to clone.
                 # We'll rely on install_ansible to install git first, then clone.
                 log_info "Git not found. Will attempt to install dependencies first."
                 install_ansible
            fi
             git clone "$REPO_URL" "$CLONE_DIR"
        fi

        # Re-exec the script from the cloned repo to ensure we have all local assets if needed
        # and to set the correct context for install_nix_config
        log_info "Transferring control to the cloned repository script..."
        exec "$CLONE_DIR/scripts/bootstrap-nix.bash" "$@"
    fi

    check_nix_installed
    install_ansible

    # Create a temporary directory for the playbook
    # Initialize variable to avoid unbound variable error if mktemp fails or hasn't run yet
    TEMP_DIR=""
    TEMP_DIR=$(mktemp -d)

    cleanup() {
        if [[ -n "${TEMP_DIR:-}" && -d "$TEMP_DIR" ]]; then
            rm -rf "$TEMP_DIR"
        fi
    }
    trap cleanup EXIT

    log_info "Setting up temporary Ansible workspace in $TEMP_DIR"

    # Install the Nix role from Ansible Galaxy
    log_info "Installing 'geerlingguy.nix' role from Ansible Galaxy..."
    ansible-galaxy install geerlingguy.nix -p "$TEMP_DIR/roles"

    # Create the playbook
    cat <<EOF > "$TEMP_DIR/install_nix.yml"
---
- name: Install Nix
  hosts: localhost
  connection: local
  become: true
  vars:
    nix_install_args: "--daemon"
  roles:
    - role: geerlingguy.nix
EOF

    # Run the playbook
    log_info "Running Ansible playbook to install Nix..."
    # We use --ask-become-pass to ensure sudo access if needed, though on some systems
    # if sudo is already cached or passwordless, it might not be needed.
    # However, 'become: true' in the playbook implies we need privilege escalation.
    # If the script is run with sudo, we don't need --ask-become-pass.

    if [ "$EUID" -eq 0 ]; then
        ansible-playbook "$TEMP_DIR/install_nix.yml"
    else
        # Check if user has passwordless sudo
        if sudo -n true 2>/dev/null; then
             ansible-playbook "$TEMP_DIR/install_nix.yml"
        else
             ansible-playbook "$TEMP_DIR/install_nix.yml" --ask-become-pass
        fi
    fi

    log_success "Nix installation complete!"
    log_info "You may need to restart your shell or run 'source /etc/profile.d/nix.sh' (or similar) to use Nix."

    if [ "$SKIP_CONFIG_INSTALL" = false ]; then
        install_nix_config
    else
        log_info "Skipping Nix configuration install as requested."
    fi
}

main "$@"
