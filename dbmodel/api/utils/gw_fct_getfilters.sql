CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getfilters"(device int4, lang varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
--    id_json json;    
--    value_json json;
    selected_json json;    
    form_json json;
    formTabs_explotations json;
    formTabs_networkStates json;
    formTabs_hydroStates json;
    formTabs text;
    json_array json[];
    api_version json;
    rec_tab record;
    v_active boolean=true;
    v_firsttab boolean=false;

BEGIN


-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

-- Start the construction of the tabs array
    formTabs := '[';

-- Tab Exploitation
        SELECT * INTO rec_tab FROM config_web_tabs WHERE layer_id='F33' AND formtab='tabExploitation' ;
    IF rec_tab IS NOT NULL THEN

        -- Get exploitations, selected and unselected
        EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
        SELECT name as label, expl_id as name, ''check'' as type, ''boolean'' as "dataType", true as "value" 
        FROM exploitation WHERE expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user=' || quote_literal(current_user) || ')
        UNION
        SELECT name as label, expl_id as name, ''check'' as type, ''boolean'' as "dataType", false as "value" 
        FROM exploitation WHERE expl_id NOT IN (SELECT expl_id FROM selector_expl WHERE cur_user=' || quote_literal(current_user) || ') ORDER BY label) a'
        INTO formTabs_explotations;

        -- Add tab name to json
        formTabs_explotations := ('{"fields":' || formTabs_explotations || '}')::json;
        formTabs_explotations := gw_fct_json_object_set_key(formTabs_explotations, 'tabName', 'selector_expl'::TEXT);
        formTabs_explotations := gw_fct_json_object_set_key(formTabs_explotations, 'tabLabel', rec_tab.tablabel::TEXT);
        formTabs_explotations := gw_fct_json_object_set_key(formTabs_explotations, 'tabIdName', 'expl_id'::TEXT);
        formTabs_explotations := gw_fct_json_object_set_key(formTabs_explotations, 'active', v_active);

        -- Create tabs array
        IF v_firsttab THEN 
            formTabs := formTabs || ',' || formTabs_explotations::text;
        ELSE 
            formTabs := formTabs || formTabs_explotations::text;
        END IF;

        v_firsttab := TRUE;
        v_active :=FALSE;
    END IF;

-- Tab network state
    SELECT * INTO rec_tab FROM config_web_tabs WHERE layer_id='F33' AND formtab='tabNetworkState' ;
    IF rec_tab IS NOT NULL THEN
    
        -- Get states, selected and unselected
        EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
        SELECT name AS label, id AS name, ''check'' AS type, ''boolean'' AS "dataType", true AS "value" 
        FROM value_state WHERE id IN (SELECT state_id FROM selector_state WHERE cur_user=' || quote_literal(current_user) || ')
        UNION
        SELECT name AS label, id AS name, ''check'' AS type, ''boolean'' AS "dataType", false AS "value" 
        FROM value_state WHERE id NOT IN (SELECT state_id FROM selector_state WHERE cur_user=' || quote_literal(current_user) || ') ORDER BY name) a'
        INTO formTabs_networkStates;    
    
        -- Add tab name to json
        formTabs_networkStates := ('{"fields":' || formTabs_networkStates || '}')::json;
        formTabs_networkStates := gw_fct_json_object_set_key(formTabs_networkStates, 'tabName', 'selector_state'::TEXT);
        formTabs_networkStates := gw_fct_json_object_set_key(formTabs_networkStates, 'tabLabel', rec_tab.tablabel::TEXT);
        formTabs_networkStates := gw_fct_json_object_set_key(formTabs_networkStates, 'tabIdName', 'state_id'::TEXT);
        formTabs_networkStates := gw_fct_json_object_set_key(formTabs_networkStates, 'active', v_active);

        -- Create tabs array
        IF v_firsttab THEN 
            formTabs := formTabs || ',' || formTabs_networkStates::text;
        ELSE 
            formTabs := formTabs || formTabs_networkStates::text;
        END IF;

        v_firsttab := TRUE;
        v_active :=FALSE;
    END IF;

-- Tab hydrometer state
    SELECT * INTO rec_tab FROM config_web_tabs WHERE layer_id='F33' AND formtab='tabHydroState' ;
    IF rec_tab IS NOT NULL THEN
    
        -- Get hydrometer states, selected and unselected
        EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
        SELECT name AS label, id AS name, ''check'' AS type, ''boolean'' AS "dataType", true AS "value" 
        FROM ext_rtc_hydrometer_state WHERE id IN (SELECT state_id FROM selector_hydrometer WHERE cur_user=' || quote_literal(current_user) || ')
        UNION
        SELECT name AS label, id AS name, ''check'' AS type, ''boolean'' AS "dataType", false AS "value" 
        FROM ext_rtc_hydrometer_state WHERE id NOT IN (SELECT state_id FROM selector_hydrometer WHERE cur_user=' || quote_literal(current_user) || ') ORDER BY name) a'
        INTO formTabs_hydroStates;    
    
        -- Add tab name to json
        formTabs_hydroStates := ('{"fields":' || formTabs_hydroStates || '}')::json;
        formTabs_hydroStates := gw_fct_json_object_set_key(formTabs_hydroStates, 'tabName', 'selector_hydrometer'::TEXT);
        formTabs_hydroStates := gw_fct_json_object_set_key(formTabs_hydroStates, 'tabLabel', rec_tab.tablabel::TEXT);
        formTabs_hydroStates := gw_fct_json_object_set_key(formTabs_hydroStates, 'tabIdName', 'state_id'::TEXT);
        formTabs_hydroStates := gw_fct_json_object_set_key(formTabs_hydroStates, 'active', false);

        -- Create tabs array
        IF v_firsttab THEN 
            formTabs := formTabs || ',' || formTabs_hydroStates::text;
        ELSE 
            formTabs := formTabs || formTabs_hydroStates::text;
        END IF;

        v_firsttab := TRUE;
        v_active :=FALSE;
    END IF;

-- Finish the construction of the tabs array
    formTabs := formTabs ||']';


-- Check null
    formTabs := COALESCE(formTabs, '[]');    

-- Return
    IF v_firsttab IS FALSE THEN
        -- Return not implemented
        RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "message":"Not implemented"'||
        '}')::json;
    ELSE 
        -- Return formtabs
        RETURN ('{"status":"Accepted"' ||
            ', "apiVersion":'|| api_version ||
            ', "formTabs":' || formTabs ||
            '}')::json;
    END IF;

-- Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

