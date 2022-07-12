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
v_colsector text;
v_colpresszone text;
v_coldma text;
v_coldqa text;
v_opasector text;
v_opapresszone text;
v_opadma text;
v_opadqa text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	SELECT project_type INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

        IF v_project_type = 'WS' THEN

		-- get mode	
		v_statussector := (SELECT (value::json->>'SECTOR')::json->>'mode' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');
		v_statuspresszone := (SELECT (value::json->>'PRESSZONE')::json->>'mode' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');
		v_statusdma := (SELECT (value::json->>'DMA')::json->>'mode' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');
		v_statusdqa := (SELECT (value::json->>'DQA')::json->>'mode' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');

		-- get column to simbolize
		v_colsector := (SELECT (value::json->>'SECTOR')::json->>'column' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');
		v_colpresszone := (SELECT (value::json->>'PRESSZONE')::json->>'column' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');
		v_coldma := (SELECT (value::json->>'DMA')::json->>'column' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');
		v_coldqa := (SELECT (value::json->>'DQA')::json->>'column' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');

		-- get column to simbolize
		v_opasector := (SELECT (value::json->>'SECTOR')::json->>'opacity' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');
		v_opapresszone := (SELECT (value::json->>'PRESSZONE')::json->>'opacity' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');
		v_opadma := (SELECT (value::json->>'DMA')::json->>'opacity' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');
		v_opadqa := (SELECT (value::json->>'DQA')::json->>'opacity' FROM config_param_system WHERE parameter = 'utils_grafanalytics_dynamic_symbology');

		-- get mapzone values
		EXECUTE 'SELECT to_json(array_agg(row_to_json(row)))FROM (SELECT '||v_colsector||' as id, stylesheet::json FROM v_edit_sector WHERE sector_id > 0 and stylesheet IS NOT NULL) row' INTO v_sector ;
		EXECUTE 'SELECT to_json(array_agg(row_to_json(row))) FROM (SELECT '||v_colpresszone||' as id ,  stylesheet::json FROM v_edit_presszone WHERE presszone_id NOT IN (''0'', ''-1'') and stylesheet IS NOT NULL) row' INTO v_presszone ;
		EXECUTE 'SELECT to_json(array_agg(row_to_json(row))) FROM (SELECT '||v_coldma||' as id, stylesheet::json FROM v_edit_dma WHERE dma_id > 0 and stylesheet IS NOT NULL) row' INTO v_dma ;
		EXECUTE 'SELECT to_json(array_agg(row_to_json(row))) FROM (SELECT '||v_coldqa||' as id, stylesheet::json FROM v_edit_dqa WHERE dqa_id > 0 and stylesheet IS NOT NULL) row' INTO v_dqa ;

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
	v_colsector  := COALESCE(v_colsector, '{}');
	v_colpresszone  := COALESCE(v_colpresszone, '{}');
	v_coldma  := COALESCE(v_coldma, '{}');
	v_coldqa  := COALESCE(v_coldqa, '{}');
	v_opasector  := COALESCE(v_opasector, '50');
	v_opapresszone := COALESCE(v_opapresszone, '50');
	v_opadma := COALESCE(v_opadma, '50');
	v_opadqa := COALESCE(v_opadqa, '50');
	

	--    Return
	RETURN ('{"status":"Accepted", "version":'||v_version||
             ',"body":{"message":{}'||
			',"data":{"mapzones":
				[{"name":"sector", "status": "'||v_statussector||'", "idname": "'||v_colsector||'", "layer":"v_edit_sector", "opacity":'||v_opasector||', "values":' || v_sector ||'}'||
				',{"name":"presszone", "status": "'||v_statuspresszone||'", "idname":"'||v_colpresszone||'",  "layer":"v_edit_presszone", "opacity":'||v_opapresszone||',  "values":' || v_presszone ||'}'||
				',{"name":"dma",  "status": "'||v_statusdma||'", "idname": "'||v_coldma||'", "layer":"v_edit_dma", "opacity":'||v_opadma||', "values":' || v_dma ||'}'||
				',{"name":"dqa",  "status": "'||v_statusdqa||'", "idname": "'||v_coldqa||'", "layer":"v_edit_dqa", "opacity":'||v_opadqa||', "values":' || v_dqa ||'}'||
				']}}'||
	    '}')::json;


	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;