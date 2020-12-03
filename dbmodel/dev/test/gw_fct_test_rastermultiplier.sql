/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NODE: ---

CREATE OR REPLACE FUNCTION gw_fct_test_rastermultiplier(p_data json)
  RETURNS void AS
$BODY$

/*
SELECT gw_fct_test_rastermultiplier($${"data":{"rasterSize":{"ncols":1001, "nrows":1001, "xllcorner":575000, "yllcorner":4774000, "cellsize":1}, "multiplier":{"rows":30, "columns":30}}}$$)

WARNINGS: 
RASTER MUST BE STORED IN UNIQUE ONE ROW;
TABLE MUST BE ON SCHEMA PUBLIC
TABLE NAME MUST BE: rst;

*/

DECLARE
	v_record record;
	v_multiplier integer = 0;
	v_rows integer = 0;
	v_columns integer = 0;
	v_totalcolumns integer = 0;
	v_totalrows integer = 0;
	v_idlast integer;
	v_ncols integer;
	v_nrows integer;
	v_x11corner integer;
	v_y11corner integer;
	v_cellsize float;
	v_xcoord float;
	v_ycoord float;
	v_rowsmod integer=0;
	
BEGIN

	-- Search path
	SET search_path = public;

	v_ncols :=  (((p_data ->>'data')::json->>'rasterSize')::json->>'ncols')::integer - 1;
	v_nrows :=  (((p_data ->>'data')::json->>'rasterSize')::json->>'nrows')::integer - 1;
	v_x11corner :=  (((p_data ->>'data')::json->>'rasterSize')::json->>'xllcorner')::integer;
	v_y11corner :=  (((p_data ->>'data')::json->>'rasterSize')::json->>'yllcorner')::integer;
	v_cellsize :=  (((p_data ->>'data')::json->>'rasterSize')::json->>'cellsize')::float;

	v_totalrows :=  (((p_data ->>'data')::json->>'multiplier')::json->>'rows')::integer;
	v_totalcolumns :=  (((p_data ->>'data')::json->>'multiplier')::json->>'columns')::integer-1;

	SELECT rast INTO v_record FROM rst;
    
        LOOP   	       		
		LOOP 
			IF v_columns + v_rows > 0 THEN  -- to scape first row
				INSERT INTO rst (rast, filename) VALUES (v_record.rast, v_columns*v_rows) RETURNING rid INTO v_idlast;

				v_rowsmod = v_rows-1;

				v_xcoord = v_x11corner + v_rowsmod*v_nrows*v_cellsize;
				v_ycoord = v_y11corner + v_columns*v_ncols*v_cellsize;

				UPDATE rst SET rast=ST_SetUpperLeft(rast,v_xcoord,v_ycoord) WHERE rid = v_idlast;
			END IF;

			RAISE NOTICE '% % % %', v_rows, v_columns , v_xcoord, v_ycoord;

			EXIT WHEN v_columns = v_totalcolumns;

			v_columns = v_columns +1;
				
		END LOOP;
		
		v_columns = 0;
		v_rows = v_rows + 1;

		EXIT WHEN v_rows = v_totalrows;
		
        END LOOP;
        
    RETURN;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;