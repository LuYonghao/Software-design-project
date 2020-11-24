note
	description: "Summary description for {ERROR_DETECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERROR_DETECTOR
create
	make
feature
	error_happen: BOOLEAN
	in_game: BOOLEAN
	current_error: STRING
feature
	this_game: ETF_MODEL_ACCESS
feature
	make
		do
			in_game := false
			error_happen := false
			create current_error.make_empty
		end
feature
	detect_refresh
		do
			current_error := ""
			error_happen := false
		end
	detect_play_error(a, j, m, b, p:INTEGER)
		do
			detect_refresh
			if in_game then
				error_happen := true
				current_error := "already in game"
			elseif not(a <= j and j <= m and m <= b and b <= p) then
				error_happen := true
				current_error := "thresholds number error"
			else
				in_game := true
			end
		end
	detect_move_error(dir: INTEGER_32)
		do
			detect_refresh
			if not in_game then
				current_error := "not in game"
				error_happen := true
			elseif this_game.m.my_explorer.is_on_land then
				current_error := "exp on land"
				error_happen := true
			else
				this_game.m.my_explorer.test_targer_full (dir)
				if this_game.m.my_explorer.target_is_full then
					current_error := "target full"
					error_happen := true
				end
			end
		end
	detect_pass_error
		do
			detect_refresh
			if not in_game then
				error_happen := true
				current_error := "not in game"
			end
		end
	detect_wormhole_error
		do
			detect_refresh
			if not in_game then
				error_happen := true
				current_error := "not in game"
			elseif this_game.m.my_explorer.is_on_land then
				current_error := "exp on land"
				error_happen := true
			elseif not this_game.m.my_galaxy.grid[this_game.m.my_explorer.row,this_game.m.my_explorer.col].has_wormhole then
				current_error := "no wormhole"
				error_happen := true
			end
		end
	detect_abort_error
		do
			detect_refresh
			if not in_game then
				error_happen := true
				current_error := "not in game"
			else
				in_game := false
			end
		end
	detect_land_error
		do
			detect_refresh
			if not in_game then
				error_happen := true
				current_error := "not in game"
			elseif this_game.m.my_explorer.is_on_land then
				current_error := "already landed"
				error_happen := true
			elseif not this_game.m.my_galaxy.grid[this_game.m.my_explorer.row,this_game.m.my_explorer.col].has_yd then
				current_error := "no yellowdwarf"
				error_happen := true
			elseif not this_game.m.my_galaxy.grid[this_game.m.my_explorer.row,this_game.m.my_explorer.col].has_p then
				current_error := "no planet"
				error_happen := true
			elseif not this_game.m.my_galaxy.grid[this_game.m.my_explorer.row,this_game.m.my_explorer.col].has_unvisited_attached_planet then
				current_error := "no unvisited attached planet"
				error_happen := true
			end
		end
	detect_liftoff_error
		do
			detect_refresh
			if not in_game then
				error_happen := true
				current_error := "not in game"
			elseif not this_game.m.my_explorer.is_on_land then
				current_error := "not on land"
				error_happen := true
			end
		end
	detect_status_error
		do
			detect_refresh
			if not in_game then
				error_happen := true
				current_error := "not in game"
			end
		end
feature
	reset_game
		do
			in_game := false
		end
	restart_game
		do
			in_game := true
		end
end
