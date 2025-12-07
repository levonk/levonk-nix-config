# Privacy & Telemetry Hardening Overview

This document summarizes the cross-platform privacy and telemetry-hardening
settings associated with this Nix config, and where automation currently
lives (Nix/darwin, scripts) versus where manual or OS-specific tooling is
required.

---

## macOS (Nix-darwin)

### ☑️ Automated via Nix-darwin

Implemented in `modules/system/darwin/defaults.nix` and
`modules/security/hardened.nix`:

- **System defaults (Software Update & App Store)**
  - File: `modules/system/darwin/defaults.nix`
  - Behavior:
    - `SoftwareUpdate.AutomaticCheckEnabled = true`
    - `SoftwareUpdate.AutomaticDownload = true`
    - `SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true`
    - `SoftwareUpdate.ConfigDataInstall = true`
    - `SoftwareUpdate.CriticalUpdateInstall = true`
    - `com.apple.commerce.AutoUpdate = true`
  - Effect: matches UI toggles:
    - Download new updates when available: **On**
    - Install macOS updates: **On**
    - Install Security Responses and system files: **On**
    - Install application updates from the App Store: **On**

- **Hardened profile: LuLu firewall on macOS**
  - File: `modules/security/hardened.nix`
  - When the hardened profile is active on Darwin and the Homebrew module is
    imported, the profile appends the **LuLu** firewall cask:
    - Extends `homebrew.casks` with `"lulu"` on Darwin only.

### 📦 Telemetry blocklist artifact (Apple)

- Location: `blocklists/native.apple.hosts.txt`
- Source: Hagezi Apple Tracker DNS blocklist
  - Upstream URL:
    - <https://raw.githubusercontent.com/hagezi/dns-blocklists/refs/heads/main/hosts/native.apple.txt>
  - Content: copied snapshot (header + host entries) at the time of import.
- Usage: this repo **does not** apply the list to `/etc/hosts` or any
  resolver directly. It is an artifact that can be consumed by:
  - Network appliances (router, Pi-hole, AdGuard, etc.).
  - Future privacy modules or external automation.

Updating the blocklist is an explicit action: fetch a new version from the
upstream URL, inspect diff, and update `blocklists/native.apple.hosts.txt`.

### ⚠️ macOS privacy items (TODO / manual)

The following macOS privacy toggles are **not** yet wired because they
require precise, version-specific preference keys that have not been
captured from a real system. They are documented here for future work:

- **Analytics & Improvements**
  - Share Mac Analytics: Off
  - Improve Siri & Dictation: Off
  - Improve Assistive Voice Features: Off
  - Share with app developers: Off
  - Share iCloud Analytics: Off

- **Apple Advertising**
  - Personalized Ads: Off

- **Other OS features**
  - Gatekeeper / "Allow apps from: App Store only"
  - Lockdown Mode, FileVault enforcement via policy.

Future plan (when keys are known and stable):

- Introduce a dedicated `privacy` module (e.g. `modules/security/privacy.nix`)
  that sets the exact `system.defaults.CustomSystemPreferences` and/or
  `CustomUserPreferences` keys for these toggles on Darwin, informed by
  `defaults read` output from a configured system.

---

## Windows

Windows privacy hardening is **not** controlled by Nix. Instead, this repo
provides:

- A **PowerShell helper script** for settings that can be safely managed via
  registry/policy.
- Documentation of additional recommendations that should be enforced via
  Group Policy, Intune, or per-environment scripts.

### ☑️ Automated via PowerShell script

Script: `scripts/windows-privacy-hardening.ps1`

