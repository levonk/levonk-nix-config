#!/usr/bin/env zsh
# shellcheck zsh strict=1

# macOS Tweaks (English version)
# Ported from https://github.com/Azazide/macos-tweaks (tweaks.sh)
#
# NOTE: This script changes many UI and privacy settings. It will restart
# affected services and only reboot if required.

set -euo pipefail

VERSION="1.0.0"

ACTION="apply"
MODE="hardened"
ALLOW_REBOOT=0

print_usage() {
  cat <<'USAGE'
Usage: macos-tweaks-custom.zsh [mode] [options]

Modes:
  (default)               Apply hardened settings from the table (Darwin only)
  --factory, --reset      Apply factory settings from the table (Darwin only)

Other commands:
  --help, -h              Show detailed help and exit
  --usage                 Show a short usage summary and exit
  --version               Show script version and exit

Options:
  --allow-reboot          If a reboot is required, perform it automatically.
                          Without this flag, the script only reports that a
                          reboot is needed, but does not reboot.

Note: Any mode that changes or reads macOS preferences requires macOS (Darwin).
USAGE
}

print_help() {
  print_usage
}

print_version() {
  echo "macos-tweaks-custom.zsh ${VERSION}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --factory|--reset)
      MODE="factory"
      shift
      ;;
    --help|-h)
      ACTION="help"
      shift
      ;;
    --usage)
      ACTION="usage"
      shift
      ;;
    --version)
      ACTION="version"
      shift
      ;;
    --allow-reboot)
      ALLOW_REBOOT=1
      shift
      ;;
    --*)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

if [[ "${ACTION}" == "help" ]]; then
  print_help
  exit 0
fi

if [[ "${ACTION}" == "usage" ]]; then
  print_usage
  exit 0
fi

if [[ "${ACTION}" == "version" ]]; then
  print_version
  exit 0
fi

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is intended to run only on macOS (Darwin)." >&2
  exit 1
fi

GREEN_CHECK="✅"
RED_X="❌"
NOCHANGE_ICON="➖"
POWER_ICON="⏻"          # Indicates this setting typically needs a reboot/log-out

typeset -A ICONS
ICONS=(
  [UI]="🎛"        # UI / window / Dock / Finder
  [PRIVACY]="🛡"   # Privacy / telemetry
  [INPUT]="🖱"     # Input devices
  [DEV]="🛠"       # Developer / tools
)

TOTAL_ATTEMPTS=0
SUCCESS_COUNT=0
FAIL_COUNT=0
NOCHANGE_COUNT=0

typeset -A CAT_ATTEMPTS CAT_SUCCESS CAT_FAIL CAT_NOCHANGE
typeset -A SERVICE_DEP_COUNT SERVICE_RESTART_ATTEMPTS SERVICE_RESTART_SUCCESS SERVICE_PENDING

NEEDS_REBOOT=0

normalize_bool() {
  local v="${1:-}"
  v="${v%"\n"}"
  case "${v:l}" in
    1|"yes"|"true") echo 1 ;;
    0|"no"|"false") echo 0 ;;
    "__unset__")      echo "__UNSET__" ;;
    *)                 echo "${v}" ;;
  esac
}

print_summary() {
  echo "--- Summary ---"
  echo "Total attempts: ${TOTAL_ATTEMPTS}"
  echo "${GREEN_CHECK} success: ${SUCCESS_COUNT}"
  echo "${RED_X} failed:  ${FAIL_COUNT}"
  echo "${NOCHANGE_ICON} unchanged: ${NOCHANGE_COUNT}"
  echo
  echo "By category:"
  for cat in UI PRIVACY INPUT DEV; do
    local icon="${ICONS[$cat]:-""}"
    echo "  ${icon} ${cat}: attempts=${CAT_ATTEMPTS[$cat]:-0}, ok=${CAT_SUCCESS[$cat]:-0}, failed=${CAT_FAIL[$cat]:-0}, unchanged=${CAT_NOCHANGE[$cat]:-0}"
  done
  echo
  echo "By service dependency:"
  for svc in ${(k)SERVICE_DEP_COUNT}; do
    echo "  ${svc}: depends=${SERVICE_DEP_COUNT[$svc]:-0}, restarts=${SERVICE_RESTART_ATTEMPTS[$svc]:-0}, ok=${SERVICE_RESTART_SUCCESS[$svc]:-0}"
  done
  echo
  if (( NEEDS_REBOOT )); then
    echo "Reboot still required: ${POWER_ICON} yes"
  else
    echo "Reboot still required: no"
  fi
}

