note
	description: "Summary description for {YELLOW_DWARF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	YELLOW_DWARF
inherit
	STAR
create
	make_yellow_dwarf
feature
	make_yellow_dwarf
		do
			item := 'Y'
			luminosity := 2
		end
end
