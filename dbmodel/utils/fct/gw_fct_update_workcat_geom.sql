/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:XXXX



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_update_workcat_geom(p_worcat_id text)
RETURNS void AS $BODY$

DECLARE 

v_the_geom public.geometry;

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	IF p_worcat_id='ALL'  THEN
	
		UPDATE cat_work SET the_geom=a.the_geom FROM v_ui_workcat_polygon_aux a WHERE cat_work.id=a.workcat_id AND a.the_geom IS NOT NULL;
		
	ELSE
	
		UPDATE cat_work SET the_geom=a.the_geom FROM v_ui_workcat_polygon_aux a WHERE cat_work.id=p_worcat_id AND a.the_geom IS NOT NULL;
	
	END IF;
   
   RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
