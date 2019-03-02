/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2644

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_setvisitmanagerstart(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
--new call
SELECT SCHEMA_NAME.gw_api_setvisitmanagerstart($${
"client":{"device":3,"infoType":100,"lang":"es"},
"form":{},
"data":{}}$$)
*/

DECLARE
	v_message json;
	v_data json;

BEGIN

	-- search_path
	SET search_path='SCHEMA_NAME';
	
	-- setting values on table om_visit_lot_x_user 
	-- TOD DO: set starttime
	
	-- message
	SELECT gw_api_getmessage(null, 70) INTO v_message;
	v_data = p_data->>'data';
	v_data = gw_fct_json_object_set_key (v_data, 'message', v_message);
	p_data = gw_fct_json_object_set_key (p_data, 'data', v_data);	
  
	-- Return
	RETURN gw_api_getvisitmanager(p_data);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;