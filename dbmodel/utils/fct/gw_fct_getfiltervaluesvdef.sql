/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2872

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getfiltervaluesvdef(p_data json)
  RETURNS json AS
$BODY$

/* example
SELECT SCHEMA_NAME.gw_fct_getfiltervaluesvdef($${"client":{"device":4, "infoType":100, "lang":"ES"},"data":{"formName": "om_visit"}}$$)
*/

DECLARE

-- Variables
v_version text;
v_schemaname text;
v_device integer;
v_formname text;
v_formtype text;
fields_array json[];
aux_json json; 
v_fields text;
v_key text;
v_value text;
i integer = 1;
	
BEGIN

	-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    v_schemaname = 'SCHEMA_NAME';

	-- get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;
       
	-- Get input parameters:
	v_device := (p_data ->> 'client')::json->> 'device';
	v_formname := (p_data ->> 'data')::json->> 'formName';
	v_formtype = 'form_list_header';

	IF (SELECT columnname FROM config_form_fields WHERE formname = v_formname AND formtype= v_formtype LIMIT 1) IS NOT NULL THEN
	
		EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT columnname, layoutorder as orderby FROM config_form_fields WHERE formname = $1 AND formtype= $2 ORDER BY orderby) a'
				INTO fields_array
				USING v_formname, v_formtype;

		-- v_fields (1step)
		v_fields = '{';
		
		-- v_fields (2 step)
		FOREACH aux_json IN ARRAY fields_array
		LOOP
			v_key = fields_array[(aux_json->>'orderby')::INT]->>'columnname';
			v_value = (SELECT listfilterparam->>'vdefault' FROM config_form_fields WHERE formname=v_formname AND columnname=v_key);
			
			IF i>1 THEN 
				v_fields = concat (v_fields,',');
			END IF;

			-- setting values
			IF v_value is null then 
				v_fields = concat (v_fields, '"',v_key, '":null');	
			ELSE
				v_fields = concat (v_fields, '"',v_key, '":"', v_value, '"');	
			END IF;
		
			i=i+1;
		END LOOP;				

		-- v_fields (3 step)
		v_fields = concat (v_fields ,'}');			
	END IF;

	-- Return
    RETURN (v_fields);    

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
    RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

