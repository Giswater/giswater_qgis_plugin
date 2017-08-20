/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_duplicated() RETURNS void AS $BODY$
DECLARE
    rec_node record;
    rec record;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Get data from config table
    SELECT * INTO rec FROM config; 

    -- Reset values
    DELETE FROM anl_review_node WHERE cur_user="current_user"() AND context='Node duplicated';
		
		
    -- Computing process
    INSERT INTO anl_review_node (node_id, state, node_id_aux, expl_id, context, the_geom)
    SELECT DISTINCT t1.node_id, t1.state, t2.node_id, t1.expl_id, 'Node duplicated', t1.the_geom
    FROM node AS t1 JOIN node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom,(rec.node_duplicated_tolerance)) 
    WHERE t1.node_id != t2.node_id  
    ORDER BY t1.node_id;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
