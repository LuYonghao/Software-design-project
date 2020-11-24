note
	description: "Summary description for {DIRECTION_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	DIRECTION_UTILITY

feature -- Queries

	N: TUPLE [row_mod: INTEGER; col_mod: INTEGER]
			-- Tuple modifier for North
			-- move up one row (-1)
		once
			Result := [-1, 0]
		end

	E: TUPLE [row_mod: INTEGER; col_mod: INTEGER]
			-- Tuple modifier for East
		once
			Result := [0, 1]
		end

	S: TUPLE [row_mod: INTEGER; col_mod: INTEGER]
			-- Tuple modifier for South
		once
			Result := [1, 0]
		end

	W: TUPLE [row_mod: INTEGER; col_mod: INTEGER]
			-- Tuple modifier for West
		once
			Result := [0, -1]
		end
	NW: TUPLE [row_mod: INTEGER; col_mod: INTEGER]
			-- Tuple modifier for North
			-- move up one row (-1)
		once
			Result := [-1, -1]
		end

	NE: TUPLE [row_mod: INTEGER; col_mod: INTEGER]
			-- Tuple modifier for East
		once
			Result := [-1, 1]
		end

	SW: TUPLE [row_mod: INTEGER; col_mod: INTEGER]
			-- Tuple modifier for South
		once
			Result := [1, -1]
		end

	SE: TUPLE [row_mod: INTEGER; col_mod: INTEGER]
			-- Tuple modifier for West
		once
			Result := [1, 1]
		end

	num_dir (int: INTEGER): TUPLE [row_mod: INTEGER; col_mod: INTEGER]
			-- Convert an integer encoding to a direction. 1 = N, 2 = E, 3 = S, 4 = W.
		do
			inspect int
			when 1 then
				Result := N
			when 2 then
				Result := NE
			when 3 then
				Result := E
			when 4 then
				Result := SE
			when 5 then
				Result := S
			when 6 then
				Result := SW
			when 7 then
				Result := W
			else
				Result := NW
			end
		end
	
end
