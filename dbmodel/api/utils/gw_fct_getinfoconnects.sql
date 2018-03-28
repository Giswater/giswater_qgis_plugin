CREATE OR REPLACE FUNCTION "arbrat_viari"."gw_fct_getinfoconnects"(element_type varchar, id varchar, device int4) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_connects json;
    query_result_node_1 json;
    query_result_node_2 json;
    query_result_upstream json;
    query_result_downstream json;

BEGIN


--    Set search path to local schema
    SET search_path = "arbrat_viari", public;


--    Query depends on element type
    IF element_type = 'arc' THEN

--        Get query for connects
        EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = ''v_ui_arc_x_connection'' AND device = $1'
            INTO query_result
            USING device;

--        Get connects
        EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE ' || quote_ident( element_type || '_id') || ' = $1) a'
            INTO query_result_connects
            USING id;

--        Get node_1
        EXECUTE 'SELECT row_to_json(a) FROM (SELECT node_1 AS sys_id, ST_X(node.the_geom) AS sys_x, ST_Y(node.the_geom) AS sys_y FROM arc JOIN node ON (node_1 = node_id) WHERE arc_id = $1) a'
            INTO query_result_node_1
            USING id;

--        Get node_2
        EXECUTE 'SELECT row_to_json(a) FROM (SELECT node_2 AS sys_id, ST_X(node.the_geom) AS sys_x, ST_Y(node.the_geom) AS sys_y FROM arc JOIN node ON (node_2 = node_id) WHERE arc_id = $1) a'
            INTO query_result_node_2
            USING id;

RAISE NOTICE 'Res: % ', query_result_connects;

--        Control NULL's
        query_result_connects := COALESCE(query_result_connects, '{}');
        query_result_node_1 := COALESCE(query_result_node_1, '{}');
        query_result_node_2 := COALESCE(query_result_node_2, '{}');
    
--        Return
        RETURN ('{"status":"Accepted", "table":' || query_result_connects || ', "node1":'|| query_result_node_1 || ', "node2":'|| query_result_node_2 ||'}')::json;

    ELSE

--        Get query for connects upstream
        EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = ''v_ui_node_x_connection_upstream'' AND device = $1'
            INTO query_result
            USING device;

--        Get connects upstream
        EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE ' || quote_ident( element_type || '_id') || ' = $1) a'
            INTO query_result_upstream
            USING id;

--        Get query for connects downstream
        EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = ''v_ui_node_x_connection_downstream'' AND device = $1'
            INTO query_result
            USING device;

--        Get connects downstream
        EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE ' || quote_ident( element_type || '_id') || ' = $1) a'
            INTO query_result_downstream
            USING id;

--        Control NULL's
        query_result_upstream := COALESCE(query_result_upstream, '{}');
        query_result_downstream := COALESCE(query_result_downstream, '{}');
        
--        Return
        RETURN ('{"status":"Accepted"' ||
        ', "upstream":' || query_result_upstream || ', "downstream":'|| query_result_downstream || '}')::json;            
    
    END IF;

--    Error
    RETURN ('{"status":"Failed","error":"error in function gw_fct_getinfoconnects"}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

