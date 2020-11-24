note
	description: "Summary description for {BLUE_GIANT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BLUE_GIANT
inherit
	STAR
create
	make_blue_giant
feature
	make_blue_giant
		do
			item := '*'
			luminosity := 5
		end
end
