/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getmincut"(x float8, y float8, srid_arg int4, mincut_id_arg int4, device int4, p_element_type varchar, lang varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    form_info json;
    formTabs text;
    api_version json;
    json_array json[];
    mincut_data record;
    point_geom public.geometry;
    SRID_var int;
    id_visit int;
    schemas_array name[];
    v_geometry json;
    address_array text[];
    aux_combo text[];
    aux_combo_id text[];
    aux_combo_name text[];    
    tabAux json;
    current_user_var character varying(30);
    v_mincut_id text=mincut_id_arg;
    
--      Value defaults
    v_mincut_new_state int2;
    v_mincut_new_type text;
    v_mincut_new_cause text;
    v_mincut_new_assigned text;
    v_publish_user text;
    v_mincut_class int2;
    v_mincut_class_name text;
    v_mincut_valve_layer text;
    v_mincut_valve_layer_json json;

    v_tab1 boolean;
    v_tab2 boolean=false;
    v_tab3 boolean;
    v_mincut_state int2;

    v_state0 boolean = FALSE;
    v_state1 boolean = TRUE;
    v_exec_geom public.geometry;
    v_anl_geom public.geometry;

    v_mincut_street_none text;

    

BEGIN

--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

  
--    Get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--    Get valve layer name
    SELECT ((value::json)->>'mincut_valve_layer') INTO v_mincut_valve_layer FROM config_param_system WHERE parameter='api_mincut_parameters';


--    Get current user
    EXECUTE 'SELECT current_user'
        INTO current_user_var;

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
    
    v_mincut_class_name := (SELECT name FROM anl_mincut_cat_class WHERE id= v_mincut_class);


--    Enable / dissable widgets
    v_mincut_state := (SELECT mincut_state FROM anl_mincut_result_cat WHERE id= mincut_id_arg);
        
    IF v_mincut_state IS NULL OR v_mincut_state=0 THEN
        v_state1=TRUE;
        v_state0=FALSE; 
        v_tab1=TRUE;
        v_tab3=FALSE;
    ELSIF v_mincut_state=1 THEN
        v_state1=FALSE;
        v_state0=FALSE;
        v_tab1=FALSE;
        v_tab3=TRUE;        
    ELSIF v_mincut_state=2 THEN
        v_state1=TRUE;
        v_state0=TRUE;
        v_tab1=TRUE;
        v_tab3=FALSE;
    END IF;
 
--    New or existing mincut?
    IF mincut_id_arg IS NOT NULL THEN

--        Update the selector
        --current user
        IF (SELECT COUNT(*) FROM anl_mincut_result_selector WHERE cur_user = current_user_var) > 0 THEN
            UPDATE anl_mincut_result_selector SET result_id = mincut_id_arg WHERE cur_user = current_user_var;
        ELSE
            INSERT INTO anl_mincut_result_selector(cur_user, result_id) VALUES (current_user_var, mincut_id_arg);
        END IF;
        
        -- publish user
        SELECT value FROM config_param_system WHERE parameter='api_publish_user' 
            INTO v_publish_user;
        IF (SELECT COUNT (*) FROM anl_mincut_result_selector WHERE cur_user = v_publish_user AND result_id=mincut_id_arg) = 0 THEN
            INSERT INTO anl_mincut_result_selector(cur_user, result_id) VALUES (v_publish_user, mincut_id_arg);
        END IF;
        
--        Get existing mincut data
        EXECUTE 'SELECT 
            id AS "mincut_id",
            work_order,
            mincut_state::TEXT,                        
            mincut_type::TEXT,            
            anl_cause::TEXT,            
            anl_tstamp,
            forecast_start::timestamp(0),
            forecast_end::timestamp(0),
            assigned_to::TEXT,
            anl_descript,
            exec_start::timestamp(0),
            exec_descript,
            exec_end::timestamp(0),
            anl_the_geom,
            ext_municipality.name AS "muni_id",
            postcode,
            streetaxis_id,
            postnumber,
            exec_user,
            exec_descript,
            exec_the_geom,
            exec_from_plot,
            exec_depth,
            exec_appropiate                
            FROM anl_mincut_result_cat LEFT JOIN ext_municipality USING (muni_id) WHERE id = $1'
        INTO mincut_data
        USING mincut_id_arg; 
        
        -- Return geometry
        EXECUTE 'SELECT row_to_json(row) FROM (SELECT St_AsText(St_simplify($1,0)))row'
            INTO v_geometry
            USING mincut_data.anl_the_geom;

