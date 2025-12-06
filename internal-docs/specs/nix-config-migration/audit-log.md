# Audit Log: Ansible to Nix Migration

**Status**: In Progress
**Source**: `levonk-ansible-galaxy`
**Target**: `levonk-nix-config`

## Core Toolset (Phase 2) - [See Plan](plan.md)

## Extended Toolset (Phase 4)

| Role | Installs (Tasks) | Configs (Tasks) | Nix Module | Status | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `system/xcode` | `manual` | - | `hosts/mac-gui` | Pending | **Critical**: Ensure Xcode Command Line Tools |
| `blueprint-namespace.blueprint-collection-role.blueprint-role` | `-` | `-` | `modules/...` | Pending | |
| `blueprint-namespace.blueprint-collection.Makefile` | `-` | `-` | `modules/...` | Pending | |
| `blueprint-namespace.blueprint-collection.blueprint-role` | `-` | `-` | `modules/...` | Pending | |
| `levonk.base_system.base_system` | `shell_setup.yml, base_packages.yml, apt.yml, homebrew.yml, aur.yml, chocolatey.yml, yum.yml, timezone.yml, shellcheck.yml, graphical.yml, locale.yml` | `fonts.yml, shell_setup.yml, symlink_support.yml, app-paths.yml, main.yml, win-temp-env.yml, apt.yml, homebrew.yml, aur.yml, chocolatey.yml, yum.yml, timezone.yml, graphical.yml, locale.yml` | `modules/...` | Pending | |
| `levonk.base_system.reboot_manager` | `-` | `-` | `modules/...` | Pending | |
| `levonk.base_system.syscheck` | `-` | `main.yml` | `modules/...` | Pending | |
| `levonk.base_system.user_setup` | `main.yml` | `-` | `modules/...` | Pending | |
| `levonk.common.checksums` | `main.yml` | `main.yml` | `modules/...` | Pending | |
| `levonk.common.fonts` | `jetbrains-monofont.yml` | `main.yml, jetbrains-monofont.yml` | `modules/...` | Pending | |
| `levonk.common.install_gui_conditionally` | `Debian.yml` | `main.yml` | `modules/...` | Pending | |
| `levonk.common.mise` | `-` | `-` | `modules/...` | Pending | |
| `levonk.common.npm` | `ensure_package_manager.yml` | `-` | `modules/...` | Pending | |
| `levonk.common.open_firewall_port` | `-` | `main.yml` | `modules/...` | Pending | |
| `levonk.common.package` | `install_nix.yml, zypper.yml, dnf.yml, yum.yml, apk.yml, darwin_native.yml, linux_native.yml` | `install_nix.yml, main.yml, darwin_native.yml, linux_native.yml, windows.yml` | `modules/...` | Pending | |
| `levonk.common.pip` | `ensure_package_manager.yml` | `-` | `modules/...` | Pending | |
| `levonk.common.vet_script_installer` | `vet-dependencies.yml` | `-` | `modules/...` | Pending | |
| `levonk.gamer.bluestacks_setup` | `main.yml` | `-` | `modules/...` | Pending | |
| `levonk.gamer.epic_setup` | `main.yml` | `-` | `modules/...` | Pending | |
| `levonk.gamer.game_performance_tuning` | `-` | `-` | `modules/...` | Pending | |
| `levonk.gamer.minecraft_forge_setup` | `main.yml` | `-` | `modules/...` | Pending | |
| `levonk.gamer.origin_setup` | `main.yml` | `-` | `modules/...` | Pending | |
| `levonk.gamer.steam_setup` | `main.yml` | `-` | `modules/...` | Pending | |
| `levonk.gamer.xbox_setup` | `main.yml` | `-` | `modules/...` | Pending | |
| `levonk.hardened.bitwarden_cli_support` | `rbw.yml, bw.yml, bws.yml` | `-` | `modules/...` | Pending | |
| `levonk.hardened.harden_baseline` | `warp.yml, macos.yml, linux.yml, fail2ban.yml, etckeeper.yml, linux.yml` | `macos.yml, etckeeper.yml` | `modules/security/baseline.nix` | ✅ Ported | |
| `levonk.hardened.harden_custom` | `-` | `main.yml` | `modules/...` | Pending | |
| `levonk.hardened.harden_moderate` | `linux.yml` | `linux.yml, linux.yml, linux.yml, macos.yml` | `modules/security/hardened.nix` | ✅ Ported | |
| `levonk.hardened.harden_noop` | `-` | `-` | `modules/...` | Pending | |
| `levonk.hardened.harden_paranoid` | `-` | `linux.yml` | `modules/security/locked.nix` | ✅ Ported | |
| `levonk.server_llmchat.Makefile` | `-` | `-` | `modules/...` | Pending | |
| `levonk.server_llmchat.lite-llm` | `install-open-webui.yml, install-lite-llm.yml` | `install-open-webui.yml, install-lite-llm.yml` | `modules/...` | Pending | |
| `levonk.server_llmchat.open-webui` | `install.yml` | `install.yml` | `modules/...` | Pending | |
| `levonk.server_llmchat.syscheck` | `-` | `-` | `modules/...` | Pending | |
| `levonk.user_setup.chezmoi` | `Linux.yml, Windows.yml, Darwin.yml` | `-` | `modules/system/chezmoi.nix` | ✅ Ported | |
| `levonk.user_setup.local_user` | `main.yml` | `-` | `modules/...` | Pending | |
| `levonk.user_setup.remote_user` | `main.yml` | `-` | `modules/...` | Pending | |
| `levonk.user_setup.service_user` | `main.yml` | `-` | `modules/...` | Pending | |
| `levonk.user_setup.thick_shell` | `mac-support-tmux-copypaste.yml, fzf.yml, neovim.yml, tmux.yml, ripgrep.yml, zoxide.yml, mosh.yml, direnv.yml, vim.yml, zellij.yml, bat.yml, fd.yml, zsh.yml, nushell.yml, fish.yml, bash.yml, windows_posh.yml` | `neovim.yml, zoxide.yml, direnv.yml, vim.yml, fd.yml` | `modules/components/tools/terminal.nix`, `modules/components/shells/zsh.nix`, `modules/components/editors/vim.nix` | ✅ Ported | |
| `levonk.vibeops.3d-printing` | `-` | `-` | `modules/...` | Pending | |
| `levonk.vibeops.Makefile` | `-` | `-` | `modules/...` | Pending | |
| `levonk.vibeops.browsers` | `librewolf.yml, edge.yml, firefox_dev.yml, perplexity_comet.yml, browser_os.yml, opera_neon.yml, chrome.yml, ungoogled_chromium.yml, brave.yml, carbonyl.yml, ladybird.yml, mullvad_browser.yml, dia.yml, chromium.yml, tor_browser.yml, opera_gx.yml` | `opera_neon.yml, carbonyl.yml, opera_gx.yml` | `modules/components/browsers/default.nix` | ✅ Ported | Core browsers ported |
| `levonk.vibeops.comms` | `discord.yml, zoom.yml, slack.yml, telegram.yml, signal.yml` | `-` | `modules/components/comms/default.nix` | ✅ Ported | |
| `levonk.vibeops.dev-ansible` | `uv.yml` | `uv.yml` | `modules/...` | Pending | |
| `levonk.vibeops.dev-cloud` | `Darwin.yml` | `-` | `modules/components/dev/cloud.nix` | ✅ Ported | |
| `levonk.vibeops.dev-cpp` | `main.yml` | `-` | `modules/...` | Pending | |
| `levonk.vibeops.dev-docker` | `docker-security.yml, docker-ux.yml, docker-desktop.yml, docker-optimize.yml, dive.yml, docker-cli.yml` | `-` | `modules/components/dev/docker.nix` | ✅ Ported | |
| `levonk.vibeops.dev-dotnet` | `main.yml` | `-` | `modules/...` | Pending | |
| `levonk.vibeops.dev-go` | `main.yml` | `-` | `modules/components/dev/go.nix` | ✅ Ported | |
| `levonk.vibeops.dev-java` | `main.yml` | `-` | `modules/...` | Pending | |
| `levonk.vibeops.dev-js` | `nodejs.yml, webstorm.yml, js-managers.yml` | `webstorm.yml` | `modules/components/dev/node.nix` | ✅ Ported | |
| `levonk.vibeops.dev-make` | `remake.yml` | `remake.yml` | `modules/...` | Pending | |
| `levonk.vibeops.dev-php` | `main.yml` | `-` | `modules/...` | Pending | |
| `levonk.vibeops.dev-python` | `pdm.yml, miniconda.yml, python.yml, poetry.yml, pipenv.yml, pyenv.yml, virtualenv.yml, uv.yml` | `pdm.yml, miniconda.yml, poetry.yml, pipenv.yml, pyenv.yml, virtualenv.yml, uv.yml, virtualenvwrapper.yml` | `modules/components/dev/python.nix` | ✅ Ported | |
| `levonk.vibeops.dev-ruby` | `main.yml` | `-` | `modules/...` | Pending | |
| `levonk.vibeops.dev-rust` | `-` | `-` | `modules/components/dev/rust.nix` | ✅ Ported | |
| `levonk.vibeops.dev_ai_assisted` | `install_aws_cli.yml, install_gcloud_sdk.yml, install_terminal_jarvis.yml, install_spec_kit.yml, install_cline.yml, install_opencode.yml, install_cursor.yml, copilot-cli.yml, install_vscode_insiders.yml, install_goose.yml, install_vscode.yml, install_android_studio.yml, install_orchestrator.yml, install_agent.yml` | `install_spec_kit.yml, install_opencode.yml, crush.yml, install_awesome_ai_system_prompts.yml, install_awesome_claude_prompts.yml, install_awesome_claude_code.yml, install_codemcp.yml, install_proxy.yml, install_superclaude.yml, install_windsurf.yml, install_goose.yml, install_kiro.yml, install_orchestrator.yml, install_archon.yml, install_serena.yml, install_mcp_zero.yml, install_agent.yml` | `modules/components/dev/ai.nix` | ✅ Ported | Core AI tools |
| `levonk.vibeops.developer` | `install_jq.yml, install_super_linter.yml, install_yq.yml, install_universal_ctags.yml` | `main.yml` | `modules/...` | Pending | |
| `levonk.vibeops.devops` | `packer.yml, docker_desktop.yml, virtualbox.yml, vagrant.yml, terraform.yml` | `terraform.yml` | `modules/components/dev/cloud.nix` | ✅ Ported | |
| `levonk.vibeops.knowledge` | `microsoft_copilot.yml, obsidian.yml` | `-` | `modules/components/tools/knowledge.nix` | ✅ Ported | |
| `levonk.vibeops.multimedia` | `ffmpeg.yml, imagemagick.yml, gimp.yml, vlc.yml, ffprobe.yml, opencut.yml, obs_studio.yml, audacity.yml, cava.yml` | `opencut.yml` | `modules/components/multimedia/default.nix` | ✅ Ported | |
| `levonk.vibeops.quantified-self` | `-` | `configure.yml, install_activitywatch.yml, install_fathom.yml` | `modules/...` | Pending | |
| `levonk.vibeops.syscheck` | `-` | `-` | `modules/...` | Pending | |
| `levonk.vibeops.tools` | `dangerzone.yml, copier.yml, install_jqfmt.yml, iterm2.yml, windows_terminal.yml, atuin.yml, eza.yml, tealdeer.yml, tilix.yml, kitty.yml, jj.yml, git_friendly.yml, sublime_text.yml, espanso.yml, raycast.yml, speech.yml, ssh_windows.yml, dos2unix.yml, ssh_unix.yml, 7zip.yml, virtualbox.yml, vagrant.yml, wispr_flow.yml, llm.yml, m1f.yml, ollama-desktop.yml, copyq.yml, copyclip.yml, ditto.yml, archi-diagrams.yml, graphviz.yml` | `install_jqfmt.yml, atuin.yml, help.yml, espanso.yml, raycast.yml, ssh_windows.yml, ssh_unix.yml, claude_task_master.yml, free_cluely.yml, m1f.yml, archi-diagrams.yml, mermaidjs.yml` | `modules/components/tools/terminal.nix`, `modules/components/tools/knowledge.nix` | ✅ Ported | Core tools |
| `levonk.vibeops.wsl_setup` | `-` | `-` | `modules/system/wsl/default.nix` | ✅ Ported | |