# set_pref <category_key> <reduction_flag> <name> <domain> <key> <type> <value> <needs_reboot> <services> <explanation>
set_pref() {
  local category_key="$1"
  local reduction_flag="$2"   # 1 = reduces functionality, 0 = mostly cosmetic/safe
  local name="$3"
  local domain="$4"
  local key="$5"
  local type="$6"            # e.g. -bool, -int, -float, -string, -int (for dict args just treat as string)
  local value="$7"
  local needs_reboot="$8"    # 1 = typically needs reboot/log-out, 0 = process restart usually enough
  local services="$9"
  local explanation="${10:-}"

  local category_icon="${ICONS[$category_key]:-🔧}"

  TOTAL_ATTEMPTS=$((TOTAL_ATTEMPTS + 1))
  CAT_ATTEMPTS[$category_key]=$(( ${CAT_ATTEMPTS[$category_key]:-0} + 1 ))

  local reduction_icon=""
  if [[ "${reduction_flag}" == "1" ]]; then
    reduction_icon="⚠️"   # Reduction in functionality / more aggressive
  else
    reduction_icon=" "
  fi

  if [[ "${needs_reboot}" == "1" ]]; then
    NEEDS_REBOOT=1
  fi

  local old_raw
  if ! old_raw=$(defaults read "${domain}" "${key}" 2>/dev/null); then
    old_raw="__UNSET__"
  fi

  local norm_old norm_new
  norm_old="$(normalize_bool "${old_raw}")"
  norm_new="$(normalize_bool "${value}")"

  if [[ "${norm_old}" == "${norm_new}" ]]; then
    NOCHANGE_COUNT=$((NOCHANGE_COUNT + 1))
    CAT_NOCHANGE[$category_key]=$(( ${CAT_NOCHANGE[$category_key]:-0} + 1 ))
    printf "%s %s%s %s (no change; already %s)\n" "${NOCHANGE_ICON}" "${category_icon}" "${reduction_icon}" "${name}" "${value}"
    return 0
  fi

  if defaults write "${domain}" "${key}" "${type}" "${value}" >/dev/null 2>&1; then
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    CAT_SUCCESS[$category_key]=$(( ${CAT_SUCCESS[$category_key]:-0} + 1 ))

    for svc in ${(z)services}; do
      SERVICE_DEP_COUNT[$svc]=$(( ${SERVICE_DEP_COUNT[$svc]:-0} + 1 ))
      SERVICE_PENDING[$svc]=1
    done

    local power_marker=""
    if [[ "${needs_reboot}" == "1" ]]; then
      power_marker=" ${POWER_ICON}"
    fi

    printf "%s %s%s %s%s\n" "${GREEN_CHECK}" "${category_icon}" "${reduction_icon}" "${name}" "${power_marker}"
    printf "    old: %s\n" "${old_raw}"
    printf "    new: %s\n" "${value}"
    if [[ -n "${explanation}" ]]; then
      printf "    %s\n" "${explanation}"
    fi
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    CAT_FAIL[$category_key]=$(( ${CAT_FAIL[$category_key]:-0} + 1 ))
    printf "%s %s%s %s (failed to apply)\n" "${RED_X}" "${category_icon}" "${reduction_icon}" "${name}"
  fi
}

###############################################################################
# Tweaks table
###############################################################################

