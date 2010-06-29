#!/bin/sh
# Copyright (C) 2006 OpenWrt.org

#DEBUG="echo"

add_ofswitch_datapath() {
	local config="$1"
	local ofports
	local dpports
	local dp
	local mode

	config_get ofports "$config" ofports
	config_get dp "$config" dp
	config_get mode "$config" mode


	dpports=`echo "$ofports" | tr ' ' ','`
	echo "$dpports"

	[ -n "$dpports" ] && {
		if [[ "$mode" == "router" ]]
		then
			echo "entering router mode"
			ofdatapath punix:/var/run/"$dp".sock -i "$dpports" --no-slicing --no-local-port --pidfile &
		else
			echo "entering switch mode"
			ofdatapath punix:/var/run/"$dp".sock -i "$dpports" --no-slicing --local-port=tap:tap0 --pidfile &
		fi
	}
}

setup_ofswitch() {
	local config="$1"

	add_ofswitch_datapath "$config"
}
		
