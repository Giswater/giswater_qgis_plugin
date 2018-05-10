
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getformtabs(
    alias_id_arg character varying,
    table_id_arg character varying,
    id character varying,
    editable boolean,
    device integer,
    user_id character varying,
    lang character varying)
  RETURNS json AS
$BODY$
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
    link_id_aux text;
    table_pkey text;
    link_path json;
    column_type text;
    schemas_array name[];
    api_version json;


    -- future parameter passed by client
    inforole_id_arg integer:=1;

BEGIN

--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    schemas_array := current_schemas(FALSE);

    parent_child_relation = false;
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--    Check if request coherence againts alias_id_arg & table_id_arg (if not exists it means navigation)
    IF (SELECT alias_id FROM config_web_layer WHERE layer_id=table_id_arg)IS NOT NULL 
	AND (SELECT alias_id FROM config_web_layer WHERE layer_id=table_id_arg)!=alias_id_arg THEN

        -- Get real layer from alias
        EXECUTE 'SELECT layer_id from config_web_layer WHERE alias_id=$1 LIMIT 1'
            INTO table_id_arg
            USING alias_id_arg;

           raise notice' Layer navigation %' , table_id_arg;

    END IF;

--        Get form (if exists) for the layer 
        -- to build json
        EXECUTE 'SELECT row_to_json(row) FROM (SELECT formname AS "formName", formid AS "formId" 
            FROM config_web_layer WHERE layer_id = $1 LIMIT 1) row'
            INTO form_info
            USING table_id_arg; 
            

--        Get link (if exists) for the layer
	link_id_aux := (SELECT link_id FROM config_web_layer WHERE layer_id=table_id_arg);

	IF  link_id_aux IS NOT NULL THEN 

		--Get id column
		EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
		INTO table_pkey
		USING table_id_arg;
		
		-- For views it suposse pk is the first column
		IF table_pkey ISNULL THEN
			EXECUTE '
			SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
			AND t.relname = $1 
			AND s.nspname = $2
			ORDER BY a.attnum LIMIT 1'
			INTO table_pkey
			USING table_id_arg, schemas_array[1];
		END IF;

		-- Get column type
		EXECUTE 'SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) FROM pg_attribute a
		JOIN pg_class t on a.attrelid = t.oid
		JOIN pg_namespace s on t.relnamespace = s.oid
		WHERE a.attnum > 0 
		AND NOT a.attisdropped
		AND a.attname = $3
		AND t.relname = $2 
		AND s.nspname = $1
		ORDER BY a.attnum'
		USING schemas_array[1], table_id_arg, table_pkey
		INTO column_type;
        
		-- Get link field value
		EXECUTE 'SELECT row_to_json(row) FROM (SELECT '||link_id_aux||' FROM '||table_id_arg||' WHERE '||table_pkey||' = CAST('||id||' AS '||column_type||'))row'
		INTO link_path;

        END IF;


         
--        Get tabs for the layer
        EXECUTE 'SELECT array_agg(formtab) FROM config_web_layer_tab WHERE layer_id = $1'
            INTO form_tabs
            USING table_id_arg;


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
        EXECUTE 'SELECT gw_fct_getinsertform($1, $2, $3)'
            INTO editable_data
            USING table_id_arg, lang, id;

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
    link_path := COALESCE(link_path, '{}');

    
--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||'"' ||
        ', "formTabs":' || form_info ||
        ', "linkPath":' || link_path ||
        ', "editData":' || editable_data ||
        '}')::json;


--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
