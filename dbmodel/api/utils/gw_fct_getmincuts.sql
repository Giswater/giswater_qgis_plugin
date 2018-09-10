/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getmincuts"(mincut_data json, device int4, lang varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_mincuts json;
    api_version json;
    json_array json[];
    tabAux json;
    form_info json;
    formTabs text;
    rec_fields record;

    v_tab text;
    v_tab1 boolean=true;
    v_tab2 boolean=false;
    v_tab3 boolean=false;
    v_muni_id integer;
    v_class_id integer;
    v_workorder text;
    
BEGIN

--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    
--    get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;
        
--      Get values form json
    v_tab := mincut_data->>'tab';
    v_muni_id := mincut_data->>'mincut_muni';
    v_class_id := mincut_data->>'mincut_class';
    v_workorder := mincut_data->>'mincut_workorder';

--     Set tab
    IF v_tab IS NOT NULL THEN
        
        IF v_tab='ongoing' THEN 
            v_tab1 := false;
            v_tab2 := true;
            v_tab3 := false;

        ELSIF v_tab='executed' THEN 
            v_tab1 := false;
            v_tab2 := false;
            v_tab3 := true;
        END IF;
    
    ELSIF (SELECT id FROM anl_mincut_result_cat WHERE exec_user=current_user AND mincut_state=1 LIMIT 1) IS NOT NULL THEN
        v_tab1 := false;
        v_tab2 := true;
        v_tab3 := false;
    END IF;

--    Get municipallity & class combo values
    IF (SELECT muni_id FROM ext_municipality where muni_id = v_muni_id) IS NULL THEN 
        v_muni_id :=(SELECT muni_id FROM ext_municipality LIMIT 1);
    END IF;

    IF (SELECT id FROM anl_mincut_cat_class where id = v_class_id) IS NULL THEN 
        v_class_id :=(SELECT id FROM anl_mincut_cat_class LIMIT 1);
    END IF;
    

--    Create tabs array
    formTabs := '[';

       
-- PLANIFIED TAB
-------------------------------

--    Get query for mincut
    query_result := 'SELECT anl_mincut_result_cat.id AS "sys_id",  forecast_start::date as "Data planificada", anl_mincut_result_cat.id as "Mincut Id", work_order AS "Expedient", 
            ext_municipality.name AS "Municipi", ext_streetaxis.name AS "Via", ST_X(anl_the_geom) AS sys_x, ST_Y(anl_the_geom) AS sys_y, lower(anl_feature_type) AS sys_id_name
            FROM anl_mincut_result_cat LEFT JOIN ext_municipality USING (muni_id) LEFT JOIN ext_streetaxis ON (streetaxis_id = ext_streetaxis.id)
            WHERE mincut_state=0 AND ext_municipality.muni_id = ' || v_muni_id|| ' AND mincut_class = ' || v_class_id;

    raise notice 'v_workorder %', v_workorder;

