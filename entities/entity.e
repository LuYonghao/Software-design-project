note
	description: "Summary description for {ENTITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENTITY
inherit
    ANY
        redefine
            out
        end
create
	make_dummy
feature
	--position info
	row: INTEGER
	col: INTEGER
	pos: INTEGER
 	--basic
 	id: INTEGER
	item: CHARACTER
 	movable: BOOLEAN
feature
	make_dummy
		do
			item := '-'
		end
feature--redefine
	out: STRING
            -- Return string representation of alphabet.
        do
            Result := item.out
        end

feature--help function
	set_position(new_row, new_col, new_pos: INTEGER)
		do
			row := new_row
			col := new_col
			pos := new_pos
		end
	set_id(new_id: INTEGER)
		do
			id := new_id
		end
	is_stationary: BOOLEAN
    	do
           	if item = 'W' or item = 'Y' or item = '*' or item = 'O' then
           		Result := True
           	end
        end
	is_star:BOOLEAN
		do
           	if item = 'Y' or item = '*' then
           		Result := True
          	end
        end
    is_wormhole:BOOLEAN
		do
           	if item = 'W' then
           		Result := True
           	end
        end
	is_explorer: BOOLEAN
		do
			if item = 'E' then
           		Result := True
           	end
		end
	is_yellow_dwarf: BOOLEAN
    	do
           	if item = 'Y' then
           		Result := True
           	end
        end
    is_bule_giant: BOOLEAN
    	do
           	if item = '*' then
           		Result := True
           	end
        end
    is_blackhole: BOOLEAN
    	do
           	if item = 'O' then
           		Result := True
           	end
        end
    is_planet: BOOLEAN
	    do
	    	if item = 'P' then
	           Result := True
	        end
	    end
    is_empty: BOOLEAN
    	do
           	if item = '-' then
           		Result := True
           	end
        end
    is_movable: BOOLEAN
    	do
    		if item = 'E' or item = 'P' or item = 'M' or item = 'A' or item = 'J' or item = 'B' then
           		Result := True
          	end
    	end
    is_janitaur: BOOLEAN
    	do
    		if item = 'J' then
           		Result := True
          	end
    	end
    is_malevolent: BOOLEAN
    	do
    		if item = 'M' then
           		Result := True
          	end
    	end
    is_asteroid: BOOLEAN
    	do
    		if item = 'A' then
           		Result := True
          	end
    	end
    is_benign: BOOLEAN
    	do
    		if item = 'B' then
           		Result := True
          	end
    	end
invariant
    allowable_symbols:
        item = 'E' or item = 'P' or item = 'O' or item = 'W' or item = 'Y' or item = '*' or item = '-' or item = 'A' or item = 'J' or item = 'B' or item = 'M'
end
