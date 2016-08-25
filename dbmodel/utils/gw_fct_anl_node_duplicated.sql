/*
This file is part of Giswater 2.0
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

    -- Create table for duplicated nodes
    DELETE FROM anl_node_duplicated;
    INSERT INTO anl_node_duplicated (node_id, node_conserv, the_geom)
    SELECT DISTINCT t1.node_id, t2.node_id, t1.the_geom
    FROM node AS t1 JOIN node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom,(rec.node_duplicated_tolerance)) 
    WHERE t1.node_id != t2.node_id  
    ORDER BY t1.node_id;

    PERFORM audit_function(0,30);
    RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
