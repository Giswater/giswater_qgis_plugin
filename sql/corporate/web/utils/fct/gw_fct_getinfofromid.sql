/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getinfofromid"(alias_id_arg varchar, table_id_arg varchar, id varchar, editable bool, v_visitability boolean, device int4, p_info_type int4, lang varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    form_info json;    
    form_tabs varchar[];
    form_tablabel varchar[];
    form_tabtext varchar[];
    form_tabs_json json;
    form_tablabel_json json;
    form_tabtext_json json;
    editable_data json;
    info_data json;
    field_wms json[2];
    feature_cat_arg text;
    formid_arg text;
    tableparent_id_arg text;
    parent_child_relation boolean;
    link_id_aux text;
    v_idname text;
    link_path json;
    column_type text;
    schemas_array name[];
    api_version json;
    v_geometry json;
    v_the_geom text;
    v_coherence boolean = false;
    v_results json;
    table_arg_return text = table_id_arg;
    v_formheader text;
    v_query_text text;
    mincut_act boolean;
    visit_act boolean;
    v_visitability boolean;

    -- fixed info type parameter(to do)
    --p_info_type integer=200;
    

BEGIN

--    Reset parameters
------------------------
     parent_child_relation = false;

--    Set search path to local schema
-------------------------------------
    SET search_path = "SCHEMA_NAME", public;
    schemas_array := current_schemas(FALSE);

--      Get api version
------------------------
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

    raise notice 'Get api version: %', api_version;


--      Get form (if exists) for the layer 
------------------------------------------
    -- to build json
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT formname AS "formName", formid AS "formId" 
	FROM config_web_layer WHERE layer_id = $1 LIMIT 1) row'
        INTO form_info
        USING table_id_arg; 
            
    raise notice 'Form number: %', form_info;

--    Get id column
---------------------
    EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
        INTO v_idname
        USING table_id_arg;
        
    -- For views it suposse pk is the first column
    IF v_idname ISNULL THEN
        EXECUTE '
        SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
        AND t.relname = $1 
        AND s.nspname = $2
        ORDER BY a.attnum LIMIT 1'
        INTO v_idname
        USING table_id_arg, schemas_array[1];
    END IF;

    -- Get id column type
    EXECUTE 'SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) FROM pg_attribute a
    JOIN pg_class t on a.attrelid = t.oid
    JOIN pg_namespace s on t.relnamespace = s.oid
    WHERE a.attnum > 0 
    AND NOT a.attisdropped
    AND a.attname = $3
    AND t.relname = $2 
    AND s.nspname = $1
    ORDER BY a.attnum'
        USING schemas_array[1], table_id_arg, v_idname
        INTO column_type;


    raise notice 'v_idname: %  column_type: %', v_idname, column_type;

--     Get geometry_column
------------------------------------------
        EXECUTE 'SELECT attname FROM pg_attribute a        
            JOIN pg_class t on a.attrelid = t.oid
            JOIN pg_namespace s on t.relnamespace = s.oid
            WHERE a.attnum > 0 
            AND NOT a.attisdropped
            AND t.relname = $1
            AND s.nspname = $2
            AND left (pg_catalog.format_type(a.atttypid, a.atttypmod), 8)=''geometry''
            ORDER BY a.attnum' 
            INTO v_the_geom
            USING table_id_arg, schemas_array[1];
               
--     Get geometry (to feature response)
------------------------------------------
    IF v_the_geom IS NOT NULL THEN
        EXECUTE 'SELECT row_to_json(row) FROM (SELECT St_AsText(St_simplify('||v_the_geom||',0)) FROM '||table_id_arg||' WHERE '||v_idname||' = CAST('||quote_literal(id)||' AS '||column_type||'))row'
            INTO v_geometry;
    END IF;

    raise notice 'Feature geometry: % ', v_geometry;

--      Get link (if exists) for the layer
------------------------------------------
    link_id_aux := (SELECT link_id FROM config_web_layer WHERE layer_id=table_id_arg);

    IF  link_id_aux IS NOT NULL THEN      
        -- Get link field value
        EXECUTE 'SELECT row_to_json(row) FROM (SELECT '||link_id_aux||' AS link FROM '||table_id_arg||' WHERE '||v_idname||' = CAST('||quote_literal(id)||' AS '||column_type||'))row'
        INTO link_path;
	raise notice 'Layer link path: % ', link_path;
   END IF;
         
