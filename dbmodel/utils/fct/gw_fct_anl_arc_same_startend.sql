/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_arc_same_startend() RETURNS void AS $BODY$
DECLARE

BEGIN

    SET search_path = "SCHEMA_NAME", public;

    -- Reset values
    DELETE FROM anl_review_arc WHERE cur_user="current_user"() AND context='Arc with same start-end nodes';
    
	-- Computing process
    INSERT INTO anl_review_arc (arc_id, state, expl_id, context, the_geom)
    SELECT arc_id, state, expl_id, 'Arc with same start-end nodes', the_geom
    FROM arc WHERE node_1::text=node_2::text;

    RETURN;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

