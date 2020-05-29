/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2928

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getmapzonestyle(p_data json)
  RETURNS json AS
$BODY$

/* EXAMPLE
SELECT SCHEMA_NAME.gw_fct_getmapzonestyle($${"client":{"device":3, "infoType":100, "lang":"ES"},"data":{}}$$)
*/

DECLARE

v_version json;
v_sector json;
v_dma json;
v_presszone json;
v_dqa json;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

	SELECT to_json(array_agg(row_to_json(row))) INTO v_sector FROM (SELECT sector_id as id, stylesheet::json FROM v_edit_sector) row;
	SELECT to_json(array_agg(row_to_json(row))) INTO v_presszone FROM (SELECT id as id , stylesheet::json FROM v_edit_presszone) row;
	SELECT to_json(array_agg(row_to_json(row))) INTO v_dma FROM (SELECT dma_id as id, stylesheet::json FROM v_edit_dma) row;
	SELECT to_json(array_agg(row_to_json(row))) INTO v_dqa FROM (SELECT dqa_id as id, stylesheet::json FROM v_edit_dqa) row;
	
	--    Return
	RETURN ('{"status":"Accepted", "version":'||v_version||
             ',"body":{"message":{}'||
			',"data":{"mapzones":
				[{"name":"sector", "idname": "sector_id", "layer":"v_edit_sector", "opacity":0.5, "values":' || v_sector ||'}'||
				',{"name":"presszone", "idname": "presszone_id",  "layer":"v_edit_presszone", "opacity":0.5,  "values":' || v_presszone ||'}'||
				',{"name":"dma", "idname": "dma_id", "layer":"v_edit_dma", "opacity":0.5, "values":' || v_dma ||'}'||
				',{"name":"dqa", "idname": "dqa_id", "layer":"v_edit_dqa", "opacity":0.5, "values":' || v_dqa ||'}'||
				']}}'||
	    '}')::json;
      
	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
