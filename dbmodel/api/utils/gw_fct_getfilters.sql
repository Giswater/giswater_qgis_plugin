CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getfilters"(device int4, lang varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
--    id_json json;    
--    value_json json;
    selected_json json;    
    form_json json;
    formTabs_explotations json;
    formTabs_states json;
    formTabs json;
    json_array json[];
    api_version json;


BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;


--      Get exploitations, selected and unselected
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
    SELECT name as label, expl_id as name, ''check'' as type, ''boolean'' as "dataType", true as "value" 
    FROM exploitation WHERE expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user=' || quote_literal(current_user) || ')
    UNION
    SELECT name as label, expl_id as name, ''check'' as type, ''boolean'' as "dataType", false as "value" 
    FROM exploitation WHERE expl_id NOT IN (SELECT expl_id FROM selector_expl WHERE cur_user=' || quote_literal(current_user) || ')) a'
    INTO formTabs;

--    Add tab name to json
    formTabs_explotations := ('{"fields":' || formTabs || '}')::json;
    formTabs_explotations := gw_fct_json_object_set_key(formTabs_explotations, 'tabName', 'selector_expl'::TEXT);
    formTabs_explotations := gw_fct_json_object_set_key(formTabs_explotations, 'tabLabel', 'Exploitation'::TEXT);
    formTabs_explotations := gw_fct_json_object_set_key(formTabs_explotations, 'tabIdName', 'expl_id'::TEXT);
    formTabs_explotations := gw_fct_json_object_set_key(formTabs_explotations, 'active', TRUE);


--      Get states, selected and unselected
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
    SELECT name AS label, id AS name, ''check'' AS type, ''boolean'' AS "dataType", true AS "value" 
    FROM value_state WHERE id IN (SELECT state_id FROM selector_state WHERE cur_user=' || quote_literal(current_user) || ')
    UNION
    SELECT name AS label, id AS name, ''check'' AS type, ''boolean'' AS "dataType", false AS "value" 
    FROM value_state WHERE id NOT IN (SELECT state_id FROM selector_state WHERE cur_user=' || quote_literal(current_user) || ')) a'
    INTO formTabs;    

--    Add tab name to json
    formTabs_states := ('{"fields":' || formTabs || '}')::json;
    formTabs_states := gw_fct_json_object_set_key(formTabs_states, 'tabName', 'selector_state'::TEXT);
    formTabs_states := gw_fct_json_object_set_key(formTabs_states, 'tabLabel', 'States'::TEXT);
    formTabs_states := gw_fct_json_object_set_key(formTabs_states, 'tabIdName', 'state_id'::TEXT);

--    Create tabs array
    formTabs := '[' || formTabs_explotations || ',' || formTabs_states || ']';


--    Check null
    formTabs := COALESCE(formTabs, '[]');    

RAISE NOTICE 'Res: %', form_json;

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "formTabs":' || formTabs ||
        '}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

