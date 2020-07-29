/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
--FUNCTION CODE: 2978
-- Function: SCHEMA_NAME.gw_fct_getstyle(json)

-- DROP FUNCTION SCHEMA_NAME.gw_fct_getstyle(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getstyle(p_data json)
  RETURNS json AS
$BODY$

/*
 SELECT SCHEMA_NAME.gw_fct_getstyle($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{},  "style_id":"106"}}$$);
*/
 
DECLARE
v_return json;
v_style_id text;
v_style text;
v_version json;




BEGIN

	-- Search path
	SET search_path = 'SCHEMA_NAME', public;

	
	v_style_id = ((p_data ->>'data')::json->>'style_id')::json;
	v_style = (SELECT stylevalue FROM sys_style where id::text = v_style_id::text and active IS TRUE);
	v_return = gw_fct_json_object_set_key((p_data->>'body')::json, 'style', v_style);

	v_version := COALESCE(v_version, '{}');
	v_return := COALESCE(v_return, '{}');
	 
	-- Return
		RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Executed successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{}'||
		     ',"styles":'||v_return||''||
	    '}}')::json;
	    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;