--        Mincut fields
        json_array[0] := gw_fct_createwidgetjson('mincut_id', 'mincut_id', 'text', 'string', '', TRUE, mincut_data.mincut_id::TEXT);
        json_array[1] := gw_fct_createwidgetjson('WorkOrder', 'work_order', 'text', 'string', '', v_state0, mincut_data.work_order);
        json_array[2] := gw_fct_createcombojson('State', 'mincut_state', 'combo', 'string', '', TRUE, 'anl_mincut_cat_state','id','name',mincut_data.mincut_state);
        json_array[3] := gw_fct_createcombojson('Type', 'mincut_type', 'combo', 'string', '', v_state0, 'anl_mincut_cat_type','id','id',mincut_data.mincut_type);
        json_array[4] := gw_fct_createcombojson('Cause', 'anl_cause', 'combo', 'string', '', v_state0, 'anl_mincut_cat_cause','id','id',mincut_data.anl_cause);
        json_array[5] := gw_fct_createcombojson('Assigned to', 'assigned_to', 'combo', 'string', '', v_state0, 'cat_users','id','name',mincut_data.assigned_to);
        json_array[6] := gw_fct_createwidgetjson('Description', 'anl_descript', 'textarea', 'string', '', v_state0, mincut_data.anl_descript);
        json_array[7] := gw_fct_createwidgetjson('Dates', 'divider', 'formDivider', 'string', NULL, TRUE, NULL);
        json_array[8] := gw_fct_createwidgetjson('Received', 'anl_tstamp', 'datepickertime', 'date', '', v_state0, mincut_data.anl_tstamp::TEXT);
        json_array[9] := gw_fct_createwidgetjson('Predicted start', 'forecast_start', 'datepickertime', 'date', '', v_state0, mincut_data.forecast_start::TEXT);
        json_array[10] := gw_fct_createwidgetjson('Predicted end', 'forecast_end', 'datepickertime', 'date', '', v_state0, mincut_data.forecast_end::TEXT);

        json_array[11] := gw_fct_createwidgetjson('Iniciar procediment de tall', 'gw_fct_setmincut_start', 'button', 'string', '', FALSE,'');
        json_array[12] := gw_fct_createwidgetjson('Data inici', 'exec_start', 'datepickertime', 'date', '', v_state1, mincut_data.exec_start::TEXT);
        json_array[13] := gw_fct_createwidgetjson(NULL, 'divider', 'formDivider', 'string', NULL, v_state1, NULL);
        json_array[14] := gw_fct_createwidgetjson('Descripció', 'exec_descript', 'textarea', 'string', '', v_state1, mincut_data.exec_descript);
        json_array[15] := gw_fct_createwidgetjson('Localització real del tall', 'gw_fct_setcoordinates', 'button', 'string', '', v_state1,'');        
        json_array[16] := gw_fct_createwidgetjson('Distància', 'exec_from_plot', 'text', 'string', '', v_state1, mincut_data.exec_from_plot::TEXT);
        json_array[17] := gw_fct_createwidgetjson('Profunditat', 'exec_depth', 'text', 'string', '', v_state1, mincut_data.exec_depth::TEXT);
        json_array[18] := gw_fct_createwidgetjson('Operari', 'exec_user', 'text', 'string', '', v_state1, mincut_data.exec_user::TEXT);
        json_array[19] := gw_fct_createwidgetjson('Apropiat', 'exec_appropiate', 'check', 'string', '', v_state1, mincut_data.exec_appropiate::TEXT);
        json_array[20] := gw_fct_createwidgetjson(NULL, 'divider', 'formDivider', 'string', NULL, FALSE, NULL);
        json_array[21] := gw_fct_createwidgetjson('Data Final', 'exec_end', 'datepickertime', 'date', '', v_state1, mincut_data.exec_end::TEXT);
        json_array[22] := gw_fct_createwidgetjson('Finalitzar procediment de tall', 'gw_fct_setmincut_end', 'button', 'string', '', v_state1,'');

        json_array[25] := gw_fct_createwidgetjson('Municipality', 'muni_id', 'text', 'string', '', TRUE, mincut_data.muni_id);
        json_array[26] := gw_fct_createwidgetjson('Postcode', 'postcode', 'text', 'string', '', TRUE, mincut_data.postcode);
        json_array[27] := gw_fct_createwidgetjson('Street axis', 'streetaxis_id', 'text', 'string', '', TRUE, mincut_data.streetaxis_id);
        json_array[28] := gw_fct_createwidgetjson('Postnumber', 'postnumber', 'text', 'string', '', TRUE, mincut_data.postnumber);

