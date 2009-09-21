#!/bin/sh
# Copyright (C) 2006 OpenWrt.org

#DEBUG="echo"

add_ofswitch_port() {
	local config="$1"
	local port="$2"

	config_get dp "$config" dp
	[ -z "$dp" -o -z "$port" ] && return 0
	dpctl show "$dp" >/dev/null 2>/dev/null && {
		$DEBUG dpctl addif "$dp" "$port"
	}
}

add_ofswitch_datapath() {
	local config="$1"
	
	config_get dp "$config" dp
	[ -n "$dp" ] && {
		dpctl show "$dp" >/dev/null 2>/dev/null || $DEBUG dpctl adddp "$dp"
	}
}

remove_ofswitch_datapath() {
	local config="$1"

	config_get dp "$config" dp
	[ -n "$dp" ] && {
		dpctl show "$dp" >/dev/null 2>/dev/null && $DEBUG dpctl deldp "$dp"
	}
}

setup_ofswitch() {
	local config="$1"
	local port ofports

	config_get ofports "$config" ofports
	
	echo "$config $ofports and $port"	
	add_ofswitch_datapath "$config"

	for port in $ofports
	do
		add_ofswitch_port "$config" "$port"
	done
}

remove_ofswitch() {
	local config="$1"

	remove_ofswitch_datapath "$config"
}

