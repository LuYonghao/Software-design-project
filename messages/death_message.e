note
	description: "Summary description for {DEATH_MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	DEATH_MESSAGE
inherit
	ANY
		redefine
			out
		end
feature
	this_game: ETF_MODEL_ACCESS
feature
	out: STRING
		do
			Result := ""
			if not this_game.m.my_explorer.is_alive then
				Result := "%N  "
				if this_game.m.my_explorer.fuel ~ 0 then
					Result := Result + "Explorer got lost in space - out of fuel at Sector:" + this_game.m.my_explorer.row.out
					Result := Result + ":" + this_game.m.my_explorer.col.out
				elseif this_game.m.my_explorer.row ~ 3 and this_game.m.my_explorer.col ~ 3 then
					Result := Result + "Explorer got devoured by blackhole (id: -1) at Sector:" + this_game.m.my_explorer.row.out
					Result := Result + ":" + this_game.m.my_explorer.col.out
--				elseif this_game.m.my_galaxy.grid[this_game.m.my_explorer.row,this_game.m.my_explorer.col].has_asteroid then
				elseif this_game.m.my_explorer.death_way ~ 'A' then
					Result := Result + "Explorer got destroyed by asteroid (id: " + this_game.m.my_explorer.killer_id.out + ") at Sector:" + this_game.m.my_explorer.row.out
					Result := Result + ":" + this_game.m.my_explorer.col.out
				elseif this_game.m.my_explorer.life_units ~ 0 then
					Result := Result + "Explorer got lost in space - out of life support at Sector:" + this_game.m.my_explorer.row.out
					Result := Result + ":" + this_game.m.my_explorer.col.out
				end
				Result := Result + "%N  The game has ended. You can start a new game."
				this_game.m.my_detector.reset_game
			end
		end

end
