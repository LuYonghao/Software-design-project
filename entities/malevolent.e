note
	description: "Summary description for {MALEVOLENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MALEVOLENT
inherit
	MOVABLE
		redefine
			reproduce, check_alive, movement, behave
		end
create
	make_malevolent
feature
	fuel: INTEGER
	max_fuel: INTEGER = 3
	reproduce_entity_info: STRING
	fucking_someone: STRING
feature
	make_malevolent
		do
			make_movable_entity
			item := 'M'
			actions_left := 1
			fuel := 3
			reproduce_entity_info := ""
			fucking_someone := ""
		end
feature
	reproduce
		local
			r_gen : RANDOM_GENERATOR_ACCESS
			temp_turns_left : INTEGER
			new_copy : MALEVOLENT
			temp_ea: ENTITY
			cur_index: INTEGER
		do
			create temp_ea.make_dummy
			if ((not this_game.m.my_galaxy.grid[row, col].is_full) or this_game.m.my_galaxy.grid[row,col].has_dummy) and actions_left ~ 0 then
				create new_copy.make_malevolent
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
			fucking_someone:= ""
			if this_game.m.my_galaxy.grid[row,col].has_explorer and
				not this_game.m.my_galaxy.grid[row,col].has_benign and
				not this_game.m.my_explorer.is_on_land
			then
				this_game.m.my_explorer.get_kicked_ass
				killed_sth := true
				fucking_someone := fucking_someone + "%N      attacked [0,E] at [" + this_game.m.my_explorer.row.out +"," + this_game.m.my_explorer.col.out +","+ (this_game.m.my_explorer.pos+1).out + "]"
				if this_game.m.my_explorer.life_units ~ 0 then
					this_game.m.my_explorer.go_die
					this_game.m.death_list.extend (this_game.m.my_explorer)
				end
			end
			turns_left := r_gen.rchoose(0, 2)
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
feature
	hero : INTEGER
	he_is_hero(a_hero: INTEGER)
		do
			hero := a_hero
		end
end
