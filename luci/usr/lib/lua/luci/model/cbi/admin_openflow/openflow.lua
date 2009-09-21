--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--
m = Map("openflow", translate("openflow"),"OpenFlow is a way for researchers  to run experimental protocols in the networks they use every day. OpenFlow is based on an Ethernet switch or WiFi access point, with an internal flow-table and a standardized interface to add and remove flow entries. Network switch vendors will add OpenFlow to their switch products for deployment in college campus backbones and wiring closets. OpenFlow is a pragmatic compromise: it allows researchers to run experiments on a variety of switches and access points in a uniform way at line-rate and with high port-density.")

s = m:section(TypedSection, "ofswitch", "")

s.anonymous = true

s:option(Value, "ofports", "Openflow Ports")
s:option(Value, "ofctl", "Controller")
s:option(Value, "dp", "Datapath")
s:option(Value, "proto", "Protocol")
s:option(Value, "ipaddr", "IP Address")
s:option(Value, "netmask", "Netmask")
s:option(Value, "gateway", "Gateway")
s:option(Value, "macaddr", "MAC Address")

return m
