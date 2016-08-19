/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_arc_same_startend()
RETURNS void AS
$BODY$
DECLARE

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

--	Delete old values
	DELETE FROM anl_arc_same_startend;
		
    INSERT INTO anl_arc_same_startend
	SELECT	
	arc_id, 
	st_length2d(arc.the_geom)::float,
	the_geom
	FROM arc WHERE node_1::text=node_2::text;
	
PERFORM audit_function(0,10);
RETURN;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

