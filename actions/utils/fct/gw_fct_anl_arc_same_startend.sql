/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2104


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_arc_same_startend() RETURNS void AS $BODY$
DECLARE

BEGIN

    SET search_path = "SCHEMA_NAME", public;

    -- Reset values
    DELETE FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=4;
    
	-- Computing process
    INSERT INTO anl_arc (arc_id, state, expl_id, fprocesscat_id, the_geom)
    SELECT arc_id, state, expl_id, 4, the_geom
    FROM arc WHERE node_1::text=node_2::text;

    DELETE FROM selector_audit WHERE fprocesscat_id=4 AND cur_user=current_user;	
    INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (4, current_user);

    RETURN;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

