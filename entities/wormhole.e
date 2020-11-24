note
	description: "Summary description for {WORMHOLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORMHOLE
inherit
	STATIONARY
create
	make_wormhole
feature
	make_wormhole
		do
			item := 'W'
		end
end