Run from an elevated PowerShell session:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
./windows-privacy-hardening.ps1
```

The script currently automates:

- **Notifications → Additional settings**
  - Disables Windows consumer experiences and tips where backed by policy:
    - Disables "suggest ways to get the most out of Windows".
    - Disables various tips / soft landing / content delivery suggestions.

- **Lock screen & Start recommendations**
  - Turns off lock screen rotating content and overlays where controllable.
  - Disables Start menu app suggestions / recommendations.

- **AutoPlay**
  - Globally disables AutoPlay for media and devices via registry
    (`DisableAutoplay`, `NoAutoplayfornonVolume`).

- **File Explorer & Search bar**
  - Disables File Explorer "sync provider notifications" (which are used for
    OneDrive and related promotional/notification surfaces).
  - Disables Bing/web search integration in the Windows search box.

The script is intentionally conservative: it targets stable, documented
registry keys and leaves adapter-specific or highly UI-coupled behavior
to dedicated tooling.

### ⚠️ Windows items documented but not scripted

The following requested behaviors are **documented** here but are not fully
automated in the script due to version-specific or adapter-specific quirks.
They are candidates for GPO/Intune baselines or environment-specific tools.

- **Screen saver / lock behavior**
  - Personalization → Lock screen:
    - Use `Picture` or `Slideshow` (avoid Spotlight).
    - "Get fun facts, tips, tricks and more on your lock screen": Off.
    - Lock screen status: None.
  - Screen saver:
    - "On resume, display logon screen": On.
    - Wait: shortest acceptable duration.

- **Additional privacy/UX toggles**
  - System → Notifications → Additional settings:
    - Show the Windows welcome experience after updates and sign-in: Off.
    - Suggest ways to get the most out of Windows and finish setting up
      this device: Off.
    - Get tips and suggestions when using Windows: Off.

- **Networking / DNS / DoH**
  - For each Ethernet/Wi‑Fi adapter (UI path):
    - Set DNS server assignment to **Manual**.
    - Enable IPv4/IPv6 and point DNS to privacy-oriented resolvers
      (e.g., Quad9: `9.9.9.9`, `149.112.112.112`, `2620:fe::fe`,
      `2620:fe::9`).
    - DNS over HTTPS: On (automatic template).
    - Fallback to plaintext: Off.
  - Wi‑Fi:
    - Random hardware addresses: On.

- **Windows Security / Defender / Device features**
  - Virus & threat protection:
    - Ensure **all protections are enabled**, **except** automatic sample
      submission if stricter privacy is desired.
    - Controlled folder access: **On** (via "Manage controlled folder
      access" → "Controlled folder access: On").
  - Firewall & network protection:
    - Firewall should be **On** for **Domain**, **Private**, and **Public**
      profiles.
  - Device security → Core isolation details:
    - Enable all available core isolation features (e.g., Memory integrity),
      subject to driver compatibility.
  - Find my device:
    - "Find my device": **Off** for stronger privacy, unless device-location
      recovery is explicitly required.

- **Additional shell / Explorer / Quick Assist behavior**
  - File Explorer:
    - View → Show:
      - Hidden items: On (recommended).
      - File name extensions: On (recommended).
    - Folder Options → View:
      - "Show sync provider notifications": Off (also automated by script).
  - Telemetry service:
    - `Connected User Experiences and Telemetry` service:
      - Service status: Stopped.
      - Startup type: Disabled.
    - Note: strongly consider handling this via GPO/endpoint policy; local
      changes may be overridden by enterprise management.
  - Quick Assist:
    - Block backend host in `C:\Windows\System32\drivers\etc\hosts`:
      - `0.0.0.0  remoteassistance.support.services.microsoft.com`
    - Uninstall user-facing app if desired:
      - `Get-AppxPackage -Name MicrosoftCorporationII.QuickAssist | Remove-AppxPackage -AllUsers`
  - Additional Microsoft telemetry hosts:
    - For users comfortable with host-based blocking, an additional
      telemetry list can be appended to the Windows hosts file. This is
      **not** managed by this repo and should be updated manually using the
      upstream source you trust.
  - Trending searches & web search in search bar:
    - Script already disables Bing/web search via `BingSearchEnabled = 0`.
    - Ensure "Show search highlights" is Off in Search permissions →
      More settings.

Because adapter names, DoH templates, and supported scenarios vary widely
across Windows builds, a one-size-fits-all script would be brittle. These
are better handled via:

- GPO/Intune configuration profiles.
- Per-organization hardening scripts that know the adapter naming
  conventions and resolver policy.

---

## Future Work / Open Questions

- Capture precise macOS `defaults` keys for:
  - Analytics & Improvements toggles.
  - Apple Advertising / Personalized Ads.
  - Lockdown Mode visibility, other privacy-relevant controls.

- Decide where a `privacy` role/module should live:
  - As a `modules/security/privacy.nix` module, or
  - As a `modules/profiles/roles/privacy.nix` capability profile.

- Integrate the Apple telemetry blocklist artifact with:
  - Home network DNS (Pi-hole/AdGuard), or
  - A future on-host resolver module, while keeping Nix inputs pinned and
    updates explicit.
