/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_createwidgetjson"(label_arg text, name_arg text, type_arg text, datatype_arg text, placeholder_arg text, disabled_arg bool, value_arg text) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    widget_json json;
    schemas_array name[];
    value_type text;

BEGIN

--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    schemas_array := current_schemas(FALSE);


RAISE NOTICE 'gw_fct_createwidgetjson() Args: %, %, %, %, %, %', label_arg, name_arg, type_arg, datatype_arg, placeholder_arg, disabled_arg;

--    Create JSON
    widget_json := json_build_object('label', label_arg, 'name', name_arg, 'type', type_arg, 'dataType', datatype_arg, 'placeholder', placeholder_arg, 'disabled', disabled_arg);

--    Cast value
    IF datatype_arg = 'integer' THEN
        value_type = 'INTEGER';
    ELSIF datatype_arg = 'double' THEN
        value_type = 'DOUBLE PRECISION';
    ELSIF datatype_arg = 'boolean' THEN
        value_type = 'BOOLEAN';
    ELSE
        value_type = 'TEXT';
    END IF;

RAISE NOTICE 'TYPE: %, %', datatype_arg, value_type;
    
--    Add 'value' field
    IF value_arg ISNULL THEN
        widget_json := gw_fct_json_object_set_key(widget_json, 'value', 'NULL'::TEXT);
    ELSE
        EXECUTE 'SELECT gw_fct_json_object_set_key($1, ''value'', CAST(' || quote_literal(value_arg) || ' AS ' || value_type || '))'    
            INTO widget_json
            USING widget_json;
    END IF;
    
    RETURN widget_json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