# Format per line (pipe-separated):
# category | reduction_flag | name | domain | key | type | hardened_value | factory_value | needs_reboot | services | explanation

while IFS='|' read -r category reduction name domain key type hardened_value factory_value needs_reboot services explanation; do
  [[ -z "${category}" || "${category}" == "#"* ]] && continue

  local value="${hardened_value}"
  if [[ "${MODE}" == "factory" ]]; then
    value="${factory_value}"
  fi

  set_pref "${category}" "${reduction}" "${name}" "${domain}" "${key}" "${type}" "${value}" "${needs_reboot}" "${services}" "${explanation}"
done <<'EOF'
# UI tweaks: Dock, window behavior, Launchpad
UI|0|Window resize animation speed|NSGlobalDomain|NSWindowResizeTime|-float|0.1|0.1|0|Dock SystemUIServer|Speeds up window resize animations so windows feel more responsive.
UI|0|Dock show/hide animation speed|com.apple.dock|autohide-time-modifier|-float|0.1|0.1|0|Dock|Faster Dock show/hide animation.
UI|0|Mission Control animation speed|com.apple.dock|expose-animation-duration|-float|0|0|0|Dock|Speeds up Mission Control animation.
UI|0|Launchpad rows|com.apple.dock|springboard-rows|-int|7|7|0|Dock|Sets Launchpad rows.
UI|0|Launchpad columns|com.apple.dock|springboard-columns|-int|7|7|0|Dock|Sets Launchpad columns.
UI|0|Dock icon size|com.apple.dock|tilesize|-int|51|51|0|Dock|Sets Dock icon size.
UI|0|Dock magnified icon size|com.apple.dock|largesize|-float|67.84|67.84|0|Dock|Sets magnified Dock icon size.
UI|0|Disable cursor magnification when shaken|-g|CGDisableCursorLocationMagnification|-bool|true|true|0|SystemUIServer|Prevents cursor from enlarging when shaken.

# Privacy / telemetry
PRIVACY|0|Disable Apple analytics autosubmit|com.apple.SubmitDiagInfo|AutoSubmit|-bool|false|true|1|cfprefsd|Stops automatic submission of diagnostics/usage data to Apple.
PRIVACY|0|Disable Apple personalized ads from diagnostics|com.apple.SubmitDiagInfo|AllowApplePersonalizedAds|-bool|false|true|1|cfprefsd|Prevents Apple from using diagnostic data to personalize ads.
PRIVACY|0|Disable personalized advertising|com.apple.AdLib|allowApplePersonalizedAdvertising|-bool|false|true|1|cfprefsd|Disables Apple personalized advertising.
PRIVACY|0|Disable location services (improve products features)|com.apple.locationd|LocationServicesEnabled|-int|0|0|1|locationd|Disables location services for analytics/improvements.
PRIVACY|0|Disable setup location services (improve products features)|com.apple.locationd|LocationServicesEnabledInSetup|-int|0|0|1|locationd|Disables setup-time location services for analytics/improvements.
PRIVACY|0|Disable Safari Do Not Track header|com.apple.Safari|SendDoNotTrackHTTPHeader|-bool|true|true|1|Safari|Enables the Do Not Track HTTP header in Safari.
PRIVACY|1|Disable Safari universal search|com.apple.Safari|UniversalSearchEnabled|-bool|false|true|1|Safari|Prevents Safari from using Apple search suggestions.
PRIVACY|1|Disable Safari search suggestions|com.apple.Safari|SuppressSearchSuggestions|-bool|true|true|1|Safari|Disables Safari search suggestions.
PRIVACY|1|Disable Spotlight suggestions|com.apple.Spotlight|SuggestionsEnabled|-bool|false|true|1|cfprefsd|Disables online Spotlight suggestions.
PRIVACY|1|Disable Siri user enable flag|com.apple.Siri|UserHasDeclinedEnable|-bool|true|false|1|cfprefsd|Marks Siri as declined to enable.
PRIVACY|0|Disable iCloud analytics|com.apple.iCloud|EnableAnalytics|-bool|false|true|1|cfprefsd|Disables analytics for iCloud.
PRIVACY|0|Disable Maps anonymous usage analytics|com.apple.Maps|UserSelectedAnonymousUsageOptIn|-bool|false|true|1|cfprefsd|Disables anonymous usage analytics in Maps.
PRIVACY|0|Disable Health anonymous usage analytics|com.apple.Health|UserSelectedAnonymousUsageOptIn|-bool|false|true|1|cfprefsd|Disables anonymous usage analytics in Health.
PRIVACY|0|Disable Messages anonymous usage analytics|com.apple.imessage|UserSelectedAnonymousUsageOptIn|-bool|false|true|1|cfprefsd|Disables anonymous usage analytics in Messages.
PRIVACY|0|Disable Photos anonymous usage analytics|com.apple.Photos|UserSelectedAnonymousUsageOptIn|-bool|false|true|1|cfprefsd|Disables anonymous usage analytics in Photos.

