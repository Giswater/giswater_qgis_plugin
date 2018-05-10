
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getinfoconnects(
    element_type character varying,
    id character varying,
    device integer)
  RETURNS json AS
$BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_connects json;
    query_result_node_1 json;
    query_result_node_2 json;
    query_result_upstream json;
    query_result_downstream json;
    exec_sql text;
    api_version json;


BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;


--    Query depends on element type
    IF element_type = 'arc' THEN

--        Get query for connects
        EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = ''arc_x_connect'' AND device = $1'
            INTO query_result
            USING device;

--        Get connects
        EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE ' || element_type || '_id::text' || ' = $1) a'
            INTO query_result_connects
            USING id;

--        Get node_1
        EXECUTE 'SELECT row_to_json(a) FROM (SELECT node_1 AS sys_id, ST_X(node.the_geom) AS sys_x, ST_Y(node.the_geom) AS sys_y FROM arc JOIN node ON (node_1 = node_id) WHERE arc.arc_id::text = $1) a'
            INTO query_result_node_1
            USING id;

--        Get node_2
        EXECUTE 'SELECT row_to_json(a) FROM (SELECT node_2 AS sys_id, ST_X(node.the_geom) AS sys_x, ST_Y(node.the_geom) AS sys_y FROM arc JOIN node ON (node_2 = node_id) WHERE arc.arc_id::text = $1) a'
            INTO query_result_node_2
            USING id;

--        Control NULL's
        query_result_connects := COALESCE(query_result_connects, '{}');
        query_result_node_1 := COALESCE(query_result_node_1, '{}');
        query_result_node_2 := COALESCE(query_result_node_2, '{}');
    
--        Return
        RETURN ('{"status":"Accepted", "table":' || query_result_connects || ', "node1":'|| query_result_node_1 || ', "node2":'|| query_result_node_2 ||'}')::json;

    ELSE

--        Get query for connects upstream
    
        EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = ''node_x_connect_upstream'' AND device = $1'
            INTO query_result
            USING device;

--        Get connects upstream
    exec_sql :='SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE ' || element_type || '_id::text' || ' = $1) a';
        IF exec_sql IS NOT NULL THEN
        EXECUTE exec_sql 
        INTO query_result_upstream
        USING id;
    END IF;

--        Get query for connects downstream
        EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = ''node_x_connect_downstream'' AND device = $1'
            INTO query_result
            USING device;

--        Get connects downstream
       exec_sql:= 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE ' || element_type || '_id::text' || ' = $1) a';
        IF exec_sql IS NOT NULL THEN
        EXECUTE exec_sql 
        INTO query_result_upstream
        USING id;
    END IF;

--        Control NULL's
        query_result_upstream := COALESCE(query_result_upstream, '{}');
        query_result_downstream := COALESCE(query_result_downstream, '{}');
        
--        Return
        RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||'"' ||
        ', "upstream":' || query_result_upstream || ', "downstream":'|| query_result_downstream || '}')::json;            
    
    END IF;

--    Error
    RETURN ('{"status":"Failed","error":"error in function gw_fct_getinfoconnects", "apiVersion":'|| api_version ||'}')::json;

--    Exception handling
 --   EXCEPTION WHEN OTHERS THEN 
  --     RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
