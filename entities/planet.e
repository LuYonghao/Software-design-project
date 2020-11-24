note
	description: "Summary description for {PLANET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLANET
inherit
	MOVABLE
		redefine
			behave, get_attached,movement,
			get_life_support, lose_life_support,
			is_attached, check_alive
		end
create
	make_planet
feature
	visited: BOOLEAN
	is_attached: BOOLEAN
	is_support_life: BOOLEAN
feature
	make_planet
		do
			make_movable_entity
			visited := false
			is_attached := false
			is_support_life := false
			item := 'P'
		end
feature
	behave
		local
			num: INTEGER
			r_gen: RANDOM_GENERATOR_ACCESS
		do
			if this_game.m.my_galaxy.grid[row, col].has_star then
				get_attached
				if this_game.m.my_galaxy.grid[row, col].has_yd then
					num := r_gen.rchoose(1,2)
					if num = 2 then
						get_life_support
					else
						lose_life_support
					end
				end
			else
				turns_left := r_gen.rchoose(0, 2)
			end
		end
	movement
		local
			direction : INTEGER
			r_g : RANDOM_GENERATOR_ACCESS
		do
			if not is_attached then
				direction := r_g.rchoose (1, 8)
				move_entity(direction)
			end
		end
	check_alive
		-- ensures entity is alive after moving
		local
			temp_ea: ENTITY
		do
			-- meet black hole entity die
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

feature -- help function

	get_visited
		do
			visited := true
		end
	off_visited
		do
			visited := false
		end
	get_attached
		do
			is_attached := true
		end
	get_life_support
		do
			is_support_life := true
		end
	lose_life_support
		do
			is_support_life := false
		end
end
