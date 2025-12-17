/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: 2796

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getselectors(p_data json)
  RETURNS json AS
$BODY$

/*example

SELECT SCHEMA_NAME.gw_fct_getselectors($${"client":{"lang":"en_US", "infoType":1, "epsg":SRID_VALUE}, "form":{"currentTab":"tab_exploitation"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"selector_basic" ,"filterText":"1"}}$$);

SELECT SCHEMA_NAME.gw_fct_getselectors($${"client":{"lang":"en_US", "infoType":1, "epsg":SRID_VALUE}, "form":{"currentTab":"tab_exploitation"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"selector_basic", "filterText":""}}$$);

SELECT SCHEMA_NAME.gw_fct_getselectors($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":SRID_VALUE}, "form":{"currentTab":"tab_exploitation"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"selector_basic", "filterText":""}}$$);

SELECT SCHEMA_NAME.gw_fct_setselectors($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"selector_basic", "tabName":"tab_exploitation", "id":"1", "isAlone":"True", "disableParent":"False", "value":"True", "addSchema":"NULL"}}$$)

*/

DECLARE
rec_tab record;

v_formTabsAux  json;
v_formTabs text;
v_version text;
v_active boolean=false;
v_firsttab boolean=false;
v_selector_list text;
v_selector_type text;
v_result_list text[];
v_filter_name text;
v_label text;
v_table text;
v_selector text;
v_table_id text;
v_selector_id text;
v_filterfromconfig text;
v_manageall boolean;
v_typeahead text;
v_expl_x_user boolean;
v_filter text;
v_selectionMode text;
v_typeaheadForced boolean=false;
v_stylesheet json;
v_errcontext text;
v_currenttab text;
v_tab record;
v_ids text;
v_filterfrominput text;
v_filterfromids text;
v_fullfilter text;
v_finalquery text;
v_querytab text;
v_orderby text;
v_geometry text;
v_query text;
v_name text;
v_pkeyfield text;
v_querystring text;
v_debug_vars json;
v_debug json;
v_msgerr json;
v_count_zone integer;
rec_macro integer;
v_count_selector integer;
v_useatlas boolean;
v_message text;
v_uservalues json;
v_action text;
v_zonetable text;
v_zoneid text;
v_macroid text;
v_macrotable text;
v_macroselector text;
v_cur_user text;
v_prev_cur_user text;
v_device integer;
v_layers text;
v_layer text;
v_rec record;
v_columns json;
v_layerColumns json;
v_loadProject boolean=false;
v_addschema text;
v_tiled boolean;
v_result json;
v_mincut_init json;
v_mincut_valve_proposed json;
v_mincut_valve_not_proposed json;
v_mincut_node json;
v_mincut_connec json;
v_mincut_arc json;
v_exclude_tab text='';
v_orderby_query text;
v_orderby_check boolean;
v_project_type text;
v_tabnetworksignal integer = 0;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get system values
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	v_project_type = (SELECT project_type FROM sys_version LIMIT 1);

	-- Get input parameters:
	v_selector_type := (p_data ->> 'data')::json->> 'selectorType';
	v_currenttab := (p_data ->> 'form')::json->> 'currentTab';
	v_filterfrominput := (p_data ->> 'data')::json->> 'filterText';
	v_geometry := ((p_data ->> 'data')::json->>'geometry');
	v_useatlas := (p_data ->> 'data')::json->> 'useAtlas';
	v_loadProject := (p_data ->> 'data')::json->> 'loadProject';
	v_message := (p_data ->> 'message')::json;
	v_cur_user := (p_data ->> 'client')::json->> 'cur_user';
	v_device := (p_data ->> 'client')::json->> 'device';
	v_addschema := (p_data ->> 'data')::json->> 'addSchema';
	v_tiled := ((p_data ->>'client')::json->>'tiled')::boolean;

	IF v_addschema IS NOT NULL THEN v_tabnetworksignal = -1; END IF;

	IF v_device is null then v_device = 4; END IF;

	v_prev_cur_user = current_user;
	IF v_cur_user IS NOT NULL THEN
		EXECUTE 'SET ROLE "'||v_cur_user||'"';
	END IF;

	-- profilactic control of schema name
	IF lower(v_addschema) = 'none' OR v_addschema = '' OR lower(v_addschema) ='null' OR v_addschema is null OR v_addschema='NULL' THEN
		v_addschema = null;
		v_exclude_tab = ' AND tabname != ''tab_exploitation_add''';
	END IF;
	-- profilactic control of message
	IF v_message is null THEN
		v_message = '{"level":111, "text":"Process done successfully"}';
	END IF;

	-- get system variables:
	v_expl_x_user = (SELECT value FROM config_param_system WHERE parameter = 'admin_exploitation_x_user');

	v_stylesheet = (SELECT value FROM config_param_system WHERE parameter = 'qgis_form_selector_stylesheet');

	-- when typeahead only one tab is executed
	IF v_filterfrominput IS NULL OR v_filterfrominput = '' OR lower(v_filterfrominput) ='None' or lower(v_filterfrominput) = 'null' THEN
		v_querytab = '';
	ELSE
		v_querytab = concat(' AND tabname = ', quote_literal(v_currenttab));
	END IF;

	-- Start the construction of the tabs array
	v_formTabs := '[';

	v_query = concat(
	'SELECT formname, tabname, label, tooltip, tabfunction, tabactions, value
	 FROM (SELECT formname, tabname, f.label, f.tooltip, tabfunction, tabactions, unnest(device) AS device, value, orderby FROM config_form_tabs f, config_param_system
	 WHERE formname=',quote_literal(v_selector_type),' AND isenabled IS TRUE AND concat(''basic_selector_'', tabname) = parameter ',(v_querytab),
	'AND orderby >=',v_tabnetworksignal,' AND sys_role IN (SELECT rolname FROM pg_roles WHERE pg_has_role(current_user, oid, ''member'')))a 
	WHERE device = ',v_device, v_exclude_tab,' ORDER BY orderby');
	v_debug_vars := json_build_object('v_selector_type', v_selector_type, 'v_querytab', v_querytab);
	v_debug := json_build_object('querystring', v_query, 'vars', v_debug_vars, 'funcname', 'gw_fct_getselectors', 'flag', 10);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;

	-- create temp tables related to expl x user variable
	DROP TABLE IF EXISTS temp_exploitation;
	DROP TABLE IF EXISTS temp_macroexploitation;
	DROP TABLE IF EXISTS temp_sector;
	DROP TABLE IF EXISTS temp_macrosector;
	DROP TABLE IF EXISTS temp_municipality;
	DROP TABLE IF EXISTS temp_t_mincut;
	DROP TABLE IF EXISTS temp_network;

	IF v_expl_x_user is false then
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
		select distinct on (s.sector_id) s.sector_id, s.name, s.macrosector_id, s.descript, s.parent_id, s.active from sector s
		JOIN (SELECT DISTINCT node.sector_id, node.expl_id FROM node WHERE node.state > 0)n USING (sector_id)
		JOIN exploitation e ON e.expl_id=n.expl_id
		JOIN config_user_x_expl c ON c.expl_id=n.expl_id WHERE s.active and s.sector_id > 0 and username = current_user
 			UNION
		select distinct on (s.sector_id) s.sector_id, s.name, s.macrosector_id, s.descript, s.parent_id, s.active from sector s
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

	-- starting loop for tabs
	FOR v_tab IN EXECUTE v_query

	LOOP
		-- get variables form input
		v_selector_list := (p_data ->> 'data')::json->> 'ids';
		v_filterfrominput := (p_data ->> 'data')::json->> 'filterText';

		-- get variables from tab
		v_label = v_tab.value::json->>'label';
		v_table = v_tab.value::json->>'table';
		v_table_id = v_tab.value::json->>'table_id';
		v_selector = v_tab.value::json->>'selector';
		v_selector_id = v_tab.value::json->>'selector_id';
		v_filterfromconfig = v_tab.value::json->>'query_filter';
		v_manageall = v_tab.value::json->>'manageAll';
		v_typeahead = v_tab.value::json->>'typeaheadFilter';
		v_selectionMode = v_tab.value::json->>'selectionMode';
		v_orderby = v_tab.value::json->>'orderBy';
		v_name = v_tab.value::json->>'name';
		v_typeaheadForced = v_tab.value::json->>'typeaheadForced';
		v_orderby_check = v_tab.value::json->>'orderbyCheck';

		-- profilactic control of v_orderby
		v_querystring = concat('SELECT gw_fct_getpkeyfield(''',v_table,''');');
		v_debug_vars := json_build_object('v_table', v_table);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getselectors', 'flag', 20);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO v_pkeyfield;
		IF v_orderby IS NULL THEN v_orderby = v_pkeyfield; end if;
		IF v_name IS NULL THEN v_name = v_orderby; end if;

		-- profilactic control of selection mode
		IF v_selectionMode = '' OR v_selectionMode is null then
			v_selectionMode = 'keepPrevious';
		END IF;

		-- order by heck. This enables to put checked rows on the top. Useful when there are lots of rows and you need to use the scrollbar to kwow what is checked
		IF v_orderby_check AND v_tab.tabname != v_currenttab THEN
			v_orderby_query = 'ORDER BY value DESC, orderby';
		ELSE
			v_orderby_query = 'ORDER BY orderby';
		END IF;

		-- built filter from input
		IF v_filterfrominput IS NULL OR v_filterfrominput = '' OR lower(v_filterfrominput) ='None' or lower(v_filterfrominput) = 'null' THEN
			v_filterfrominput := NULL;
		ELSE
			v_filterfrominput = concat (v_typeahead,' LIKE ''%', lower(v_filterfrominput), '%''');
		END IF;


		-- Manage filters from ids (only mincut)
		IF v_selector = 'selector_mincut_result' THEN
			v_selector_list = replace(replace(v_selector_list, '[', '('), ']', ')');
			IF v_selector_list != '' THEN
				v_filterfromids = ' AND ' || v_table_id || ' IN '|| v_selector_list || ' ';
			END IF;
			-- always order descending for mincut
			v_orderby_query = 'ORDER BY orderby DESC';
		END IF;

		-- built full filter
		v_fullfilter = concat(v_filterfromids, v_filterfromconfig, v_filterfrominput);

		-- use atlas on psector selector
		IF v_useatlas AND v_tab.tabname ='tab_psector' THEN
			v_orderby = 'atlas_id::integer';
			v_name = 'concat(row_number() over(order by atlas_id::integer), ''-'',name)';
		END IF;

		-- filter out archived psectors (status 5, 6, 7 = archived)
		IF v_tab.tabname = 'tab_psector' THEN
			v_fullfilter = concat(v_fullfilter, ' AND (status NOT IN (''5'', ''6'', ''7'') OR status IS NULL)');
		END IF;

		-- profilactic null control
		v_fullfilter := COALESCE(v_fullfilter, '');

		-- setting schema add
		IF v_tab.tabname like '%add%' AND v_addschema IS NOT  NULL THEN
			v_table = concat(v_addschema,'.',v_table);
			v_selector = concat(v_addschema,'.',v_selector);
		END IF;

		-- final query
		-- Add conditional active filter (not applicable for mincut selector)
		IF v_selector = 'selector_mincut_result' THEN
			v_finalquery = concat('SELECT array_to_json(array_agg(row_to_json(b))) FROM (
					select *, row_number() OVER (',v_orderby_query,') as orderby from (
					SELECT ',quote_ident(v_table_id),', concat(' , v_label , ') AS label, ',v_name,' as name, ', v_table_id , '::text as widgetname, ' ,
					v_orderby, ' as orderby , ''', v_selector_id , ''' as columnname, ''check'' as type, ''boolean'' as "dataType",
					EXISTS (SELECT ', v_selector_id, ' FROM ', v_selector, ' e WHERE e.', v_selector_id, ' = s.', v_table_id, ' and cur_user=current_user) as "value", null as active,
					null as stylesheet
					FROM ', v_table ,' s WHERE TRUE ', v_fullfilter, ' ) a)b');
		ELSE
			v_finalquery = concat('SELECT array_to_json(array_agg(row_to_json(b))) FROM (
					select *, row_number() OVER (',v_orderby_query,') as orderby from (
					SELECT ',quote_ident(v_table_id),', concat(' , v_label , ') AS label, ',v_name,' as name, ', v_table_id , '::text as widgetname, ' ,
					v_orderby, ' as orderby , ''', v_selector_id , ''' as columnname, ''check'' as type, ''boolean'' as "dataType",
					EXISTS (SELECT ', v_selector_id, ' FROM ', v_selector, ' e WHERE e.', v_selector_id, ' = s.', v_table_id, ' and cur_user=current_user) as "value", active,
					case when EXISTS(SELECT ', v_table_id, ' FROM ', v_table, ' e WHERE active and e.', v_table_id, ' = s.', v_table_id, ') is not true then ''color: lightgray; font-style: italic;'' end as stylesheet
					FROM ', v_table ,' s WHERE TRUE ', v_fullfilter, ' ) a)b');
		END IF;

		v_debug_vars := json_build_object('v_table_id', v_table_id, 'v_label', v_label, 'v_orderby', v_orderby, 'v_name', v_name, 'v_selector_id', v_selector_id,
						  'v_table', v_table, 'v_selector', v_selector, 'current_user', current_user, 'v_fullfilter', v_fullfilter);
		v_debug := json_build_object('querystring', v_finalquery, 'vars', v_debug_vars, 'funcname', 'gw_fct_getselectors', 'flag', 30);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;


		EXECUTE  v_finalquery INTO v_formTabsAux;
		--reset v_ids
		v_ids= null;

		-- Add tab name to json
		IF v_formTabsAux IS NULL THEN
			v_formTabsAux := ('{"fields":[]}')::json;
		ELSE
			v_formTabsAux := ('{"fields":' || v_formTabsAux || '}')::json;
		END IF;

		-- setting active tab
		IF v_currenttab = v_tab.tabname THEN
			v_active = true;
		ELSIF v_currenttab IS NULL OR v_currenttab = '' OR v_currenttab ='None' OR v_firsttab is false THEN
			v_active = false;
		END IF;

		-- setting other variables of tab
		v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'tabName', v_tab.tabname::TEXT);
		v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'tableName', v_selector);
		v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'tabLabel', v_tab.label::TEXT);
		v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'tooltip', v_tab.tooltip::TEXT);
		v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'selectorType', v_tab.formname::TEXT);
		v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'manageAll', v_manageall::TEXT);
		v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'typeaheadFilter', v_typeahead::TEXT);
		v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'selectionMode', v_selectionMode::TEXT);
		v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'typeaheadForced', v_typeaheadForced::TEXT);

		-- Create tabs array
		IF v_firsttab THEN
			v_formTabs := v_formTabs || ',' || v_formTabsAux::text;
		ELSE
			v_formTabs := v_formTabs || v_formTabsAux::text;
		END IF;
		v_firsttab := TRUE;

	END LOOP;

	-- Manage web client
	IF v_device = 5 THEN

		-- Get active exploitations geometry (to zoom on them)
		IF v_loadProject IS TRUE AND v_geometry IS NULL THEN
			SELECT row_to_json (a)
			INTO v_geometry
			FROM (SELECT st_xmin(the_geom)::numeric(12,2) as x1, st_ymin(the_geom)::numeric(12,2) as y1, st_xmax(the_geom)::numeric(12,2) as x2, st_ymax(the_geom)::numeric(12,2) as y2
			FROM (SELECT st_expand(st_collect(the_geom), 50.0) as the_geom FROM exploitation where expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user)) b) a;
		END IF;

		if v_selector_type='selector_mincut' then
			-- GET GEOJSON
		--v_om_mincut
		SELECT jsonb_build_object(
		    'type', 'FeatureCollection',
		    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
		) INTO v_result
			FROM (
	  	SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(anl_the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'anl_the_geom'
	  	) AS feature
	  	FROM (SELECT id, ST_Transform(anl_the_geom, 4326) as anl_the_geom
	  	FROM  v_om_mincut) row) features;
		v_mincut_init = v_result;

			--v_om_mincut_valve proposed true
            SELECT jsonb_build_object(
		        'type', 'FeatureCollection',
		        'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
		    ) INTO v_result
                FROM (
            SELECT jsonb_build_object(
             'type',       'Feature',
            'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
            'properties', to_jsonb(row) - 'the_geom'
            ) AS feature
            FROM (SELECT id, ST_Transform(the_geom, 4326) as the_geom
            FROM  v_om_mincut_valve WHERE proposed = true) row) features;

            v_mincut_valve_proposed = v_result;

            --v_om_mincut_valve proposed false
            SELECT jsonb_build_object(
		        'type', 'FeatureCollection',
		        'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
		    ) INTO v_result
                FROM (
            SELECT jsonb_build_object(
             'type',       'Feature',
            'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
            'properties', to_jsonb(row) - 'the_geom'
            ) AS feature
            FROM (SELECT id, ST_Transform(the_geom, 4326) as the_geom
            FROM  v_om_mincut_valve WHERE proposed = false) row) features;

            v_mincut_valve_not_proposed = v_result;

		--v_om_mincut_node
		SELECT jsonb_build_object(
		    'type', 'FeatureCollection',
		    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
		) INTO v_result
			FROM (
	  	SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'the_geom'
	  	) AS feature
	  	FROM (SELECT id, ST_Transform(the_geom, 4326) as the_geom
	  	FROM  v_om_mincut_node) row) features;

		v_mincut_node = v_result;

		--v_om_mincut_connec
		SELECT jsonb_build_object(
		    'type', 'FeatureCollection',
		    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
		) INTO v_result
			FROM (
	  	SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'the_geom'
	  	) AS feature
	  	FROM (SELECT id, ST_Transform(the_geom, 4326) as the_geom
	  	FROM  v_om_mincut_connec) row) features;

		v_mincut_connec = v_result;

		--v_om_mincut_arc
		SELECT jsonb_build_object(
		    'type', 'FeatureCollection',
		    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
		) INTO v_result
			FROM (
	  	SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'the_geom'
	  	) AS feature
	  	FROM (SELECT id, arc_id, ST_Transform(the_geom, 4326) as the_geom
	  	FROM  v_om_mincut_arc) row) features;

		v_mincut_arc = v_result;
		end if;
	END IF;

	-- Finish the construction of the tabs array
	v_formTabs := v_formTabs ||']';

	-- Check null
	v_formTabs := COALESCE(v_formTabs, '[]');
	v_manageall := COALESCE(v_manageall, FALSE);
	v_selectionMode = COALESCE(v_selectionMode, '');
	v_currenttab = COALESCE(v_currenttab, '');
	v_geometry = COALESCE(v_geometry, '{}');
	v_stylesheet := COALESCE(v_stylesheet, '{}');
	v_layerColumns = COALESCE(v_layerColumns, '{}');
	v_mincut_init = COALESCE(v_mincut_init, '[]');
	v_mincut_valve_proposed = COALESCE(v_mincut_valve_proposed, '[]');
	v_mincut_valve_not_proposed = COALESCE(v_mincut_valve_not_proposed, '[]');
	v_mincut_node = COALESCE(v_mincut_node, '[]');
	v_mincut_connec = COALESCE(v_mincut_connec, '[]');
	v_mincut_arc = COALESCE(v_mincut_arc, '[]');
	v_uservalues = COALESCE(v_uservalues, '{}');
	v_tiled = COALESCE(v_tiled, FALSE);

	EXECUTE 'SET ROLE "'||v_prev_cur_user||'"';

	-- Return
	IF v_firsttab IS FALSE THEN
		-- Return not implemented
		RETURN ('{"status":"Accepted"' ||
		', "version":"'|| v_version ||'"'||
		', "message":"Not implemented"'||
		'}')::json;
	ELSE
		v_uservalues := COALESCE(json_extract_path_text(p_data,'data','userValues'),
			(SELECT to_json(array_agg(row_to_json(a))) FROM (SELECT parameter, value FROM config_param_user WHERE parameter IN ('plan_psector_current', 'utils_workspace_current') AND cur_user = current_user ORDER BY parameter)a)::text,
			'{}');
		v_action := json_extract_path_text(p_data,'data','action');
		IF v_action = '' THEN v_action = NULL; END IF;

		DROP TABLE IF EXISTS temp_exploitation;
		DROP TABLE IF EXISTS temp_macroexploitation;
		DROP TABLE IF EXISTS temp_sector;
		DROP TABLE IF EXISTS temp_macrosector;
		DROP TABLE IF EXISTS temp_municipality;
		DROP TABLE IF EXISTS temp_t_mincut;
		DROP TABLE IF EXISTS temp_network;
		-- Return formtabs
		RETURN gw_fct_json_create_return(('{"status":"Accepted", "version":"'||v_version||'"'||
			',"body":{"message":'||v_message||
			',"form":{"formName":"", "formLabel":"", "currentTab":"'||v_currenttab||'", "formText":"", "formTabs":'||v_formTabs||', "style": '||v_stylesheet||'}'||
			',"feature":{}'||
			',"data":{
				"userValues":'||v_uservalues||',
				"geometry":'||v_geometry||',
				"layerColumns":'||v_layerColumns||
				(case when v_selector_type = 'selector_mincut' then ',
					"tiled":'||v_tiled||',
					"mincutInit":'||v_mincut_init||',
					"mincutProposedValve":'||v_mincut_valve_proposed||',
					"mincutNotProposedValve":'||v_mincut_valve_not_proposed||',
					"mincutNode":'||v_mincut_node||',
					"mincutConnec":'||v_mincut_connec||',
					"mincutArc":'||v_mincut_arc else '' end ) ||
				'}'||
			'}'||
		    '}')::json,2796, null, null, v_action::json);
	END IF;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;
	DROP TABLE IF EXISTS temp_exploitation;
	DROP TABLE IF EXISTS temp_macroexploitation;
	DROP TABLE IF EXISTS temp_sector;
	DROP TABLE IF EXISTS temp_macrosector;
	DROP TABLE IF EXISTS temp_municipality;
	DROP TABLE IF EXISTS temp_t_mincut;
	DROP TABLE IF EXISTS temp_network;
	RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE, 'MSGERR', (v_msgerr::json ->> 'MSGERR'))::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
