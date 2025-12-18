# Windows Privacy & UX Hardening Helper# Windows Privacy & UX Hardening Helper
#
# This script applies a subset of the Windows privacy and UX recommendations
# discussed in the Nix config project. It focuses on registry- and policy-
# backed settings that are reasonably stable across recent Windows 10/11
# versions. Settings that are too UI-specific or volatile are documented as
# TODOs for manual follow-up.
#
# Usage (run in an elevated PowerShell session):
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#   ./windows-privacy-hardening.ps1

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }

if (-not ([bool](New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
  Write-Warn 'This script should be run as Administrator. Some settings may fail without elevation.'
}

# Helper to safely set a registry value, creating keys as needed.
function Set-RegistryValue {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][string]$Name,
    [Parameter(Mandatory = $true)]$Value,
    [ValidateSet('String','DWord')][string]$Type = 'DWord'
  )

  if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
  }

  switch ($Type) {
    'String' { New-ItemProperty -Path $Path -Name $Name -Value ([string]$Value) -PropertyType String -Force | Out-Null }
    'DWord'  { New-ItemProperty -Path $Path -Name $Name -Value ([int]$Value) -PropertyType DWord  -Force | Out-Null }
  }
}

Write-Info 'Applying Windows privacy and UX hardening settings...'

# ---------------------------------------------------------------------------
# System → Notifications → Additional settings
# - Show the Windows welcome experience after updates...: Off
# - Suggest ways to get the most out of Windows...: Off
# - Get tips and suggestions when using Windows: Off
# ---------------------------------------------------------------------------

Write-Info 'Disabling Windows welcome/tips/first-run experiences where possible...'

# Disable consumer experiences ("suggest ways to get the most out of Windows")
Set-RegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableSoftLanding' -Value 1

# Disable suggestions in Start, notifications, etc.
Set-RegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsConsumerFeatures' -Value 1

# Disable tips, tricks and suggestions (per-user content delivery)
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SoftLandingEnabled' -Value 0
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338393Enabled' -Value 0
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338389Enabled' -Value 0
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-310093Enabled' -Value 0

# ---------------------------------------------------------------------------
# Personalization → Lock screen / Start
# - Use Picture/Slideshow (not Spotlight) and disable extra fun facts/tips.
# - Show recommendations for tips, shortcuts, new apps and more: Off.
# ---------------------------------------------------------------------------

Write-Info 'Hardening lock screen and Start recommendations (where configurable)...'

# Disable lock screen fun facts / tips (Content Delivery Manager knobs)
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenOverlayEnabled' -Value 0
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenEnabled' -Value 0

# Disable Start menu app suggestions / recommendations
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SystemPaneSuggestionsEnabled' -Value 0

# Screen saver password-on-resume is location- and version-dependent; document
Write-Warn 'TODO (manual): Ensure "On resume, display logon screen" is enabled for your screen saver.'

# ---------------------------------------------------------------------------
# AutoPlay
# - Use AutoPlay for all media and devices: Off
# ---------------------------------------------------------------------------

Write-Info 'Disabling AutoPlay for all media and devices...'

Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers' -Name 'DisableAutoplay' -Value 1
Set-RegistryValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoAutoplayfornonVolume' -Value 1

# ---------------------------------------------------------------------------
# File Explorer and Search bar
# - Disable sync provider notifications (Explorer ads).
# - Disable Bing/web search integration in the search box.
# ---------------------------------------------------------------------------

Write-Info 'Hardening File Explorer and search box (sync provider notifications, Bing/web search)...'

# Disable sync provider notifications in File Explorer ("Show sync provider notifications")
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSyncProviderNotifications' -Value 0

# Disable Bing/web search in the search box (equivalent to provided command)
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' -Name 'BingSearchEnabled' -Value 0

# ---------------------------------------------------------------------------
# Networking (high level notes)
# - DNS over HTTPS, Quad9 / other resolvers, randomized MAC, etc.
# These are strongly version- and adapter-specific; implementing a
# one-size-fits-all script is fragile. We document them in privacy-hardening
# docs and recommend handling via Intune/GPO or per-environment scripts.
# ---------------------------------------------------------------------------

