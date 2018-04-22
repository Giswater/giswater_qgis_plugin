CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getformtabs"(alias_id_arg varchar, table_id_arg varchar, id varchar, editable bool, device int4, user_id varchar, lang varchar) RETURNS pg_catalog.json AS $BODY$
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
    tableparent_id_arg text;
    parent_child_relation boolean;

    -- future parameter passed by client
    inforole_id_arg integer:=1;

BEGIN

--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

    parent_child_relation = false;

--    Check if request coherence againts alias_id_arg & table_id_arg (if not exists it means navigation)
    IF (SELECT alias_id FROM config_web_layer WHERE layer_id=table_id_arg)!=alias_id_arg THEN

   
        -- Get real layer from alias
        EXECUTE 'SELECT layer_id from config_web_layer WHERE alias_id=$1 LIMIT 1'
            INTO table_id_arg
            USING alias_id_arg;

           raise notice' Layer navigation %' , table_id_arg;


    END IF;

--        Get form for the layer 
        -- to build json
        EXECUTE 'SELECT row_to_json(row) FROM (SELECT formname AS "formName", formid AS "formId" 
            FROM config_web_layer WHERE layer_id = $1 LIMIT 1) row'
            INTO form_info
            USING table_id_arg; 

           
--        Get tabs for the layer
        EXECUTE 'SELECT array_agg(formtab) FROM config_web_layer_tab WHERE layer_id = $1'
            INTO form_tabs
            USING table_id_arg;

          raise notice' table_id_arg %' , table_id_arg;


--        Check if it is parent table (is_parent is true)
        IF table_id_arg IN (SELECT layer_id FROM config_web_layer WHERE is_parent IS TRUE) THEN

            -- parent-child relation exits    
        parent_child_relation:=true;

            -- check parent_view
        EXECUTE 'SELECT tableparent_id from config_web_layer WHERE layer_id=$1'
                INTO tableparent_id_arg
                USING table_id_arg;
                
        raise notice'Parent-Child. Table parent: %' , tableparent_id_arg;


            -- Identify tableinforole_id 
        EXECUTE' SELECT tableinforole_id FROM config_web_layer_child
        JOIN config_web_tableinfo_x_inforole ON config_web_layer_child.tableinfo_id=config_web_tableinfo_x_inforole.tableinfo_id 
        WHERE featurecat_id= (SELECT custom_type FROM '||tableparent_id_arg||' WHERE nid::text=$1) 
        AND inforole_id=$2'
            INTO table_id_arg
            USING id, inforole_id_arg;

        raise notice'Parent-Child. Table: %' , table_id_arg;

--        Check if it is not editable layer (is_editable is false)
        ELSIF table_id_arg IN (SELECT layer_id FROM config_web_layer WHERE is_editable IS FALSE) THEN

            -- Identify tableinforole_id 
        EXECUTE 'SELECT tableinforole_id FROM config_web_layer
        JOIN config_web_tableinfo_x_inforole ON config_web_layer.tableinfo_id=config_web_tableinfo_x_inforole.tableinfo_id 
        WHERE layer_id=$1 AND inforole_id=$2'
                INTO table_id_arg
            USING table_id_arg, inforole_id_arg;

        raise notice'No parent-child and no editable table: %' , table_id_arg;

        END IF;
        

--  Take form_id 
    EXECUTE 'SELECT formid FROM config_web_layer WHERE layer_id = $1 LIMIT 1'
        INTO formid_arg
        USING alias_id_arg; 
            
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
 --   EXCEPTION WHEN OTHERS THEN 
  --      RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

