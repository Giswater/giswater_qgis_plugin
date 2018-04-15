CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getformtabs"(class_id_arg varchar, table_id_arg varchar, id varchar, editable bool, device int4, user_id varchar, lang varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    form_info json;    
    form_tabs varchar[];
    form_tabs_json json;
    editable_data json;
    info_data json;
    field_wms json[2];
    feature_cat_arg text;
    formid_arg text;
    table_id_parent_arg text;
    parent_view_arg text;
    parent_table_arg text;
    parent_child_relation boolean;

BEGIN

--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

    parent_child_relation = false;

--    Check if request coherence againts class_id_arg & table_id_arg (if exists it means direct click)
    IF (SELECT class_id FROM config_web_layer WHERE layer_id=table_id_arg)=class_id_arg THEN

--        Get form for the layer 
        -- to build json
        EXECUTE 'SELECT row_to_json(row) FROM (SELECT formname AS "formName", formid AS "formId" 
            FROM config_web_layer_form WHERE layer_id = $1 LIMIT 1) row'
            INTO form_info
            USING table_id_arg; 
            
--        Get tabs for the layer
        EXECUTE 'SELECT array_agg(formtab) FROM config_web_layer_tab WHERE layer_id = $1'
            INTO form_tabs
            USING table_id_arg;

--        Check if is parent table
        IF table_id_arg IN (SELECT table_parent FROM config_web_layer_child) THEN

            -- parent-child relation exits    
            parent_child_relation:=true;

            -- check parent_view
            EXECUTE 'SELECT parent_id from config_web_layer_parent WHERE layer_id=$1'
                INTO parent_view_arg
                USING table_id_arg;

            -- Identify featurecat_id
            EXECUTE 'SELECT table_name FROM cat_feature 
            WHERE id=(SELECT custom_type FROM '||parent_view_arg||' WHERE nid::text=$1)'
                INTO feature_cat_arg
                USING id;

            -- identify child view to proceed
            table_id_arg:=(SELECT table_child FROM config_web_layer_child WHERE id=feature_cat_arg);

        END IF;

    -- Check if request coherence againts class_id_arg & table_id_arg (if not exists it means navigation)
    ELSE
    
        -- identify layer from class
        EXECUTE 'SELECT layer_id from config_web_layer WHERE layer_id=$1 LIMIT 1'
            INTO table_id_arg
            USING class_id_arg;

--        Check if is parent table
        IF table_id_arg IN (SELECT table_parent FROM config_web_layer_child) THEN

            -- parent-child relation exits    
            parent_child_relation:=true;

            -- check parent_view
            EXECUTE 'SELECT parent_id from config_web_layer_parent WHERE layer_id=$1'
                INTO parent_view_arg
                USING table_id_arg;

            -- Identify featurecat_id
            EXECUTE 'SELECT table_name FROM cat_feature 
            WHERE id=(SELECT custom_type FROM '||parent_view_arg||' WHERE nid::text=$1)'
                INTO feature_cat_arg
                USING id;

            -- identify child view to proceed
            table_id_arg:=(SELECT table_child FROM config_web_layer_child WHERE id=feature_cat_arg);

        END IF;

        -- Get form for the layer
        EXECUTE 'SELECT row_to_json(row) FROM (SELECT formname AS "formName", formid AS "formId" 
            FROM config_web_layer_form WHERE layer_id = $1 LIMIT 1) row'
            INTO form_info
            USING table_id_arg; 

        -- Get tabs for the layer
        EXECUTE 'SELECT array_agg(formtab) FROM config_web_layer_tab WHERE layer_id = $1'
            INTO form_tabs
            USING table_id_arg;
        
    END IF;

    EXECUTE 'SELECT formid FROM config_web_layer_form WHERE layer_id = $1 LIMIT 1'
        INTO formid_arg
        USING table_id_arg; 
            
--    Check generic
    IF form_info ISNULL THEN
        form_info := json_build_object('formName','F16','formId','GENERIC');
        formid_arg := 'F16';
    END IF;

--    Add default tab
    form_tabs_json := array_to_json(array_append(form_tabs, 'tabInfo'));

--    Join json
    form_info := gw_fct_json_object_set_key(form_info, 'formTabs', form_tabs_json);


--    if editable layer
    IF editable AND parent_child_relation IS FALSE THEN

        -- call editable form using table information
        EXECUTE 'SELECT gw_fct_getinsertform($1, $2, $3, $4)'
            INTO editable_data
            USING table_id_arg, lang, id, formid_arg;

--    IF no editable layer
    ELSE
        -- call getinfoform using table information
        EXECUTE 'SELECT gw_fct_getinfoform($1, $2, $3, $4)'
            INTO editable_data
            USING table_id_arg, lang, id, formid_arg;
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

