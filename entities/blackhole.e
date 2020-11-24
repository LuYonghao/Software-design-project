note
	description: "Summary description for {BLACKHOLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BLACKHOLE
inherit
	STATIONARY
create
	make_blackhole
feature
	make_blackhole
		do
			item := 'O'
			id := -1
		end
end
