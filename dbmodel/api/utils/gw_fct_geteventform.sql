CREATE OR REPLACE FUNCTION "arbrat_viari"."gw_fct_geteventform"(parameter_id varchar, arc_id varchar, lang varchar) RETURNS pg_catalog.json AS $BODY$
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



BEGIN


--    Set search path to local schema
    SET search_path = "arbrat_viari", public;


--    Get web form:
    SELECT form_type INTO query_result FROM om_visit_parameter WHERE id = parameter_id;

--    Case
    CASE query_result

    WHEN 'event_standard' THEN

        formToDisplay := 'F22';

    WHEN 'event_ud_arc_standard' THEN

        formToDisplay := 'F23';

    WHEN  'event_ud_arc_rehabit' THEN

        formToDisplay := 'F24';

    ELSE
        RETURN ('{"status":"Failed","message":"Form does not exist"}')::json;

    END CASE;


--    Get form fields
    EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT label, name, type, "dataType", placeholder FROM config_web_fields WHERE table_id = $1) a'
        INTO fields_array
        USING formToDisplay;    


--    Position nodes
    IF arc_id IS NOT NULL THEN

--        Get node_1
        EXECUTE 'SELECT array_to_json(ARRAY[node_1, node_2]) FROM arbrat_viari.arc WHERE arc_id = $1'
            INTO position
            USING arc_id;

--        Get position row
        EXECUTE 'SELECT rownum FROM (SELECT name, ROW_NUMBER() OVER() AS rownum FROM config_web_fields WHERE table_id = $1) a WHERE name = $2'
        INTO position_row
        USING formToDisplay, 'position_id';

RAISE NOTICE 'Res: %', formToDisplay;


--        Update position_id
        IF position_row IS NOT NULL THEN
            fields_array[position_row] := gw_fct_json_object_set_key(fields_array[position_row], 'comboValues', position);
            fields_array[position_row] := gw_fct_json_object_set_key(fields_array[position_row], 'comboKeys', position);
            fields_array[position_row] := gw_fct_json_object_set_key(fields_array[position_row], 'selectedValue', position->1);
        END IF;
        

    END IF;
    

--    Get combo rows
    EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT id, name, type, dv_table, dv_key_column, dv_value_column, ROW_NUMBER() OVER() AS rownum 
        FROM config_web_fields WHERE table_id = $1) a WHERE name != $2 AND type = $3'
    INTO combo_rows
    USING formToDisplay, 'position_id', 'combo';
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


--    Control NULL's
    formToDisplay := COALESCE(formToDisplay, '');
    fields := COALESCE(fields, '[]');    
    position := COALESCE(position, '[]');

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "formToDisplay":"' || formToDisplay || '"' ||
        ', "fields":' || fields ||
        '}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

