/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2204


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_arc_inverted() RETURNS integer AS $BODY$
DECLARE
    
BEGIN


    SET search_path = "SCHEMA_NAME", public;


    -- Reset values
    DELETE FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=10;
    
	-- Computing process
    INSERT INTO anl_arc (arc_id, expl_id, fprocesscat_id, the_geom)
    SELECT arc_id, expl_id, 10, the_geom 
	FROM v_edit_arc
	WHERE slope < 0;
    
    DELETE FROM selector_audit WHERE fprocesscat_id=10 AND cur_user=current_user;	
    INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (10, current_user);
    
    RETURN 1;
                
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;