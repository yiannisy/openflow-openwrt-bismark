#!/bin/sh
# Copyright (C) 2009 OpenFlowSwitch.org

setup_ofprotocol() {
#	local iface="$1"
	local config="$1"
	local ofctl
	local dp

	[ -x "/usr/bin/ofprotocol" ] || ( echo "ofprotocol not executable" && return 0 )
	config_get ofctl "$config" ofctl
	config_get dp "$config" dp

	pidfile="/var/run/ofprotocol.pid"
	# prevent ofprotocol from starting more than once
	lock "/var/lock/ofprotocol"

	pid="$(cat "$pidfile" 2>/dev/null)"

	echo "My controller is $ofctl and datapath is $dp"

	if [ -d "/proc/$pid" ] && grep ofprotocol "/proc/${pid}/cmdline" >/dev/null 2>/dev/null; then
		lock -u "/var/lock/ofprotocol"
	else
		[ -z "$dp" -o -z "$ofctl" ] && echo "no datapath or controller specified" && return 1
		ofprotocol unix:/var/run/"$dp".sock "$ofctl" --fail=closed "-D" "--pidfile=$pidfile" &
		lock -u "/var/lock/ofprotocol"
	fi
}

setup_inband_control() {
	local config="$1"
	local ipaddr
	local netmask
	local proto
	
	config_get ipaddr "$config" ipaddr
	config_get netmask "$config" netmask
	config_get proto "$config" proto
	config_get gateway "$config" gateway

	echo "Configuring local device with ip $ipaddr and netmask $netmask"	
	ifconfig tap0 $ipaddr netmask $netmask up
	route add default gw $gateway
	
	#assume dhcp for now...
	#udhcpc -i tap0 -b
}
	
	
	
	
	
	
	
	
	