--        Get tabs for the layer
--------------------------------
    EXECUTE 'SELECT array_agg(formtab) FROM (SELECT formtab FROM config_web_tabs WHERE layer_id = $1 order by id desc) a'
	INTO form_tabs
        USING table_id_arg;

    raise notice 'form_tabs %', form_tabs;

    -- Get tab label for tabs form
    ------------------------------
    EXECUTE 'SELECT array_agg(tablabel) FROM (SELECT tablabel FROM config_web_tabs WHERE layer_id = $1 order by id desc) a'
	INTO form_tablabel
        USING table_id_arg;

    raise notice 'form_tablabel; %', form_tablabel;

    -- Get header text for tabs form
    --------------------------------
    EXECUTE 'SELECT array_agg(tabtext) FROM (SELECT tabtext FROM config_web_tabs WHERE layer_id = $1 order by id desc) a'
	INTO form_tabtext
        USING table_id_arg;

    raise notice 'form_tabtext; %', form_tabtext;

--        Check if it is parent table 
-------------------------------------
   IF table_id_arg IN (SELECT layer_id FROM config_web_layer WHERE is_parent IS TRUE) THEN

	-- parent-child relation exits    
	parent_child_relation:=true;
    
	-- check parent_view
	EXECUTE 'SELECT tableparent_id from config_web_layer WHERE layer_id=$1'
		INTO tableparent_id_arg
		USING table_id_arg;
                
	raise notice'Parent-Child. Table parent: %' , tableparent_id_arg;

	-- Identify tableinforole_id 
        v_query_text := ' SELECT tableinforole_id FROM config_web_layer_child
	JOIN config_web_tableinfo_x_inforole ON config_web_layer_child.tableinfo_id=config_web_tableinfo_x_inforole.tableinfo_id 
	WHERE featurecat_id= (SELECT custom_type FROM '||tableparent_id_arg||' WHERE nid::text='||id||'::text) 
	AND inforole_id='||p_info_type;

    	-- Identify tableinforole_id 
	EXECUTE v_query_text INTO table_id_arg;

	-- Identify Name of feature type (to put on header of form)
	EXECUTE' SELECT custom_type FROM '||tableparent_id_arg||' WHERE nid::text=$1'
		INTO v_formheader
		USING id;
		
	raise notice'Parent-Child. Table child: %, p_info_type: %' , table_id_arg, p_info_type;


    -- Check if it is not parent, not editable and has tableinfo_id
    ELSIF table_id_arg IN (SELECT layer_id FROM config_web_layer WHERE is_parent IS FALSE AND is_editable IS FALSE AND tableinfo_id IS NOT NULL) THEN 
	
	-- Identify tableinforole_id 
	EXECUTE 'SELECT tableinforole_id FROM config_web_layer
	JOIN config_web_tableinfo_x_inforole ON config_web_layer.tableinfo_id=config_web_tableinfo_x_inforole.tableinfo_id 
	WHERE layer_id=$1 AND inforole_id=$2'
	INTO table_id_arg
	USING table_id_arg, p_info_type;

	raise notice 'NO parent-child, NO editable, Informable: %, p_info_type: %' , table_id_arg, p_info_type;

    -- Check if it is not parent, not editable and has not tableinfo_id (is not informable)
    ELSIF table_id_arg IN (SELECT layer_id FROM config_web_layer WHERE is_parent IS FALSE AND is_editable IS FALSE AND tableinfo_id IS NULL) THEN 
	
	raise notice 'NO parent-child, NO editable NO informable: %' , table_id_arg;

	table_id_arg= null;
	
    END IF;
    
