-- Function: ws_sample35.gw_fct_getfiltervaluesvdef(json)

-- DROP FUNCTION ws_sample35.gw_fct_getfiltervaluesvdef(json);

CREATE OR REPLACE FUNCTION ws_sample35.gw_fct_getfiltervaluesvdef(p_data json)
  RETURNS json AS
$BODY$

/* example
SELECT ws_sample35.gw_fct_getfiltervaluesvdef($${"client":{"device":4, "infoType":100, "lang":"ES"},"data":{"formName": "om_visit"}}$$)
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

v_tabname text;
	
BEGIN

	-- Set search path to local schema
    SET search_path = "ws_sample35", public;
    v_schemaname = 'ws_sample35';

	-- get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;
       
	-- Get input parameters:
	v_device := (p_data ->> 'client')::json->> 'device';
	v_formname := (p_data ->> 'data')::json->> 'formName';
	v_formtype := (p_data ->> 'data')::json->> 'formType';
	
	v_tabname := (p_data ->> 'data')::json->> 'tabName';
	IF v_formtype IS NULL THEN--IF IS BMAPS
		v_formtype = 'form_list_header';
	END IF;
RAISE NOTICE '%---%',v_formname, v_formtype;
	IF (SELECT columnname FROM config_form_fields WHERE formname = v_formname AND formtype= v_formtype LIMIT 1) IS NOT NULL THEN
		RAISE NOTICE '%---%',v_formname, v_formtype;
		IF v_device = 4 THEN
			EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT columnname, layoutorder as orderby FROM config_form_fields WHERE formname = $1 AND formtype= $2 AND tabname = $3 ORDER BY orderby) a'
					INTO fields_array
					USING v_formname, v_formtype, v_tabname;
		ELSE
			EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT columnname, layoutorder as orderby FROM config_form_fields WHERE formname = $1 AND formtype= $2 ORDER BY orderby) a'
					INTO fields_array
					USING v_formname, v_formtype;
		END IF;
RAISE NOTICE 'fields_array---%',fields_array;

		-- v_fields (1step)
		v_fields = '{';

		-- v_fields (2 step)
		FOREACH aux_json IN ARRAY fields_array
		LOOP
			v_key = fields_array[(aux_json->>'orderby')::INT]->>'columnname';
			IF v_device = 4 THEN
				v_value = (SELECT listfilterparam->>'vdefault' FROM config_form_fields WHERE formname=v_formname AND columnname=v_key AND tabname =v_tabname);
			ELSE
				v_value = (SELECT listfilterparam->>'vdefault' FROM config_form_fields WHERE formname=v_formname AND columnname=v_key);
			END IF;
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
RAISE NOTICE 'v_fields----------->%',v_fields;

	-- Return
    RETURN (v_fields);

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
    RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION ws_sample35.gw_fct_getfiltervaluesvdef(json)
  OWNER TO role_admin;
GRANT EXECUTE ON FUNCTION ws_sample35.gw_fct_getfiltervaluesvdef(json) TO public;
GRANT EXECUTE ON FUNCTION ws_sample35.gw_fct_getfiltervaluesvdef(json) TO role_admin;
GRANT EXECUTE ON FUNCTION ws_sample35.gw_fct_getfiltervaluesvdef(json) TO role_basic;