--        Returning geometry
        IF v_mincut_class=1 THEN
            v_exec_geom := (SELECT exec_the_geom FROM anl_mincut_result_cat WHERE id= v_mincut_id::integer);
            v_anl_geom := (SELECT anl_the_geom FROM anl_mincut_result_cat WHERE id= v_mincut_id::integer);

            IF  v_exec_geom IS NOT NULL THEN 
                EXECUTE 'SELECT row_to_json(row) FROM (SELECT St_AsText($1))row'
                INTO v_geometry
                USING v_exec_geom;
            ELSE
                EXECUTE 'SELECT row_to_json(row) FROM (SELECT St_AsText($1))row'
                    INTO v_geometry
                    USING v_anl_geom;
            END IF;        
        END IF;    


    ELSE    -- NEW MINCUT

--        Construct geom in device coordinates
        point_geom := ST_SetSRID(ST_Point(X, Y),SRID_arg);

--        Get table coordinates
        schemas_array := current_schemas(FALSE);
        SRID_var := Find_SRID(schemas_array[1]::TEXT, 'om_visit', 'the_geom');

--        Transform from device EPSG to database EPSG
        point_geom := ST_Transform(point_geom, SRID_var);


--        Return geometry
        IF v_mincut_class=1 THEN
            EXECUTE 'SELECT row_to_json(row) 
                FROM (SELECT St_AsText(St_simplify(St_closestPoint(arc.the_geom,$1),0)) FROM SCHEMA_NAME.arc ORDER BY ST_Distance(arc.the_geom, $1) LIMIT 1)row'
                INTO v_geometry
                USING point_geom;
        ELSE
                v_geometry:= to_json(point_geom);
        END IF;        


--        Get default values
        SELECT ((value::json)->>'mincut_state') INTO v_mincut_new_state FROM config_param_system WHERE parameter='api_mincut_new_vdef';
        SELECT ((value::json)->>'mincut_type') INTO v_mincut_new_type FROM config_param_system WHERE parameter='api_mincut_new_vdef';
        SELECT ((value::json)->>'anl_cause') INTO v_mincut_new_cause FROM config_param_system WHERE parameter='api_mincut_new_vdef';
        SELECT ((value::json)->>'assigned_to') INTO v_mincut_new_assigned FROM config_param_system WHERE parameter='api_mincut_new_vdef';
        SELECT ((value::json)->>'street_none') INTO v_mincut_street_none FROM config_param_system WHERE parameter='api_mincut_new_vdef';

        v_mincut_street_none='1-9110C';

