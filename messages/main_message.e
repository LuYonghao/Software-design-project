note
	description: "Summary description for {MAIN_MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	MAIN_MESSAGE
inherit
	ANY
		redefine
			out
		end
feature
	this_game: ETF_MODEL_ACCESS
	dead_turn: BOOLEAN
feature
	change_pos_info: STRING
		do
			if this_game.m.my_detector.in_game then
				Result := "%N  Movement:"
				across
					this_game.m.every_thing is mov
				loop
					if mov.is_movable then
						check attached{MOVABLE} mov as mve then
							if mve.try_to_move then
								Result := Result + mve.get_values
								if mve.reproduced then
									mve.end_reproduce
								end
								if mve.killed_sth then
									mve.clean_dead_body
								end
								mve.done_trying
							end
						end

					end

				end

				if
					Result ~ "%N  Movement:"
				then
					Result := Result + "none"
				end
			else
				Result := ""
			end

		end
	show_all_info: STRING
		local
			r,c,ii : INTEGER
		do
			Result := "%N  Sectors:"
			ii := 1
			from
				r := 1
			until
				r > 5
			loop
				from
					c := 1
				until
					c > 5
				loop
					Result := Result + "%N    [" + r.out + "," + c.out + "]->"
					across
						this_game.m.my_galaxy.grid[r,c].contents is mgc
					loop
						if mgc.is_stationary or mgc.is_movable then
							Result := Result +"["+ mgc.id.out + ","
							Result := Result + mgc.item.out + "],"
						else
							Result := Result + mgc.item.out + ","
						end
						ii := ii + 1
					end

					from
					until
						ii > 4
					loop
						Result := Result + "-,"
						ii := ii + 1
					end
					ii := 1

					Result.remove_tail(1)

					c := c + 1
				end
				r := r + 1
			end
			Result := Result + "%N  Descriptions:"
			across
				this_game.m.every_thing is et
			loop
--				Result := Result + "%N    ["+et.id.out+","+et.item.out+"]->"
				if et.is_stationary and not et.is_star then
					Result := Result + "%N    ["+et.id.out+","+et.item.out+"]->"
				end
				if et.is_star then
					check attached {STAR} et as ett then
						Result := Result + "%N    ["+et.id.out+","+et.item.out+"]->"
						Result := Result + "Luminosity:" + ett.luminosity.out
					end
				end
				if et.is_explorer then
					check attached {EXPLORER} et as ett then
						if ett.is_alive then
							Result := Result + "%N    ["+et.id.out+","+et.item.out+"]->"
							Result := Result + "fuel:" + ett.fuel.out + "/3, "
							Result := Result + "life:" + ett.life_units.out + "/3, "
							Result := Result + "landed?:" + ett.is_on_land.out[1].out
						end
					end
				end
				if et.is_planet then
					check attached {PLANET} et as ett then
						if ett.is_alive then
							Result := Result + "%N    ["+et.id.out+","+et.item.out+"]->"
							Result := Result + "attached?:" + ett.is_attached.out[1].out + ", "
							Result := Result + "support_life?:" + ett.is_support_life.out[1].out + ", "
							Result := Result + "visited?:" + ett.visited.out[1].out + ", "
							if ett.is_attached or ett.turns_left < 0 then
								Result := Result + "turns_left:N/A"
							else
								Result := Result + "turns_left:" + ett.turns_left.out
							end
						end
					end
				end
				if et.is_benign then
					check attached{BENIGN} et as ett then
						if ett.is_alive then
							Result := Result + "%N    ["+et.id.out+","+et.item.out+"]->"
							Result := Result + "fuel:" + ett.fuel.out + "/3, "
							Result := Result + "actions_left_until_reproduction:" + ett.actions_left.out + "/1, "
							Result := Result + "turns_left:" + ett.turns_left.out
						end
					end
				end
				if et.is_janitaur then
					check attached{JANITAUR} et as ett then
						if ett.is_alive then
							Result := Result + "%N    ["+et.id.out+","+et.item.out+"]->"
							Result := Result + "fuel:" + ett.fuel.out + "/5, "
							Result := Result + "load:" + ett.load.out + "/2, "
							Result := Result + "actions_left_until_reproduction:" + ett.actions_left.out + "/2, "
							Result := Result + "turns_left:" + ett.turns_left.out
						end
					end
				end
				if et.is_asteroid then
					check attached{ASTEROID} et as ett then
						if ett.is_alive then
							Result := Result + "%N    ["+et.id.out+","+et.item.out+"]->"
							Result := Result + "turns_left:" + ett.turns_left.out
						end
					end
				end
				if et.is_malevolent then
					check attached{MALEVOLENT} et as ett then
						if ett.is_alive then
							Result := Result + "%N    ["+et.id.out+","+et.item.out+"]->"
							Result := Result + "fuel:" + ett.fuel.out + "/3, "
							Result := Result + "actions_left_until_reproduction:" + ett.actions_left.out + "/1, "
							Result := Result + "turns_left:" + ett.turns_left.out
						end
					end
				end
			end
			Result := Result + "%N  Deaths This Turn:"----------------------------------------------------
			dead_turn:= false
			across
				this_game.m.death_list is et
			loop
				if et.is_planet then
					check attached {PLANET} et as ett then
						if ett.death_this_turn then
							dead_turn := true
							Result := Result + "%N    [" + ett.id.out + "," + ett.item.out+"]->"
							Result := Result + "attached?:" + ett.is_attached.out[1].out + ", "
							Result := Result + "support_life?:" + ett.is_support_life.out[1].out + ", "
							Result := Result + "visited?:" + ett.visited.out[1].out + ", "
							Result := Result + "turns_left:N/A,"
							Result := Result + "%N      Planet got devoured by blackhole (id: -1) at Sector:3:3"
							ett.pass_dead
						end
					end
				end
				if et.is_benign then
					check attached {BENIGN} et as ett then
						if ett.death_this_turn then
							dead_turn := true
							Result := Result + "%N    [" + ett.id.out + "," + ett.item.out+"]->"
							Result := Result + "fuel:" + ett.fuel.out + "/3, "
							Result := Result + "actions_left_until_reproduction:" + ett.actions_left.out + "/1, "
							Result := Result + "turns_left:N/A,"

							if ett.fuel ~ 0 then
								Result := Result + "%N      Benign got lost in space - out of fuel at Sector:" + ett.row.out
								Result := Result + ":" + ett.col.out
							elseif ett.row ~ 3 and ett.col ~ 3 then
								Result := Result + "%N      Benign got devoured by blackhole (id: -1) at Sector:" + ett.row.out
								Result := Result + ":" + ett.col.out
