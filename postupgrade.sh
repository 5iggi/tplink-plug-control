#!/bin/bash
# postupgrade.sh - TP-Link Plug Control
# Restores persistent user configuration after an upgrade.
# Arguments:
# $1 = temp folder short, $2 = plugin short name, $3 = plugin folder, $4 = version, $5 unused, $6 = full temp path

set -u
PDIR="${3:-tplink}"
PVERSION="${4:-unknown}"
PTEMPPATH="${6:-/tmp}"
PCONFIG="${LBPCONFIG:-/opt/loxberry/config/plugins}/$PDIR"
PDATA="${LBPDATA:-/opt/loxberry/data/plugins}/$PDIR"
PLOG="${LBPLOG:-/opt/loxberry/log/plugins}/$PDIR"
BACKUPDIR="$PTEMPPATH/tplink-backup"

printf '<INFO> TP-Link Plug Control postupgrade started. PDIR=%s VERSION=%s\n' "$PDIR" "$PVERSION"
mkdir -p "$PCONFIG" "$PDATA" "$PLOG"

if [ -f "$BACKUPDIR/devices.json" ]; then
  cp -p "$BACKUPDIR/devices.json" "$PCONFIG/devices.json"
  printf '<OK> Restored devices.json from upgrade backup\n'
elif [ ! -f "$PCONFIG/devices.json" ]; then
  printf '{"devices":[]}\n' > "$PCONFIG/devices.json"
  printf '<WARNING> No backup found; created empty devices.json\n'
else
  printf '<INFO> Existing devices.json found; no restore required\n'
fi

if [ ! -f "$PLOG/tplink.log" ]; then
  printf '%s <INFO> TP-Link Plug Control log created after upgrade\n' "$(date)" > "$PLOG/tplink.log"
fi

chmod 775 "$PCONFIG" "$PDATA" "$PLOG" 2>/dev/null || true
chmod 664 "$PCONFIG/devices.json" "$PLOG/tplink.log" 2>/dev/null || true
rm -f /etc/cron.d/loxberry-tplink 2>/dev/null || true

printf '<OK> TP-Link Plug Control postupgrade finished\n'
exit 0
