CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getreview"(id int8, element_type varchar, lang varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    form_data json;
    review_data record;
    review_data_json json;
    api_version json;


BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--    Get event data


--    ESPECIFIC TASKS:
    IF element_type = 'arc' THEN
    
        SELECT arc_id AS sys_id, y1, y2, arc_type, matcat_id, shape, geom1, geom2, annotation, observ, field_checked INTO review_data FROM review_arc WHERE arc_id = id;
        
    ELSIF element_type = 'node' THEN

        SELECT node_id AS sys_id, top_elev, ymax, node_type, matcat_id, shape, geom1, geom2, annotation, observ, field_checked INTO review_data FROM review_node WHERE node_id = id;

    ELSIF element_type = 'gully' THEN

        SELECT connec_id AS sys_id, y1, y2, arc_type, matcat_id, shape, geom1, geom2, annotation, observ, field_checked INTO review_data FROM review_connec WHERE connec_id = id;

    ELSIF element_type = 'connec' THEN

        SELECT gully_id AS sys_id, top_elev, ymax, sandbox, matcat_id, gratecat_id, units, groove, siphon, connec_matcat_id, shape, geom1, geom2, featurecat_id, feature_id, annotation, observ, field_checked INTO review_data FROM review_gully WHERE gully_id = id;
    
    END IF;


    review_data_json := row_to_json(review_data);

--    Get form data
    form_data := gw_fct_getreviewform(element_type, lang);


--    Control NULL's
    review_data_json := COALESCE(review_data_json, '{}');
    form_data := COALESCE(form_data, '{}');

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "review_data":' || review_data_json || 
        ', "form_data":' || form_data ||
        '}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;



END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

