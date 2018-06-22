CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_get_config"(p_device int4) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    formBasic json;
    formOm json;
    formEdit json;
    formCad json;
    formEpa json;
    formPlan json;    
    formAdmin json;    
    editCode json;
    editCode1 json;
    editCode2 json;
    comboType json;
    comboType1 json;
    comboType2 json;
    comboType3 json;
    formTabs text;
    combo_json json;
    fieldsJson json;
    formSearch json;
    formPsector json;
    api_version json;
    formAdress json;
    rec_tab record;
    v_firsttab boolean;
    v_active boolean;
    fields_array json;
    combo_rows json;
    v_querytext_result text[];
    aux_json json;
    fields json;

BEGIN


-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

-- Create tabs array
    formTabs := '[';

-- basic_tab
-------------------------
    SELECT * INTO rec_tab FROM config_web_tabs WHERE layer_id='F51' AND formtab='tabBasic' ;
    IF rec_tab IS NOT NULL THEN


--todo

    
        
        -- Create network tab form
        formBasic := json_build_object('tabName','network','tabLabel',rec_tab.tablabel, 'active' , true);
        formBasic := gw_fct_json_object_set_key(formBasic, 'fields', fieldsJson);

        -- Create tabs array
        formTabs := formTabs || formBasic::text;

        v_firsttab := TRUE;
        v_active :=FALSE;

    END IF;


-- Om tab
-------------


-- Edit tab
-------------
    

-- Cad tab
------------
    

-- EPA tab
--------------
       

-- Plan tab
--------------


-- Admin tab
--------------
    SELECT * INTO rec_tab FROM config_web_tabs WHERE layer_id='F51' AND formtab='tabAdmin' ;
    IF rec_tab IS NOT NULL THEN
    
    -- Get fields
    EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT field_label, paramater AS field_name, value as field_value sys_api_cat_widgettype_id AS widgettype, 
        sys_api_cat_datatype_id AS datatype ,placeholder, orderby 
        FROM config_param_system WHERE isenabled=TRUE ORDER BY orderby) a'
        INTO fields_array
        USING p_table_id; 
    
    -- Get combo rows
    EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT parameter AS field_name, value AS field_value, sys_api_cat_widgettype_id AS widgettype, 
                sys_api_cat_datatype_id AS datatype, dv_querytext, dv_filterbyfield, orderby 
                FROM config_param_system WHERE isenabled=TRUE ORDER BY orderby) a WHERE widgettype = 2'
    INTO combo_rows
    USING p_table_id, p_device;
    combo_rows := COALESCE(combo_rows, '{}');
        
    -- Update combos
    FOREACH aux_json IN ARRAY combo_rows
    LOOP

        EXECUTE quote_ident(aux_json->>'dv_querytext')
            INTO v_querytext_result;

        -- get id values
        EXECUTE 'SELECT array_to_json(array_agg(SELECT id FROM ('||querytext_result'||) ORDER BY idval)'
            INTO combo_json;

        -- Update array
        fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'comboIds', COALESCE(combo_json, '[]'));

        -- Update array
        IF combo_json IS NOT NULL THEN
            fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'selectedId', combo_json->>'field_value');
        END IF;

        -- get idval values
        EXECUTE 'SELECT array_to_json(array_agg(SELECT idval FROM ('||querytext_result'||) ORDER BY idval)'
            INTO combo_json;

        -- Update array
        fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'comboNames', combo_json);

        combo_json := COALESCE(combo_json, '[]');
    
    END LOOP;
 
    -- Convert to json
    fields := array_to_json(fields_array);

        -- Create network tab form
        formAdmin := json_build_object('tabName','Admin','tabLabel',rec_tab.tablabel);
        formAdmin := gw_fct_json_object_set_key(formAdmin, 'fields', fields);
 
        formTabs := formTabs || formAdmin::text;

    END IF;

    
--    Finish the construction of formtabs
    formTabs := formtabs ||']';

--    Check null
    formTabs := COALESCE(formTabs, '[]');    

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "formTabs":' || formTabs ||
        '}')::json;

--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

