/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2454


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_edit_node_switch_arc_id(node_id_aux text) RETURNS void AS $$

DECLARE
arc_id_aux varchar;
	
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;
	
    -- Computing process
	SELECT arc_id INTO arc_id_aux FROM node WHERE node_id=node_id_aux;
	IF arc_id_aux IS NULL THEN
		arc_id_aux=
		(SELECT arc_id FROM arc,node 
		WHERE ST_DWithin(node.the_geom, arc.the_geom, 2) 	AND node_id=node_id_aux 
		ORDER BY ST_distance(ST_closestpoint(node.the_geom, arc.the_geom),node.the_geom) ASC LIMIT 1);
		UPDATE node SET arc_id=arc_id_aux WHERE node_id=node_id_aux;
	
	ELSE
		UPDATE node SET arc_id=NULL WHERE node_id=node_id_aux;
	END IF;
		
    RETURN;
        
END;
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 