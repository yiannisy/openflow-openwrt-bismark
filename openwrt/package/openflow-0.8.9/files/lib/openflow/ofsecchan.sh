#!/bin/sh
# Copyright (C) 2009 OpenFlowSwitch.org

setup_ofsecchan() {
	local iface="$1"
	local config="$2"

	[ -x "/usr/bin/secchan" ] || ( echo "secchan not executable" && return 0 )
	config_get ofctl "$config" ofctl
	config_get dp "$config" dp

	pidfile="/var/run/secchan-${iface}.pid"
	# prevent secchan from starting more than once
	lock "/var/lock/secchan-$iface"

	pid="$(cat "$pidfile" 2>/dev/null)"
	if [ -d "/proc/$pid" ] && grep secchan "/proc/${pid}/cmdline" >/dev/null 2>/dev/null; then
		lock -u "/var/lock/secchan-$iface"
	else
		[ -z "$dp" -o -z "$ofctl" ] && echo "no datapath or controller specified" && return 1
		secchan "$dp" "$ofctl" "-D" "--pidfile=$pidfile" &
		lock -u "/var/lock/secchan-$iface"
	fi
}