--        Return defaults
        json_array[0] := gw_fct_createwidgetjson('mincut_id', 'mincut_id', 'text', 'string', '', TRUE, '');
        json_array[1] := gw_fct_createwidgetjson('WorkOrder', 'work_order', 'text', 'string', '', v_state0, '');
        json_array[2] := gw_fct_createcombojson('State', 'mincut_state', 'combo', 'string', '', v_state0, 'anl_mincut_cat_state','id','name',v_mincut_new_state::TEXT);
        json_array[3] := gw_fct_createcombojson('Type', 'mincut_type', 'combo', 'string', '', v_state0, 'anl_mincut_cat_type','id','id',v_mincut_new_type::TEXT);
        json_array[4] := gw_fct_createcombojson('Cause', 'anl_cause', 'combo', 'string', '', v_state0, 'anl_mincut_cat_cause','id','id',v_mincut_new_cause);
        json_array[5] := gw_fct_createcombojson('Assignat a', 'assigned_to', 'combo', 'string', '', v_state0, 'cat_users','id','name',v_mincut_new_assigned);
        json_array[6] := gw_fct_createwidgetjson('Descripció', 'anl_descript', 'textarea', 'string', '', v_state0, '');        
        json_array[7] := gw_fct_createwidgetjson('Dates', 'divider', 'formDivider', 'string', NULL, TRUE, NULL);
        json_array[8] := gw_fct_createwidgetjson('Rebut', 'anl_tstamp', 'datepickertime', 'date', '', v_state0, now()::timestamp(0)::TEXT);
        json_array[9] := gw_fct_createwidgetjson('Inici previst', 'forecast_start', 'datepickertime', 'date', '', v_state0, NULL);
        json_array[10] := gw_fct_createwidgetjson('Final previst', 'forecast_end', 'datepickertime', 'date', '', v_state0, NULL);

        json_array[11] := gw_fct_createwidgetjson('Iniciar procediment de tall', 'gw_fct_setmincut_start', 'button', 'string', '', FALSE,'');
        json_array[12] := gw_fct_createwidgetjson('Data inici', 'exec_start', 'datepickertime', 'date', '', v_state1, NULL);
        json_array[13] := gw_fct_createwidgetjson(NULL, 'divider', 'formDivider', 'string', NULL, FALSE, NULL);
        json_array[14] := gw_fct_createwidgetjson('Descripció', 'exec_descript', 'textarea', 'string', '', v_state1, '');
        json_array[15] := gw_fct_createwidgetjson('Localització real del tall', 'gw_fct_setcoordinates', 'button', 'string', '', v_state1,'');
        json_array[16] := gw_fct_createwidgetjson('Distància', 'exec_from_plot', 'text', 'string', '', v_state1, '');
        json_array[17] := gw_fct_createwidgetjson('Profunditat', 'exec_depth', 'text', 'string', '', v_state1, '');
        json_array[18] := gw_fct_createwidgetjson('Operari', 'exec_user', 'text', 'string', '', v_state1, '');
        json_array[19] := gw_fct_createwidgetjson('Apropiat', 'exec_appropiate', 'check', 'string', '', v_state1, '');
        json_array[20] := gw_fct_createwidgetjson(NULL, 'divider', 'formDivider', 'string', NULL, FALSE, NULL);
        json_array[21] := gw_fct_createwidgetjson('Data Final', 'exec_end', 'datepickertime', 'date', '', v_state1, NULL);
        json_array[22] := gw_fct_createwidgetjson('Finalitzar procediment de tall', 'gw_fct_setmincut_end', 'button', 'string', '', v_state1,'');


--        Get location combos searching the address
        EXECUTE 'SELECT array_agg(row.id) FROM (SELECT id FROM ext_address WHERE ST_DWithin(the_geom, $1, 200) ORDER BY ST_distance (the_geom,$1) ASC LIMIT 5) row'
        INTO address_array
        USING point_geom;

        IF address_array IS NULL THEN
            EXECUTE 'SELECT array_agg(row.id) FROM (SELECT id FROM ext_address) row'
                INTO address_array
                USING point_geom;
        END IF;

--        Get municipality
        EXECUTE 'SELECT array_agg(row.name) FROM (SELECT DISTINCT ext_municipality.name FROM ext_address JOIN ext_municipality USING (muni_id) WHERE id = ANY($1)) row'
        INTO aux_combo_name
        USING address_array;
        EXECUTE 'SELECT array_agg(row.muni_id) FROM (SELECT DISTINCT ext_municipality.muni_id FROM ext_address JOIN ext_municipality USING (muni_id) WHERE id = ANY($1)) row'
        INTO aux_combo_id
        USING address_array;

--        Construc the JSON
        json_array[25] := json_build_object('label', 'Municipality', 'name', 'muni_id', 'type', 'combo', 'dataType', 'string', 
                        'disabled', FALSE, 'tab', 'location', 
                        'comboNames', array_to_json(aux_combo_name),
                        'comboIds', array_to_json(aux_combo_id), 
                        'selectedId', aux_combo_id[1]::TEXT);

        json_array[26] := gw_fct_createwidgetjson('Postcode', 'postcode', 'text', 'string', '', FALSE, '');
        json_array[27] := gw_fct_createwidgetjson('Street axis', 'streetaxis_id', 'text', 'string', '', FALSE, '');


