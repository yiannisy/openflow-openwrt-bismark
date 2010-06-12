#!/bin/sh
# Copyright (C) 2006 OpenWrt.org

#DEBUG="echo"

add_ofswitch_datapath() {
	local config="$1"
	local ofports
	local dpports
	local dp

	config_get ofports "$config" ofports
	config_get dp "$config" dp

	dpports=`echo "$ofports" | tr ' ' ','`
	echo "$dpports"

	[ -n "$dpports" ] && {
		ofdatapath punix:/var/run/"$dp".sock -i "$dpports" --no-slicing --local-port=tap:tap0 &
	}
}

setup_ofswitch() {
	local config="$1"

	add_ofswitch_datapath "$config"
}
		
