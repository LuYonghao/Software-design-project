note
	description: "Summary description for {BENIGN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BENIGN
inherit
	MOVABLE
		redefine
			reproduce, check_alive, movement, behave
		end
create
	make_benign
feature
	fuel: INTEGER
	max_fuel: INTEGER = 3
	reproduce_entity_info: STRING
	fucking_someone: STRING
feature
	make_benign
		do
			make_movable_entity
			item := 'B'
			actions_left := 1
			fuel := 3
			reproduce_entity_info := ""
			fucking_someone:=""
		end
feature
	reproduce
		local
			r_gen : RANDOM_GENERATOR_ACCESS
			temp_turns_left : INTEGER
			new_copy : BENIGN
			temp_ea: ENTITY
			cur_index: INTEGER
		do
			create temp_ea.make_dummy
			if ((not this_game.m.my_galaxy.grid[row, col].is_full) or this_game.m.my_galaxy.grid[row,col].has_dummy) and actions_left ~ 0 then
				create new_copy.make_benign
				reproduced := true

				if this_game.m.my_galaxy.grid[row, col].contents.has (temp_ea) then
					cur_index := this_game.m.my_galaxy.grid[row, col].contents.index_of (temp_ea, 1) - 1
					this_game.m.my_galaxy.grid[row, col].contents.array_put (new_copy, cur_index)
				else
					this_game.m.my_galaxy.grid[row, col].contents.extend (new_copy)
					cur_index := this_game.m.my_galaxy.grid[row, col].contents.count - 1
				end
				new_copy.set_position (row, col, cur_index)

				temp_turns_left := r_gen.rchoose(0, 2)
				new_copy.set_turn (temp_turns_left)

				this_game.m.movable_entities.extend (new_copy)
				new_copy.set_id (this_game.m.set_next_id)
				reproduce_entity_info := "%N      reproduced ["+ new_copy.id.out + "," + new_copy.item.out +"] at [" + new_copy.row.out +"," + new_copy.col.out+","+(new_copy.pos+1).out+"]"
				new_copy.unmovable_baby
				this_game.m.every_thing.extend (new_copy)

				actions_left := 1
			else
				if actions_left /~ 0 then
					actions_left := actions_left - 1
				elseif this_game.m.my_galaxy.grid[row, col].is_full and (not this_game.m.my_galaxy.grid[row,col].has_dummy) then
					--do nothing
				end
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
				this_game.m.death_list.extend (current)
				dead_now
				create temp_ea.make_dummy
				this_game.m.my_galaxy.grid[row, col].contents.array_put (temp_ea, pos)
				this_game.m.my_galaxy.grid[row, col].contents.prune (current)
			end
		end
	movement
		local
			direction : INTEGER
			r_g : RANDOM_GENERATOR_ACCESS
		do
			if is_alive then
				direction := r_g.rchoose (1, 8)
				move_entity(direction)
				if moved then
					fuel_consume
				end
			end
		end
feature
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
				id_low_high is cpp
			loop
				if cpp.is_malevolent then
					check attached {MALEVOLENT} cpp as cp then
						cp.go_die
						cp.set_death_way(current.item)
						this_game.m.death_list.extend (cp)
						fucking_someone := fucking_someone + "%N      destroyed ["+ cp.id.out + "," + cp.item.out +"] at [" + cp.row.out +"," + cp.col.out+","+(cp.pos+1).out+"]"
						killed_sth := true
						cp.he_is_hero(id)
					end
				end
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
end