--							elseif this_game.m.my_galaxy.grid[ett.row,ett.col].has_asteroid --then---------------
--							and ett.death_way ~ 'A' then
							elseif ett.death_way ~ 'A' then

								Result := Result + "%N      Benign got destroyed by asteroid (id: " + ett.killer_id.out + ") at Sector:" + ett.row.out
								Result := Result + ":" + ett.col.out
							end
							ett.pass_dead
						end
					end
				end
				if et.is_malevolent then
					check attached {MALEVOLENT} et as ett then
						if ett.death_this_turn then
							dead_turn := true
							Result := Result + "%N    [" + ett.id.out + "," + ett.item.out+"]->"
							Result := Result + "fuel:" + ett.fuel.out + "/3, "
							Result := Result + "actions_left_until_reproduction:" + ett.actions_left.out + "/1, "
							Result := Result + "turns_left:N/A,"

							if ett.fuel ~ 0 then
								Result := Result + "%N      Malevolent got lost in space - out of fuel at Sector:" + ett.row.out
								Result := Result + ":" + ett.col.out
							elseif ett.row ~ 3 and ett.col ~ 3 then
								Result := Result + "%N      Malevolent got devoured by blackhole (id: -1) at Sector:" + ett.row.out
								Result := Result + ":" + ett.col.out
--							elseif this_game.m.my_galaxy.grid[ett.row,ett.col].has_asteroid --then--------------
--							and ett.death_way ~ 'A' then
							elseif ett.death_way ~ 'A' then

								Result := Result + "%N      Malevolent got destroyed by asteroid (id: " + ett.killer_id.out + ") at Sector:" + ett.row.out
								Result := Result + ":" + ett.col.out
--							elseif this_game.m.my_galaxy.grid[ett.row,ett.col].has_benign --then--------------
--							and ett.death_way ~ 'B' then
							elseif ett.death_way ~ 'B' then

								Result := Result + "%N      Malevolent got destroyed by benign (id: " + ett.hero.out + ") at Sector:" + ett.row.out
								Result := Result + ":" + ett.col.out
							end
							ett.pass_dead
						end
					end
				end
				if et.is_janitaur then
					check attached {JANITAUR} et as ett then
						if ett.death_this_turn then
							dead_turn := true
							Result := Result + "%N    [" + ett.id.out + "," + ett.item.out+"]->"
							Result := Result + "fuel:" + ett.fuel.out + "/5, "
							Result := Result + "load:" + ett.load.out + "/2, "
							Result := Result + "actions_left_until_reproduction:" + ett.actions_left.out + "/2, "
							Result := Result + "turns_left:N/A,"

							if ett.fuel ~ 0 then
								Result := Result + "%N      Janitaur got lost in space - out of fuel at Sector:" + ett.row.out
								Result := Result + ":" + ett.col.out
							elseif ett.row ~ 3 and ett.col ~ 3 then
								Result := Result + "%N      Janitaur got devoured by blackhole (id: -1) at Sector:" + ett.row.out
								Result := Result + ":" + ett.col.out
