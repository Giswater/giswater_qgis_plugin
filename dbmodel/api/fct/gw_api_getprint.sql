/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 2682


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getprint(p_data json)
  RETURNS json AS
$BODY$
DECLARE

/*
 
SELECT "SCHEMA_NAME".gw_api_getprint($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{},
"data":{"composers":"{A4-mincut, A3-mincut}"}}$$)
*/  
    
	
--    Variables
    column_type character varying;
    fields json;
    fields_array json[];
    combo_rows json[];
    aux_json json;    
    combo_json json;
    project_type character varying;
    table_pkey varchar;
    schemas_array name[];
    array_index integer DEFAULT 0;
    field_value character varying;
    api_version json;
    v_value_vdef character varying;
    formTabs text;
    formTabs_inittab json;
    query_text text;
    formInfo json;
    v_formname text;
    v_fields json [];
    v_device integer;
    v_activecomposer text;
    

BEGIN

    -- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

    -- Get schema name
    schemas_array := current_schemas(FALSE);

    -- Get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

	v_device = ((p_data ->>'client')::json->>'device')::integer;
	v_activecomposer = ((p_data ->>'data')::json->>'composers');

	EXECUTE 'SELECT array_to_json($1::text[])'
		USING v_activecomposer
		INTO combo_json; 

        v_formname='printGeneric';

-- Create tabs array
    formTabs := '[';
       
	SELECT gw_api_get_formfields( 'printGeneric', 'form', 'data', null, null, null, null, 'SELECT', null, 3) INTO v_fields; -- 'SELECT' parameter used on line 190 of gw_api_get_formfields

	-- setting values
	FOREACH aux_json IN ARRAY v_fields 
	LOOP          
		IF (aux_json->>'column_id')='composer' THEN 
			raise notice 'asg';
			v_fields[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(v_fields[(aux_json->>'orderby')::INT], 'comboIds', COALESCE (combo_json,'[]') );
			v_fields[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(v_fields[(aux_json->>'orderby')::INT], 'comboNames', COALESCE (combo_json,'[]') );
			v_fields[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(v_fields[(aux_json->>'orderby')::INT], 'selectedId', '1'::text );
		END IF;		
	END LOOP;			
	
--    Inizialing the the tab
	formTabs_inittab := gw_fct_json_object_set_key(formTabs_inittab, 'tabName', 'Menu print'::TEXT);
	formTabs_inittab := gw_fct_json_object_set_key(formTabs_inittab, 'tabLabel', 'Menu de print'::TEXT);
	formTabs_inittab := gw_fct_json_object_set_key(formTabs_inittab, 'tabIdName', 'print'::TEXT);
	formTabs_inittab := gw_fct_json_object_set_key(formTabs_inittab, 'active', true);

--    Adding the fields array
	formTabs_inittab := gw_fct_json_object_set_key(formTabs_inittab, 'fields', array_to_json(v_fields));

--    Adding to the tabs structure
	formTabs := formTabs || formTabs_inittab::text;
    
--    Finish the construction of formtabs
      formTabs := formtabs ||']';

--    Create new form for mincut
      formInfo := json_build_object('formId','F41','formName','Impressio');

--    Check null
      api_version := COALESCE(api_version, '[]');    
      formInfo := COALESCE(formInfo, '[]'); 
      formTabs := COALESCE(formTabs, '[]');      

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version || 
        ', "formInfo":'|| formInfo || 
        ', "formTabs":' || formTabs ||
        '}')::json;


--    Exception handling
    --EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
