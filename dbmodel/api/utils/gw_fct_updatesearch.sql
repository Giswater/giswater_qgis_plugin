CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_updatesearch"(search_data json) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    response_json json;
    name_arg varchar;
    id_arg varchar;
    text_arg varchar;
    search_json json;
    tab_arg varchar;
    combo1 json;
    edit1 json;
    id_column varchar;
    catid varchar;
    states varchar[];
    api_version json;
    project_type_aux character varying;

BEGIN

--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--      get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--     get project type
    SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;

    
--    Get tab
    tab_arg := search_data->>'tabName';


-------------------------
--------NETWORK TAB
-------------------------
    
    IF tab_arg = 'network' THEN
    
--    Text to search
    combo1 := search_data->>'type';
    id_arg := combo1->>'id';
    name_arg := combo1->>'name';
    edit1 := search_data->>'code';
    text_arg := concat(edit1->>'text' ,'%');

--    Get id column
    id_column := concat(name_arg, '_id');

--    Catalog name
    catid := concat(name_arg, 'cat_id');

--    Get Ids for type combo
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
        SELECT DISTINCT(t1.code) AS id, ST_X(ST_Centroid(the_geom)) AS sys_x, ST_Y(ST_Centroid(the_geom)) AS sys_y, concat(''ID:'', t1.' || quote_ident(id_column) || ', '' CAT:'', t1.' || quote_ident(catid) || ') AS display_name, ' || quote_literal(id_arg) || ' AS table, ' || quote_literal(id_column) || ' AS id_name 
            FROM ' || quote_ident(id_arg) || ' AS t1 
            WHERE code LIKE ' || quote_literal(text_arg) || ' 
                AND t1.expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user) 
                AND t1.state IN (SELECT state_id FROM selector_state WHERE cur_user = current_user) 
            ORDER BY id LIMIT 10) a'
        INTO response_json;


-------------------------
--------HYDRO TAB
-------------------------

    ELSIF tab_arg = 'hydro' THEN

--    Text to search
    combo1 := search_data->>'exploitation';
    id_arg := combo1->>'id';
    name_arg := combo1->>'name';
    edit1 := search_data->>'hydrometer';
    text_arg := concat(edit1->>'text' ,'%');

--    Get id column
    id_column := concat(name_arg, '_id');

--    Create states list
    IF id_arg ISNULL OR id_arg = '' THEN
        EXECUTE 'SELECT array_agg(state_id) FROM selector_state WHERE cur_user=' || quote_literal(current_user)
        INTO states;
    ELSE
        states := array_append(states, id_arg);
    END IF;

--    Get hydrometer
     EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
         SELECT connec_id AS id, concat(''HYD:'', hydrometer_customer_code, '' CONNEC:'', connec_customer_code, '' ST:'', state) AS display_name, ''v_edit_connec'' AS table
             FROM v_rtc_hydrometer
             WHERE expl_id = $2::INT
                 AND hydrometer_customer_code LIKE ' || quote_literal(text_arg) || '
            ORDER BY hydrometer_customer_code LIMIT 10) a'
         USING states, id_arg
          INTO response_json;              


    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
        SELECT v_rtc_hydrometer.connec_id AS id, ST_X(ST_Centroid(connec.the_geom)) AS sys_x, ST_Y(ST_Centroid(connec.the_geom)) AS sys_y, concat(''HYD:'', hydrometer_customer_code, '' CONNEC:'', connec_customer_code) AS display_name, ''v_edit_connec'' AS table, ''connec_id'' AS id_name
            FROM v_rtc_hydrometer
                JOIN connec ON (connec.connec_id = v_rtc_hydrometer.connec_id)
            WHERE v_rtc_hydrometer.expl_id = $2::INT
                AND hydrometer_customer_code LIKE ' || quote_literal(text_arg) || '
            ORDER BY hydrometer_customer_code LIMIT 10) a'
        USING states, id_arg
         INTO response_json; 


-------------------------
--------WORKCAT TAB
-------------------------

    ELSIF tab_arg = 'workcat' THEN

--    Text to search
    combo1 := search_data->>'workcat';
    id_arg := combo1->>'id';
    name_arg := combo1->>'name';
    edit1 := search_data->>'code';
    text_arg := concat(edit1->>'text' ,'%');

--    Get id column
    id_column := concat(name_arg, '_id');

--    Search in the workcat
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
        SELECT arc_id AS id, ST_X(ST_Centroid(the_geom)) AS sys_x, ST_Y(ST_Centroid(the_geom)) AS sys_y, concat(''ARC ID:'', arc_id, '' CAT:'', arccat_id) AS display_name, ''v_edit_arc'' AS table, ''arc_id'' AS id_name
            FROM arc
            WHERE workcat_id = $1
                AND arc_id LIKE ' || quote_literal(text_arg) || '
        UNION
        SELECT node_id AS id, ST_X(ST_Centroid(the_geom)) AS sys_x, ST_Y(ST_Centroid(the_geom)) AS sys_y, concat(''NODE ID:'', node_id, '' CAT:'', nodecat_id) AS display_name, ''v_edit_node'' AS table, ''node_id'' AS id_name
            FROM node
            WHERE workcat_id = $1
                AND node_id LIKE ' || quote_literal(text_arg) || '        
        UNION
        SELECT connec_id AS id, ST_X(ST_Centroid(the_geom)) AS sys_x, ST_Y(ST_Centroid(the_geom)) AS sys_y, concat(''CONNEC ID:'', connec_id, '' CAT:'', connecat_id) AS display_name, ''v_edit_connec'' AS table, ''connec_id'' AS id_name 
            FROM connec
             WHERE workcat_id = $1
                AND connec_id LIKE ' || quote_literal(text_arg) || ' LIMIT 10) a'
        USING name_arg
         INTO response_json;  

    ELSE

        RETURN ('{"status":"Failed","SQLERR":"Only tab Network, Hydro and WorkCat are available","SQLSTATE":"NULL"}')::json;

    END IF;


--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "data":' || response_json ||    
        '}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

