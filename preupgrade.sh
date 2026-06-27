#!/bin/bash
# preupgrade.sh - TP-Link Plug Control
# Backs up persistent user configuration before an upgrade.
# Arguments:
# $1 = temp folder short, $2 = plugin short name, $3 = plugin folder, $4 = version, $5 unused, $6 = full temp path

set -u
PDIR="${3:-tplink}"
PVERSION="${4:-unknown}"
PTEMPPATH="${6:-/tmp}"
PCONFIG="${LBPCONFIG:-/opt/loxberry/config/plugins}/$PDIR"
BACKUPDIR="$PTEMPPATH/tplink-backup"

printf '<INFO> TP-Link Plug Control preupgrade started. PDIR=%s VERSION=%s\n' "$PDIR" "$PVERSION"
mkdir -p "$BACKUPDIR"

if [ -f "$PCONFIG/devices.json" ]; then
  cp -p "$PCONFIG/devices.json" "$BACKUPDIR/devices.json"
  printf '<OK> Backed up devices.json to %s\n' "$BACKUPDIR"
else
  printf '<INFO> No devices.json found to back up\n'
fi

printf '<OK> TP-Link Plug Control preupgrade finished\n'
exit 0
