CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_insertreview"(element_type varchar, srid int4, the_geom varchar, insert_data json) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    id_insert character varying;
    insert_geom geometry;
    SRID_var int;
    schemas_array name[];
    table_name character varying;
    inputstring text;


BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;    


--    COMMON TASKS:

--    Construct geom in device coordinates
    insert_geom := ST_SetSRID(ST_GeomFromText(the_geom), srid);

--    Get table coordinates
    schemas_array := current_schemas(FALSE);
    SRID_var := Find_SRID(schemas_array[1]::TEXT, 'om_visit', 'the_geom');

--    Transform from device EPSG to database EPSG
    insert_geom := ST_Transform(insert_geom , SRID_var);

--    Update geometry field
    insert_data := gw_fct_json_object_set_key(insert_data, 'the_geom', insert_geom);

--    Set table name
    table_name = concat('review_', element_type);

    RAISE NOTICE 'Res: % ', insert_data;

--    Get columns names
    SELECT string_agg(quote_ident(key),',') INTO inputstring FROM json_object_keys(insert_data) AS X (key);

--    Perform INSERT
    EXECUTE 'INSERT INTO '|| quote_ident(table_name) || '(' || inputstring || ') SELECT ' ||  inputstring || 
        ' FROM json_populate_record( NULL::' || quote_ident(table_name) || ' , $1)'
    USING insert_data;


--    ESPECIFIC TASKS:
    IF element_type = 'arc' THEN

    ELSIF element_type = 'node' THEN

    ELSIF element_type = 'gully' THEN

    ELSIF element_type = 'connect' THEN
    
    END IF;

--    Control NULL's
    id_insert := COALESCE(id_insert, '');


--    Return
    RETURN ('{"status":"Accepted"' ||
        '}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

