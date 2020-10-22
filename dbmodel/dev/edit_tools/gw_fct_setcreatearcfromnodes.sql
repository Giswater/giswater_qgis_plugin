/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_setcreatearcfromnodes(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setcreatearcfromnodes(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_setcreatearcfromnodes($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{"parameters":{}}}$$)


*/

DECLARE

v_epsg integer;
v_data record;
v_querytext text;
v_nodecat text;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- Create arc geom
	v_querytext = 'SELECT * FROM arc ';
		
	FOR v_data IN EXECUTE v_querytext
	LOOP

		--raise notice '4th loop %', v_data;
		--Insert start point, add vertices if exist, add end point
		SELECT array_agg(the_geom) INTO geom_array FROM node WHERE v_data.node_1=node_id;
	
		SELECT array_agg(ST_SetSrid(ST_MakePoint(csv2::numeric,csv3::numeric),v_epsg)order by id) INTO  geom_array_vertex FROM temp_csv 
		WHERE cur_user=current_user AND fid =v_fid and source='[VERTICES]' and csv1=v_data.arc_id;
		
		IF geom_array_vertex IS NOT NULL THEN
			geom_array=array_cat(geom_array, geom_array_vertex);
		END IF;
		
		geom_array=array_append(geom_array,(SELECT the_geom FROM node WHERE v_data.node_2=node_id));

		UPDATE arc SET the_geom=ST_MakeLine(geom_array) where arc_id=v_data.arc_id;

	END LOOP;

RETURN '{"status":"Accepted"}';
	

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
