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
CURRENT
SELECT gw_fct_getselectors($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"currentTab":"tab_exploitation"}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "selector_type":{"mincut": {"ids":[]}}}}$$);

SELECT gw_fct_getselectors($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "selector_type":{"exploitation": {"ids":[]}}}}$$);

UPDATE config_param_system SET value =
'{"table":"exploitation", "selector":"selector_expl", "table_id":"expl_id",  "selector_id":"expl_id",  "label":"expl_id, '' - '', name, '''', CASE WHEN descript IS NULL THEN '''' ELSE concat('' - '', descript) END", 
 "manageAll":true, "selectionMode":"keepPreviousUsingShift", 
 "layerManager":{"active":[], "visible":["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_gully"], "zoom":["v_edit_arc"], "index":["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_gully"]}, 
 "query_filter":"AND expl_id > 0", "typeaheadFilter":{"queryText":"SELECT expl_id as id, name AS idval FROM v_edit_exploitation WHERE expl_id > 0"}}'
 WHERE parameter = 'basic_selector_exploitation';
 


*/

DECLARE

selected_json json;	
form_json json;
v_formTabsAux  json;
v_formTabs text;
json_array json[];
v_version json;
rec_tab record;
v_active boolean=false;
v_firsttab boolean=false;
v_selectors_list text;
v_selector_type json;
v_aux_json json;
fields_array json[];
v_result_list text[];
v_filter_name text;
v_parameter_selector json;
v_label text;
v_table text;
v_selector text;
v_table_id text;
v_selector_id text;
v_query_filter text;
v_query_filteradd text;
v_manageall boolean;
v_typeahead json;
v_expl_x_user boolean;
v_filter text;
v_filterstatus boolean;
v_selectionMode text;
v_error_context text;
v_currenttab text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;

	-- Get input parameters:
	v_selector_type := (p_data ->> 'data')::json->> 'selector_type';
	v_currenttab := (p_data ->> 'form')::json->> 'currentTab';


	-- get system variables:
	v_expl_x_user = (SELECT value FROM config_param_system WHERE parameter = 'admin_exploitation_x_user');
	
	-- Start the construction of the tabs array
	v_formTabs := '[';
	
	SELECT array_agg(row_to_json(a)) FROM (SELECT * FROM json_object_keys(v_selector_type))a into fields_array;

	FOREACH v_aux_json IN ARRAY fields_array
	LOOP		

		SELECT * INTO rec_tab FROM config_form_tabs WHERE formname=v_aux_json->>'json_object_keys';
		IF rec_tab.formname IS NOT NULL THEN

			-- get selector parameters
			v_parameter_selector = (SELECT value::json FROM config_param_system WHERE parameter = concat('basic_selector_', lower(v_aux_json->>'json_object_keys')::text));

			v_label = v_parameter_selector->>'label';
			v_table = v_parameter_selector->>'table';
			v_selector = v_parameter_selector->>'selector';
			v_table_id = v_parameter_selector->>'table_id';
			v_selector_id = v_parameter_selector->>'selector_id';
			v_query_filteradd = v_parameter_selector->>'query_filter';
			v_manageall = v_parameter_selector->>'manageAll';
			v_typeahead = v_parameter_selector->>'typeaheadFilter';
			v_selectionMode = v_parameter_selector->>'selectionMode';

			-- profilactic control
			IF v_selectionMode = '' OR v_selectionMode is null then
				v_selectionMode = 'keepPrevious';
			END IF;

			-- getting from v_expl_x_user variable
			IF v_selector = 'selector_expl' AND v_expl_x_user THEN
				v_query_filteradd = concat (v_query_filteradd, ' AND expl_id IN (SELECT expl_id FROM config_user_x_expl WHERE username = current_user)');

			END IF;

			-- Manage v_query_filter (using ids)
			v_selectors_list := (((p_data ->> 'data')::json->>'selector_type')::json ->>(lower(v_aux_json->>'json_object_keys')))::json->>'ids';
			v_selectors_list = replace(replace(v_selectors_list, '[', '('), ']', ')');
			IF v_selectors_list IN (NULL, 'None') THEN
				v_query_filter = '';
			ELSIF v_selectors_list = '()' AND v_selector IN ('selector_mincut_result') THEN
				v_query_filter = ' AND ' || v_table_id || ' IN (-1) ';
				--v_query_filter = '';
			ELSIF v_selectors_list = '()' THEN
				v_query_filter = '';
			ELSE
				v_query_filter = ' AND ' || v_table_id || ' IN '|| v_selectors_list || ' ';
			END IF;
			
			-- Manage v_queryfilter add (using filter)
			IF v_query_filter is not NULL THEN
				v_filterstatus = True;
				-- amplify v_queryadd
				v_filter := (((p_data ->> 'data')::json->>'selector_type')::json ->>(lower(v_aux_json->>'json_object_keys')))::json->>'filter';
				v_filter := COALESCE(v_filter, '');
				v_query_filteradd = concat (v_query_filteradd,' AND concat(',v_label ,') LIKE ''%', v_filter, '%''');
				
			ELSE
				v_query_filteradd = '';
			END IF;

			IF v_query_filteradd IS NULL THEN v_query_filteradd ='' ; END IF;

			-- Get exploitations, selected and unselected with selectors list
			v_query_filter := COALESCE(v_query_filter, '');
			v_query_filteradd := COALESCE(v_query_filteradd, '');
		
			EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
			SELECT concat(' || v_label || ') AS label, ' || v_table_id || '::text as widgetname, ''' || v_selector_id || ''' as columnname, ''check'' as type, ''boolean'' as "dataType", true as "value" 
			FROM '|| v_table ||' WHERE ' || v_table_id || ' IN (SELECT ' || v_selector_id || ' FROM '|| v_selector ||' WHERE cur_user=' || quote_literal(current_user) || ') '|| v_query_filter ||' '
			||v_query_filteradd||' 
			UNION 
			SELECT concat(' || v_label || ') AS label, ' || v_table_id || '::text as widgetname, ''' || v_selector_id || ''' as columnname, ''check'' as type, ''boolean'' as "dataType", false as "value" 
			FROM '|| v_table ||' WHERE ' || v_table_id || ' NOT IN (SELECT ' || v_selector_id || ' FROM '|| v_selector ||' WHERE cur_user=' || quote_literal(current_user) || ') '|| v_query_filter ||' '
			||v_query_filteradd||'  ORDER BY label) a'
			INTO v_formTabsAux;

			-- Add tab name to json
			IF v_formTabsAux IS NULL THEN
				v_formTabsAux := ('{"fields":[]}')::json;
			ELSE
				v_formTabsAux := ('{"fields":' || v_formTabsAux || '}')::json;
			END IF;

			-- setting active tab
			IF v_currenttab = rec_tab.tabname THEN
				v_active = true;
			ELSIF v_currenttab IS NULL OR v_currenttab = '' OR v_currenttab ='None' OR v_firsttab is false THEN
				v_active = false;
			END IF;

			-- setting other variables of tab
			v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'tabName', rec_tab.tabname::TEXT);
			v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'tableName', v_selector);
			v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'tabLabel', rec_tab.label::TEXT);
			v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'tooltip', rec_tab.tooltip::TEXT);
			v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'selectorType', rec_tab.formname::TEXT);
			v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'manageAll', v_manageall::TEXT);
			v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'typeaheadFilter', v_typeahead::TEXT);
			v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'selectionMode', v_selectionMode::TEXT);
			v_formTabsAux := gw_fct_json_object_set_key(v_formTabsAux, 'active', v_active::TEXT);

			-- Create tabs array
			IF v_firsttab THEN
				v_formTabs := v_formTabs || ',' || v_formTabsAux::text;
			ELSE 
				v_formTabs := v_formTabs || v_formTabsAux::text;
			END IF;
			v_firsttab := TRUE;
		END IF;
	
	END LOOP;

	-- Finish the construction of the tabs array
	v_formTabs := v_formTabs ||']';

	-- Check null
	v_formTabs := COALESCE(v_formTabs, '[]');
	v_manageall := COALESCE(v_manageall, FALSE);	
	v_selectionMode = COALESCE(v_selectionMode, '');
    v_currenttab = COALESCE(v_currenttab, '');

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
			',"data":{}}'||
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
