/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_upsertmincut"(mincut_id_arg int4, x float8, y float8, srid_arg int4, device int4, insert_data json, p_element_type varchar, id_arg varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    point_geom public.geometry;
    v_geometry public.geometry;
    SRID_var int;
    id_visit int;
    schemas_array name[];
    is_done boolean;
    api_version json;
    p_parameter_type text;
    record_aux record;
    mincut_id integer;
    inputstring text;
    muni_id_var integer;
    streetaxis_id_var character varying(16);
    mincut_class integer;
    current_user_var character varying(30);
    column_name_var varchar;
    column_type_var varchar;
    conflict_text text;
    v_publish_user text;
    v_mincut_class int2;



BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;   
    schemas_array := current_schemas(FALSE);

--    Get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;    

--    Mincut id is an argument
    mincut_id := mincut_id_arg;

--    Get current user
    EXECUTE 'SELECT current_user'
        INTO current_user_var;

--    Harmonize p_element_type
    p_element_type := lower (p_element_type);
    IF RIGHT (p_element_type,1)=':' THEN
        p_element_type := reverse(substring(reverse(p_element_type) from 2 for 99));
    END IF;
    
--    Perform INSERT in case of new mincut
    IF mincut_id ISNULL THEN

        --    Get mincut class
        IF p_element_type='arc' THEN 
            v_mincut_class=1;
        ELSIF p_element_type='node' 
            THEN v_mincut_class=1;
        ELSIF p_element_type='connec' 
            THEN v_mincut_class=2;
        ELSIF p_element_type='hydrometer' 
            THEN v_mincut_class=3;
        END IF;

        -- Construct geom in device coordinates
        point_geom := ST_SetSRID(ST_Point(x, y),SRID_arg);

        -- Get table coordinates
        SRID_var := Find_SRID(schemas_array[1]::TEXT, 'om_visit', 'the_geom');

        -- Transform from device EPSG to database EPSG
        point_geom := ST_Transform(point_geom, SRID_var);

--        Calculate geometry
        IF v_mincut_class=1 THEN
            EXECUTE 'SELECT St_closestPoint(arc.the_geom,$1) FROM SCHEMA_NAME.arc ORDER BY ST_Distance(arc.the_geom, $1) LIMIT 1'
                INTO v_geometry
                USING point_geom;
        ELSE
                v_geometry:= point_geom;
        END IF;    
        
     
        -- Insert mincut
        EXECUTE 'INSERT INTO anl_mincut_result_cat (anl_the_geom) VALUES ($1) RETURNING id'
        USING v_geometry
        INTO mincut_id;

        -- Update state
        insert_data := gw_fct_json_object_set_key(insert_data, 'mincut_state', 0);

    ELSE

        -- Location data is not combo components, the ID's are computed from values

        -- Find municipality ID
        SELECT muni_id INTO muni_id_var FROM ext_municipality WHERE name = insert_data->>'muni_id';

        -- Update municipality value in the JSON
        insert_data := gw_fct_json_object_set_key(insert_data, 'muni_id', muni_id_var);

        -- Find street axis ID
        SELECT ext_streetaxis.id INTO streetaxis_id_var FROM ext_streetaxis WHERE name = insert_data->>'streetaxis_id';

        -- Update streetaxis value in the JSON
        insert_data := gw_fct_json_object_set_key(insert_data, 'streetaxis_id', streetaxis_id_var);


    END IF;

--    Update feature id
    insert_data := gw_fct_json_object_set_key(insert_data, 'anl_feature_id', id_arg);

--    Update feature type
    IF p_element_type = 'hydrometer' THEN
        insert_data := gw_fct_json_object_set_key(insert_data, 'anl_feature_type', 'NODE');
    ELSE
        insert_data := gw_fct_json_object_set_key(insert_data, 'anl_feature_type', upper(p_element_type));
    END IF;

