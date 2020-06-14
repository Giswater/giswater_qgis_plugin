/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2928

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getstylemapzones(p_data json)
  RETURNS json AS
$BODY$

/* EXAMPLE
SELECT SCHEMA_NAME.gw_fct_getstylemapzones($${"client":{"device":4, "infoType":1, "lang":"ES"},"data":{}}$$)

*/

DECLARE

v_version json;
v_sector json;
v_dma json;
v_presszone json;
v_dqa json;
v_statussector text;
v_statuspresszone text;
v_statusdma text;
v_statusdqa text;
v_project_type text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	SELECT project_type INTO v_project_type FROM sys_version LIMIT 1;

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

        IF v_project_type = 'WS' THEN

		-- get status	
		v_statussector := (SELECT value::json->>'SECTOR' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');
		v_statuspresszone := (SELECT value::json->>'PRESSZONE' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');
		v_statusdma := (SELECT value::json->>'DMA' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');
		v_statusdqa := (SELECT value::json->>'DQA' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');

		-- get values
		SELECT to_json(array_agg(row_to_json(row))) INTO v_sector FROM (SELECT sector_id as id, stylesheet::json FROM v_edit_sector) row;
		SELECT to_json(array_agg(row_to_json(row))) INTO v_presszone FROM (SELECT presszone_id as id , stylesheet::json FROM v_edit_presszone) row;
		SELECT to_json(array_agg(row_to_json(row))) INTO v_dma FROM (SELECT dma_id as id, stylesheet::json FROM v_edit_dma) row;
		SELECT to_json(array_agg(row_to_json(row))) INTO v_dqa FROM (SELECT dqa_id as id, stylesheet::json FROM v_edit_dqa) row;

	ELSE
		-- control nulls
		v_statussector := COALESCE(v_sector, '{}');
		v_statuspresszone := COALESCE(v_sector, '{}');
		v_statusdma := COALESCE(v_sector, '{}');
		v_statusdqa := COALESCE(v_sector, '{}');	

	END IF;

	v_sector := COALESCE(v_sector, '{}');
	v_dma  := COALESCE(v_dma, '{}');
	v_presszone := COALESCE(v_presszone, '{}');
	v_dqa  := COALESCE(v_dqa, '{}');
	
	--    Return
	RETURN ('{"status":"Accepted", "version":'||v_version||
             ',"body":{"message":{}'||
			',"data":{"mapzones":
				[{"name":"sector", "status": "'||v_statussector||'", "idname": "sector_id", "layer":"v_edit_sector", "opacity":0.5, "values":' || v_sector ||'}'||
				',{"name":"presszone", "status": "'||v_statuspresszone||'", "idname": "presszone_id",  "layer":"v_edit_presszone", "opacity":0.5,  "values":' || v_presszone ||'}'||
				',{"name":"dma",  "status": "'||v_statusdma||'", "idname": "dma_id", "layer":"v_edit_dma", "opacity":0.5, "values":' || v_dma ||'}'||
				',{"name":"dqa",  "status": "'||v_statusdqa||'", "idname": "dqa_id", "layer":"v_edit_dqa", "opacity":0.5, "values":' || v_dqa ||'}'||
				']}}'||
	    '}')::json;
      
	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
