/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 2682

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getprint(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getprint(p_data json)
  RETURNS json AS
$BODY$

/*

SELECT "SCHEMA_NAME".gw_fct_getprint($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},
"feature":{},
"data":{"composers":"{A4-mincut, A3-mincut}"}}$$)
*/  

DECLARE    

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
v_version text;
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
    SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	v_device = ((p_data ->>'client')::json->>'device')::integer;
	v_activecomposer = ((p_data ->>'data')::json->>'composers');

	EXECUTE 'SELECT array_to_json($1::text[])'
		USING v_activecomposer
		INTO combo_json; 

        v_formname='print';

	-- Create tabs array
    formTabs := '[';
       
	SELECT gw_fct_getformfields( 'print', 'form_print', 'data', null, null, null, null, 'SELECT', null, 9, null) INTO v_fields; -- 'SELECT' parameter used on line 190 of gw_fct_getformfields

	-- setting values
	FOREACH aux_json IN ARRAY v_fields 
	LOOP          
		IF (aux_json->>'columnname')='composer' THEN 
			v_fields[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(v_fields[(aux_json->>'orderby')::INT], 'comboIds', COALESCE (combo_json,'[]') );
			v_fields[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(v_fields[(aux_json->>'orderby')::INT], 'comboNames', COALESCE (combo_json,'[]') );
			v_fields[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(v_fields[(aux_json->>'orderby')::INT], 'selectedId', combo_json->0::text );
		END IF;		
	END LOOP;			
	
	-- Inizialing the the tab
	formTabs_inittab := gw_fct_json_object_set_key(formTabs_inittab, 'tabName', 'Menu print'::TEXT);
	formTabs_inittab := gw_fct_json_object_set_key(formTabs_inittab, 'tabLabel', 'Menu de print'::TEXT);
	formTabs_inittab := gw_fct_json_object_set_key(formTabs_inittab, 'tabIdName', 'print'::TEXT);
	formTabs_inittab := gw_fct_json_object_set_key(formTabs_inittab, 'active', true);

	-- adding the fields array
	formTabs_inittab := gw_fct_json_object_set_key(formTabs_inittab, 'fields', array_to_json(v_fields));

	-- adding to the tabs structure
	formTabs := formTabs || formTabs_inittab::text;
    
	--  finish the construction of formtabs
      formTabs := formtabs ||']';

	-- create new form for mincut
      formInfo := json_build_object('formId','F41','formName','Impressio');

	-- check null
      v_version := COALESCE(v_version, '');
      formInfo := COALESCE(formInfo, '[]'); 
      formTabs := COALESCE(formTabs, '[]');      

	-- Return
    RETURN ('{"status":"Accepted"' ||
        ', "version":"'|| v_version ||'"'||
        ', "formInfo":'|| formInfo || 
        ', "formTabs":' || formTabs ||
        '}')::json;

	-- Exception handling
    EXCEPTION WHEN OTHERS THEN 
    RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
