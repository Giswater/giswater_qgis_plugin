/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2796

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getselectors(p_data json)
  RETURNS json AS
$BODY$

/*example
CURRENT
SELECT gw_api_getselectors($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, 
"selector_type":{"mincut": {"ids":[1, 10, 12, 13, 14, 15, 16, 17], "table":"anl_mincut_result_selector", "view":"anl_mincut_result_cat"}}}}$$)::text

PROPOSED
SELECT gw_api_getselectors($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, selectorType":"mincut"}}$$)::text
*/

DECLARE


--	Variables
	selected_json json;	
	form_json json;
	v_formTabs_minuct  json;
	v_formTabs text;
	json_array json[];
	api_version json;
	rec_tab record;
	v_active boolean=true;
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

BEGIN


-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO api_version;

-- Get input parameters:
	v_selector_type := (p_data ->> 'data')::json->> 'selector_type';
	v_selectors_list := (((p_data ->> 'data')::json->>'selector_type')::json ->>'mincut')::json->>'ids';

-- Manage list ids
	v_selectors_list = replace(replace(v_selectors_list, '[', '('), ']', ')');
	
-- Start the construction of the tabs array
	v_formTabs := '[';
	
	SELECT array_agg(row_to_json(a)) FROM (SELECT * FROM json_object_keys(v_selector_type))a into fields_array;
	
	
	FOREACH v_aux_json IN ARRAY fields_array
	LOOP		

	SELECT * INTO rec_tab FROM config_api_form_tabs WHERE formname=v_aux_json->>'json_object_keys';
	IF rec_tab.id IS NOT NULL THEN

		-- get selector parameters
		v_parameter_selector = (SELECT value::json FROM config_param_system WHERE parameter = 'api_selector_mincut');
		v_label = v_parameter_selector->>'label';
		v_table = v_parameter_selector->>'table';
		v_selector = v_parameter_selector->>'selector';

		-- Manage selectors list
		IF v_selectors_list = '()' THEN
			v_selectors_list = '(-1)';
		END IF;
		
		-- Get exploitations, selected and unselected with selectors list
		EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
		SELECT concat(' || v_label || ') AS label, id::text as widgetname, ''result_id'' as column_id, ''check'' as type, ''boolean'' as "dataType", true as "value" 
		FROM '|| v_table ||' WHERE id IN (SELECT result_id FROM '|| v_selector ||' WHERE cur_user=' || quote_literal(current_user) || ') AND id IN '|| v_selectors_list ||'
		UNION
		SELECT concat(' || v_label || ') AS label, id::text as widgetname, ''result_id'' as column_id, ''check'' as type, ''boolean'' as "dataType", false as "value" 
		FROM '|| v_table ||' WHERE id NOT IN (SELECT result_id FROM '|| v_selector ||' WHERE cur_user=' || quote_literal(current_user) || ') AND id IN '|| v_selectors_list ||'
		ORDER BY label) a'
		INTO v_formTabs_minuct;

		
		-- Add tab name to json
		IF v_formTabs_minuct IS NULL THEN
			v_formTabs_minuct := ('{"fields":[]}')::json;
		ELSE
			v_formTabs_minuct := ('{"fields":' || v_formTabs_minuct || '}')::json;
		END IF;

		v_formTabs_minuct := gw_fct_json_object_set_key(v_formTabs_minuct, 'tabName', rec_tab.tabname::TEXT);
		v_formTabs_minuct := gw_fct_json_object_set_key(v_formTabs_minuct, 'tableName', v_selector);
		v_formTabs_minuct := gw_fct_json_object_set_key(v_formTabs_minuct, 'tabLabel', rec_tab.tablabel::TEXT);
		v_formTabs_minuct := gw_fct_json_object_set_key(v_formTabs_minuct, 'selectorType', rec_tab.formname::TEXT);

		-- Create tabs array
		IF v_firsttab THEN 
			v_formTabs := v_formTabs || ',' || v_formTabs_minuct::text;
		ELSE 
			v_formTabs := v_formTabs || v_formTabs_minuct::text;
		END IF;

		v_firsttab := TRUE;
		v_active :=FALSE;
	END IF;


	END LOOP;

-- Finish the construction of the tabs array
	v_formTabs := v_formTabs ||']';


-- Check null
	v_formTabs := COALESCE(v_formTabs, '[]');	

-- Return
	IF v_firsttab IS FALSE THEN
		-- Return not implemented
		RETURN ('{"status":"Accepted"' ||
		', "apiVersion":'|| api_version ||
		', "message":"Not implemented"'||
		'}')::json;
	ELSE 
		-- Return formtabs
		RETURN ('{"status":"Accepted", "apiVersion":'||api_version||
			',"body":{"message":{"priority":1, "text":"This is a test message"}'||
			',"form":{"formName":"", "formLabel":"", "formText":""'|| 
			',"formTabs":'||v_formTabs||
			',"formActions":[]}'||
			',"feature":{}'||
			',"data":{}}'||
		    '}')::json;
	END IF;

-- Exception handling
--	EXCEPTION WHEN OTHERS THEN 
		--RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
