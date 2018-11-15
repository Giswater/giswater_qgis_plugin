/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2210


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_sink() RETURNS integer AS $BODY$
DECLARE
    node_id_var    text;
    expl_id_var    integer;
    point_aux      public.geometry;
    srid_schema    text;

BEGIN


    SET search_path = "SCHEMA_NAME", public;

    -- Reset values
    DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=13;
    
     -- Computing process 
    FOR node_id_var, expl_id_var, point_aux IN SELECT node_id, expl_id, the_geom FROM node AS a WHERE ((SELECT COUNT(*) FROM arc AS b WHERE b.node_2 = a.node_id) > 0) AND ((SELECT COUNT(*) FROM arc AS b WHERE b.node_1 = a.node_id) = 0)
    LOOP
        -- Insert in analytics table
        INSERT INTO anl_node (node_id, expl_id, num_arcs, fprocesscat_id, the_geom) VALUES(node_id_var, expl_id_var, 
        (SELECT COUNT(*) FROM arc WHERE node_1 = node_id_var OR node_2 = node_id_var), 13, point_aux);
    END LOOP;
    
    DELETE FROM selector_audit WHERE fprocesscat_id=13 AND cur_user=current_user;	
    INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (13, current_user);

    RETURN (SELECT COUNT(*) FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=13);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;