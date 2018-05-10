CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_upsertvisit"(x float8, y float8, srid_arg int4, element_type varchar, id varchar, device int4, visitcat_id_aux int4, cur_user varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result_cat_visits json;
    query_result_def_visit varchar;
    query_result_def_code varchar;
    query_result_parameter_type json;
    query_result_def_parameter_type json;
    query_result_parameter_id_options json;
    query_result_parameter_id varchar;
    point_geom geometry;
    SRID_var int;
    id_visit int;
    schemas_array name[];
    is_done boolean;
    api_version json;


BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;   

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;    


--    COMMON TASKS:

--    Get visits catalog
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (SELECT id::TEXT, name FROM om_visit_cat) a' INTO query_result_cat_visits;

--    Get user default
    EXECUTE 'SELECT value FROM config_param_user WHERE parameter=''visicat_vdefault'' AND cur_user=$1 LIMIT 1' USING cur_user INTO query_result_def_visit;

--    Get parameter type
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (SELECT DISTINCT parameter_type AS "id", parameter_type AS "name" FROM om_visit_parameter) a' INTO query_result_parameter_type;

--    Get default parameter type
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (SELECT value AS parameter_type FROM config_param_user 
        WHERE parameter = ''om_param_type_vdefault'' AND cur_user=$1) a' USING cur_user 
        INTO query_result_def_parameter_type;

--    Get parameter id
    EXECUTE 'SELECT array_to_json(array_agg(json_data)) FROM (SELECT row_to_json(t) AS json_data FROM (SELECT id, descript AS "name" FROM om_visit_parameter 
    WHERE parameter_type = (SELECT value FROM config_param_user WHERE parameter = ''om_param_type_vdefault'' AND cur_user=$1) 
        AND LOWER(feature_type) = $2) t  ) r'  
    USING cur_user, element_type
    INTO query_result_parameter_id_options;

RAISE NOTICE 'Res: % ', query_result_parameter_id_options;

--    INSERT VISIT:

--    Construct geom in device coordinates
    point_geom := ST_SetSRID(ST_Point(X, Y),SRID_arg);

--    Get table coordinates
    schemas_array := current_schemas(FALSE);
    SRID_var := Find_SRID(schemas_array[1]::TEXT, 'om_visit', 'the_geom');

--    Transform from device EPSG to database EPSG
    point_geom := ST_Transform(point_geom, SRID_var);

--    Check if INSERT or UPDATE
    EXECUTE 'SELECT visit_id, is_done, ext_code FROM ' || quote_ident('om_visit_x_' || element_type) || ' JOIN om_visit ON (om_visit.id = visit_id) 
        WHERE ' || quote_ident(element_type || '_id') || ' = ' || quote_literal(id) || ' AND startdate::date=now()::date ORDER BY startdate DESC LIMIT 1'
        INTO id_visit, is_done, query_result_def_code;


        

--    Perform INSERT in case of new visit
    IF id_visit ISNULL THEN

--        Get visit code
        EXECUTE 'SELECT value FROM config_param_user WHERE parameter=''codi_vdefault'' AND cur_user=$1 LIMIT 1' USING cur_user 
            INTO query_result_def_code;

--        Insert visit
        EXECUTE 'INSERT INTO om_visit (visitcat_id,the_geom) VALUES ($1, $2) RETURNING id'
            USING query_result_def_visit::INT, point_geom
            INTO id_visit;
            
--        Insert into element visit
        EXECUTE 'INSERT INTO ' || quote_ident('om_visit_x_' || element_type) || ' (visit_id,' || quote_ident( element_type || '_id') || ') VALUES ($1, $2)'
            USING id_visit, id;    
            is_done := FALSE;        

    END IF;



--    ESPECIFIC TASKS:
    IF element_type = 'arc' THEN

    ELSIF element_type = 'node' THEN

    ELSIF element_type = 'gully' THEN

    ELSIF element_type = 'connect' THEN
    
    END IF;


--    Control NULL's
    query_result_def_code := COALESCE(query_result_def_code, '');
    is_done := COALESCE(is_done, FALSE);
    query_result_parameter_id_options := COALESCE(query_result_parameter_id_options, '[]');



--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||'"' ||
        ', "visicat_id_options":' || query_result_cat_visits || 
        ', "visicat_id":"' || query_result_def_visit || '"' ||
        ', "parameter_type_options":' || query_result_parameter_type ||
        ', "parameter_type":' || query_result_def_parameter_type ||  
        ', "parameter_id_options":' || query_result_parameter_id_options ||
        ', "visit_id":' || id_visit ||
        ', "visit_isDone":' || is_done ||
        ', "ext_code":"' || query_result_def_code || '"' ||
        '}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

