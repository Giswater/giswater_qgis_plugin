/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- Function: SCHEMA_NAME.gw_fct_getfilterdate(json)

-- DROP FUNCTION SCHEMA_NAME.gw_fct_getfilterdate(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getfilterdate(info_json json)
  RETURNS json AS
$BODY$
/*
SELECT SCHEMA_NAME.gw_fct_getfilterdate('{"istilemap":"False","device":3,"lang":"es"}') AS result
*/


DECLARE

--	Variables
	selected_json json;	
	form_json json;
	filter_dates json[];
	aux_json json;
	formTabs text;
	json_array json[];
	api_version json;
	rec_tab record;
	v_active boolean=true;
	v_firsttab boolean=false;
	v_istiled_filterstate varchar;
	json_date_value timestamp;
	fields json;
	v_istilemap boolean;
	device integer;
	lang character varying;
	v_formTabs_inittab json;
	formInfo json;

BEGIN


-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO api_version;

-- Start the construction of the tabs array
	formTabs := '[';

--  Get values from json
    v_istilemap:= info_json->>'istilemap';
    device:= info_json->>'device';
    lang:= info_json->>'lang';

-- Selector Filter Date
        SELECT * INTO rec_tab FROM config_web_fields WHERE table_id='filter_date';

	EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (
	SELECT id, label,name, type, "dataType", dv_table, dv_id_column, dv_name_column, orderby, placeholder
	    FROM config_web_fields WHERE table_id=''filter_date'' ORDER BY orderby)a'
	    INTO filter_dates;
	
	FOREACH aux_json IN ARRAY filter_dates
	LOOP
		EXECUTE 'SELECT '|| (aux_json->>'dv_name_column') ||' FROM selector_date WHERE cur_user = current_user'
		INTO json_date_value;
				
		filter_dates[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(filter_dates[(aux_json->>'orderby')::INT], 'value', to_char(json_date_value, 'DD-MM-YYYY HH:MM'));


		IF (aux_json->>'name') = 'date_to' THEN
		filter_dates[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(filter_dates[(aux_json->>'orderby')::INT], 'value', to_char(json_date_value, 'DD-MM-YYYY HH:MM'));
		END IF;
		
		
	END LOOP;

--    Inizialing the the tab
	v_formTabs_inittab := gw_fct_json_object_set_key(v_formTabs_inittab, 'tabName', 'Filtro de Fecha'::TEXT);
	v_formTabs_inittab := gw_fct_json_object_set_key(v_formTabs_inittab, 'tabLabel', 'Filtro de Fecha'::TEXT);
	v_formTabs_inittab := gw_fct_json_object_set_key(v_formTabs_inittab, 'tabIdName', 'date'::TEXT);
	v_formTabs_inittab := gw_fct_json_object_set_key(v_formTabs_inittab, 'active', true);

--    Adding the fields array
	v_formTabs_inittab := gw_fct_json_object_set_key(v_formTabs_inittab, 'fields', array_to_json(filter_dates));

--    Adding to the tabs structure
	formTabs := formTabs || v_formTabs_inittab::text;

	raise notice 'v_formTabs_inittab %', v_formTabs_inittab;

/*	-- Add tab to json
	fields := ('{"fields":' || array_to_json(filter_dates) || '}')::json;

	formTabs := formTabs || fields;*/

-- Finish the construction of the tabs array
	formTabs := formTabs ||']';

--    Create new form for mincut
      formInfo := json_build_object('formId','filter_date','formName','filter_date');
	
-- Check null
	formTabs := COALESCE(formTabs, '[]');	
	formInfo := COALESCE(formInfo, '[]');  

-- Return
	-- Return formtabs
	RETURN ('{"status":"Accepted"' ||
		', "apiVersion":'|| api_version ||
		', "formInfo":'|| formInfo || 
		', "formTabs":' || formTabs ||
		'}')::json;

-- Exception handling
--	EXCEPTION WHEN OTHERS THEN 
		--RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