-- Propierties of info layer's
------------------------------
    IF table_id_arg IS NOT NULL THEN 
	EXECUTE 'SELECT EXISTS ( SELECT 1 FROM   information_schema.tables WHERE  table_schema = '||quote_literal(schemas_array[1])||' 
		AND table_name = '||quote_literal(table_id_arg)||')'
		INTO v_query_text;
            
	IF v_query_text::boolean IS FALSE THEN
		RETURN ('{"status":"Failed","message":'||to_json('The info table does not exists. Check your parent-child and inforole configurations'::text)
		||', "apiVersion":'|| api_version ||'}')::json;
	END IF;
        
	--    Get id column
	EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
		INTO v_idname
		USING table_id_arg;

        -- For views it suposse pk is the first column
	IF v_idname ISNULL THEN
		EXECUTE '
		SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
		AND t.relname = $1 
		AND s.nspname = $2
		ORDER BY a.attnum LIMIT 1'
		INTO v_idname
		USING table_id_arg, schemas_array[1];
	END IF;
	
	--    Control for layer with mincut option on info
	IF v_idname = 'arc_id'::text OR v_idname = 'node_id'::text OR v_idname = 'connec_id'::text OR v_idname = 'gully_id'::text OR v_idname = 'sys_hydrometer_id'::text THEN
		mincut_act = TRUE;
	ELSE
		mincut_act = FALSE;	
	END IF;

	-- enhance visitability
	IF v_visitability IS NULL THEN 
		v_visitability := TRUE;
	END IF;

	-- Setting form header
	IF v_formheader IS NULL THEN
		v_formheader = (SELECT formname FROM config_web_layer WHERE tableinfo_id=table_id_arg LIMIT 1);
	END IF;

	raise notice' v_formheader %', v_formheader;
	
	--    Check generic
	IF form_info ISNULL THEN
		v_formheader:='GENERIC';
		form_info := json_build_object('formName','F16','formId',v_formheader);
		form_tablabel_json := array_to_json(array_append(form_tablabel, 'DADES'));
		formid_arg := 'F16';
	ELSE 
		form_tablabel_json := array_to_json(array_append(form_tablabel, 'Dades'));
	END IF;

	--    Add default tab
	form_tabs_json := array_to_json(array_append(form_tabs, 'tabInfo'));
	form_tabtext_json := array_to_json(array_append(form_tabtext, ''));

	--    Join json
	v_formheader:=concat(v_formheader,' - ',id);
	form_info := gw_fct_json_object_set_key(form_info, 'formName', v_formheader);
	form_info := gw_fct_json_object_set_key(form_info, 'formTabs', form_tabs_json);
	form_info := gw_fct_json_object_set_key(form_info, 'tabLabel', form_tablabel_json);
	form_info := gw_fct_json_object_set_key(form_info, 'tabText', form_tabtext_json);

	--  Calling form function
	-------------------------
	IF editable THEN
		-- call editable form using table information
		EXECUTE 'SELECT gw_fct_getinsertform($1, $2, $3)'
		INTO editable_data
		USING table_id_arg, lang, id;

	ELSIF table_id_arg is not null THEN
		-- call getinfoform using table information
		EXECUTE 'SELECT gw_fct_getinfoform($1, $2, $3, $4)'
		INTO editable_data
		USING table_id_arg, lang, id, formid_arg;
	END IF;

    END IF;

   table_arg_return:= (to_json(table_arg_return));


--    Hydrometer 'id' fix
-------------------------
    IF v_idname = 'sys_hydrometer_id' THEN
        v_idname = 'hydrometer_id';
    END IF;


--    Control NULL's
----------------------
    api_version := COALESCE(api_version, '{}');
    form_info := COALESCE(form_info, '{}');
    table_arg_return := COALESCE(table_arg_return, '{}');
    v_idname := COALESCE(v_idname, '{}');
    v_geometry := COALESCE(v_geometry, '{}');
    link_path := COALESCE(link_path, '{}');
    editable_data := COALESCE(editable_data, '{}');
    v_results:= ('{"number":1}')::json;

--    Return
-----------------------
IF table_id_arg IS NULL THEN
     RETURN ('{"status":"Accepted", "apiVersion":'|| api_version || ', "results":0' ||', "formTabs":[] , "tableName":"", "idName": "", "geometry":"", "linkPath":"", "editData":[] }')::json;

ELSE
    
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "results":1'||
        ', "formTabs":' || form_info ||
        ', "tableName":'|| table_arg_return ||
        ', "idName": "' || v_idname ||'"'||
        ', "geometry":' || v_geometry ||
        ', "linkPath":' || link_path ||
        ', "editData":' || editable_data ||
        ', "mincut":'   || mincut_act ||
        ', "visitability":'    || v_visitability ||
        '}')::json;

END IF;

--    Exception handling
 --   EXCEPTION WHEN OTHERS THEN 
   --     RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

