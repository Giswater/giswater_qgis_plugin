/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2566

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getattributetable(p_data json)  RETURNS json AS
$BODY$

/*EXAMPLE:
-- attribute table using custom filters
SELECT SCHEMA_NAME.gw_api_getattributetable($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_edit_man_pipe", "idName":"arc_id"},
"data":{"filterFields":{"arccat_id":"PVC160-PN10", "limit":5},
        "pageInfo":{"orderBy":"arc_id", "orderType":"DESC", "currentPage":3}}}$$)

-- attribute table using canvas filter
SELECT SCHEMA_NAME.gw_api_getattributetable($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"ve_arc_pipe", "idName":"arc_id"},
"data":{"canvasExtend":{"canvascheck":true, "x1coord":12131313,"y1coord":12131313,"x2coord":12131313,"y2coord":12131313},
        "pageInfo":{"orderBy":"arc_id", "orderType":"DESC", "currentPage":1}}}$$)
*/

DECLARE
	v_formactions json;
	v_form json;
	v_body json;
	v_return json;
	v_feature json;
	v_idname text;
	v_schemaname text;
	v_tablename text;
	
BEGIN

-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

--  Creating the form actions  
   	v_formactions = '[{"actionName":"actionZoom","actionTooltip":"Zoom"},{"actionName":"actionSelect","actionTooltip":"Select"}
			,{"actionName":"actionLink","actionTooltip":"Link"},{"actionName":"actionDelete","actionTooltip":"Delete"}]';

	SELECT gw_api_getlist (p_data) INTO v_return;

-- getting idname
	v_tablename = (p_data->>'feature')::json->>'tableName';

	EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
		INTO v_idname
		USING v_tablename, v_schemaname;
		
	-- For views it suposse pk is the first column
	IF v_idname ISNULL THEN
		EXECUTE '
		SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
		AND t.relname = $1 
		AND s.nspname = $2
		ORDER BY a.attnum LIMIT 1'
		INTO v_idname
		USING v_tablename, v_schemaname;
	END IF;

-- setting the idname
	v_feature = gw_fct_json_object_set_key(((v_return->>'body')::json->>'feature')::json, 'idName', v_idname);
	v_body = gw_fct_json_object_set_key((v_return->>'body')::json, 'feature', v_feature); 
	v_return = gw_fct_json_object_set_key(v_return, 'body', v_body);

--  setting the formactions
	v_form = gw_fct_json_object_set_key(((v_return->>'body')::json->>'form')::json, 'formActions', v_formactions);
	v_body = gw_fct_json_object_set_key((v_return->>'body')::json, 'form', v_form);
	v_return = gw_fct_json_object_set_key(v_return, 'body', v_body);
   
--  Return
	RETURN v_return;
       
--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
