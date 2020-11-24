note
	description: "Represents a sector in the galaxy."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SECTOR

create
	make, make_dummy

feature -- attributes
	shared_info_access : SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result:= shared_info_access.shared_info
		end

	gen: RANDOM_GENERATOR_ACCESS

	contents: ARRAYED_LIST [ENTITY] --holds 4 quadrants

	row: INTEGER

	column: INTEGER

	model_accecc: ETF_MODEL_ACCESS
	current_explorer: EXPLORER

feature -- constructor
	make(row_input: INTEGER; column_input: INTEGER; a_explorer:ENTITY)
		--initialization
		require
			valid_row: (row_input >= 1) and (row_input <= shared_info.number_rows)
			valid_column: (column_input >= 1) and (column_input <= shared_info.number_columns)
		do
			create current_explorer.make_explorer
			row := row_input
			column := column_input
			create contents.make (shared_info.max_capacity) -- Each sector should have 4 quadrants
			contents.compare_objects
			if (row = 3) and (column = 3) then
				put (create {BLACKHOLE}.make_blackhole) -- If this is the sector in the middle of the board, place a black hole
			else
				if (row = 1) and (column = 1) then
					check attached {EXPLORER} a_explorer as exp then
						current_explorer := exp
						current_explorer.set_position (1,1,0)
						current_explorer.set_id (0)
					end
					put (current_explorer) -- If this is the top left corner sector, place the explorer there
				end
				populate(row, column) -- Run the populate command to complete setup
			end -- if
		end

feature -- commands
	make_dummy
		--initialization without creating entities in quadrants
		do
			create contents.make (shared_info.max_capacity)
			contents.compare_objects
			create current_explorer.make_explorer
		end

	populate(r, c:INTEGER)
			-- this feature creates 1 to max_capacity-1 components to be intially stored in the
			-- sector. The component may be a planet or nothing at all.
		local
			threshold: INTEGER
			number_items: INTEGER
			loop_counter: INTEGER
			component: MOVABLE
			turn :INTEGER
		do
			number_items := gen.rchoose (1, shared_info.max_capacity-1)  -- MUST decrease max_capacity by 1 to leave space for Explorer (so a max of 3)
			from
				loop_counter := 1
			until
				loop_counter > number_items
			loop
				threshold := gen.rchoose (1, 100) -- each iteration, generate a new value to compare against the threshold values provided by `test` or `play`

				if threshold < shared_info.asteroid_threshold then
					create {ASTEROID} component.make_asteroid
					component.set_position (r, c, contents.count)
				elseif threshold < shared_info.janitaur_threshold then
					create {JANITAUR} component.make_janitaur
					component.set_position (r, c, contents.count)
				elseif (threshold < shared_info.malevolent_threshold) then
					create {MALEVOLENT} component.make_malevolent
					component.set_position (r, c, contents.count)
				elseif (threshold < shared_info.benign_threshold) then
					create {BENIGN} component.make_benign
					component.set_position (r, c, contents.count)
				elseif threshold < shared_info.planet_threshold then
					create {PLANET} component.make_planet
					component.set_position (r, c, contents.count)
				end

				if attached component as entity then
					put (entity) -- add new entity to the contents list

					--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					turn:=gen.rchoose (0, 2) -- Hint: Use this number for assigning turn values to movable entities
					-- The turn value of a movable entity (except explorer) suggests the number of turns left before it can move.
					--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


					--dangerous code
					component.set_turn (turn)
					model_accecc.m.movable_entities.force (component)
					--dangerous code

					component := void -- reset component object
				end

				loop_counter := loop_counter + 1
			end
		end

feature {GALAXY} --command

	put (new_component: ENTITY)
			-- put `new_component' in contents array
		local
			loop_counter: INTEGER
			found: BOOLEAN
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or found
			loop
				if contents [loop_counter] = new_component then
					found := TRUE
				end --if
				loop_counter := loop_counter + 1
			end -- loop

			if not found and not is_full then
				contents.extend (new_component)
			end

			if new_component.is_stationary then
				model_accecc.m.stationary_array.put_front (new_component)
			end

		ensure
			component_put: not is_full implies contents.has (new_component)
		end

feature -- Queries

	print_sector: STRING
			-- Printable version of location's coordinates with different formatting
		do
			Result := ""
			Result.append (row.out)
			Result.append (":")
			Result.append (column.out)
		end

	is_full: BOOLEAN
			-- Is the location currently full?
		local
			loop_counter: INTEGER
			occupant: ENTITY
			empty_space_found: BOOLEAN
		do
			if contents.count < shared_info.max_capacity then
				empty_space_found := TRUE
			end
			from
				loop_counter := 1
			until
				loop_counter > contents.count or empty_space_found
			loop
				occupant := contents [loop_counter]
				if not attached occupant  then
					empty_space_found := TRUE
				end
				loop_counter := loop_counter + 1
			end

			if contents.count = shared_info.max_capacity and then not empty_space_found then
				Result := TRUE
			else
				Result := FALSE
			end
		end

	has_stationary: BOOLEAN
			-- returns whether the location contains any stationary item
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_stationary
				end -- if
				loop_counter := loop_counter + 1
			end
		end
	has_wormhole: BOOLEAN
			--lululu-- to see if this sector has a wormhole
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_wormhole
				end -- if
				loop_counter := loop_counter + 1
			end
		end
	has_star: BOOLEAN
			--lululu-- to see if this sector has a star
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_star
				end -- if

				loop_counter := loop_counter + 1
			end
		end
	has_yd: BOOLEAN
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_yellow_dwarf
				end -- if
				loop_counter := loop_counter + 1
			end
		end
	has_dummy: BOOLEAN
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_empty
				end -- if
				loop_counter := loop_counter + 1
			end
		end
	has_p: BOOLEAN
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result :=  temp_item.is_planet
				end -- if
				loop_counter := loop_counter + 1
			end
		end
	has_blackhole: BOOLEAN
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_blackhole
				end -- if
				loop_counter := loop_counter + 1
			end
		end
	has_unvisited_attached_planet: BOOLEAN
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					if temp_item.is_planet then
						check attached {PLANET} temp_item as temp_planet then
							Result := (temp_planet.is_attached and not temp_planet.visited)
						end
					end

				end -- if
				loop_counter := loop_counter + 1
			end
		end
	has_explorer: BOOLEAN
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_explorer
				end -- if
				loop_counter := loop_counter + 1
			end
		end
	has_benign: BOOLEAN
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_benign
				end -- if
				loop_counter := loop_counter + 1
			end
		end
	has_asteroid: BOOLEAN
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_asteroid
				end -- if
				loop_counter := loop_counter + 1
			end
		end
	has_janitaur: BOOLEAN
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_janitaur
				end -- if
				loop_counter := loop_counter + 1
			end
		end

end
