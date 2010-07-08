#!/bin/sh
# Copyright (C) 2009 OpenFlowSwitch.org

setup_ofprotocol() {
	local config="$1"
	local ofctl
	local dp

	[ -x "/usr/bin/ofprotocol" ] || ( echo "ofprotocol not executable" && return 0 )
	config_get ofctl "$config" ofctl
	config_get dp "$config" dp
	config_get mode "$config" mode


	pidfile="/var/run/ofprotocol.pid"
	# prevent ofprotocol from starting more than once
	lock "/var/lock/ofprotocol"

	pid="$(cat "$pidfile" 2>/dev/null)"

	if [ -d "/proc/$pid" ] && grep ofprotocol "/proc/${pid}/cmdline" >/dev/null 2>/dev/null; then
		lock -u "/var/lock/ofprotocol"
	else
		[ -z "$dp" -o -z "$ofctl" ] && echo "no controller specified" && return 1
		if [[ "$mode" == "router" ]]
		then
			ofprotocol unix:/var/run/"$dp".sock "$ofctl" --fail=closed "-D" "--pidfile=$pidfile" --out-of-band &
		else
			ofprotocol unix:/var/run/"$dp".sock "$ofctl" --fail=closed "-D" "--pidfile=$pidfile" &
		fi
		lock -u "/var/lock/ofprotocol"
	fi
}


setup_box() {
	local config="$1"
	local mode
	
	config_get mode "$config" mode
	
	if [[ "$mode" == "router" ]]
	then
		setup_outband_control "$1"
	else
		setup_inband_control "$1"
	fi
}

setup_inband_control() {
	local config="$1"
	local ipaddr
	local netmask
	
	config_get ipaddr "$config" ipaddr
	config_get netmask "$config" netmask
	config_get gateway "$config" gateway

	echo "Configuring local device with ip $ipaddr and netmask $netmask"	
	ifconfig tap0 $ipaddr netmask $netmask up
	route add default gw $gateway
}
	
setup_outband_control() {
	local config="$1"
	
	config_get ipaddr "$config" ipaddr
	config_get netmask "$config" netmask
	
	vethd -e tap0 -v veth0
	ifconfig veth0 $ipaddr netmask $netmask up	

}	
	
	
	
	
	
	
