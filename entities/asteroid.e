note
	description: "Summary description for {ASTEROID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ASTEROID
inherit
	MOVABLE
		redefine
			movement, behave,check_alive
		end
create
	make_asteroid
feature
	fucking_someone: STRING
feature
	make_asteroid
		do
			make_movable_entity
			item := 'A'
			fucking_someone:=""
		end
feature
	movement
		local
			direction : INTEGER
			r_g : RANDOM_GENERATOR_ACCESS
		do
			if is_alive then
				direction := r_g.rchoose (1, 8)
				move_entity(direction)
			end
		end
	behave
		local
			r_gen : RANDOM_GENERATOR_ACCESS
		do
			behaver
			turns_left := r_gen.rchoose(0, 2)
		end
	behaver
		do
			fucking_someone:= ""
			across
				id_low_high is ilh
			loop
				if ilh.is_malevolent or ilh.is_benign or ilh.is_janitaur or (ilh.is_explorer and not this_game.m.my_explorer.is_on_land) then
					check attached {MOVABLE} ilh as il then
						il.go_die
						this_game.m.death_list.extend (il)
						il.set_death_way(current.item)
						fucking_someone := fucking_someone + "%N      destroyed ["+ il.id.out + "," + il.item.out +"] at [" + il.row.out +"," + il.col.out+","+(il.pos+1).out+"]"
						killed_sth:= true
						il.my_last_word (id)
					end
				end
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
end
