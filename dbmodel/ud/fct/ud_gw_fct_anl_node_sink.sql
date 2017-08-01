/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_sink() RETURNS integer AS $BODY$
DECLARE
    node_id_var    text;
    point_aux      public.geometry;
    srid_schema    text;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    RAISE NOTICE 'Create table.';

    -- Create table for node results
    DELETE FROM anl_node_sink;
        
    RAISE NOTICE 'Start computations.';

    --  Compute the tributary area using DFS
    FOR node_id_var, point_aux IN SELECT node_id, the_geom FROM node AS a WHERE ((SELECT COUNT(*) FROM arc AS b WHERE b.node_2 = a.node_id) > 0) AND ((SELECT COUNT(*) FROM arc AS b WHERE b.node_1 = a.node_id) = 0)
    LOOP
        -- Insert in analytics table
        INSERT INTO anl_node_sink VALUES(node_id_var, (SELECT COUNT(*) FROM arc WHERE node_1 = node_id_var OR node_2 = node_id_var), point_aux);
    END LOOP;
    
    PERFORM audit_function(0,50);

    RETURN (SELECT COUNT(*) FROM anl_node_sink);
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;