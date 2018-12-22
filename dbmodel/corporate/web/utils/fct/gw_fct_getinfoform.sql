CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getinfoform"(table_id varchar, lang varchar, p_id varchar, formtodisplay text) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    column_type character varying;
    query_result character varying;
    position json;
    fields json;
    fields_array json[];
    values_array json;
    position_row integer;
    combo_rows json[];
    aux_json json;    
    combo_json json;
    project_type character varying;
    formToDisplayName character varying;
    table_pkey varchar;
    schemas_array name[];
    array_index integer DEFAULT 0;
    field_value character varying;
    class_id_var text;
    api_version json;
    rec_value record;



BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--    Get schema name
    schemas_array := current_schemas(FALSE);
    

   raise notice 'table_id %, id %, formtodisplay %', table_id, p_id, formtodisplay;
        
--    Get form fields
    EXECUTE 'SELECT array_agg(row_to_json(a)) FROM 
    (SELECT a.attname as label, a.attname as name, 
	(case when a.atttypid=16 then ''check'' else ''text'' end ) as type, 
	(case when a.atttypid=16 then ''boolean'' else ''string'' end ) as "dataType", 
	''''::TEXT as placeholder, false as "disabled" 
	FROM pg_attribute a
	JOIN pg_class t on a.attrelid = t.oid
	JOIN pg_namespace s on t.relnamespace = s.oid
	WHERE a.attnum > 0 
	AND NOT a.attisdropped
	AND t.relname = $1
	AND s.nspname = $2
	AND (a.attname !=''the_geom'' OR a.attname !=''geom'')
	AND a.atttypid != 150381
	ORDER BY a.attnum ) a'
        INTO fields_array
        USING table_id, schemas_array[1];  
		

--    Get id column
    EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
        INTO table_pkey
        USING table_id;


--    For views it suposse pk is the first column
    IF table_pkey ISNULL THEN
        EXECUTE '
 SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
  AND t.relname = $1 
  AND s.nspname = $2
ORDER BY a.attnum LIMIT 1'

        INTO table_pkey
        USING table_id, schemas_array[1];
    END IF;


--    Get column type
    EXECUTE 'SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) FROM pg_attribute a
  JOIN pg_class t on a.attrelid = t.oid
  JOIN pg_namespace s on t.relnamespace = s.oid
WHERE a.attnum > 0 
  AND NOT a.attisdropped
  AND a.attname = $3
  AND t.relname = $2 
  AND s.nspname = $1
ORDER BY a.attnum'
        USING schemas_array[1], table_id, table_pkey
        INTO column_type;
        
--getting values
EXECUTE 'SELECT (row_to_json(a)) FROM 
    (SELECT * FROM '||table_id||' WHERE '||table_pkey||' = CAST($1 AS '||column_type||'))a'
        INTO values_array
        USING p_id;


--    Fill every value
    FOREACH aux_json IN ARRAY fields_array
    LOOP
--      Index
        array_index := array_index + 1;

    field_value := (values_array->>(aux_json->>'name'));
          
        field_value := COALESCE(field_value, '');
        
--      Update array
        fields_array[array_index] := gw_fct_json_object_set_key(fields_array[array_index], 'value', field_value);
           
    END LOOP;

   
--    Convert to json
    fields := array_to_json(fields_array);

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
  --  EXCEPTION WHEN OTHERS THEN 
  --     RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

