/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3002

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_setplan(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setplan(p_data json)
RETURNS json AS
$BODY$

/*+

SELECT gw_fct_setplan($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}}}$$);

*/

DECLARE
v_version text;


BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select config values
	SELECT giswater INTO v_version FROM sys_version order by 1 desc limit 1;

		--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":{}'||
			'}}'||
	    '}')::json, 3002);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;