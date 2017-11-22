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
    DELETE FROM anl_arc_x_node WHERE cur_user="current_user"() AND context='Arc without start-end nodes';

	-- Get data from config table
    SELECT * INTO rec FROM config;

    -- Computing process
	FOR arc_rec IN SELECT * FROM arc

    	LOOP
	SELECT * INTO nodeRecord1 FROM node WHERE node_id=gw_fct_state_searchnodes(arc_rec.arc_id, arc_rec.state, 'StartPoint'::varchar, arc_rec.the_geom, 'INSERT');
	IF nodeRecord1 IS NULL 	THEN
		INSERT INTO anl_arc_x_node (arc_id, state, expl_id, context, the_geom, the_geom_p) 
		SELECT arc_rec.arc_id, arc_rec.state, arc_rec.expl_id, 'Arc without start-end nodes', arc_rec.the_geom, st_startpoint(arc_rec.the_geom);
	END IF;

	SELECT * INTO nodeRecord2 FROM node WHERE node_id=gw_fct_state_searchnodes(arc_rec.arc_id, arc_rec.state, 'EndPoint'::varchar, arc_rec.the_geom, 'INSERT');
	IF nodeRecord2 IS NULL 	THEN
		INSERT INTO anl_arc_x_node (arc_id, state, expl_id, context, the_geom, the_geom_p) 
		SELECT arc_rec.arc_id, arc_rec.state, arc_rec.expl_id, 'Arc without start-end nodes', arc_rec.the_geom, st_endpoint(arc_rec.the_geom);
	END IF;
	END LOOP;
			
    RETURN;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

