CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getformtabs"(layer_id varchar, table_id varchar, id varchar, editable bool, device int4, user_id varchar, lang varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    form_info json;    
    form_tabs varchar[];
    form_tabs_json json;
    editable_data json;




BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;


--    Get form info fot the layer
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT formname AS "formName", formid AS "formId" FROM config_web_layer_tab WHERE table_id = $1 LIMIT 1) row'
        INTO form_info
        USING table_id; 


--    Get tabs info for the layer
    EXECUTE 'SELECT array_agg(formtab) FROM config_web_layer_tab WHERE table_id = $1'
        INTO form_tabs
        USING table_id;

--    Add default tab
    form_tabs_json := array_to_json(array_append(form_tabs, 'tabInfo'));

--    Join json
    form_info := gw_fct_json_object_set_key(form_info, 'formTabs', form_tabs_json);

--    Get editable form
    IF editable THEN
        EXECUTE 'SELECT gw_fct_getinsertform($1, $2, $3)'
            INTO editable_data
            USING table_id, lang, id;
    END IF;

--    Control NULL's
    form_info := COALESCE(form_info, '{}');
    editable_data := COALESCE(editable_data, '{}');

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "formTabs":' || form_info ||
        ', "editData":' || editable_data ||
        '}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