--        Get postcode
        EXECUTE 'SELECT array_agg(row.postcode) FROM (SELECT DISTINCT postcode FROM ext_address WHERE id = ANY($1)) row'
        INTO aux_combo_name
        USING address_array;

--        Construc the JSON
        json_array[26] := json_build_object('label', 'PostCode', 'name', 'postcode', 'type', 'combo', 'dataType', 'string', 
                        'disabled', FALSE, 'tab', 'location', 
                        'comboNames', array_to_json(aux_combo_name),
                        'comboIds', array_to_json(aux_combo_name), 
                        'selectedId', aux_combo_name[1]::TEXT
                        );                        
--        Get street
        EXECUTE 'SELECT array_agg(row.streetaxis_id) FROM (SELECT $2::text AS streetaxis_id UNION SELECT DISTINCT streetaxis_id FROM ext_address WHERE id = ANY($1)) row'
            INTO aux_combo_id
            USING address_array, v_mincut_street_none;        

        EXECUTE 'SELECT array_agg(row.name) FROM (SELECT DISTINCT ext_streetaxis.name FROM ext_address JOIN ext_streetaxis ON 
            (streetaxis_id = ext_streetaxis.id) WHERE ext_address.id = ANY($1)) row'
            INTO aux_combo_name
            USING address_array;

--        Construc the JSON
        json_array[27] := json_build_object('label', 'Street_axis', 'name', 'streetaxis_id', 'type', 'combo', 'dataType', 'string', 
                        'disabled', FALSE, 'tab', 'location', 
                        'comboNames', array_to_json(aux_combo_name),
                        'comboIds', array_to_json(aux_combo_id), 
                        'selectedId', aux_combo_id[1]
                        );

--        Get postnumber
        EXECUTE 'SELECT array_agg(row.postnumber) FROM (SELECT DISTINCT postnumber FROM ext_address WHERE id = ANY($1)) row'
        INTO aux_combo_name
        USING address_array;

        json_array[28] := gw_fct_createwidgetjson('Postnumber', 'postnumber', 'text', 'string', '', FALSE, '');



    END IF;
    
--    Create tabs array
    formTabs := '[';

--    General tab
    tabAux := json_build_object('tabName','Type', 'tabLabel','General','tabText','Type','active',v_tab1);
    tabAux := gw_fct_json_object_set_key(tabAux, 'fields', array_to_json(json_array[0:10]));
    formTabs := formTabs || tabAux::text;

--    Location tab
    tabAux := json_build_object('tabName','Location','tabLabel','Adreça','tabText','Location','active',v_tab2);
    tabAux := gw_fct_json_object_set_key(tabAux, 'fields', array_to_json(json_array[25:28]));
    formTabs := formTabs || ',' || tabAux::text;

--    Exec tab
    tabAux := json_build_object('tabName','Dates', 'tabLabel','Execució','tabText','Dates','active',v_tab3);
    tabAux := gw_fct_json_object_set_key(tabAux, 'fields', array_to_json(json_array[11:22]));
    formTabs := formTabs || ',' || tabAux::text;

--    Finish the construction of formtabs
    formTabs := formtabs ||']';

--    Create new form for mincut
        form_info := json_build_object('formId','F41','formName',upper(v_mincut_class_name));    
        
--    Convert mincut_valve_layer
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT $1 as layer_table_name) row'
        INTO v_mincut_valve_layer_json
        USING v_mincut_valve_layer;

    IF v_mincut_id IS NULL THEN
        v_mincut_id='FALSE';
    END IF;
    
--    Control NULL's
    formTabs := COALESCE(formTabs, '[]');
    api_version := COALESCE(api_version, '{}');
    form_info := COALESCE(form_info, '{}');
     v_geometry := COALESCE(v_geometry, '{}');
     v_mincut_valve_layer_json := COALESCE(v_mincut_valve_layer_json, '{}');
  
--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "formInfo":' || form_info ||
        ', "formTabs":' || formTabs ||
        ', "geometry":' || v_geometry ||
        ', "mincut_id":"' || v_mincut_id ||'"'||
        ', "mincutValveLayer": ' ||v_mincut_valve_layer_json ||
        '}')::json;

--    Exception handling
 --   EXCEPTION WHEN OTHERS THEN 
   --     RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

