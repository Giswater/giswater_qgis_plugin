-- Function: SCHEMA_NAME.gw_api_getselectors(json)

-- DROP FUNCTION SCHEMA_NAME.gw_api_getselectors(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getselectors(p_data json)
  RETURNS json AS
$BODY$

/*example
SELECT gw_api_getselectors($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selector_type":{"mincut": [2, 4]}}}$$)::text

SELECT gw_api_getselectors($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selector_type":{"state": []}}}$$)::text
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
	v_selectors_list json;
	v_aux_json json;
	fields_array json[];
	v_result_list text[];
	v_label_selector json;
	v_concat_label text;
	v_filter_name text;

BEGIN


-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO api_version;

-- Get input parameters:
	v_selectors_list := (p_data ->> 'data')::json->> 'selector_type';

-- Start the construction of the tabs array
	v_formTabs := '[';
	
	SELECT array_agg(row_to_json(a)) FROM (SELECT * FROM json_object_keys(v_selectors_list))a into fields_array;
	

	FOREACH v_aux_json IN ARRAY fields_array
	LOOP		

	SELECT * INTO rec_tab FROM config_api_form_tabs WHERE formname=v_aux_json->>'json_object_keys';
	IF rec_tab.id IS NOT NULL THEN

		EXECUTE 'SELECT value FROM config_param_system WHERE parameter = ''api_selector_label''' INTO v_label_selector;
		v_concat_label = replace(replace(v_label_selector->>rec_tab.formname, '[',''),']','');
		v_concat_label = replace(v_concat_label::text, ',',', '' '',');	
		v_filter_name = 'AND name IN ' ||replace(replace(((v_selectors_list->>rec_tab.formname)::json->>'ids'), '[','('),']',')');
		
		IF (v_selectors_list->>rec_tab.formname)::json->>'ids' IN ('[]') THEN
			v_filter_name = ' ';
		END IF;
		-- Get exploitations, selected and unselected
		EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
		SELECT concat(' || v_concat_label || ') AS label, name::text as widgetname, ''result_id'' as column_id, ''check'' as type, ''boolean'' as "dataType", true as "value" 
		FROM '|| ((v_selectors_list->>rec_tab.formname)::json->>'view') ||' WHERE name IN (SELECT result_id FROM '|| ((v_selectors_list->>rec_tab.formname)::json->>'table') ||' WHERE cur_user=' || quote_literal(current_user) || ')
		'||v_filter_name||' 
		UNION
		SELECT concat(' || v_concat_label || ') AS label, name::text as widgetname, ''result_id'' as column_id, ''check'' as type, ''boolean'' as "dataType", false as "value" 
		FROM '|| ((v_selectors_list->>rec_tab.formname)::json->>'view') ||' WHERE name NOT IN (SELECT result_id FROM '|| ((v_selectors_list->>rec_tab.formname)::json->>'table') ||' WHERE cur_user=' || quote_literal(current_user) || ') 
		'||v_filter_name||' ORDER BY label) a'
		INTO v_formTabs_minuct; 
		
		
		-- Add tab name to json
		IF v_formTabs_minuct IS NULL THEN
			v_formTabs_minuct := ('{"fields":[]}')::json;
		ELSE
			v_formTabs_minuct := ('{"fields":' || v_formTabs_minuct || '}')::json;
		END IF;

		v_formTabs_minuct := gw_fct_json_object_set_key(v_formTabs_minuct, 'tabName', rec_tab.tabname::TEXT);
		v_formTabs_minuct := gw_fct_json_object_set_key(v_formTabs_minuct, 'tableName', ((v_selectors_list->>rec_tab.formname)::json->>'table'));
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
ALTER FUNCTION SCHEMA_NAME.gw_api_getselectors(json)
  OWNER TO postgres;
