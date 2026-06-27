#!/bin/bash
# postroot.sh - TP-Link Plug Control
# Runs with root privileges after postinstall.sh, if LoxBerry executes root hook.
# This plugin currently does not require root tasks. The script is intentionally kept as safe no-op.
# Arguments:
# $1 = temp folder short, $2 = plugin short name, $3 = plugin folder, $4 = version, $5 unused, $6 = full temp path

set -u
PDIR="${3:-tplink}"
PVERSION="${4:-unknown}"

printf '<INFO> TP-Link Plug Control postroot started. PDIR=%s VERSION=%s\n' "$PDIR" "$PVERSION"
printf '<INFO> No root tasks required.\n'
printf '<OK> TP-Link Plug Control postroot finished\n'
exit 0
