/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_updatefeature"(p_table_id varchar, p_id varchar, p_column_name varchar, p_value_new varchar) RETURNS pg_catalog.json AS 
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_updatefeature('v_edit_man_junction','35', 'depth', '4')
*/

DECLARE

--    Variables
    column_type character varying;
    schemas_array name[];
    sql_query varchar;
    table_pkey varchar;
    column_type_id character varying;
    api_version json;

BEGIN

--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--    Get schema name
    schemas_array := current_schemas(FALSE);

--    Get column type
    EXECUTE FORMAT ('SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(p_table_id) || ' AND column_name = $2')
        USING schemas_array[1], p_column_name
        INTO column_type;

--    Error control
    IF column_type ISNULL THEN
        RETURN ('{"status":"Failed","SQLERR":"Column ' || quote_literal(p_column_name) || ' does not exist in table "}')::json;
    END IF;

--    Get id column, for tables is the key column
    EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
        INTO table_pkey
        USING p_table_id;

--    For views is the first column
    IF table_pkey ISNULL THEN
        EXECUTE FORMAT ('SELECT column_name FROM information_schema.columns WHERE table_schema = $1 AND table_name = ' || quote_literal(p_table_id) || ' AND ordinal_position = 1')
        INTO table_pkey
        USING schemas_array[1];
    END IF;

--    Get column type
    EXECUTE FORMAT ('SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(p_table_id) || ' AND column_name = $2')
        USING schemas_array[1], table_pkey
        INTO column_type_id;

         EXECUTE FORMAT ('UPDATE ' || quote_ident(p_table_id) || ' SET ' || quote_ident(p_column_name) || ' = CAST( $1 AS ' || quote_literal(column_type) || ') 
			  WHERE ' || quote_ident(table_pkey) || ' = CAST( ' || quote_ident(p_id) || ' AS ' || quote_literal(column_type_id) || ')')
		USING p_value_new;
		
--    Return
    RETURN ('{"status":"Accepted", "apiVersion":'|| api_version ||'}')::json;    

--    Exception handling
   EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

