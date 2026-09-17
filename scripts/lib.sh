#!/usr/bin/env bash
# Shared output helpers.
#
# A full setup run is long, mostly unattended, and interleaves output from
# brew, stow, fisher and sudo. These give each phase a visible start and a
# visible finish so it's obvious at a glance how far along the run is and
# which step something failed in.
#
# Sourced (not executed) by the other scripts in this directory. setup.sh runs
# them as separate processes, so each one sources this itself.

# Emit escape codes only to a terminal, so piping a run to a log file stays
# readable instead of filling up with \e[1m.
if [[ -t 1 ]]; then
    _c_reset=$'\e[0m'
    _c_bold=$'\e[1m'
    _c_dim=$'\e[2m'
    _c_blue=$'\e[34m'
    _c_green=$'\e[32m'
else
    _c_reset='' _c_bold='' _c_dim='' _c_blue='' _c_green=''
fi

_rule="$(printf '%.0s─' {1..68})"

# Top-level phase: one per script, e.g. "Installing macOS packages".
section() {
    printf '\n%s%s%s\n' "$_c_blue$_c_bold" "$_rule" "$_c_reset"
    printf '%s  %s%s\n' "$_c_blue$_c_bold" "$1" "$_c_reset"
    printf '%s%s%s\n' "$_c_blue$_c_bold" "$_rule" "$_c_reset"
}

# A step within a phase, e.g. "Desktop apps".
step() {
    printf '\n%s▶ %s%s\n' "$_c_bold" "$1" "$_c_reset"
}

# A step finished successfully.
ok() {
    printf '%s✓ %s%s\n' "$_c_green" "$1" "$_c_reset"
}

# Nothing to do -- dimmed, so the things that *did* happen stand out.
skip() {
    printf '%s· %s%s\n' "$_c_dim" "$1" "$_c_reset"
}
