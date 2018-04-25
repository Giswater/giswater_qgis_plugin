/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:XXXX



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_refresh_mat_view()
RETURNS integer SECURITY DEFINER AS $BODY$
BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	REFRESH MATERIALIZED VIEW v_ui_workcat_polygon_aux;
	
	RETURN 1;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
