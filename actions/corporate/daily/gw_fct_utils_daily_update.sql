/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: XXXX

DROP FUNCTION IF EXISTS utils.gw_fct_utils_daily_update();
CREATE OR REPLACE FUNCTION utils.gw_fct_utils_daily_update ()

RETURNS integer AS
$BODY$

DECLARE 
v_return integer;

BEGIN 


	-- Daily updates
	PERFORM crm.gw_fct_crm2gis();
	PERFORM ud.gw_fct_refresh_mat_view();
	PERFORM ws.gw_fct_refresh_mat_view();

	-- Log
	INSERT INTO utils.audit_log (fprocesscat_id, log_message) VALUES (999, 'Ok');

	
	RETURN 0;

--  Exception handling
	EXCEPTION WHEN OTHERS THEN         
	INSERT INTO utils.audit_log (fprocesscat_id, log_message) VALUES (999, 'Ko. The process has not been executed');
	RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