--							elseif this_game.m.my_galaxy.grid[ett.row,ett.col].has_asteroid and--then ---------------------------
--								ett.death_way ~ 'A' then
							elseif ett.death_way ~ 'A' then

								Result := Result + "%N      Janitaur got destroyed by asteroid (id: " + ett.killer_id.out + ") at Sector:" + ett.row.out
								Result := Result + ":" + ett.col.out
							end
							ett.pass_dead
						end
					end
				end
				if et.is_asteroid then
					check attached {ASTEROID} et as ett then
						if ett.death_this_turn then
							dead_turn := true
							Result := Result + "%N    [" + ett.id.out + "," + ett.item.out+"]->"
							Result := Result + "turns_left:N/A,"

							if ett.row ~ 3 and ett.col ~ 3 then
								Result := Result + "%N      Asteroid got devoured by blackhole (id: -1) at Sector:" + ett.row.out
								Result := Result + ":" + ett.col.out
--							elseif this_game.m.my_galaxy.grid[ett.row,ett.col].has_janitaur and --then ------------------------------
--								ett.death_way ~ 'J' then
							elseif ett.death_way ~ 'J' then
								Result := Result + "%N      Asteroid got imploded by janitaur (id: " + ett.killer_id.out + ") at Sector:" + ett.row.out
								Result := Result + ":" + ett.col.out
							end
							ett.pass_dead
						end
					end
				end
				if et.is_explorer then
					check attached {EXPLORER} et as ett then
						if ett.death_this_turn then
							dead_turn := true
							Result := Result + "%N    ["+et.id.out+","+et.item.out+"]->"
							Result := Result + "fuel:" + ett.fuel.out + "/3, "
							Result := Result + "life:" + "0/3, "
							Result := Result + "landed?:" + ett.is_on_land.out[1].out + ","

							if this_game.m.my_explorer.fuel ~ 0 then
								Result := Result + "%N      Explorer got lost in space - out of fuel at Sector:" + this_game.m.my_explorer.row.out
								Result := Result + ":" + this_game.m.my_explorer.col.out
							elseif this_game.m.my_explorer.row ~ 3 and this_game.m.my_explorer.col ~ 3 then
								Result := Result + "%N      Explorer got devoured by blackhole (id: -1) at Sector:" + this_game.m.my_explorer.row.out
								Result := Result + ":" + this_game.m.my_explorer.col.out
--							elseif this_game.m.my_galaxy.grid[this_game.m.my_explorer.row,this_game.m.my_explorer.col].has_asteroid and--then-------------
--								ett.death_way ~ 'A' then
							elseif ett.death_way ~ 'A' then
								Result := Result + "%N      Explorer got destroyed by asteroid (id: " + this_game.m.my_explorer.killer_id.out + ") at Sector:" + this_game.m.my_explorer.row.out
								Result := Result + ":" + this_game.m.my_explorer.col.out
							elseif this_game.m.my_explorer.life_units ~ 0 then
								Result := Result + "%N      Explorer got lost in space - out of life support at Sector:" + this_game.m.my_explorer.row.out
								Result := Result + ":" + this_game.m.my_explorer.col.out
							end
							ett.pass_dead
						end
					end
				end
			end
			this_game.m.death_list.wipe_out
			if not dead_turn then
				Result := Result + "none"
			end
		end
feature
	out:STRING
		do
			Result := ""
			if this_game.m.current_action ~ "" then
				Result := "%N  Welcome! Try test(3,5,7,15,30)"
			end

			if this_game.m.my_detector.in_game then
				if this_game.m.current_action ~ "play" or this_game.m.current_action ~ "test" or this_game.m.current_action ~ "move"
					or this_game.m.current_action ~ "wormhole" or this_game.m.current_action ~ "pass"
				then
					Result := ""
				elseif this_game.m.current_action ~ "status" then
					Result := "%N  "
					if not this_game.m.my_explorer.is_on_land then
						Result := Result + "Explorer status report:Travelling at cruise speed at ["
					else
						Result := Result + "Explorer status report:Stationary on planet surface at ["
					end
					Result := Result + this_game.m.my_explorer.row.out + ","
					Result := Result + this_game.m.my_explorer.col.out + ","
					Result := Result + (this_game.m.my_explorer.pos + 1).out + "]"
					Result := Result + "%N  Life units left:" + this_game.m.my_explorer.life_units.out
					Result := Result + ", Fuel units left:" + this_game.m.my_explorer.fuel.out
				elseif this_game.m.current_action ~ "land" then
					if this_game.m.is_win then
						Result := "%N  Tranquility base here - we've got a life!"
						this_game.m.my_detector.reset_game
					else
						Result := "%N  Explorer found no life as we know it at Sector:" + this_game.m.my_explorer.row.out
						Result := Result + ":" + this_game.m.my_explorer.col.out
					end
				elseif this_game.m.current_action ~ "liftoff" then
					Result := "%N  Explorer has lifted off from planet at Sector:" + this_game.m.my_explorer.row.out
					Result := Result + ":" + this_game.m.my_explorer.col.out
				end
			elseif this_game.m.current_action ~ "abort" then
				Result := "%N  Mission aborted. Try test(3,5,7,15,30)"
			end
			this_game.m.reset_current_action
		end
end
