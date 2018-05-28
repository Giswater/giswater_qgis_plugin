CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getreviewform"(element_type varchar, lang varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;
    formToDisplay character varying;
    position json;
    fields json;
    fields_array json[];
    position_row integer;
    combo_rows json[];
    aux_json json;    
    combo_json json;
    project_type character varying;
    formToDisplayName character varying;    
    api_version json;




BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;


--    Check project type
    EXECUTE 'SELECT wsoftware FROM version' INTO project_type;

--    Get web form name:
    formToDisplayName := 'review_' || element_type;

--    Get web form number:
    IF element_type = 'arc' THEN

        IF project_type = 'UD' THEN
            formToDisplay := 'F51';
        ELSE
            formToDisplay := 'F55';
        END IF;

    ELSIF element_type = 'node' THEN

        IF project_type = 'UD' THEN
            formToDisplay := 'F52';
        ELSE
            formToDisplay := 'F56';
        END IF;
        
    ELSIF element_type = 'connec' THEN

        IF project_type = 'UD' THEN
            formToDisplay := 'F53';
        ELSE
            formToDisplay := 'F57';
        END IF;    

    ELSIF element_type = 'gully' THEN

        formToDisplay := 'F54';

    END IF;


--    Get form fields
    EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT label, name, type, "dataType", placeholder FROM config_web_fields WHERE table_id = $1) a'
        INTO fields_array
        USING formToDisplayName;    
    

--    Get combo rows
    EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT id, name, type, dv_table, dv_key_column, dv_value_column, ROW_NUMBER() OVER() AS rownum 
        FROM config_web_fields WHERE table_id = $1) a WHERE type = $2'
    INTO combo_rows
    USING formToDisplayName, 'combo';
    combo_rows := COALESCE(combo_rows, '{}');

--    Update combos
    FOREACH aux_json IN ARRAY combo_rows
    LOOP

--        Get combo values
        EXECUTE 'SELECT array_to_json(array_agg(' || quote_ident(aux_json->>'dv_key_column') || ')) FROM ' || (aux_json->>'dv_table')::TEXT
        INTO combo_json; 

--        Update array
        fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboValues', combo_json);

--        Get combo id's
        EXECUTE 'SELECT array_to_json(array_agg(' || quote_ident(aux_json->>'dv_value_column') || ')) FROM ' || (aux_json->>'dv_table')::TEXT
        INTO combo_json; 

        fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboKeys', combo_json);
        fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'selectedValue', combo_json->1);

    END LOOP;


--    Convert to json
    fields := array_to_json(fields_array);


    
RAISE NOTICE 'Res: %', combo_rows;

--    Control NULL's
    formToDisplay := COALESCE(formToDisplay, '');
    fields := COALESCE(fields, '[]');    
    position := COALESCE(position, '[]');

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "formToDisplay":"' || formToDisplay || '"' ||
        ', "fields":' || fields ||
        '}')::json;

--    Exception handling
   EXCEPTION WHEN OTHERS THEN 
      RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

