/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2102


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_arc_no_startend_node()  RETURNS void AS
$BODY$
DECLARE
arc_rec record;
nodeRecord1 record;
nodeRecord2 record;
rec record;

BEGIN

    SET search_path = "SCHEMA_NAME", public;

	-- Reset values
    DELETE FROM anl_arc_x_node WHERE cur_user="current_user"() AND fprocesscat_id=3;

	-- Get data from config table
    SELECT * INTO rec FROM config;

	-- Computing process
	FOR arc_rec IN SELECT * FROM v_edit_arc

    	LOOP

		SELECT * INTO nodeRecord1 FROM v_edit_node WHERE ST_DWithin(ST_startpoint(arc_rec.the_geom), v_edit_node.the_geom, rec.arc_searchnodes)
		ORDER BY ST_Distance(v_edit_node.the_geom, ST_startpoint(arc_rec.the_geom)) LIMIT 1;
		IF nodeRecord1 IS NULL 	THEN
			INSERT INTO anl_arc_x_node (arc_id, state, expl_id, fprocesscat_id, the_geom, the_geom_p) 
			SELECT arc_rec.arc_id, arc_rec.state, arc_rec.expl_id, 3, arc_rec.the_geom, st_startpoint(arc_rec.the_geom);
		END IF;
	
		SELECT * INTO nodeRecord2 FROM v_edit_node WHERE ST_DWithin(ST_endpoint(arc_rec.the_geom), v_edit_node.the_geom, rec.arc_searchnodes)
		ORDER BY ST_Distance(v_edit_node.the_geom, ST_endpoint(arc_rec.the_geom)) LIMIT 1;
		IF nodeRecord2 IS NULL 	THEN
			INSERT INTO anl_arc_x_node (arc_id, state, expl_id, fprocesscat_id, the_geom, the_geom_p) 
			SELECT arc_rec.arc_id, arc_rec.state, arc_rec.expl_id, 3, arc_rec.the_geom, st_endpoint(arc_rec.the_geom);
		END IF;
		
	END LOOP;

    DELETE FROM selector_audit WHERE fprocesscat_id=3 AND cur_user=current_user;	
	INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (3, current_user);
			
    RETURN;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

