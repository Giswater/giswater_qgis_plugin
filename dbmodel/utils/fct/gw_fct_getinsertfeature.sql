/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2588

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_getinsertfeature(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getinsertfeature(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT SCHEMA_NAME.gw_fct_getinsertfeature($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},
"feature":{"geometryType":"line"},
"data":{}}$$)

SELECT SCHEMA_NAME.gw_fct_getinsertfeature($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},
"feature":{"geometryType":"point"},
"data":{}}$$)
*/

DECLARE

v_version text;
v_rows json;
v_geometrytype text;
v_errcontext text;
	
BEGIN

	-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

	--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

	--  Creating the list elements
	----------------------------
	-- Get input parameters:
	v_geometrytype := (p_data ->> 'feature')::json->> 'geometryType';

	RAISE NOTICE 'v_geometrytype %', v_geometrytype;

	IF v_geometrytype='line' THEN 
		EXECUTE 'SELECT array_to_json(array_agg(row_to_json(row))) FROM (SELECT id, system_id, shortcut_key, parent_layer, child_layer, orderby FROM cat_feature WHERE type=''ARC'' AND active IS TRUE) row'
			INTO v_rows;
				RAISE NOTICE 'v_rows 1%', v_rows;

	ELSIF v_geometrytype='point' THEN 
		EXECUTE 'SELECT array_to_json(array_agg(row_to_json(row))) FROM (SELECT id, system_id, shortcut_key, parent_layer, child_layer, orderby FROM cat_feature WHERE type=''NODE'' AND active IS TRUE UNION 
							 SELECT id, system_id, shortcut_key, parent_layer, child_layer, orderby FROM cat_feature WHERE type=''NODE'' AND active IS TRUE
							 ORDER BY orderby) row'
			INTO v_rows;
	END IF;

	RAISE NOTICE 'v_rows %', v_rows;

	-- Control NULL's	
	v_version := COALESCE(v_version, '{}');
	v_rows := COALESCE(v_rows, '{}');
    
	-- Return
    RETURN ('{"status":"Accepted", "version":'||v_version||
             ',"body":{"message":{"level":1, "text":"This is a test message"}'||
			',"form":{}'||
			',"feature":{}'||
			',"data":{"listValues":' || v_rows ||
		     '}}'||
	    '}')::json;
    
	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;  
	RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_errcontext) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;