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
module("luci.controller.admin.openflow", package.seeall)

function index()
		luci.i18n.loadc("admin-core")
		local i18n = luci.i18n.translate
	
		local page  = node("admin", "openflow")
		page.target = alias("admin", "openflow", "openflow")
		page.title  = "OpenFlow"
		page.order  = 40
		page.index  = true

		if nixio.fs.access("/etc/config/openflow") then
			local page  = node("admin", "openflow", "openflow")
			page.target = cbi("admin_openflow/openflow")
			page.title  = "OpenFlow Switch"
			page.order  = 11
		end
end
