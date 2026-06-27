#!/bin/bash
# postinstall.sh - TP-Link Plug Control
# Runs after plugin files have been copied. Runs as user "loxberry".
# Arguments:
# $1 = temp folder short, $2 = plugin short name, $3 = plugin folder, $4 = version, $5 unused, $6 = full temp path
# Exit codes: 0=OK, 1=Warning, 2=Fatal

set -u

COMMAND="$0"
PTEMPDIR="${1:-}"
PSHNAME="${2:-tplink}"
PDIR="${3:-tplink}"
PVERSION="${4:-unknown}"
PTEMPPATH="${6:-}"

PCONFIG="${LBPCONFIG:-/opt/loxberry/config/plugins}/$PDIR"
PDATA="${LBPDATA:-/opt/loxberry/data/plugins}/$PDIR"
PLOG="${LBPLOG:-/opt/loxberry/log/plugins}/$PDIR"
PBIN="${LBPBIN:-/opt/loxberry/bin/plugins}/$PDIR"
PHTMLAUTH="${LBPHTMLAUTH:-/opt/loxberry/webfrontend/htmlauth/plugins}/$PDIR"
PTEMPL="${LBPTEMPL:-/opt/loxberry/templates/plugins}/$PDIR"

printf '<INFO> TP-Link Plug Control postinstall started. PDIR=%s VERSION=%s\n' "$PDIR" "$PVERSION"
printf '<INFO> Paths: PCONFIG=%s PDATA=%s PLOG=%s\n' "$PCONFIG" "$PDATA" "$PLOG"

mkdir -p "$PCONFIG" "$PDATA" "$PLOG"

# Create default configuration only on first install. Do not overwrite existing user configuration.
if [ ! -f "$PCONFIG/devices.json" ]; then
  printf '{"devices":[]}\n' > "$PCONFIG/devices.json"
  printf '<OK> Created initial devices.json\n'
else
  printf '<INFO> Existing devices.json preserved\n'
fi

# Create plugin log file for LoxBerry logviewer.
if [ ! -f "$PLOG/tplink.log" ]; then
  printf '%s <INFO> TP-Link Plug Control log created\n' "$(date)" > "$PLOG/tplink.log"
  printf '<OK> Created tplink.log\n'
else
  printf '<INFO> Existing tplink.log preserved\n'
fi

# Best-effort permissions. Installation is usually owned by loxberry already.
chmod 775 "$PCONFIG" "$PDATA" "$PLOG" 2>/dev/null || true
chmod 664 "$PCONFIG/devices.json" "$PLOG/tplink.log" 2>/dev/null || true

# Ensure CGI files are executable if present.
for f in "$PHTMLAUTH"/*.cgi; do
  [ -f "$f" ] && chmod 755 "$f" 2>/dev/null || true
done

# No cron file is required by this plugin. Remove legacy cron file if present.
rm -f /etc/cron.d/loxberry-tplink 2>/dev/null || true

printf '<OK> TP-Link Plug Control postinstall finished\n'
exit 0
