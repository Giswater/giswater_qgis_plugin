/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_sink() RETURNS integer AS $BODY$
DECLARE
    node_id_var    text;
    expl_id_var    integer;
    point_aux      public.geometry;
    srid_schema    text;

BEGIN


    SET search_path = "SCHEMA_NAME", public;

    -- Reset values
    DELETE FROM anl_review_node WHERE cur_user="current_user"() AND context='Node sink';
    
     -- Computing process 
    FOR node_id_var, expl_id_var, point_aux IN SELECT node_id, expl_id, the_geom FROM node AS a WHERE ((SELECT COUNT(*) FROM arc AS b WHERE b.node_2 = a.node_id) > 0) AND ((SELECT COUNT(*) FROM arc AS b WHERE b.node_1 = a.node_id) = 0)
    LOOP
        -- Insert in analytics table
        INSERT INTO anl_review_node (node_id, expl_id, num_arcs, context, the_geom) VALUES(node_id_var, expl_id_var, 
        (SELECT COUNT(*) FROM arc WHERE node_1 = node_id_var OR node_2 = node_id_var), 'Node sink'::text, point_aux);
    END LOOP;
    
    RETURN (SELECT COUNT(*) FROM anl_review_node WHERE cur_user="current_user"() AND context='Node sink');
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;