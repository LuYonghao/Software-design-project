note
	description: "Summary description for {ERROR_MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	ERROR_MESSAGE
inherit
	ANY
		redefine
			out
		end
feature
	this_game: ETF_MODEL_ACCESS
feature
	out: STRING
		local
			current_error: STRING
		do
			Result := ""
			current_error:= this_game.m.my_detector.current_error
			if current_error ~ "already in game" then
				Result := "%N  To start a new mission, please abort the current one first."
			end
			if current_error ~ "not in game" then
				Result := "%N  Negative on that request:no mission in progress."
			end
			if current_error ~ "exp on land" then
				Result := "%N  Negative on that request:you are currently landed at Sector:" + this_game.m.my_explorer.row.out + ":" + this_game.m.my_explorer.col.out
			end
			if current_error ~ "target full" then
				Result := "%N  Cannot transfer to new location as it is full."
			end
			if current_error ~ "no wormhole" then
				Result := "%N  Explorer couldn't find wormhole at Sector:" + this_game.m.my_explorer.row.out + ":" + this_game.m.my_explorer.col.out
			end
			if current_error ~ "already landed" then
				Result := "%N  Negative on that request:already landed on a planet at Sector:" + this_game.m.my_explorer.row.out + ":" + this_game.m.my_explorer.col.out
			end
			if current_error ~ "no yellowdwarf" then
				Result := "%N  Negative on that request:no yellow dwarf at Sector:" + this_game.m.my_explorer.row.out + ":" + this_game.m.my_explorer.col.out
			end
			if current_error ~ "no planet" then
				Result := "%N  Negative on that request:no planets at Sector:" + this_game.m.my_explorer.row.out + ":" + this_game.m.my_explorer.col.out
			end
			if current_error ~ "no unvisited attached planet" then
				Result := "%N  Negative on that request:no unvisited attached planet at Sector:" + this_game.m.my_explorer.row.out + ":" + this_game.m.my_explorer.col.out
			end
			if current_error ~ "not on land" then
				Result := "%N  Negative on that request:you are not on a planet at Sector:" + this_game.m.my_explorer.row.out + ":" + this_game.m.my_explorer.col.out
			end
			if current_error ~ "thresholds number error" then
				Result := "%N  Thresholds should be non-decreasing order."
			end
		end
end
