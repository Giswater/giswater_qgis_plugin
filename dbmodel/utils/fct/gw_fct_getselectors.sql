/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2796

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_getselectors(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getselectors(p_data json)
  RETURNS json AS
$BODY$

/*example

SELECT gw_fct_getselectors($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"currentTab":"tab_exploitation"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"selector_basic" ,"filterText":"1"}}$$);
SELECT gw_fct_getselectors($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"currentTab":"tab_exploitation"}, "feature":{}, "data":{"selectorType":"selector_basic"}}$$);

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
v_error_context text;
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

	raise notice 'p_data %', v_geometry;
	
	-- get system variables:
	v_expl_x_user = (SELECT value FROM config_param_system WHERE parameter = 'admin_exploitation_x_user');

	-- when typeahead only one tab is executed
	IF v_filterfrominput IS NULL OR v_filterfrominput = '' OR lower(v_filterfrominput) ='None' or lower(v_filterfrominput) = 'null' THEN
		v_querytab = '';
	ELSE 
		v_querytab = concat(' AND tabname = ', quote_literal(v_currenttab));
	END IF;

	-- Start the construction of the tabs array
	v_formTabs := '[';

	FOR v_tab IN EXECUTE 'SELECT config_form_tabs.*, value FROM config_form_tabs, config_param_system WHERE formname='||quote_literal(v_selector_type)||
	' AND concat(''basic_selector_'', tabname) = parameter '||(v_querytab)||' AND sys_role IN (SELECT rolname FROM pg_roles WHERE pg_has_role(current_user, oid, ''member''))  ORDER BY orderby'

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

		-- profilactic control of v_orderby
		IF v_orderby IS NULL THEN v_orderby = '2'; end if;

		-- profilactic control of selection mode
		IF v_selectionMode = '' OR v_selectionMode is null then
			v_selectionMode = 'keepPrevious';
		END IF;

		-- Manage filters from ids (only mincut)
		IF v_selector = 'selector_mincut_result' THEN
			v_selector_list = replace(replace(v_selector_list, '[', '('), ']', ')');
			v_filterfromids = ' AND ' || v_table_id || ' IN '|| v_selector_list || ' ';
		END IF;

		-- built filter from input (recalled from typeahead)
		IF v_filterfrominput IS NULL OR v_filterfrominput = '' OR lower(v_filterfrominput) ='None' or lower(v_filterfrominput) = 'null' THEN
			v_filterfrominput := NULL;
		ELSE 
			v_filterfrominput = concat (v_typeahead,' LIKE ''%', lower(v_filterfrominput), '%''');
		END IF;

		-- built full filter 
		v_fullfilter = concat(v_filterfromids, v_filterfromconfig, v_filterfrominput);
				
		-- profilactic null control
		v_fullfilter := COALESCE(v_fullfilter, '');

		v_finalquery =  'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
			SELECT '||quote_ident(v_table_id)||', concat(' || v_label || ') AS label, ' || v_table_id || '::text as widgetname, ''' || v_selector_id || ''' as columnname, ''check'' as type, ''boolean'' as "dataType", true as "value" 
			FROM '|| v_table ||' WHERE ' || v_table_id || ' IN (SELECT ' || v_selector_id || ' FROM '|| v_selector ||' WHERE cur_user=' || quote_literal(current_user) || ') '|| v_fullfilter ||' UNION 
			SELECT '||quote_ident(v_table_id)||', concat(' || v_label || ') AS label, ' || v_table_id || '::text as widgetname, ''' || v_selector_id || ''' as columnname, ''check'' as type, ''boolean'' as "dataType", false as "value" 
			FROM '|| v_table ||' WHERE ' || v_table_id || ' NOT IN (SELECT ' || v_selector_id || ' FROM '|| v_selector ||' WHERE cur_user=' || quote_literal(current_user) || ') '||
			 v_fullfilter ||' ORDER BY '||v_orderby||' ) a';

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

		raise notice 'v_formTabsAux %', v_formTabsAux;
	
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

	-- Return
	IF v_firsttab IS FALSE THEN
		-- Return not implemented
		RETURN ('{"status":"Accepted"' ||
		', "version":'|| v_version ||
		', "message":"Not implemented"'||
		'}')::json;
	ELSE 

		-- Return formtabs
		RETURN ('{"status":"Accepted", "version":'||v_version||
			',"body":{"message":{"level":1, "text":"This is a test message"}'||
			',"form":{"formName":"", "formLabel":"", "currentTab":"'||v_currenttab||'", "formText":"", "formTabs":'||v_formTabs||'}'||
			',"feature":{}'||
			',"data":{"geometry":'||v_geometry||'}'||
			'}'||
		    '}')::json;
	END IF;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
