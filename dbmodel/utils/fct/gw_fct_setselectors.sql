/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2870

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setselectors(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*example
SELECT SCHEMA_NAME.gw_fct_setselectors($${"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"test_user"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"None", "tabName":"tab_exploitation", "forceParent":"True", "checkAll":"True", "addSchema":"None"}}$$);
SELECT SCHEMA_NAME.gw_fct_setselectors($${"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"test_user"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"explfrommuni", "id":32, "value":true, "isAlone":true, "addSchema":"ud"}}$$)::text

SELECT SCHEMA_NAME.gw_fct_setselectors($${"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"test_user"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"selector_basic", "tabName":"tab_psector", "id":"1", "ids":"[1,2]", "isAlone":"True", "value":"True", "addSchema":"None", "useAtlas":true}}$$);

SELECT SCHEMA_NAME.gw_fct_setselectors($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"selector_mincut", "tabName":"tab_mincut", "checkAll":"True", "addSchema":"NULL"}}$$);

SELECT SCHEMA_NAME.gw_fct_setselectors($${"client":{"device":4, "lang":"", "epsg":25830}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{},
"selectorType":"explfrommuni", "id":527, "value":true, "isAlone":true, "addSchema":"ud"}

fid: 397

select * from SCHEMA_NAME.anl_arc

*/

DECLARE

v_version json;
v_tabname text;
v_tablename text;
v_columnname text;
v_id text;
v_ids text;
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
v_disableparent boolean;
v_fid integer = 397;
v_uservalues json;
v_action text = null;
v_sector integer;
v_zonetable text;
v_cur_user text;
v_prev_cur_user text;
v_device integer;
v_expand float=50;
v_tiled boolean;
v_result json;
v_result_init json;
v_result_valve json;
v_result_node json;
v_result_connec json;
v_result_arc json;
v_expl_x_user boolean;
v_project_type text;
v_psector_current_value integer;
v_sectorisexplismuni boolean;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;

	-- get system variables
	v_expl_x_user = (SELECT value FROM config_param_system WHERE parameter = 'admin_exploitation_x_user');
	v_project_type = (SELECT project_type FROM sys_version LIMIT 1);

	-- Get input parameters:
	v_tabname := (p_data ->> 'data')::json->> 'tabName';
	v_selectortype := (p_data ->> 'data')::json->> 'selectorType';
	v_id := (p_data ->> 'data')::json->> 'id';
	v_ids := (p_data ->> 'data')::json->> 'ids';
	v_value := (p_data ->> 'data')::json->> 'value';
	v_isalone := (p_data ->> 'data')::json->> 'isAlone';
	v_checkall := (p_data ->> 'data')::json->> 'checkAll';
	v_addschema := (p_data ->> 'data')::json->> 'addSchema';
	v_useatlas := (p_data ->> 'data')::json->> 'useAtlas';
	v_disableparent := (p_data ->> 'data')::json->> 'disableParent';
	v_data = p_data->>'data';
	v_cur_user := (p_data ->> 'client')::json->> 'cur_user';
	v_device := (p_data ->> 'client')::json->> 'device';

	v_tiled := ((p_data ->>'client')::json->>'tiled')::boolean;
	v_prev_cur_user = current_user;
	IF v_cur_user IS NOT NULL THEN
		EXECUTE 'SET ROLE "'||v_cur_user||'"';
	END IF;

	-- profilactic control
	IF lower(v_selectortype) = 'none' OR v_selectortype = '' OR lower(v_selectortype) ='null' THEN v_selectortype = 'selector_basic'; END IF;
	IF v_useatlas IS null then v_useatlas = false; END IF;

	-- profilactic control of schema name
	IF lower(v_addschema) = 'none' OR v_addschema = '' OR lower(v_addschema) ='null' OR v_addschema is null OR v_addschema='NULL'
		THEN v_addschema = null;
	ELSE
		IF (select schemaname from pg_tables WHERE schemaname = v_addschema LIMIT 1) IS NULL THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
	            "data":{"message":"3132", "function":"2870","parameters":null, "is_process":true}}$$)';
		-- todo: send message to response
		END IF;
	END IF;

	-- control null tabname when layout of municipalities appear
	IF v_tabname IS NULL AND v_selectortype = 'explfrommuni' THEN
		v_tabname = 'tab_municipality';
	END IF;

	-- Get system parameters
	v_parameter_selector = (SELECT value::json FROM config_param_system WHERE parameter = concat('basic_selector_', v_tabname));
	v_tablename = v_parameter_selector->>'selector';
	v_columnname = v_parameter_selector->>'selector_id';
	v_table = v_parameter_selector->>'table';
	v_tableid = v_parameter_selector->>'table_id';
	v_sectorisexplismuni = (SELECT value::boolean FROM config_param_system WHERE parameter = 'basic_selector_sectorisexplismuni');

	IF v_sectorisexplismuni IS NULL THEN v_sectorisexplismuni = FALSE; END IF;
	
	-- setting schema add
	IF v_tabname like '%add%' AND v_addschema IS NOT NULL THEN
		v_tablename = concat(v_addschema,'.',v_tablename);
		v_table = concat(v_addschema,'.',v_table);
	END IF;

	-- create temp tables related to expl x user variable
	DROP TABLE IF EXISTS temp_exploitation;
	DROP TABLE IF EXISTS temp_macroexploitation;
	DROP TABLE IF EXISTS temp_sector;
	DROP TABLE IF EXISTS temp_macrosector;
	DROP TABLE IF EXISTS temp_municipality;
	DROP TABLE IF EXISTS temp_t_mincut;
	DROP TABLE IF EXISTS temp_network;

	IF v_expl_x_user is false THEN
		CREATE TEMP TABLE temp_exploitation as select e.* from exploitation e WHERE active and expl_id > 0 order by 1;
		CREATE TEMP TABLE temp_macroexploitation as select e.* from macroexploitation e WHERE active and macroexpl_id > 0 order by 1;
		CREATE TEMP TABLE temp_sector as select e.* from sector e WHERE active and sector_id > 0 order by 1;
		CREATE TEMP TABLE temp_macrosector as select e.* from macrosector e WHERE active and macrosector_id > 0 order by 1;
		CREATE TEMP TABLE temp_municipality as select em.* from ext_municipality em WHERE active and muni_id > 0 order by 1;
		CREATE TEMP TABLE temp_network AS SELECT id::integer as network_id, idval as name, true as active
		FROM om_typevalue WHERE typevalue = 'network_type' order by id;

		IF v_project_type = 'WS' THEN
			CREATE TEMP TABLE temp_t_mincut as select e.* from om_mincut e WHERE id > 0 order by 1;
		END IF;
	ELSE
		CREATE TEMP TABLE temp_exploitation as select e.* from exploitation e
		JOIN config_user_x_expl USING (expl_id)	WHERE e.active and expl_id > 0 and username = current_user order by 1;

		CREATE TEMP TABLE temp_network AS SELECT id::integer as network_id, idval as name, true as active
		FROM om_typevalue WHERE typevalue = 'network_type' order by id;

		CREATE TEMP TABLE temp_macroexploitation as select distinct on (m.macroexpl_id) m.* from macroexploitation m
		JOIN temp_exploitation e USING (macroexpl_id)
		WHERE m.active and m.macroexpl_id > 0 order by 1;

		CREATE TEMP TABLE temp_sector as
		select distinct on (s.sector_id) s.sector_id, s.name, s.macrosector_id, s.descript, s.active from sector s
		JOIN (SELECT DISTINCT node.sector_id, node.expl_id FROM node WHERE node.state > 0)n USING (sector_id)
		JOIN exploitation e ON e.expl_id=n.expl_id
		JOIN config_user_x_expl c ON c.expl_id=n.expl_id WHERE s.active and s.sector_id > 0 and username = current_user
 			UNION
		select distinct on (s.sector_id) s.sector_id, s.name, s.macrosector_id, s.descript, s.active from sector s
		JOIN (SELECT DISTINCT node.sector_id, node.expl_id FROM node WHERE node.state > 0)n USING (sector_id)
		WHERE n.sector_id is null AND s.active and s.sector_id > 0
		order by 1;

		CREATE TEMP TABLE temp_macrosector as select distinct on (m.macrosector_id) m.* from macrosector m
		JOIN temp_sector e USING (macrosector_id)
		WHERE m.active and m.macrosector_id > 0;

		CREATE TEMP TABLE temp_municipality as
		select distinct on (muni_id) muni_id, em.name, descript, em.active from ext_municipality em
		JOIN (SELECT DISTINCT expl_id, muni_id FROM node)n USING (muni_id)
		JOIN exploitation e ON e.expl_id=n.expl_id
		JOIN config_user_x_expl c ON c.expl_id=n.expl_id
		WHERE em.active and username = current_user;

		IF v_project_type = 'WS' THEN
			CREATE TEMP TABLE temp_t_mincut AS select distinct on (m.id) m.* from om_mincut m
			JOIN config_user_x_expl USING (expl_id)
			where username = current_user and m.id > 0;
		END IF;
	END IF;

	-- manage check all
	IF v_checkall THEN
		IF v_tabname = 'tab_psector' THEN -- to manage only those psectors related to selected exploitations

			EXECUTE 'INSERT INTO ' || v_tablename || ' ('|| v_columnname ||', cur_user) SELECT '||v_tableid||', current_user FROM '||v_table||
			' WHERE expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user) ON CONFLICT DO NOTHING';

		ELSIF v_tabname in ('tab_hydro_state', 'tab_mincut') THEN
			EXECUTE concat('INSERT INTO ',v_tablename,' (',v_columnname,', cur_user) SELECT ',v_tableid,', current_user FROM ',v_table,'
			',(CASE when v_ids is not null then concat(' WHERE id = ANY(ARRAY',v_ids,') ') end),' 
			ON CONFLICT (',v_columnname,', cur_user) DO NOTHING;');

		ELSE
			EXECUTE concat('INSERT INTO ',v_tablename,' (',v_columnname,', cur_user) SELECT ',v_tableid,', current_user FROM ',v_table,'
			',(CASE when v_ids is not null then concat(' WHERE id = ANY(ARRAY',v_ids,')') end),' WHERE active
			ON CONFLICT (',v_columnname,', cur_user) DO NOTHING;');
		END IF;

	ELSIF v_checkall is false THEN
		EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE cur_user = current_user';

	ELSE
		IF v_isalone THEN
			EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE cur_user = current_user';
		END IF;

		-- manage value
		IF v_value then
			IF v_tabname='tab_period' THEN
				EXECUTE 'INSERT INTO ' || v_tablename || ' ('|| v_columnname ||', cur_user) VALUES('''|| v_id ||''', '''|| current_user ||''')ON CONFLICT DO NOTHING';
			ELSE
				EXECUTE 'INSERT INTO ' || v_tablename || ' ('|| v_columnname ||', cur_user) VALUES('|| v_id ||', '''|| current_user ||''')ON CONFLICT DO NOTHING';
			END IF;
		ELSE
			EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE ' || v_columnname || '::text = '''|| v_id ||''' AND cur_user = current_user';
		END IF;


	END IF;

	-- manage parents
	IF v_tabname IN ('tab_psector', 'tab_dscenario', 'tab_sector') AND v_checkall is null AND v_disableparent IS NOT TRUE THEN

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
			v_querytext = 'SELECT '||v_tableid||' FROM '||v_table||' WHERE active IS TRUE AND parent_id = '|| v_id;

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

	--set expl as vdefault if only one value on selector (remember default value has priority over spatial intersection)
	IF (SELECT count (*) FROM selector_expl WHERE cur_user = current_user) = 1 THEN

		v_expl = (SELECT expl_id FROM selector_expl WHERE cur_user = current_user);

		INSERT INTO config_param_user(parameter, value, cur_user)
		VALUES ('edit_exploitation_vdefault', v_expl, current_user) ON CONFLICT (parameter, cur_user)
		DO UPDATE SET value = v_expl WHERE config_param_user.parameter = 'edit_exploitation_vdefault' AND config_param_user.cur_user = current_user;

	ELSE -- delete if more than one value on selector

		DELETE FROM config_param_user WHERE parameter = 'edit_exploitation_vdefault' AND cur_user = current_user;
	END IF;

	--set sector as vdefault if only one value on selector (remember default value has priority over spatial intersection)
	IF (SELECT count (*) FROM selector_sector WHERE cur_user = current_user) = 1 THEN

		v_sector = (SELECT sector_id FROM selector_sector WHERE cur_user = current_user);

		INSERT INTO config_param_user(parameter, value, cur_user)
		VALUES ('edit_sector_vdefault', v_sector, current_user) ON CONFLICT (parameter, cur_user)
		DO UPDATE SET value = v_sector WHERE config_param_user.parameter = 'edit_sector_vdefault' AND config_param_user.cur_user = current_user;

	ELSE -- delete if more than one value on selector

		DELETE FROM config_param_user WHERE parameter = 'edit_sector_vdefault' AND cur_user = current_user;
	END IF;

	-- trigger getmapzones
	IF v_tabname IN('tab_exploitation', 'tab_macroexploitation') THEN
		v_action = '[{"funcName": "set_style_mapzones", "params": {}}]';
	END IF;

	-- manage cross-reference tables
	select count(*) into v_count from node;
	IF v_count > 0 THEN
		IF v_tabname IN ('tab_exploitation', 'tab_macroexploitation') THEN

			IF v_tabname = 'tab_exploitation' THEN
				DELETE FROM selector_macroexpl WHERE cur_user = current_user;

			ELSIF v_tabname = 'tab_macroexploitation' THEN
				DELETE FROM selector_expl WHERE cur_user = current_user;
				INSERT INTO selector_expl
				SELECT DISTINCT expl_id, current_user FROM exploitation WHERE active is true and macroexpl_id IN (SELECT macroexpl_id FROM selector_macroexpl WHERE cur_user = current_user)
				ON CONFLICT (expl_id, cur_user) DO NOTHING;
			END IF;

			-- macrosector
			DELETE FROM selector_macrosector WHERE cur_user = current_user;

			-- sector
			DELETE FROM selector_sector WHERE cur_user = current_user;

			INSERT INTO selector_sector
			SELECT DISTINCT sector_id, current_user FROM node WHERE expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user)
			ON CONFLICT (sector_id, cur_user) DO NOTHING;

			-- those that are in expl_visibility
			INSERT INTO selector_sector
			SELECT DISTINCT sector_id, current_user FROM arc WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(arc.expl_visibility))
			UNION
			SELECT DISTINCT sector_id, current_user FROM node WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(node.expl_visibility))
			UNION	
			SELECT DISTINCT sector_id, current_user FROM connec WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(connec.expl_visibility))
			UNION 
			SELECT DISTINCT sector_id, current_user FROM link WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(link.expl_visibility))
			ON CONFLICT (sector_id, cur_user) DO NOTHING;

			-- muni
			DELETE FROM selector_municipality WHERE cur_user = current_user;
			INSERT INTO selector_municipality
			SELECT DISTINCT muni_id, current_user FROM node WHERE expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user);

			-- those that are in expl_visibility
			INSERT INTO selector_municipality
			SELECT DISTINCT muni_id, current_user FROM arc WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(arc.expl_visibility))
			UNION
			SELECT DISTINCT muni_id, current_user FROM node WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(node.expl_visibility))
			UNION	
			SELECT DISTINCT muni_id, current_user FROM connec WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(connec.expl_visibility))
			UNION 
			SELECT DISTINCT muni_id, current_user FROM link WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(link.expl_visibility))
			ON CONFLICT (muni_id, cur_user) DO NOTHING;

		ELSIF v_tabname IN ('tab_sector', 'tab_macrosector') THEN

			IF  v_tabname = 'tab_macrosector' THEN
				DELETE FROM selector_sector WHERE cur_user = current_user;
				INSERT INTO selector_sector
				SELECT DISTINCT sector_id, current_user FROM sector WHERE macrosector_id IN (SELECT macrosector_id FROM selector_macrosector WHERE cur_user = current_user)
				ON CONFLICT (sector_id, cur_user) DO NOTHING;
			END IF;

			-- expl
			DELETE FROM selector_expl WHERE cur_user = current_user;
			INSERT INTO selector_expl
			SELECT DISTINCT expl_id, current_user FROM node WHERE sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user = current_user)
			ON CONFLICT (expl_id, cur_user) DO NOTHING;
		
			-- muni
			DELETE FROM selector_municipality WHERE cur_user = current_user;
			INSERT INTO selector_municipality
			SELECT DISTINCT muni_id, current_user FROM node WHERE sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user = current_user)
			ON CONFLICT (muni_id, cur_user) DO NOTHING;


		-- inserting muni_id from selected muni
		ELSIF v_tabname IN ('tab_municipality') THEN

			-- macroexpl
			DELETE FROM selector_macroexpl WHERE cur_user = current_user;

			-- expl
			DELETE FROM selector_expl WHERE cur_user = current_user;
			INSERT INTO selector_expl
			SELECT DISTINCT expl_id, current_user FROM node WHERE muni_id IN (SELECT muni_id FROM selector_municipality WHERE cur_user = current_user)
			ON CONFLICT (expl_id, cur_user) DO NOTHING;

			-- macrosector
			DELETE FROM selector_macrosector WHERE cur_user = current_user;

			-- sector
			DELETE FROM selector_sector WHERE cur_user = current_user AND sector_id > 0;
			INSERT INTO selector_sector
			SELECT DISTINCT sector_id, current_user FROM node WHERE muni_id IN (SELECT muni_id FROM selector_municipality WHERE cur_user = current_user)
			ON CONFLICT (sector_id, cur_user) DO NOTHING;

			-- sector for those objects wich has expl_visibility and expl_visibility is not selected but yes one
			INSERT INTO selector_sector
			SELECT DISTINCT sector_id, current_user FROM arc
			WHERE sector_id > 0
			  AND EXISTS (
			    SELECT 1 FROM selector_expl se
			    WHERE se.cur_user = current_user
			      AND se.expl_id = ANY(arc.expl_visibility)
			  )
			UNION
			SELECT DISTINCT sector_id, current_user FROM node
			WHERE sector_id > 0
			  AND EXISTS (
			    SELECT 1 FROM selector_expl se
			    WHERE se.cur_user = current_user
			      AND se.expl_id = ANY(node.expl_visibility)
			  )
			ON CONFLICT (sector_id, cur_user) DO NOTHING;

			-- scenarios
			IF (SELECT rolname FROM pg_roles WHERE pg_has_role(current_user, oid, 'member') AND rolname = 'role_epa') IS NOT NULL THEN
				DELETE FROM selector_inp_dscenario WHERE dscenario_id NOT IN
				(SELECT dscenario_id FROM cat_dscenario WHERE active is true and expl_id IS NULL OR expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user));
			END IF;

			-- psector
			DELETE FROM selector_psector WHERE psector_id NOT IN
			(SELECT psector_id FROM plan_psector WHERE active is true and expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user));

			-- manage add schema for muni
			IF v_addschema IS NOT NULL THEN
				EXECUTE 'SET search_path = '||v_addschema||', public';

				EXECUTE' DELETE FROM selector_municipality WHERE cur_user = current_user';
				EXECUTE' INSERT INTO selector_municipality 
				SELECT muni_id, current_user FROM '||v_schemaname||'.selector_municipality WHERE cur_user = current_user';

				EXECUTE 'SET search_path = '||v_schemaname||', public';
			END IF;
		END IF;
	END IF;

	-- manage addschema
	IF v_addschema IS NOT NULL AND v_tabname IN ('tab_exploitation', 'tab_macroexploitation') THEN

		EXECUTE 'SET search_path = '||v_addschema||', public';

		EXECUTE' DELETE FROM selector_municipality WHERE cur_user = current_user';
		EXECUTE' INSERT INTO selector_municipality 
		SELECT muni_id, current_user FROM '||v_schemaname||'.selector_municipality WHERE cur_user = current_user';

		-- macroexpl
		DELETE FROM selector_macroexpl WHERE cur_user = current_user;

		-- expl
		DELETE FROM selector_expl WHERE cur_user = current_user;
		INSERT INTO selector_expl
		SELECT DISTINCT expl_id, current_user FROM node WHERE muni_id IN (SELECT muni_id FROM selector_municipality WHERE cur_user = current_user)
		ON CONFLICT (expl_id, cur_user) DO NOTHING;
		
		-- macrosector
		DELETE FROM selector_macrosector WHERE cur_user = current_user;

		-- sector
		DELETE FROM selector_sector WHERE cur_user = current_user AND sector_id > 0;
		IF v_sectorisexplismuni THEN			
			INSERT INTO selector_sector SELECT expl_id, current_user FROM ud.selector_expl WHERE cur_user = current_user AND expl_id 
			IN (SELECT sector_id FROM sector WHERE active);
		ELSE 
			INSERT INTO selector_sector
			SELECT DISTINCT sector_id, current_user FROM node WHERE muni_id IN (SELECT muni_id FROM selector_municipality WHERE cur_user = current_user)
			ON CONFLICT (sector_id, cur_user) DO NOTHING;
		END IF;
		
		-- sector for those objects wich has expl_id2 and expl_id2 is not selected but yes one
		INSERT INTO selector_sector
		SELECT DISTINCT sector_id,current_user FROM arc WHERE expl_id2 IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user) AND sector_id > 0
		UNION
		SELECT DISTINCT sector_id,current_user FROM node WHERE expl_id2 IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user) AND sector_id > 0
		ON CONFLICT (sector_id, cur_user) DO NOTHING;

		-- scenarios
		IF (SELECT rolname FROM pg_roles WHERE pg_has_role(current_user, oid, 'member') AND rolname = 'role_epa') IS NOT NULL THEN
			DELETE FROM selector_inp_dscenario WHERE dscenario_id NOT IN
			(SELECT dscenario_id FROM cat_dscenario WHERE active is true and expl_id IS NULL OR expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user));
		END IF;

		-- psector
		DELETE FROM selector_psector WHERE psector_id NOT IN
		(SELECT psector_id FROM cat_dscenario WHERE active is true and expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user));
	
		EXECUTE 'SET search_path = '||v_schemaname||', public';
	END IF;

	IF v_addschema IS NOT NULL AND v_tabname IN ('tab_exploitation_add', 'tab_macroexploitation_add') THEN

		EXECUTE 'SET search_path = '||v_addschema||', public';

		-- manage cross-reference tables
		select count(*) into v_count from node;
		IF v_count > 0 THEN

			IF v_checkall THEN

				EXECUTE concat('INSERT INTO ',v_tablename,' (',v_columnname,', cur_user) SELECT ',v_tableid,', current_user FROM ',v_table,'
				',(CASE when v_ids is not null then concat(' WHERE id = ANY(ARRAY',v_ids,')') end),' WHERE active
				ON CONFLICT (',v_columnname,', cur_user) DO NOTHING;');

			ELSIF v_checkall is false THEN
				EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE cur_user = current_user';
			ELSE

				IF v_isalone THEN
					EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE cur_user = current_user';
				END IF;

				-- manage value
				IF v_value THEN
					EXECUTE 'INSERT INTO ' || v_tablename || ' ('|| v_columnname ||', cur_user) VALUES('|| v_id ||', '''|| current_user ||''')ON CONFLICT ('|| v_columnname ||', cur_user) DO NOTHING';
				ELSE
					EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE ' || v_columnname || '::text = '''|| v_id ||''' AND cur_user = current_user';
				END IF;

			END IF;
		
			IF  v_tabname = 'tab_macroexploitation_add' THEN
				DELETE FROM selector_expl WHERE cur_user = current_user;
				INSERT INTO selector_expl
				SELECT DISTINCT expl_id, current_user FROM exploitation WHERE active is true and macroexpl_id IN (SELECT macroexpl_id FROM selector_macroexpl WHERE cur_user = current_user)
				ON CONFLICT (expl_id, cur_user) DO NOTHING;
			END IF;

			-- macrosector
			DELETE FROM selector_macrosector WHERE cur_user = current_user;

			-- sector
			DELETE FROM selector_sector WHERE cur_user = current_user AND sector_id > 0;
			INSERT INTO selector_sector
			SELECT DISTINCT sector_id, current_user FROM node WHERE expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user)
			ON CONFLICT (sector_id, cur_user) DO NOTHING;

			-- those that are in expl_visibility
			INSERT INTO selector_sector
			SELECT DISTINCT sector_id, current_user FROM arc WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(arc.expl_visibility))
			UNION
			SELECT DISTINCT sector_id, current_user FROM node WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(node.expl_visibility))
			UNION	
			SELECT DISTINCT sector_id, current_user FROM connec WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(connec.expl_visibility))
			UNION 
			SELECT DISTINCT sector_id, current_user FROM link WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(link.expl_visibility))
			ON CONFLICT (sector_id, cur_user) DO NOTHING;

			-- muni
			DELETE FROM selector_municipality WHERE cur_user = current_user;
			INSERT INTO selector_municipality
			SELECT DISTINCT muni_id, current_user FROM node WHERE expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user);

			-- those that are in expl_visibility
			INSERT INTO selector_municipality
			SELECT DISTINCT muni_id, current_user FROM arc WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(arc.expl_visibility))
			UNION
			SELECT DISTINCT muni_id, current_user FROM node WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(node.expl_visibility))
			UNION	
			SELECT DISTINCT muni_id, current_user FROM connec WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(connec.expl_visibility))
			UNION 
			SELECT DISTINCT muni_id, current_user FROM link WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.cur_user = current_user AND se.expl_id = ANY(link.expl_visibility))
			ON CONFLICT (muni_id, cur_user) DO NOTHING;

			IF v_sectorisexplismuni IS FALSE THEN
				EXECUTE' DELETE FROM '||v_schemaname||'.selector_municipality WHERE cur_user = current_user';
				EXECUTE' INSERT INTO '||v_schemaname||'.selector_municipality 
				SELECT muni_id, current_user FROM selector_municipality WHERE cur_user = current_user';
			END IF;
			
			SELECT row_to_json (a)
			INTO v_geometry
			FROM (SELECT st_xmin(the_geom)::numeric(12,2) as x1, st_ymin(the_geom)::numeric(12,2) as y1, 
			st_xmax(the_geom)::numeric(12,2) as x2, st_ymax(the_geom)::numeric(12,2) as y2
			FROM (SELECT st_expand(st_collect(the_geom), v_expand) as the_geom FROM ve_arc) b) a;

		END IF;

		EXECUTE 'SET search_path = '||v_schemaname||', public';
								
		IF v_sectorisexplismuni IS NOT TRUE THEN

			-- macroexpl
			DELETE FROM selector_macroexpl WHERE cur_user = current_user;
	
			-- expl
			DELETE FROM selector_expl WHERE cur_user = current_user;
			INSERT INTO selector_expl
			SELECT DISTINCT expl_id, current_user FROM node WHERE muni_id IN (SELECT muni_id FROM selector_municipality WHERE cur_user = current_user)
			ON CONFLICT (expl_id, cur_user) DO NOTHING;
	
			-- macrosector
			DELETE FROM selector_macrosector WHERE cur_user = current_user;
	
			-- sector
			DELETE FROM selector_sector WHERE cur_user = current_user AND sector_id > 0;
			INSERT INTO selector_sector
			SELECT DISTINCT sector_id, current_user FROM node WHERE muni_id IN (SELECT muni_id FROM selector_municipality WHERE cur_user = current_user)
			ON CONFLICT (sector_id, cur_user) DO NOTHING;
	
			-- scenarios
			IF (SELECT rolname FROM pg_roles WHERE pg_has_role(current_user, oid, 'member') AND rolname = 'role_epa') IS NOT NULL THEN
				DELETE FROM selector_inp_dscenario WHERE dscenario_id NOT IN
				(SELECT dscenario_id FROM cat_dscenario WHERE active is true and expl_id IS NULL OR expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user));
			END IF;
	
			-- psector
			DELETE FROM selector_psector WHERE psector_id NOT IN
			(SELECT psector_id FROM cat_dscenario WHERE active is true and expl_id IN 
		    (SELECT expl_id FROM selector_expl WHERE cur_user = current_user));
		END IF;
	END IF;

	-- change current psector if selector_expl changes
	v_expl = (SELECT expl_id FROM plan_psector JOIN
            (SELECT value FROM config_param_user where parameter ='plan_psector_current' and cur_user = current_user) a ON value::integer = psector_id
            WHERE expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user));

	IF v_expl IS NULL THEN
		UPDATE config_param_user SET value = NULL WHERE parameter = 'plan_psector_current' AND cur_user = CURRENT_USER;
	END IF;

	-- cross reference schema for state 
    IF v_addschema IS NOT NULL THEN 
        EXECUTE 'DELETE FROM '||v_addschema||'.selector_state WHERE cur_user = current_user';
        EXECUTE 'INSERT INTO '||v_addschema||'.selector_state SELECT state_id, current_user FROM selector_state WHERE cur_user = current_user';
    END IF;

	-- get envelope
	SELECT count(the_geom) INTO v_count FROM ve_node LIMIT 1;

	IF v_tabname IN ('tab_sector', 'tab_macrosector','tab_exploitation', 'tab_macroexploitation', 'tab_municipality') THEN
		SELECT row_to_json (a)
		INTO v_geometry
		FROM (SELECT st_xmin(the_geom)::numeric(12,2) as x1, st_ymin(the_geom)::numeric(12,2) as y1,
		st_xmax(the_geom)::numeric(12,2) as x2, st_ymax(the_geom)::numeric(12,2) as y2
		FROM (SELECT st_expand(st_collect(the_geom), v_expand) as the_geom FROM ve_arc) b) a;
				
	ELSIF v_tabname IN ('tab_psector') THEN
		SELECT row_to_json (a)
		INTO v_geometry
		FROM (SELECT st_xmin(the_geom)::numeric(12,2) as x1, st_ymin(the_geom)::numeric(12,2) as y1, st_xmax(the_geom)::numeric(12,2) as x2, st_ymax(the_geom)::numeric(12,2) as y2
		FROM (SELECT st_expand(st_collect(the_geom), v_expand) as the_geom FROM plan_psector WHERE psector_id IN (select psector_id FROM selector_psector WHERE cur_user = current_user))b) a;
	
	ELSIF v_tabname IN ('tab_hydro_state', 'tab_network_state', 'tab_dscenario') THEN
		v_geometry = NULL;

	ELSIF (v_count > 0 or (v_checkall IS False and v_id is null)) AND v_tabname NOT IN ('tab_exploitation_add', 'tab_macroexploitation_add')  THEN
		SELECT row_to_json (a)
		INTO v_geometry
		FROM (SELECT st_xmin(the_geom)::numeric(12,2) as x1, st_ymin(the_geom)::numeric(12,2) as y1, st_xmax(the_geom)::numeric(12,2) as x2, st_ymax(the_geom)::numeric(12,2) as y2
		FROM (SELECT st_expand(st_collect(the_geom), v_expand) as the_geom FROM ve_arc) b) a;

	END IF;

	-- force 0 
	INSERT INTO selector_sector values (0, current_user) ON CONFLICT (sector_id, cur_user) do nothing;
	INSERT INTO selector_municipality values (0, current_user) ON CONFLICT (muni_id, cur_user) do nothing;

	-- warn the user that in the selected psectors, there is a connec connected to different arcs
	WITH mec AS (
		SELECT connec_id,
		row_number() over(PARTITION BY connec_id ORDER BY connec_id) AS rowid_connec,
		row_number() over(PARTITION BY arc_id ORDER BY arc_id) AS rowid_arc,
		row_number() over(PARTITION BY psector_id ORDER BY psector_id) AS rowid_psector
		FROM plan_psector_x_connec
		JOIN selector_psector USING (psector_id) WHERE cur_user = current_user
	)
	SELECT count(*) INTO v_count FROM mec WHERE rowid_connec>1 AND rowid_arc > 0 AND rowid_psector > 0;

	IF v_count>0 then

		SELECT concat('{"level":',log_level, ', "text":"', error_message, '"}') INTO v_message FROM sys_message WHERE id = 4340;

	END IF;

	IF v_project_type = 'UD' THEN

		WITH mec AS (
			SELECT gully_id,
			row_number() over(PARTITION BY gully_id ORDER BY gully_id) AS rowid_gully,
			row_number() over(PARTITION BY arc_id ORDER BY arc_id) AS rowid_arc,
			row_number() over(PARTITION BY psector_id ORDER BY psector_id) AS rowid_psector
			FROM plan_psector_x_gully
			JOIN selector_psector USING (psector_id) WHERE cur_user = current_user
		)
		SELECT count(*) INTO v_count FROM mec WHERE rowid_gully>1 AND rowid_arc > 0 AND rowid_psector > 0;

		IF v_count>0 then

			SELECT concat('{"level":',log_level, ', "text":"', error_message, '"}') INTO v_message FROM sys_message WHERE id = 4340;

		END IF;

	END IF;

	-- get uservalues
	PERFORM gw_fct_workspacemanager($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},"data":{"filterFields":{}, "pageInfo":{}, "action":"CHECK"}}$$);
	v_uservalues = (SELECT to_json(array_agg(row_to_json(a))) FROM (SELECT parameter, value FROM config_param_user WHERE parameter IN ('plan_psector_current', 'utils_workspace_current')
	AND cur_user = current_user ORDER BY parameter)a);


	-- Control NULL's
	v_geometry := COALESCE(v_geometry, '{}');
	v_uservalues := COALESCE(v_uservalues, '{}');
	v_action := COALESCE(v_action, 'null');
	v_message := COALESCE(v_message, '{}');


	EXECUTE 'SET ROLE "'||v_prev_cur_user||'"';

	-- Return
	v_return = concat('{"client":',(p_data ->> 'client'),', "message":', v_message, ', "form":{"currentTab":"', v_tabname,'"}, "feature":{}, 
	"data":{"userValues":',v_uservalues,', "geometry":', v_geometry,', "useAtlas":"',v_useatlas,'", "action":',v_action,', 
	"selectorType":"',v_selectortype,'", "addSchema":"', v_addschema,'", "tiled":"', v_tiled,'", "id":"', v_id,'", "ids":"', v_ids,'",
	"layers":',COALESCE(((p_data ->> 'data')::json->> 'layers'), '{}'),'}}');
	RETURN gw_fct_getselectors(v_return);


	--Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;

$function$
;
