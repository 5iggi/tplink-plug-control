#!/bin/bash
# uninstall/uninstall.sh - TP-Link Plug Control
# Runs during uninstall. Keep user data by default for safety.
# Arguments are LoxBerry-specific; $3 is usually plugin folder.

set -u
PDIR="${3:-tplink}"
PCONFIG="${LBPCONFIG:-/opt/loxberry/config/plugins}/$PDIR"
PDATA="${LBPDATA:-/opt/loxberry/data/plugins}/$PDIR"
PLOG="${LBPLOG:-/opt/loxberry/log/plugins}/$PDIR"

printf '<INFO> TP-Link Plug Control uninstall started. PDIR=%s\n' "$PDIR"

# Remove legacy cron file if present. The current plugin does not use cron.
rm -f /etc/cron.d/loxberry-tplink 2>/dev/null || true
printf '<OK> Removed legacy cron file if present\n'

# Do not delete user configuration/data/logs automatically.
# If a full cleanup is desired, uncomment the block below or run manually.
printf '<INFO> Preserving user data by default:\n'
printf '<INFO>   %s\n' "$PCONFIG"
printf '<INFO>   %s\n' "$PDATA"
printf '<INFO>   %s\n' "$PLOG"

# Optional full cleanup, disabled intentionally:
# rm -rf "$PCONFIG" "$PDATA" "$PLOG"

printf '<OK> TP-Link Plug Control uninstall finished\n'
exit 0
