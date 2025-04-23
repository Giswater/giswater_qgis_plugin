/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2928

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getstylemapzones(p_data json)
  RETURNS json AS
$BODY$

/* EXAMPLE
SELECT SCHEMA_NAME.gw_fct_getstylemapzones($${"client":{"device":4, "infoType":1, "lang":"ES"},"data":{}}$$)

SELECT SCHEMA_NAME.gw_fct_getstylemapzones($${"client":{"device":4, "infoType":1, "lang":"ES"},"data":{"graphClass":"DMA", "tempLayer":"graphanalytics tstep process", "idName":"mapzone_id"}}$$)


*/

DECLARE

v_version json;
v_sector json;
v_dma json;
v_presszone json;
v_dqa json;
v_modesector text = 'Random';
v_modepresszone text = 'Random';
v_modedma text = 'Random';
v_modedqa text = 'Random';
v_project_type text;
v_colsector text;
v_colpresszone text;
v_coldma text;
v_coldqa text;
v_trasector text;
v_trapresszone text;
v_tradma text;
v_tradqa text;
v_drainzone json;
v_modedrainzone text = 'Random';
v_coldrainzone text;
v_tradrainzone text;
v_netscenario_dma json;
v_netscenario_presszone json;
v_graphclass text;
v_stylesheet json;
v_mode text = 'Random';
v_transparency text;
v_templayer text;
v_idname text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	SELECT project_type INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	v_graphclass = ((p_data ->>'data')::json->>'graphClass');
	v_templayer = ((p_data ->>'data')::json->>'tempLayer');
	v_idname = ((p_data ->>'data')::json->>'idName');


	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
    INTO v_version;

	IF 	v_graphclass IS NOT NULL THEN -- called after getgraphinundation

		EXECUTE 'SELECT to_json(array_agg(row_to_json(row))) FROM (SELECT '||lower(concat(v_graphclass,'_id'))||' as id, stylesheet::json FROM '||lower(v_graphclass)||'
				 WHERE '||lower(concat(v_graphclass,'_id'))||' > 0 and active IS TRUE) row'
		INTO v_stylesheet;

		EXECUTE 'SELECT (value::json->>'''||upper(v_graphclass)||''')::json->>''transparency'' FROM config_param_system WHERE parameter=''utils_graphanalytics_style'';'
		INTO v_transparency;

		EXECUTE 'SELECT (value::json->>'''||upper(v_graphclass)||''')::json->>''mode'' FROM config_param_system WHERE parameter=''utils_graphanalytics_style'';'
		INTO v_mode;

		-- Control null
		v_stylesheet  := COALESCE(v_stylesheet, '{}');
		v_transparency  := COALESCE(v_transparency, '{}');
		v_mode  := COALESCE(v_mode, '{}');

		--    Return
		RETURN ('{"status":"Accepted", "version":'||v_version||
				 ',"body":{"message":{}'||
				',"data":{"mapzones":
					[{"name":"graphinundation",  "mode": "'||v_mode||'", "layer":"'||v_templayer||'", "idname": "'||v_idname||'", "transparency":'||v_transparency||', "values":' || v_stylesheet ||'}'||
					']}}'||
			'}')::json;

	ELSE

		-- get mode
		v_modesector := (SELECT (value::json->>'SECTOR')::json->>'mode' FROM config_param_system WHERE parameter='utils_graphanalytics_style');
		v_modedma := (SELECT (value::json->>'DMA')::json->>'mode' FROM config_param_system WHERE parameter='utils_graphanalytics_style');

		-- get column to simbolize
		v_colsector := (SELECT (value::json->>'SECTOR')::json->>'column' FROM config_param_system WHERE parameter='utils_graphanalytics_style');
		v_coldma := (SELECT (value::json->>'DMA')::json->>'column' FROM config_param_system WHERE parameter='utils_graphanalytics_style');

		-- get transparency
		v_trasector := (SELECT (value::json->>'SECTOR')::json->>'transparency' FROM config_param_system WHERE parameter='utils_graphanalytics_style');
		v_tradma := (SELECT (value::json->>'DMA')::json->>'transparency' FROM config_param_system WHERE parameter='utils_graphanalytics_style');

		-- get mapzone values
		EXECUTE 'SELECT to_json(array_agg(row_to_json(row)))FROM (SELECT '||v_colsector||' as id, stylesheet::json FROM v_edit_sector WHERE sector_id > 0) row' INTO v_sector;

		IF v_project_type = 'WS' THEN

			v_modepresszone := (SELECT (value::json->>'PRESSZONE')::json->>'mode' FROM config_param_system WHERE parameter='utils_graphanalytics_style');
			v_modedqa := (SELECT (value::json->>'DQA')::json->>'mode' FROM config_param_system WHERE parameter='utils_graphanalytics_style');

			v_colpresszone := (SELECT (value::json->>'PRESSZONE')::json->>'column' FROM config_param_system WHERE parameter='utils_graphanalytics_style');
			v_coldqa := (SELECT (value::json->>'DQA')::json->>'column' FROM config_param_system WHERE parameter='utils_graphanalytics_style');

			v_trapresszone := (SELECT (value::json->>'PRESSZONE')::json->>'transparency' FROM config_param_system WHERE parameter='utils_graphanalytics_style');
			v_tradqa := (SELECT (value::json->>'DQA')::json->>'transparency' FROM config_param_system WHERE parameter='utils_graphanalytics_style');

			EXECUTE 'SELECT to_json(array_agg(row_to_json(row))) FROM (SELECT '||v_coldma||' as id, stylesheet::json FROM v_edit_dma WHERE dma_id > 0) row' INTO v_dma;
			EXECUTE 'SELECT to_json(array_agg(row_to_json(row))) FROM (SELECT '||v_colpresszone||' as id, stylesheet::json FROM v_edit_presszone WHERE presszone_id NOT IN (''0'', ''-1'')) row' INTO v_presszone ;
			EXECUTE 'SELECT to_json(array_agg(row_to_json(row))) FROM (SELECT '||v_coldqa||' as id, stylesheet::json FROM v_edit_dqa WHERE dqa_id > 0) row' INTO v_dqa ;
			EXECUTE 'SELECT to_json(array_agg(row_to_json(row))) FROM (SELECT '||v_coldma||' as id, null as stylesheet FROM v_edit_plan_netscenario_dma WHERE dma_id > 0 ) row' INTO v_netscenario_dma;
			EXECUTE 'SELECT to_json(array_agg(row_to_json(row))) FROM (SELECT '||v_colpresszone||' as id, null as stylesheet FROM v_edit_plan_netscenario_presszone WHERE presszone_id NOT IN (''0'', ''-1'') ) row' INTO v_netscenario_presszone ;

		ELSIF v_project_type = 'UD' THEN

			-- get mode
			v_modedrainzone := (SELECT (value::json->>'DRAINZONE')::json->>'mode' FROM config_param_system WHERE parameter='utils_graphanalytics_style');

			-- get column to simbolize
			v_coldrainzone := (SELECT (value::json->>'DRAINZONE')::json->>'column' FROM config_param_system WHERE parameter='utils_graphanalytics_style');

			-- get transparency
			v_tradrainzone := (SELECT (value::json->>'DRAINZONE')::json->>'transparency' FROM config_param_system WHERE parameter='utils_graphanalytics_style');

			-- get mapzone values
			EXECUTE 'SELECT to_json(array_agg(row_to_json(row)))FROM (SELECT '||v_coldrainzone||' as id, stylesheet::json FROM v_edit_drainzone WHERE drainzone_id > 0) row' INTO v_drainzone;

		END IF;

		v_sector := COALESCE(v_sector, '{}');
		v_dma  := COALESCE(v_dma, '{}');
		v_presszone := COALESCE(v_presszone, '{}');
		v_dqa  := COALESCE(v_dqa, '{}');
		v_drainzone  := COALESCE(v_drainzone, '{}');
		v_netscenario_dma  := COALESCE(v_netscenario_dma, '{}');
		v_netscenario_presszone  := COALESCE(v_netscenario_presszone, '{}');
		v_colsector  := COALESCE(v_colsector, '{}');
		v_colpresszone  := COALESCE(v_colpresszone, '{}');
		v_coldma  := COALESCE(v_coldma, '{}');
		v_coldqa  := COALESCE(v_coldqa, '{}');
		v_coldrainzone  := COALESCE(v_coldrainzone, '{}');
		v_trasector  := COALESCE(v_trasector, '0.5');
		v_trapresszone := COALESCE(v_trapresszone, '0.5');
		v_tradma := COALESCE(v_tradma, '0.5');
		v_tradqa := COALESCE(v_tradqa, '0.5');
		v_tradrainzone := COALESCE(v_tradrainzone, '0.5');

		--    Return
		RETURN ('{"status":"Accepted", "version":'||v_version||
					',"body":{"message":{}'||
				',"data":{"mapzones":
					[{"name":"sector", "mode": "'||v_modesector||'", "idname": "'||v_colsector||'", "layer":"v_edit_sector", "transparency":'||v_trasector||', "values":' || v_sector ||'}'||
					',{"name":"presszone", "mode": "'||v_modepresszone||'", "idname":"'||v_colpresszone||'",  "layer":"v_edit_presszone", "transparency":'||v_trapresszone||',  "values":' || v_presszone ||'}'||
					',{"name":"dma",  "mode": "'||v_modedma||'", "idname": "'||v_coldma||'", "layer":"v_edit_dma", "transparency":'||v_tradma||', "values":' || v_dma ||'}'||
					',{"name":"dqa",  "mode": "'||v_modedqa||'", "idname": "'||v_coldqa||'", "layer":"v_edit_dqa", "transparency":'||v_tradqa||', "values":' || v_dqa ||'}'||
					',{"name":"netscenario_dma",  "mode": "'||v_modedma||'", "idname": "'||v_coldma||'", "layer":"v_edit_plan_netscenario_dma", "transparency":'||v_tradma||', "values":' || v_netscenario_dma ||'}'||
					',{"name":"netscenario_presszone",  "mode": "'||v_modepresszone||'", "idname": "'||v_colpresszone||'", "layer":"v_edit_plan_netscenario_presszone", "transparency":'||v_trapresszone||', "values":' || v_netscenario_presszone ||'}'||
					',{"name":"drainzone",  "mode": "'||v_modedrainzone||'", "idname": "'||v_coldrainzone||'", "layer":"v_edit_drainzone", "transparency":'||v_tradrainzone||', "values":' || v_drainzone ||'}'||
					']}}'||
			'}')::json;
	END IF;


	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE)::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;