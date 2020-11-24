note
	description: "Summary description for {MOVABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOVABLE
inherit
	ENTITY
feature
	moved: BOOLEAN
	try_to_move: BOOLEAN
	is_alive: BOOLEAN
	old_row: INTEGER
 	old_col: INTEGER
 	old_pos: INTEGER
 	target_is_full: BOOLEAN
 	death_this_turn : BOOLEAN
 	turns_left: INTEGER
feature --??
	this_game: ETF_MODEL_ACCESS
feature
	make_movable_entity
		do
			is_alive := true
			movable := true
			moved := false
			target_is_full := false
			death_this_turn := false
		end
feature
	move_entity(dir: INTEGER)
		local
			du : DIRECTION_UTILITY
			du_tuple: TUPLE[r: INTEGER; c: INTEGER]
			temp_ea: ENTITY
			cur_index: INTEGER
		do
			old_pos := pos
			create temp_ea.make_dummy
			du_tuple := du.num_dir (dir)
			trying_move
			test_targer_full(dir)
			if (not target_is_full) and is_alive then
				--this_game.m.my_galaxy.grid[row, col].contents.prune (temp_ea)
				if this_game.m.my_galaxy.grid[row, col].contents.count ~ 0 then
					this_game.m.my_galaxy.grid[row, col].contents.extend (temp_ea)
				else
					this_game.m.my_galaxy.grid[row, col].contents.array_put (temp_ea, pos)
				end
				change_pos (du.num_dir (dir))
				if this_game.m.my_galaxy.grid[row, col].contents.has (temp_ea) then
					cur_index := this_game.m.my_galaxy.grid[row, col].contents.index_of (temp_ea, 1) - 1
					this_game.m.my_galaxy.grid[row, col].contents.array_put (current, cur_index)
					pos := cur_index
				else
					this_game.m.my_galaxy.grid[row, col].contents.extend (current)
					pos := this_game.m.my_galaxy.grid[row, col].contents.count - 1
				end
				moved := true
			else
				moved := false
			end
		end

	change_pos(a_tuple: TUPLE[r_m: INTEGER; c_m: INTEGER])
		do
			old_row := row
			old_col := col
			row := row + a_tuple.r_m
			col := col + a_tuple.c_m
			row := across_board(row)
			col := across_board(col)
		end
	across_board(pre_fix: INTEGER): INTEGER
		do
			Result := pre_fix
			if pre_fix < 1 then
				Result := 5
			end
			if pre_fix > 5 then
				Result := 1
			end
		end
	check_alive
		-- ensures entity is alive after moving
		do
			-- meet black hole entity die
--			if
--				this_game.m.my_galaxy.grid[row, col].has_blackhole
--			then
--				this_game.m.death_list.extend (current)
--				is_alive := false
--			end

--			-- remove ent from game
--			if
--				not is_alive
--			then
--				dead_now
--				this_game.m.my_galaxy.grid[row, col].contents.prune (current)
--			end

		end
feature
	travel_wormhole(r, c: INTEGER)
		do
			old_row := row
			old_col := col
			row := r
			col := c
		end
	wormhole
		local
			added : BOOLEAN
			tmp_row : INTEGER
			tmp_col : INTEGER
			temp_ea: ENTITY
			cur_index: INTEGER
			r_gen: RANDOM_GENERATOR_ACCESS
		do
			old_pos := pos
			create temp_ea.make_dummy
				from
					added := false
				until
					added
				loop
					tmp_row := r_gen.rchoose(1,5)
					tmp_col := r_gen.rchoose(1,5)
					trying_move
					if ((not this_game.m.my_galaxy.grid[tmp_row, tmp_col].is_full) or this_game.m.my_galaxy.grid[tmp_row, tmp_col].has_dummy)and is_alive then
						added := true
						if this_game.m.my_galaxy.grid[row, col].contents.count ~ 0 then
							this_game.m.my_galaxy.grid[row, col].contents.extend (temp_ea)
						else
							this_game.m.my_galaxy.grid[row, col].contents.array_put (temp_ea, pos)
						end
						travel_wormhole (tmp_row, tmp_col)
						if this_game.m.my_galaxy.grid[row, col].contents.has (temp_ea) then
							cur_index := this_game.m.my_galaxy.grid[row, col].contents.index_of (temp_ea, 1) - 1
							this_game.m.my_galaxy.grid[row, col].contents.array_put (current, cur_index)
							pos := cur_index
						else
							this_game.m.my_galaxy.grid[row, col].contents.extend (current)
							pos := this_game.m.my_galaxy.grid[row, col].contents.count - 1
						end
						if col /~ old_col or row /~ old_row or pos /~ old_pos then
							moved := true
						else
							moved := false
						end
					else
						moved := false
					end
				end
		end