# Note: The following Siri/analyticsd/system-level changes require sudo and are
# handled outside set_pref to avoid mixing privilege escalation into the table.

# Input / keyboard / Dock behavior
INPUT|0|External mouse non-natural scroll|-g|com.apple.swipescrolldirection|-bool|false|true|0|SystemUIServer|Makes external mouse scroll direction traditional instead of 'natural'.
INPUT|0|Keyboard repeat speed|-g|KeyRepeat|-int|2|2|0|SystemUIServer|Sets key repeat speed.
INPUT|0|Keyboard initial repeat delay|-g|InitialKeyRepeat|-int|25|25|0|SystemUIServer|Sets delay before key repeat.
INPUT|0|Use function keys as standard|-g|com.apple.keyboard.fnState|-bool|true|false|0|SystemUIServer|Treats F1–F12 as standard function keys.
UI|0|Dock autohide delay|com.apple.dock|autohide-delay|-float|0|0|0|Dock|Removes Dock autohide delay.
UI|0|Dock autohide time modifier|com.apple.dock|autohide-time-modifier|-float|0.2|0.2|0|Dock|Controls Dock autohide animation speed.
UI|0|Disable automatic menu bar hiding|NSGlobalDomain|_HIHideMenuBar|-bool|false|true|0|SystemUIServer|Keeps menu bar always visible.
UI|0|Dock spring loading delay|NSGlobalDomain|com.apple.springing.delay|-float|0|0|0|Dock Finder|Removes delay for spring-loading Dock items.
UI|0|Enable Dock spring loading|NSGlobalDomain|com.apple.springing.enabled|-bool|true|false|0|Dock Finder|Enables spring-loading for Dock items.
UI|0|Minimize windows to application icon|com.apple.dock|minimize-to-application|-bool|true|false|0|Dock|Minimizes windows into their app icons.