--    Update state: Check start
    IF (insert_data->>'mincut_state')::INT = 0 AND insert_data->>'exec_start' != '' THEN
        insert_data := gw_fct_json_object_set_key(insert_data, 'mincut_state', 1);
    END IF;

--    Update state: Check end
    IF (insert_data->>'mincut_state')::INT != 0 AND insert_data->>'exec_end' != '' THEN
        insert_data := gw_fct_json_object_set_key(insert_data, 'mincut_state', 2);
        insert_data := gw_fct_json_object_set_key(insert_data, 'exec_user', current_user_var);
    END IF;

--    Update class
    IF p_element_type = 'connec' THEN
        mincut_class = 2;
    ELSIF p_element_type = 'hydrometer' THEN
        mincut_class = 3;
    ELSE
        mincut_class = 1;
    END IF;
 
    insert_data := gw_fct_json_object_set_key(insert_data, 'mincut_class', mincut_class);


--    Update user
    insert_data := gw_fct_json_object_set_key(insert_data, 'anl_user', current_user_var);

--    Update element type to catalog
    insert_data := gw_fct_json_object_set_key(insert_data, 'p_element_type', current_user_var);

--    Update reception date
    insert_data := gw_fct_json_object_set_key(insert_data, 'received_date',(insert_data->>'anl_tstamp')::timestamp::date);


--    Get columns names
    SELECT string_agg(quote_ident(key),',') INTO inputstring FROM json_object_keys(insert_data) AS X (key);


--    Perform UPDATE (<9.5)
    FOR column_name_var, column_type_var IN SELECT column_name, data_type FROM information_schema.Columns WHERE table_schema = schemas_array[1]::TEXT AND table_name = 'anl_mincut_result_cat' LOOP
        IF (insert_data->>column_name_var) IS NOT NULL THEN
            EXECUTE 'UPDATE anl_mincut_result_cat SET ' || quote_ident(column_name_var) || ' = $1::' || column_type_var || ' WHERE anl_mincut_result_cat.id = $2'
            USING insert_data->>column_name_var, mincut_id;
        END IF;
    END LOOP;

--    Update the selector
    IF (SELECT COUNT(*) FROM anl_mincut_result_selector WHERE cur_user = current_user_var) > 0 THEN
        UPDATE anl_mincut_result_selector SET result_id = mincut_id WHERE cur_user = current_user_var;
    ELSE
        INSERT INTO anl_mincut_result_selector(cur_user, result_id) VALUES (current_user_var, mincut_id);
    END IF;

--    Update the selector for publish_user
    -- Get publish user
    SELECT value FROM config_param_system WHERE parameter='api_publish_user' 
        INTO v_publish_user;
    IF (SELECT COUNT(*) FROM anl_mincut_result_selector WHERE cur_user = v_publish_user AND result_id=mincut_id) = 0 THEN
        INSERT INTO anl_mincut_result_selector(cur_user, result_id) VALUES (v_publish_user, mincut_id);
    END IF;

--    SPECIFIC TASKS
    IF mincut_id_arg ISNULL THEN
        IF p_element_type = 'connec' THEN
            INSERT INTO anl_mincut_result_connec(result_id, connec_id, the_geom) VALUES (mincut_id, id_arg, point_geom);
        ELSIF p_element_type = 'hydrometer' THEN
            INSERT INTO anl_mincut_result_hydrometer(result_id, hydrometer_id) VALUES (mincut_id, id_arg);
        ELSE
            RAISE NOTICE 'Call to gw_fct_mincut: %, %, %, %', id_arg, p_element_type, mincut_id, current_user_var;
            conflict_text := gw_fct_mincut(id_arg, p_element_type, mincut_id, current_user_var);
            RAISE NOTICE 'MinCut: %', conflict_text;
        END IF;
    END IF;


--    Control NULL's
--    mincut_id := COALESCE(mincut_id, '');


--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "mincut_id":' || mincut_id ||
        '}')::json;

--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
--    RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