feature--help function
	less_turn
		do
			turns_left := turns_left -1
		end
	set_turn(fixed: INTEGER)
		do
			turns_left := fixed
		end
	na_turn
		do
			turns_left:= -999
		end
	dead_now
		do
			death_this_turn := true
		end
	pass_dead
		do
			death_this_turn := false
		end
	done_trying
		do
			try_to_move := false
		end
	trying_move
		do
			try_to_move := true
		end
	get_values: STRING
		do
			if moved then
				Result := "%N    [" + id.out + "," + item.out + "]:[" + old_row.out + "," + old_col.out + "," + (old_pos + 1).out + "]->[" + row.out + "," + col.out + "," + (pos + 1).out + "]"
			elseif try_to_move then
				Result := "%N    [" + id.out + "," + item.out + "]:[" + row.out + "," + col.out + "," + (pos + 1).out + "]"
			else
				Result := ""
			end
			if reproduced then
				if is_benign then
					check attached {BENIGN} current as c then
						Result := Result + c.reproduce_entity_info
					end
				end
				if is_janitaur then
					check attached {JANITAUR} current as c then
						Result := Result + c.reproduce_entity_info
					end
				end
				if is_malevolent then
					check attached {MALEVOLENT} current as c then
						Result := Result + c.reproduce_entity_info
					end
				end
			end
			if killed_sth then
				if is_benign then
					check attached {BENIGN} current as c then
						Result := Result + c.fucking_someone
					end
				end
				if is_janitaur then
					check attached {JANITAUR} current as c then
						Result := Result + c.fucking_someone
					end
				end
				if is_malevolent then
					check attached {MALEVOLENT} current as c then
						Result := Result + c.fucking_someone
					end
				end
				if is_asteroid then
					check attached {ASTEROID} current as c then
						Result := Result + c.fucking_someone
					end
				end
			end
		end
	test_targer_full(dir: INTEGER)
		local
			du : DIRECTION_UTILITY
			du_tuple: TUPLE[r: INTEGER; c: INTEGER]
			target_row: INTEGER
			target_col: INTEGER
		do
			du_tuple := du.num_dir (dir)
			target_row := row + du_tuple.r
			target_col := col + du_tuple.c
			target_row := across_board (target_row)
			target_col := across_board (target_col)
			if (not this_game.m.my_galaxy.grid[target_row,target_col].is_full) or this_game.m.my_galaxy.grid[target_row,target_col].has_dummy then
				target_is_full := false
			else
				target_is_full := true
			end
		end
	go_die
		local
			temp_ea: ENTITY
		do
			is_alive := false
			if
				not is_alive
			then
				dead_now
				create temp_ea.make_dummy
				this_game.m.my_galaxy.grid[row, col].contents.array_put (temp_ea, pos)
				this_game.m.my_galaxy.grid[row, col].contents.prune (current)
			end
		end
feature
	id_low_high: ARRAYED_LIST[ENTITY]
		local
			arr: LINKED_LIST[INTEGER]
			temp: INTEGER
		do
			create Result.make (4)
			create arr.make
			across
				this_game.m.my_galaxy.grid[row,col].contents is cop
			loop
				temp:= 999
				across
					this_game.m.my_galaxy.grid[row,col].contents is cpp
				loop
					if cpp.id < temp and not arr.has (cpp.id) and (cpp.is_movable or cpp.is_stationary) then
						temp := cpp.id
					end
				end
				arr.extend (temp)
				across
					this_game.m.my_galaxy.grid[row,col].contents is cpc
				loop
					if cpc.id ~ temp and (cpc.is_movable or cpc.is_stationary) then
						Result.extend(cpc)
					end
				end
			end
		end
	unmovable_baby
		do
			movable := false
		end
	growup
		do
			movable := true
		end
feature
	movement
		do
		end
feature -- redefine features
	behave
		do end
feature -- redefine planet features
	get_attached
		do end
	get_life_support
		do end
	lose_life_support
		do end
	is_attached: BOOLEAN
feature -- redefine features
	reproduce
		do
		end
	actions_left : INTEGER
feature
	reproduced:BOOLEAN
	end_reproduce
		do
			reproduced := false
		end
	killed_sth:BOOLEAN
	clean_dead_body
		do
			killed_sth := false
		end
feature
	killer_id : INTEGER
	my_last_word(he_is_killer: INTEGER)
		do
			killer_id := he_is_killer
		end
	death_way : CHARACTER
	set_death_way(a_c: CHARACTER)
		do
			death_way := a_c
		end
end
