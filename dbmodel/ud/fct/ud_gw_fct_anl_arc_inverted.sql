/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_arc_inverted() RETURNS integer AS $BODY$
DECLARE
    
BEGIN


    SET search_path = "SCHEMA_NAME", public;


    -- Reset values
    DELETE FROM anl_review_arc WHERE cur_user="current_user"() AND context='Arc inverted';
    
	-- Computing process
    INSERT INTO anl_review_arc (arc_id, expl_id, context, the_geom)
    SELECT arc_id, expl_id, 'Arc Inverted'::text, the_geom 
	FROM v_edit_arc
	WHERE slope < 0;

    RETURN 1;
                
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;