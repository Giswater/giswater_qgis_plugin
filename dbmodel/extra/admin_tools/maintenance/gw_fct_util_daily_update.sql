/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_util_daily_update();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_util_daily_update ();

RETURNS void AS
$BODY$

DECLARE 

BEGIN 

	
	-- Daily updates
	SELECT crm.gw_fct_crm2gis();
	SELECT ud.gw_fct_refresh_mat_view();
	SELECT ws.gw_fct_refresh_mat_view();
		

		
RETURN ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

