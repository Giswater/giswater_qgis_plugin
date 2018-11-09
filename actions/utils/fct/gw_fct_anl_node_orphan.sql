/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2110


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_orphan() RETURNS void AS $$
DECLARE

    rec_node record;
    v_closest_arc_id varchar;
    v_closest_arc_distance numeric;
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Reset values
    DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=7;
        
    -- Computing process
    FOR rec_node IN SELECT DISTINCT * FROM node AS a WHERE (SELECT COUNT(*) FROM arc WHERE node_1 = a.node_id OR node_2 = a.node_id) = 0
    LOOP
        --find the closest arc and the distance between arc and node
        SELECT ST_Distance(arc.the_geom, rec_node.the_geom) as d, arc.arc_id INTO v_closest_arc_distance, v_closest_arc_id FROM arc ORDER BY arc.the_geom <-> rec_node.the_geom  LIMIT 1;
    
        INSERT INTO anl_node (node_id, state, expl_id, fprocesscat_id, the_geom, nodecat_id,arc_id,arc_distance) 
        VALUES (rec_node.node_id, rec_node.state, rec_node.expl_id, 7, rec_node.the_geom, rec_node.nodecat_id,v_closest_arc_id,v_closest_arc_distance);
    END LOOP;

    DELETE FROM selector_audit WHERE fprocesscat_id=7 AND cur_user=current_user;    
    INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (7, current_user);

    RETURN;
        
END;
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 