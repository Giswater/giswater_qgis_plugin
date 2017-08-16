/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_orphan() RETURNS void AS $$
DECLARE
    rec_node record;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Reset values
    DELETE FROM anl_node_orphan;

    -- Loop for all the arcs
    FOR rec_node IN SELECT DISTINCT * FROM node AS a WHERE (SELECT COUNT(*) FROM arc WHERE node_1 = a.node_id OR node_2 = a.node_id) = 0
    LOOP
        INSERT INTO anl_node_orphan VALUES (rec_node.node_id, rec_node.node_type, rec_node.the_geom);
    END LOOP;

    PERFORM audit_function(0,40);
    RETURN;
        
END;
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;