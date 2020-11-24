note
	description: "Summary description for {EXPLORER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER
inherit
	MOVABLE
		redefine
			check_alive
		end
create
	make_explorer
feature
	is_on_land: BOOLEAN
	fuel : INTEGER
	max_fuel : INTEGER = 3
	life_units: INTEGER

	--test value
--	wantgor: INTEGER
--	wantgoc: INTEGER
--	wantgoi: INTEGER
feature
	make_explorer
		do
			make_movable_entity
			item := 'E'
			fuel := 3
			life_units := 3
			is_on_land := false
		end
feature
	move(dir: INTEGER)
		do
			move_entity(dir)
			if moved then
				fuel_consume
			end
		end
	check_alive
		local
			temp_ea: ENTITY
		do
			fuel_refill
			if fuel ~ 0 then
				this_game.m.death_list.extend (current)
				is_alive := false
			end
			if life_units ~ 0 then
				this_game.m.death_list.extend (current)
				is_alive := false
			end
			if
				this_game.m.my_galaxy.grid[row, col].has_blackhole
			then
				this_game.m.death_list.extend (current)
				is_alive := false
			end

			-- remove ent from game
			if
				not is_alive
			then
				dead_now
				create temp_ea.make_dummy
				this_game.m.my_galaxy.grid[row, col].contents.array_put (temp_ea, pos)
				this_game.m.my_galaxy.grid[row, col].contents.prune (current)
			end
		end
feature-- help function
	fuel_consume
		do
			fuel := fuel - 1
		end
	fuel_refill
		do
			if this_game.m.my_galaxy.grid[row, col].has_star then
				if
					this_game.m.my_galaxy.grid[row, col].has_yd and (fuel + 2 < 3)
				then
					fuel := fuel + 2
				else
					fuel := 3
				end
			end
		end
	get_land
		do
			is_on_land := true
		end

	off_land
		do
			is_on_land := false
		end
	get_kicked_ass
		do
			life_units := life_units - 1
		end

end
