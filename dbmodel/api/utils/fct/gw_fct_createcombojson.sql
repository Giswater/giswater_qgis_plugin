/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_createcombojson"(label_arg text, name_arg text, type_arg text, datatype_arg text, placeholder_arg text, disabled_arg bool, table_name_text text, id_column text, name_column text, selected_id text) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    names_json json;
    ids_json json;
    combo_json json;
    schemas_array name[];
    column_type character varying;
    sql_query varchar;
    table_name regclass;

BEGIN

--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    schemas_array := current_schemas(FALSE);

--    Check table exists
    table_name := table_name_text::regclass;

--    Create field
    combo_json := json_build_object('label', label_arg, 'name', name_arg, 'type', type_arg, 'dataType', datatype_arg, 'placeholder', placeholder_arg, 'disabled', disabled_arg);

--    Get combo Names
    EXECUTE 'SELECT array_to_json(array_agg(' || quote_ident(name_column) || ')) FROM (SELECT ' || quote_ident(name_column) || ' FROM ' || quote_ident(table_name_text) || ' ORDER BY ' || quote_ident(name_column) || ') a'
    INTO names_json; 

--    Update array
    combo_json := gw_fct_json_object_set_key(combo_json, 'comboNames', names_json);

--    Get combo Ids
    EXECUTE 'SELECT array_to_json(array_agg(' || quote_ident(id_column) || ')) FROM (SELECT ' || quote_ident(id_column) || '::TEXT FROM ' || quote_ident(table_name_text) || ' ORDER BY ' || quote_ident(name_column) || ') a'
    INTO ids_json;  

--    Update array
    combo_json := gw_fct_json_object_set_key(combo_json, 'comboIds', ids_json);

--    Selected value
    IF selected_id ISNULL THEN
        combo_json := gw_fct_json_object_set_key(combo_json, 'selectedId', ids_json->>0);
    ELSE


--        Get column type
        EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = ' || quote_literal(schemas_array[1]) || ' AND table_name = ' || quote_literal(table_name_text) || ' AND column_name = ' || quote_literal(id_column)
        INTO column_type;

--        Error control
        IF column_type ISNULL THEN
            RETURN ('{"status":"Failed","SQLERR":"Column ' || id_column || ' does not exist in table ' || table_name_text || '"}')::json;
        END IF;        

--        Selected value
--        EXECUTE 'SELECT gw_fct_json_object_set_key($1, ''selectedId'', CAST(' || quote_literal(selected_id) || ' AS ' || column_type || '))'    
        EXECUTE 'SELECT gw_fct_json_object_set_key($1, ''selectedId'', ' || quote_literal(selected_id) || '::TEXT)'    
        INTO combo_json
        USING combo_json, selected_id, column_type;

    END IF;

    RETURN combo_json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

