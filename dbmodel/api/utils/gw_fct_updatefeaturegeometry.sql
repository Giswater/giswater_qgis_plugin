CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_updatefeaturegeometry"(table_id varchar, srid int4, id int8, value_new varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    column_type character varying;
    schemas_array name[];
    sql_query varchar;
    insert_geom geometry;
    SRID_var int;
    res character varying;
    table_pkey varchar;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--    Get schema name
    schemas_array := current_schemas(FALSE);

--    Construct geom in device coordinates
    insert_geom := ST_SetSRID(ST_GeomFromText(value_new), srid);

--    Get table coordinates
    SRID_var := Find_SRID(schemas_array[1]::TEXT, table_id, 'the_geom');

    RAISE NOTICE '1';

--    Transform from device EPSG to database EPSG
    insert_geom := ST_Transform(insert_geom , SRID_var);    

    RAISE NOTICE '2';


--    Get id column
    EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
        INTO table_pkey
        USING table_id;

    RAISE NOTICE '3';


--    For views is the fir1t column
    IF table_pkey ISNULL THEN
        EXECUTE 'SELECT column_name FROM information_schema.columns WHERE table_schema = $1 AND table_name = ' || quote_literal(table_id) || ' AND ordinal_position = 1'
        INTO table_pkey
        USING schemas_array[1];
    END IF;

--    Get column type
    EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(table_id) || ' AND column_name = $2'
        USING schemas_array[1], table_pkey
        INTO column_type;

RAISE NOTICE 'Res: %1', ST_AsText(insert_geom);

--    Value update
    EXECUTE 'UPDATE ' || quote_ident(table_id) || ' SET the_geom = $1 WHERE ' || quote_ident(table_pkey) || ' = CAST(' || quote_literal(id) || ' AS ' || column_type || ')'
    USING insert_geom;

--    Return
    RETURN ('{"status":"Accepted"}')::json;    

--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
--        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