--     Workorder
    IF v_workorder IS NOT NULL THEN 
        query_result = query_result || ' AND work_order= '''||v_workorder||'''';
    END IF;


--     Add order 
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' ORDER BY 1 desc) a'
        INTO query_result_mincuts;

--    Control NULL's
    query_result_mincuts := COALESCE(query_result_mincuts, '{}');
        
--    Form controls
    -- create municipality combo
    SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F45' AND name='mincut_muni';
    json_array[0] := gw_fct_createcombojson(rec_fields.label, rec_fields.name, 'combo', 'string', '', FALSE, 'ext_municipality','muni_id','name',v_muni_id::text);
    
    -- create class combo
    SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F45' AND name='mincut_class';
    json_array[1] := gw_fct_createcombojson(rec_fields.label, rec_fields.name, 'combo', 'string', '', FALSE, 'anl_mincut_cat_class','id','name',v_class_id::text);

    -- Create workorder search field
    SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F45' AND name='mincut_workorder';
    json_array[2] := json_build_object('label',rec_fields.label, 'name', 'mincut_workorder', 'type','typeahead','dataType','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
        
    -- Create widget fivider
    json_array[3] := gw_fct_createwidgetjson(NULL, 'divider', 'formDivider', 'string', NULL, TRUE, NULL);

    -- Create array of results
    json_array[4] := json_build_object('label', 'Llistat talls planificats', 'active', 1, 'name', 'talls', 'type', 'list', 'dataType', 'string','disabled', TRUE, 'value', query_result_mincuts);

    -- State tab
    tabAux := json_build_object('tabName','planified','tabLabel','Planificats','tabText','','active',v_tab1);
    tabAux := gw_fct_json_object_set_key(tabAux, 'fields', array_to_json(json_array[0:4]));
    formTabs := formTabs || tabAux::text;



-- ON GOING TAB
-------------------------------

    json_array = null;
    
--    Get query for mincut
    query_result := 'SELECT anl_mincut_result_cat.id AS "sys_id",  exec_start::timestamp(0) as "Data inici", anl_mincut_result_cat.id as "Mincut Id", work_order AS "Expedient", 
            ext_municipality.name AS "Municipi", ext_streetaxis.name AS "Via", ST_X(anl_the_geom) AS sys_x, ST_Y(anl_the_geom) AS sys_y, lower(anl_feature_type) AS sys_id_name, exec_user AS "Operari"
            FROM anl_mincut_result_cat LEFT JOIN ext_municipality USING (muni_id) LEFT JOIN ext_streetaxis ON (streetaxis_id = ext_streetaxis.id)
            LEFT JOIN (VALUES (current_user, 1)) AS x(value, order_number) ON anl_mincut_result_cat.exec_user = x.value
            WHERE mincut_state=1 AND ext_municipality.muni_id = ' || v_muni_id|| ' AND mincut_class = ' || v_class_id;
            
--     Workorder
    IF v_workorder IS NOT NULL THEN 
        query_result = query_result || ' AND work_order= '''||v_workorder||'''';
    END IF;

--     Add order 
    query_result := query_result || ' ORDER BY x.order_number, 2 desc';

--    Get mincuts with just date filters
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' ) a'
        INTO query_result_mincuts;

--    Control NULL's
    query_result_mincuts := COALESCE(query_result_mincuts, '{}');
        
--    Form controls
    -- create municipality combo
    SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F45' AND name='mincut_muni';
    json_array[0] := gw_fct_createcombojson(rec_fields.label, rec_fields.name, 'combo', 'string', '', FALSE, 'ext_municipality','muni_id','name',v_muni_id::text);
    
    -- create class combo
    SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F45' AND name='mincut_class';
    json_array[1] := gw_fct_createcombojson(rec_fields.label, rec_fields.name, 'combo', 'string', '', FALSE, 'anl_mincut_cat_class','id','name',v_class_id::text);

    -- Create workorder search field
    SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F45' AND name='mincut_workorder';
    json_array[2] := json_build_object('label',rec_fields.label, 'name', 'mincut_workorder', 'type','typeahead','dataType','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
        
    -- Create widget fivider
    json_array[3] := gw_fct_createwidgetjson(NULL, 'divider', 'formDivider', 'string', NULL, TRUE, NULL);

    -- Create array of results
    json_array[4] := json_build_object('label', 'Llistat talls en execució', 'name', 'talls', 'type', 'list', 'dataType', 'string','disabled', TRUE, 'value', query_result_mincuts);

    -- State tab
    tabAux := json_build_object('tabName','on_going','tabLabel','En curs','tabText','','active',v_tab2);
    tabAux := gw_fct_json_object_set_key(tabAux, 'fields', array_to_json(json_array[0:4]));
    formTabs := formTabs || ',' || tabAux::text;



-- EXECUTED TAB
-------------------------------

    json_array = null;
    
--    Get query for mincut
    query_result := 'SELECT anl_mincut_result_cat.id AS "sys_id",  exec_start::date as "Data execució", anl_mincut_result_cat.id as "Mincut Id", work_order AS "Expedient", 
            ext_municipality.name AS "Municipi", ext_streetaxis.name AS "Via", ST_X(anl_the_geom) AS sys_x, ST_Y(anl_the_geom) AS sys_y, lower(anl_feature_type) AS sys_id_name
            FROM anl_mincut_result_cat LEFT JOIN ext_municipality USING (muni_id) LEFT JOIN ext_streetaxis ON (streetaxis_id = ext_streetaxis.id)
            WHERE mincut_state=2 AND ext_municipality.muni_id = ' || v_muni_id|| ' AND mincut_class = ' || v_class_id;

--     Workorder
    IF v_workorder IS NOT NULL THEN 
        query_result = query_result || ' AND work_order= '''||v_workorder||'''';
    END IF;

--     Add order 
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' ORDER BY 1 desc) a'
        INTO query_result_mincuts;

--    Control NULL's
    query_result_mincuts := COALESCE(query_result_mincuts, '{}');
        
--    Form controls
    -- create municipality combo
    SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F45' AND name='mincut_muni';
    json_array[0] := gw_fct_createcombojson(rec_fields.label, 'mincut_muni', 'combo', 'string', '', FALSE, 'ext_municipality','muni_id','name', v_muni_id::text);
    
    -- create class combo
    SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F45' AND name='mincut_class';
    json_array[1] := gw_fct_createcombojson(rec_fields.label, 'mincut_class', 'combo', 'string', '', FALSE, 'anl_mincut_cat_class','id','name',v_class_id::text);

    -- Create workorder search field
    SELECT * INTO rec_fields FROM config_web_fields WHERE table_id='F45' AND name='mincut_workorder';
    json_array[2] := json_build_object('label',rec_fields.label, 'name', 'mincut_workorder', 'type','typeahead','dataType','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');
        
    -- Create widget fivider
    json_array[3] := gw_fct_createwidgetjson(NULL, 'divider', 'formDivider', 'string', NULL, TRUE, NULL);

    -- Create array of results
    json_array[4] := json_build_object('label', 'Llistat talls finalitzats', 'name', 'talls', 'type', 'list', 'dataType', 'string','disabled', TRUE, 'value', query_result_mincuts);

    -- State tab
    tabAux := json_build_object('tabName','executed','tabLabel','Executats','tabText','','active',v_tab3);
    tabAux := gw_fct_json_object_set_key(tabAux, 'fields', array_to_json(json_array[0:4]));
    formTabs := formTabs || ',' || tabAux::text;
    
    
--Finish the construction of formtabs
-------------------------------------

    formTabs := formtabs ||']';

--    Create new form for mincut
        form_info := json_build_object('formId','F45','formName','MINCUT MANAGER');    


--    Control NULL's
    formTabs := COALESCE(formTabs, '[]');
    api_version := COALESCE(api_version, '{}');


--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "formInfo":'|| form_info ||
        ', "formTabs":' || formTabs ||
        '}')::json;    


--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
--        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

