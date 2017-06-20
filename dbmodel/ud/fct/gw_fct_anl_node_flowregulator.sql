/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_flowregulator() RETURNS integer AS $BODY$
DECLARE
    node_id_var    text;
    point_aux      public.geometry;
    srid_schema    text;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Reset values
    DELETE FROM anl_node_flowregulator;

	INSERT INTO anl_node_flowregulator	
	SELECT node_1 as node_id, count(node_1) as num_arcs, node.the_geom from galia.arc join galia.node on node_id=node_1 group by node_1, node.the_geom having count(node_1)> 1 order by 2 desc;

    RETURN NULL;
--    PERFORM audit_function(0,50);


        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;