Write-Warn 'DNS over HTTPS, per-adapter DNS, and randomized MAC settings are documented for manual/GPO automation; this script does not touch adapter settings.'

Write-Info 'Windows privacy & UX hardening pass complete. Some items remain manual; see internal-docs/security/privacy-hardening.md.'

#
# This script applies a subset of the Windows privacy and UX recommendations
# discussed in the Nix config project. It focuses on registry- and policy-
# backed settings that are reasonably stable across recent Windows 10/11
# versions. Settings that are too UI-specific or volatile are documented as
# TODOs for manual follow-up.
#
# Usage (run in an elevated PowerShell session):
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#   ./windows-privacy-hardening.ps1

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }

if (-not ([bool](New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
  Write-Warn 'This script should be run as Administrator. Some settings may fail without elevation.'
}

# Helper to safely set a registry value, creating keys as needed.
function Set-RegistryValue {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][string]$Name,
    [Parameter(Mandatory = $true)]$Value,
    [ValidateSet('String','DWord')][string]$Type = 'DWord'
  )

  if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
  }

  switch ($Type) {
    'String' { New-ItemProperty -Path $Path -Name $Name -Value ([string]$Value) -PropertyType String -Force | Out-Null }
    'DWord'  { New-ItemProperty -Path $Path -Name $Name -Value ([int]$Value) -PropertyType DWord  -Force | Out-Null }
  }
}

Write-Info 'Applying Windows privacy and UX hardening settings...'

# ---------------------------------------------------------------------------
# System → Notifications → Additional settings
# - Show the Windows welcome experience after updates...: Off
# - Suggest ways to get the most out of Windows...: Off
# - Get tips and suggestions when using Windows: Off
# ---------------------------------------------------------------------------

Write-Info 'Disabling Windows welcome/tips/first-run experiences where possible...'

# Disable consumer experiences ("suggest ways to get the most out of Windows")
Set-RegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableSoftLanding' -Value 1

# Disable suggestions in Start, notifications, etc.
Set-RegistryValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsConsumerFeatures' -Value 1

# Disable tips, tricks and suggestions
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SoftLandingEnabled' -Value 0
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338393Enabled' -Value 0
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338389Enabled' -Value 0
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-310093Enabled' -Value 0

# ---------------------------------------------------------------------------
# Personalization → Lock screen / Start
# - Use Picture/Slideshow (not Spotlight) and disable extra fun facts/tips.
# - Show recommendations for tips, shortcuts, new apps and more: Off.
# ---------------------------------------------------------------------------

Write-Info 'Hardening lock screen and Start recommendations (where configurable)...'

# Disable lock screen fun facts / tips (Content Delivery Manager knobs)
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenOverlayEnabled' -Value 0
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenEnabled' -Value 0

# Disable Start menu app suggestions / recommendations
Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SystemPaneSuggestionsEnabled' -Value 0

# Screen saver password-on-resume is location- and version-dependent; document
Write-Warn 'TODO (manual): Ensure "On resume, display logon screen" is enabled for your screen saver.'

# ---------------------------------------------------------------------------
# AutoPlay
# - Use AutoPlay for all media and devices: Off
# ---------------------------------------------------------------------------

Write-Info 'Disabling AutoPlay for all media and devices...'

Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers' -Name 'DisableAutoplay' -Value 1
Set-RegistryValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoAutoplayfornonVolume' -Value 1

# ---------------------------------------------------------------------------
# Networking (high level notes)
# - DNS over HTTPS, Quad9 / other resolvers, randomized MAC, etc.
# These are strongly version- and adapter-specific; implementing a
# one-size-fits-all script is fragile. We document them in privacy-hardening
# docs and recommend handling via Intune/GPO or per-environment scripts.
# ---------------------------------------------------------------------------

Write-Warn 'DNS over HTTPS, per-adapter DNS, and randomized MAC settings are documented for manual/GPO automation; this script does not touch adapter settings.'

Write-Info 'Windows privacy & UX hardening pass complete. Some items remain manual; see internal-docs/security/privacy-hardening.md.'

