/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2870

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_setselectors (json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setselectors(p_data json)
  RETURNS json AS
$BODY$

/*example
SELECT SCHEMA_NAME.gw_fct_setselectors($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"None", "tabName":"tab_exploitation", "checkAll":"True", "addSchema":"None"}}$$);
SELECT SCHEMA_NAME.gw_fct_setselectors($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"explfrommuni", "id":32, "value":true, "isAlone":true, "addSchema":"ud"}}$$)::text

SELECT SCHEMA_NAME.gw_fct_setselectors($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"selector_basic", "tabName":"tab_psector", "id":"1", "isAlone":"True", "value":"True", "addSchema":"None", "useAtlas":true}}$$);



*/

DECLARE

v_version json;
v_tabname text;
v_tablename text;
v_columnname text;
v_id integer;
v_value text;
v_muni integer;
v_isalone boolean;
v_parameter_selector json;
v_data json;
v_expl integer;
v_addschema text;
v_error_context text;
v_selectortype text;
v_schemaname text;
v_return json;
v_table text;
v_tableid text;
v_checkall boolean;
v_geometry text;
v_useatlas boolean;
v_querytext text;
v_message text = '{"level":1, "text":"Process done successfully"}';
v_count integer = 0;
v_count_aux integer = 0;
v_name text;


BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';
	
	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;
	
	-- Get input parameters:
	v_tabname := (p_data ->> 'data')::json->> 'tabName';
	v_selectortype := (p_data ->> 'data')::json->> 'selectorType';
	v_id := (p_data ->> 'data')::json->> 'id';
	v_value := (p_data ->> 'data')::json->> 'value';
	v_isalone := (p_data ->> 'data')::json->> 'isAlone';
	v_checkall := (p_data ->> 'data')::json->> 'checkAll';
	v_addschema := (p_data ->> 'data')::json->> 'addSchema';
	v_useatlas := (p_data ->> 'data')::json->> 'useAtlas';
	v_data = p_data->>'data';
	
	-- profilactic control
	IF lower(v_selectortype) = 'none' OR v_selectortype = '' OR lower(v_selectortype) ='null' THEN v_selectortype = 'selector_basic'; END IF;
	IF v_useatlas IS null then v_useatlas = true; END IF;

	-- profilactic control of schema name
	IF lower(v_addschema) = 'none' OR v_addschema = '' OR lower(v_addschema) ='null'
		THEN v_addschema = null; 
	ELSE
		IF (select schemaname from pg_tables WHERE schemaname = v_addschema LIMIT 1) IS NULL THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
            "data":{"message":"3132", "function":"2870","debug_msg":null}}$$)';
			-- todo: send message to response
		END IF;
	END IF;

	-- looking for additional schema 
	IF v_addschema IS NOT NULL AND v_addschema != v_schemaname THEN
		EXECUTE 'SET search_path = '||v_addschema||', public';
		PERFORM gw_fct_setselectors(p_data);
		SET search_path = 'SCHEMA_NAME', public;
	END IF;

	-- Get system parameters
	v_parameter_selector = (SELECT value::json FROM config_param_system WHERE parameter = concat('basic_selector_', v_tabname));
	v_tablename = v_parameter_selector->>'selector';
	v_columnname = v_parameter_selector->>'selector_id'; 
	v_table = v_parameter_selector->>'table';
	v_tableid = v_parameter_selector->>'table_id';	

	-- get expl from muni
	IF v_selectortype = 'explfrommuni' THEN

		-- getting specifics parameters
		v_parameter_selector = (SELECT value::json FROM config_param_system WHERE parameter = 'basic_selector_explfrommuni');
		v_tablename = v_parameter_selector->>'selector';
		v_columnname = v_parameter_selector->>'selector_id'; 

		v_id = (SELECT expl_id FROM exploitation e, ext_municipality m 
			WHERE e.active IS TRUE AND st_dwithin(st_centroid(e.the_geom), m.the_geom, 0) AND muni_id::text = v_id::text limit 1);
		EXECUTE 'DELETE FROM selector_expl WHERE cur_user = current_user';
		EXECUTE 'INSERT INTO selector_expl (expl_id, cur_user) VALUES('|| v_id ||', '''|| current_user ||''')';	
	END IF;

	IF (v_checkall IS NULL OR v_checkall IS FALSE) AND (SELECT json_extract_path_text(value::json,'sectorfromexpl')::boolean 
		FROM config_param_system WHERE parameter = 'basic_selector_mapzone_relation') IS TRUE AND v_tabname='tab_exploitation' THEN

		IF  v_value='True' THEN
			IF v_isalone IS TRUE THEN
				EXECUTE 'DELETE FROM selector_sector WHERE cur_user = current_user';
				EXECUTE 'DELETE FROM selector_expl WHERE cur_user = current_user';
			END IF;
			EXECUTE 'INSERT INTO selector_sector (sector_id, cur_user) 
			SELECT sector_id, current_user FROM exploitation e, sector s 
			WHERE e.active IS TRUE AND st_dwithin(st_buffer(e.the_geom,0.5,''side=right''), s.the_geom,0) 
			AND expl_id = '||v_id||' ON CONFLICT (sector_id,cur_user) DO NOTHING;';
		ELSE
			EXECUTE 'DELETE FROM selector_sector WHERE cur_user = current_user AND sector_id IN
			(SELECT sector_id FROM exploitation e, sector s 
			WHERE e.active IS TRUE  AND st_dwithin(st_buffer(e.the_geom,0.5,''side=right''), s.the_geom,0) 
			AND expl_id = '||v_id||');';
		END IF;

	ELSIF (v_checkall IS NULL OR v_checkall IS FALSE) AND (SELECT json_extract_path_text(value::json,'sectorfromexpl')::boolean 
	FROM config_param_system WHERE parameter = 'basic_selector_mapzone_relation') IS TRUE AND v_tabname='tab_macroexploitation' THEN

		EXECUTE 'DELETE FROM selector_sector WHERE cur_user = current_user';
		IF  v_value='True' THEN
			EXECUTE 'INSERT INTO selector_sector (sector_id, cur_user) 
			SELECT DISTINCT sector_id, current_user 
			FROM sector s, exploitation e
			JOIN macroexploitation USING (macroexpl_id)
			WHERE e.active IS TRUE  AND st_dwithin(st_buffer(e.the_geom,0.5,''side=right''), s.the_geom,0) 
			AND macroexpl_id = '||v_id||';';
		END IF;
	END IF;

	IF (v_checkall IS NULL OR v_checkall IS FALSE) AND (SELECT json_extract_path_text(value::json,'explfromsector')::boolean 
		FROM config_param_system WHERE parameter = 'basic_selector_mapzone_relation') IS TRUE AND v_tabname='tab_sector' THEN
 
		IF  v_value='True' THEN
			IF v_isalone IS TRUE THEN
				EXECUTE 'DELETE FROM selector_sector WHERE cur_user = current_user';
				EXECUTE 'DELETE FROM selector_expl WHERE cur_user = current_user';
			END IF;
			EXECUTE 'INSERT INTO selector_expl (expl_id, cur_user) 
			SELECT expl_id, current_user FROM exploitation e, sector s 
			WHERE e.active IS TRUE AND st_dwithin(e.the_geom, st_buffer(s.the_geom,0.5,''side=right''),0) 
			AND sector_id = '||v_id||' ON CONFLICT (expl_id,cur_user) DO NOTHING;';
		ELSE
			EXECUTE 'DELETE FROM selector_expl WHERE cur_user = current_user AND expl_id IN
			(SELECT expl_id FROM exploitation e, sector s 
			WHERE e.active IS TRUE AND st_dwithin(e.the_geom, st_buffer(s.the_geom,0.5,''side=right''),0) 
			AND sector_id = '||v_id||');';
		END IF;


	END IF;

	-- manage check all
	IF v_checkall THEN
		IF v_table ='plan_psector' THEN -- to manage only those psectors related to selected exploitations
			EXECUTE 'INSERT INTO ' || v_tablename || ' ('|| v_columnname ||', cur_user) SELECT '||v_tableid||', current_user FROM '||v_table||
			' WHERE expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user) ON CONFLICT DO NOTHING';
		ELSE
			EXECUTE 'INSERT INTO ' || v_tablename || ' ('|| v_columnname ||', cur_user) SELECT '||v_tableid||', current_user FROM '||v_table||' ON CONFLICT DO NOTHING';
		END IF;
		
	ELSIF v_checkall IS FALSE THEN
		EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE cur_user = current_user';
		
	ELSE
		-- manage isalone
		IF v_isalone OR v_checkall IS FALSE THEN
			EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE cur_user = current_user';
		END IF;

		IF v_tabname='tab_macroexploitation' THEN
			-- manage value
			IF v_value THEN
				EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE cur_user = current_user';
				EXECUTE 'INSERT INTO ' || v_tablename || ' ('|| v_columnname ||', cur_user) 
				SELECT '|| v_columnname ||', current_user FROM exploitation WHERE '||v_tableid||' = '||v_id||';';
			ELSE
				EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE cur_user = current_user AND 
				' || v_columnname || ' IN (SELECT '|| v_columnname ||' FROM exploitation WHERE '||v_tableid||' = '||v_id||');';
			END IF;
		ELSE
			-- manage value
			IF v_value THEN
				EXECUTE 'INSERT INTO ' || v_tablename || ' ('|| v_columnname ||', cur_user) VALUES('|| v_id ||', '''|| current_user ||''')ON CONFLICT DO NOTHING';
			ELSE
				EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE ' || v_columnname || ' = '|| v_id ||' AND cur_user = current_user';
			END IF;
		END IF;

	END IF;

	-- manage parents
	IF v_tabname IN ('tab_psector', 'tab_dscenario') AND v_checkall is null THEN

		-- getting name
		v_name = substring (v_tabname,5,99);
	
		IF v_value THEN
			-- getting parent_id for selected row
			EXECUTE 'SELECT parent_id FROM '||v_table||' WHERE active IS TRUE AND parent_id IS NOT NULL AND '||v_tableid||' = '||v_id
			INTO v_id;

			IF v_id IS NOT NULL THEN
				-- force parent_id to be visible if child have been enabled
				EXECUTE 'INSERT INTO ' || v_tablename || ' ('|| v_columnname ||', cur_user) VALUES('|| v_id ||', '''|| current_user ||''')ON CONFLICT DO NOTHING';
				GET DIAGNOSTICS v_count = row_count;
				IF v_count > 0 THEN
					v_message = concat ('{"level":0, "text":"',v_name,' ',v_id,' have been enabled, because of its parent-relation with selected ', v_name,'"}');
				END IF;
			END IF;
		ELSE
			-- getting childs for parent_id for selected row	
			v_querytext = 'SELECT '||v_tableid||' FROM '||v_table||' WHERE active IS TRUE AND parent_id = '||v_id;

			FOR v_id IN EXECUTE v_querytext
			LOOP
				EXECUTE 'DELETE FROM '||v_tablename||' WHERE ' || v_columnname || ' = '|| v_id ||' AND cur_user = current_user';
				GET DIAGNOSTICS v_count_aux = row_count;
				v_count = v_count + v_count_aux;
			END LOOP;

			IF v_count > 0 THEN
				v_message = concat ('{"level":0, "text":"',v_count,' ',v_name,'(s) have been disabled, because of its child-relation from selected ', v_name,'"}');
			END IF;
		END IF;
	END IF;

	-- get envelope over arcs or over exploitation if arcs dont exist
	IF v_tabname='tab_sector' THEN
		SELECT row_to_json (a) 
		INTO v_geometry
		FROM (SELECT st_xmin(the_geom)::numeric(12,2) as x1, st_ymin(the_geom)::numeric(12,2) as y1, 
		st_xmax(the_geom)::numeric(12,2) as x2, st_ymax(the_geom)::numeric(12,2) as y2 
		FROM (SELECT st_collect(the_geom) as the_geom FROM sector where sector_id IN
		(SELECT sector_id FROM selector_sector WHERE cur_user=current_user)) b) a;
		
	ELSIF v_tabname IN ('tab_hydro_state', 'tab_psector', 'tab_network_state', 'tab_dscenario') THEN
		v_geometry = NULL;

	ELSIF (SELECT the_geom FROM v_edit_arc LIMIT 1) IS NOT NULL or (v_checkall IS False and v_id is null) THEN
		SELECT row_to_json (a) 
		INTO v_geometry
		FROM (SELECT st_xmin(the_geom)::numeric(12,2) as x1, st_ymin(the_geom)::numeric(12,2) as y1, st_xmax(the_geom)::numeric(12,2) as x2, st_ymax(the_geom)::numeric(12,2) as y2 
		FROM (SELECT st_collect(the_geom) as the_geom FROM v_edit_arc) b) a;
		
	ELSIF v_tabname='tab_exploitation' THEN
		SELECT row_to_json (a) 
		INTO v_geometry
		FROM (SELECT st_xmin(the_geom)::numeric(12,2) as x1, st_ymin(the_geom)::numeric(12,2) as y1, st_xmax(the_geom)::numeric(12,2) as x2, st_ymax(the_geom)::numeric(12,2) as y2 
		FROM (SELECT the_geom FROM exploitation where expl_id=v_id) b) a;
	END IF;

	/*set expl as vdefault if only one value on selector. In spite expl_vdefault is a hidden value, user can enable this variable if he needs it when working on more than
	one exploitation in order to choose what is the default (remember default value has priority over spatial intersection)*/ 
	IF (SELECT count (*) FROM selector_expl WHERE cur_user = current_user) = 1 THEN
	
		v_expl = (SELECT expl_id FROM selector_expl WHERE cur_user = current_user);
		
		INSERT INTO config_param_user(parameter, value, cur_user)
		VALUES ('edit_exploitation_vdefault', v_expl, current_user) ON CONFLICT (parameter, cur_user) 
		DO UPDATE SET value = v_expl WHERE config_param_user.parameter = 'edit_exploitation_vdefault' AND config_param_user.cur_user = current_user;
	ELSE -- delete if more than one value on selector
		DELETE FROM config_param_user WHERE parameter = 'edit_exploitation_vdefault' AND cur_user = current_user;
	END IF;

	-- Control NULL's
	v_geometry := COALESCE(v_geometry, '{}');

	-- Return
	v_return = concat('{"client":{"device":4, "infoType":1, "lang":"ES"}, "message":', v_message, ', "form":{"currentTab":"', v_tabname,'"}, "feature":{}, "data":{"geometry":',
	v_geometry,', "useAtlas":"',v_useatlas,'", "selectorType":"',v_selectortype,'"}}');
	RETURN gw_fct_getselectors(v_return);

	
	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  