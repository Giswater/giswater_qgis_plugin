/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2796

-- DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getselectors(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getselectors(p_data json)
  RETURNS json AS
$BODY$

/*example

SELECT gw_fct_getselectors($${"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"test_user"}, "form":{"currentTab":"tab_exploitation"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"selector_basic" ,"filterText":"1"}}$$);
SELECT gw_fct_getselectors($${"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"test_user"}, "form":{"currentTab":"tab_psector"}, "feature":{}, "data":{"selectorType":"selector_basic", "useAtlas":true}}$$);

*/

DECLARE
rec_tab record;

v_formTabsAux  json;
v_formTabs text;
v_version json;
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
v_count_expl integer;
rec_macro record;
v_count_selector integer;
v_useatlas boolean;
v_message text;
v_uservalues json;
v_action text;
v_zonetable text;
v_cur_user text;
v_prev_cur_user text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;

	-- Get input parameters:
	v_selector_type := (p_data ->> 'data')::json->> 'selectorType';
	v_currenttab := (p_data ->> 'form')::json->> 'currentTab';
	v_filterfrominput := (p_data ->> 'data')::json->> 'filterText';
	v_geometry := ((p_data ->> 'data')::json->>'geometry');
	v_useatlas := (p_data ->> 'data')::json->> 'useAtlas';
	v_message := (p_data ->> 'message')::json;
	v_cur_user := (p_data ->> 'client')::json->> 'cur_user';
	
	v_prev_cur_user = current_user;
	IF v_cur_user THEN
		EXECUTE 'SET ROLE ' || v_cur_user || '';
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

	v_query = concat('SELECT config_form_tabs.*, value FROM config_form_tabs, config_param_system WHERE formname=',quote_literal(v_selector_type),
	' AND isenabled IS TRUE AND concat(''basic_selector_'', tabname) = parameter ',(v_querytab),
	' AND sys_role IN (SELECT rolname FROM pg_roles WHERE pg_has_role(current_user, oid, ''member''))  ORDER BY orderby');
	v_debug_vars := json_build_object('v_selector_type', v_selector_type, 'v_querytab', v_querytab);
	v_debug := json_build_object('querystring', v_query, 'vars', v_debug_vars, 'funcname', 'gw_fct_getselectors', 'flag', 10);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;

	FOR v_tab IN EXECUTE v_query
​
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

		-- getting from v_expl_x_user variable to setup v_filterfrominput
		IF v_selector = 'selector_expl' AND v_expl_x_user THEN
			IF v_filterfrominput IS NULL OR v_filterfrominput = '' THEN
				v_filterfrominput = ' AND expl_id IN (SELECT expl_id FROM config_user_x_expl WHERE username = current_user)';
			ELSE
				v_filterfrominput = concat (' AND expl_id IN (SELECT expl_id FROM config_user_x_expl WHERE username = current_user) ', v_typeahead,' LIKE ''%', lower(v_filterfrominput), '%''');
			END IF;
			
		ELSIF v_selector = 'selector_sector' AND v_expl_x_user THEN
			IF v_filterfrominput IS NULL OR v_filterfrominput = '' THEN
				v_filterfrominput = ' AND sector_id IN (SELECT sector_id FROM config_user_x_sector WHERE username = current_user)';
			ELSE
				v_filterfrominput = concat (' AND sector_id IN (SELECT sector_id FROM config_user_x_sector WHERE username = current_user) ', v_typeahead,' LIKE ''%', lower(v_filterfrominput), '%''');
			END IF;

		ELSE 
			-- built filter from input (recalled from typeahead)
			IF v_filterfrominput IS NULL OR v_filterfrominput = '' OR lower(v_filterfrominput) ='None' or lower(v_filterfrominput) = 'null' THEN
				v_filterfrominput := NULL;
			ELSE 
				v_filterfrominput = concat (v_typeahead,' LIKE ''%', lower(v_filterfrominput), '%''');
			END IF;
		END IF;

		-- Manage filters from ids (only mincut)
		IF v_selector = 'selector_mincut_result' THEN
			v_selector_list = replace(replace(v_selector_list, '[', '('), ']', ')');
			v_filterfromids = ' AND ' || v_table_id || ' IN '|| v_selector_list || ' ';
		END IF;


		-- built full filter 
		v_fullfilter = concat(v_filterfromids, v_filterfromconfig, v_filterfrominput);

		-- use atlas on psector selector
		IF v_useatlas AND v_tab.tabname ='tab_psector' THEN
			v_orderby = 'atlas_id::integer';
			v_name = 'concat(row_number() over(order by atlas_id::integer), ''-'',name)';
		END IF;
			
		-- profilactic null control
		v_fullfilter := COALESCE(v_fullfilter, '');
		IF v_tab.tabname ='tab_macroexploitation' OR v_tab.tabname='tab_macrosector' THEN
			
			IF v_tab.tabname ='tab_macroexploitation' THEN
				v_zonetable='exploitation';
				EXECUTE 'SELECT array_agg(macroexpl_id) FROM macroexploitation' INTO v_ids;
			ELSIF v_tab.tabname='tab_macrosector' THEN
				EXECUTE 'SELECT array_agg(macrosector_id) FROM v_edit_macrosector' INTO v_ids;
				v_zonetable='sector';
			END IF;

			v_ids = replace(v_ids,'{','');
			v_ids = replace(v_ids,'}','');	

			IF v_ids IS NULL THEN v_ids='0'; END IF;

			v_finalquery = concat('SELECT array_to_json(array_agg(row_to_json(a))) FROM (
					SELECT ',quote_ident(v_table_id),', concat(' , v_label , ') AS label, ',v_orderby,' as orderby , ',v_name,' as name, ', v_table_id , '::text as widgetname, ''' , 
					v_selector_id , ''' as columnname, ''check'' as type, ''boolean'' as "dataType", true as "value" 
					FROM ' , v_table , ' m JOIN  ' , v_zonetable , '  USING (',v_table_id,') 
					WHERE ',v_table_id ,' IN (' , v_ids, ') ', v_fullfilter ,' UNION 
					SELECT ',quote_ident(v_table_id),', concat(' , v_label , ') AS label, ',v_orderby,' as orderby , ',v_name,' as name, ', v_table_id , '::text as widgetname, ''' , 
					v_selector_id , ''' as columnname, ''check'' as type, ''boolean'' as "dataType", false as "value" 
					FROM ' , v_table , ' m JOIN   ' , v_zonetable , '    USING (',v_table_id,')
					WHERE ',v_table_id ,' NOT IN (' , v_ids, ') ',
					 v_fullfilter ,' ORDER BY orderby asc) a');

		ELSE 
			v_finalquery = concat('SELECT array_to_json(array_agg(row_to_json(a))) FROM (
					SELECT ',quote_ident(v_table_id),', concat(' , v_label , ') AS label, ',v_orderby,' as orderby , ',v_name,' as name, ', v_table_id , '::text as widgetname, ''' ,
					 v_selector_id , ''' as columnname, ''check'' as type, ''boolean'' as "dataType", true as "value" 
					FROM ', v_table ,' WHERE ' , v_table_id , ' IN (SELECT ' , v_selector_id , ' FROM ', v_selector ,' WHERE cur_user=' , quote_literal(current_user) , ') ', v_fullfilter ,' UNION 
					SELECT ',quote_ident(v_table_id),', concat(' , v_label , ') AS label, ',v_orderby,' as orderby , ',v_name,' as name, ', v_table_id , '::text as widgetname, ''' , 
					v_selector_id , ''' as columnname, ''check'' as type, ''boolean'' as "dataType", false as "value" 
					FROM ', v_table ,' WHERE ' , v_table_id , ' NOT IN (SELECT ' , v_selector_id , ' FROM ', v_selector ,' WHERE cur_user=' , quote_literal(current_user) , ') ',
					 v_fullfilter ,' ORDER BY orderby asc) a');
		END IF;
		v_debug_vars := json_build_object('v_table_id', v_table_id, 'v_label', v_label, 'v_orderby', v_orderby, 'v_name', v_name, 'v_selector_id', v_selector_id, 
						  'v_table', v_table, 'v_selector', v_selector, 'current_user', current_user, 'v_fullfilter', v_fullfilter);
		v_debug := json_build_object('querystring', v_finalquery, 'vars', v_debug_vars, 'funcname', 'gw_fct_getselectors', 'flag', 30);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;

		EXECUTE  v_finalquery INTO v_formTabsAux;

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

	-- Finish the construction of the tabs array
	v_formTabs := v_formTabs ||']';

	-- Check null
	v_formTabs := COALESCE(v_formTabs, '[]');
	v_manageall := COALESCE(v_manageall, FALSE);	
	v_selectionMode = COALESCE(v_selectionMode, '');
	v_currenttab = COALESCE(v_currenttab, '');
	v_geometry = COALESCE(v_geometry, '{}');
	v_stylesheet := COALESCE(v_stylesheet, '{}');
	
	EXECUTE 'SET ROLE ' || v_prev_cur_user || '';
	
	-- Return
	IF v_firsttab IS FALSE THEN
		-- Return not implemented
		RETURN ('{"status":"Accepted"' ||
		', "version":'|| v_version ||
		', "message":"Not implemented"'||
		'}')::json;
	ELSE 
		v_uservalues := COALESCE(json_extract_path_text(p_data,'data','userValues'), 
			(SELECT to_json(array_agg(row_to_json(a))) FROM (SELECT parameter, value FROM config_param_user WHERE parameter IN ('plan_psector_vdefault', 'utils_workspace_vdefault') AND cur_user = current_user ORDER BY parameter)a)::text, 
			'{}');
		v_action := json_extract_path_text(p_data,'data','action');
		IF v_action = '' THEN v_action = NULL; END IF;
		
		
		-- Return formtabs
		RETURN gw_fct_json_create_return(('{"status":"Accepted", "version":'||v_version||
			',"body":{"message":'||v_message||
			',"form":{"formName":"", "formLabel":"", "currentTab":"'||v_currenttab||'", "formText":"", "formTabs":'||v_formTabs||', "style": '||v_stylesheet||'}'||
			',"feature":{}'||
			',"data":{"userValues":'||v_uservalues||',"geometry":'||v_geometry||'}'||
			'}'||
		    '}')::json,2796, null, null, v_action::json);
	END IF;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;
	RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version || ',"SQLSTATE":' || to_json(SQLSTATE) || ',"MSGERR": '|| to_json(v_msgerr::json ->> 'MSGERR') ||'}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
