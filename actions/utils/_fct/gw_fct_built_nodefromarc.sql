/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2118


-- DROP FUNCTION SCHEMA_NAME.gw_fct_built_nodefromarc();


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_built_nodefromarc() RETURNS void AS
$BODY$

DECLARE
rec_arc record;
rec_table record;
rec record;
numnodes integer;

BEGIN

    -- Search path
    SET search_path = SCHEMA_NAME, public;

	-- Get data from config tables
	SELECT * INTO rec FROM config;
	
	--  Reset values
	DELETE FROM temp_table WHERE user_name=current_user AND fprocesscat_id=16;

	-- inserting all extrem nodes on temp_node
	INSERT INTO temp_table (fprocesscat_id, geom_point)
	SELECT 
	16,
	ST_StartPoint(the_geom) AS the_geom FROM arc 
		UNION 
	SELECT 
	16,
	ST_EndPoint(the_geom) AS the_geom FROM arc;

	-- inserting into v_edit_node table
	FOR rec_table IN SELECT * FROM temp_table WHERE user_name=current_user AND fprocesscat_id=16
	LOOP
	        -- Check existing nodes  
	        numNodes:= 0;
		numNodes:= (SELECT COUNT(*) FROM node WHERE node.the_geom && ST_Expand(rec_table.geom_point, rec.node_proximity));
		IF numNodes = 0 THEN
			INSERT INTO node (the_geom, state) VALUES (rec_table.geom_point,1);
		ELSE

		END IF;
	END LOOP;


	-- udpdate arc table
	FOR rec_arc IN SELECT * FROM arc
	LOOP
	UPDATE arc  SET node_1= (SELECT node_id FROM node WHERE ST_DWithin(node.the_geom, ST_StartPoint(rec_arc.the_geom),rec.node_proximity) 
					ORDER BY ST_Distance(node.the_geom, ST_StartPoint(rec_arc.the_geom)) LIMIT 1),
				node_2= (SELECT node_id FROM node WHERE ST_DWithin(node.the_geom, ST_EndPoint(rec_arc.the_geom), rec.node_proximity) 
					ORDER BY ST_Distance(node.the_geom, ST_EndPoint(rec_arc.the_geom)) LIMIT 1) 
					WHERE rec_arc.arc_id=arc_id;
	END LOOP;
   
  RETURN;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