# Finder / TextEdit / desktop services
UI|0|Show all file extensions|NSGlobalDomain|AppleShowAllExtensions|-bool|true|false|0|Finder|Shows all file extensions in Finder.
UI|0|Warn on extension change|com.apple.finder|FXEnableExtensionChangeWarning|-bool|true|true|0|Finder|Warns when changing file extensions.
UI|0|Warn before removing from iCloud Drive|com.apple.finder|FXEnableRemoveFromICloudDriveWarning|-bool|true|true|0|Finder|Warns before deleting from iCloud Drive.
UI|0|Warn before emptying Trash|com.apple.finder|WarnOnEmptyTrash|-bool|true|true|0|Finder|Warns before emptying the Trash.
UI|0|Auto-remove items from Trash after 30 days|com.apple.finder|FXRemoveOldTrashItems|-bool|true|false|0|Finder|Automatically removes items from Trash after 30 days.
UI|0|Show folders first when sorting by name|com.apple.finder|_FXSortFoldersFirst|-bool|true|false|0|Finder|Shows folders first when sorting by name.
UI|0|Finder default search scope is current folder|com.apple.finder|FXDefaultSearchScope|-string|SCcf|SCev|0|Finder|Sets default search scope to current folder.
UI|0|Finder default view is list|com.apple.finder|FXPreferredViewStyle|-string|Nlsv|icnv|0|Finder|Sets Finder default view to list.
UI|0|Finder icon size|com.apple.finder|IconViewSettings|-dict|IconSize -integer 64|IconSize -integer 64|0|Finder|Sets Finder icon size to 64 pixels.
UI|0|Finder sort order|com.apple.finder|FXArrangeGroupViewBy|-string|Name|None|0|Finder|Sorts Finder items by name.
UI|0|TextEdit plain text default|com.apple.TextEdit|RichText|-int|0|1|0|TextEdit|Uses plain text by default in TextEdit.
UI|0|TextEdit width in chars|com.apple.TextEdit|WidthInChars|-int|140|80|0|TextEdit|Sets default TextEdit width in characters.
UI|0|TextEdit height in chars|com.apple.TextEdit|HeightInChars|-int|40|30|0|TextEdit|Sets default TextEdit height in lines.
UI|0|TextEdit spell check while typing|com.apple.TextEdit|CheckSpellingWhileTyping|-bool|true|true|0|TextEdit|Enables spelling check while typing.
UI|0|TextEdit smart quotes|com.apple.TextEdit|SmartQuotes|-bool|true|false|0|TextEdit|Enables smart quotes in TextEdit.
UI|0|TextEdit smart dashes|com.apple.TextEdit|SmartDashes|-bool|true|false|0|TextEdit|Enables smart dashes in TextEdit.
UI|0|TextEdit show ruler|com.apple.TextEdit|ShowRuler|-bool|true|false|0|TextEdit|Shows ruler in TextEdit.
UI|0|Disable .DS_Store on network shares|com.apple.desktopservices|DSDontWriteNetworkStores|-bool|true|false|0|Finder|Prevents .DS_Store files on network locations.

# Developer tools
DEV|0|Enable Safari Develop menu|com.apple.Safari|IncludeDevelopMenu|-bool|true|false|0|Safari|Enables the Safari Develop menu for web development tools.
EOF

###############################################################################
# System-level privacy changes requiring sudo (not in tweak table)
###############################################################################

echo "Applying additional Siri and analyticsd hardening (requires sudo)..."

if sudo true 2>/dev/null; then
  # Siri and analytics (very invasive)
  sudo defaults write com.apple.assistant.support "Assistant Enabled" -bool false || true
  sudo defaults write com.apple.analyticsd AutoSubmit -bool false || true
  sudo defaults write com.apple.analyticsd AutoSubmitVersion -int 0 || true
  sudo launchctl disable system/com.apple.analyticsd || true
  NEEDS_REBOOT=1
else
  echo "sudo not available or not authorized; skipping system-level Siri/analytics changes."
fi

###############################################################################
# Apply changes by restarting key services, then reboot only if needed
###############################################################################

echo "Restarting services to apply settings..."

for svc in ${(k)SERVICE_PENDING}; do
  SERVICE_RESTART_ATTEMPTS[$svc]=$(( ${SERVICE_RESTART_ATTEMPTS[$svc]:-0} + 1 ))
  if killall "$svc" >/dev/null 2>&1; then
    SERVICE_RESTART_SUCCESS[$svc]=$(( ${SERVICE_RESTART_SUCCESS[$svc]:-0} + 1 ))
  else
    NEEDS_REBOOT=1
  fi
done

echo "All privacy and UI tweaks have been processed."

print_summary

if (( NEEDS_REBOOT )); then
  if (( ALLOW_REBOOT )); then
    echo "System will reboot in 3 seconds..."
    sleep 3
    echo "Rebooting system..."
    sudo reboot
  else
    echo "A reboot is required for all changes to take full effect."
  fi
fi
