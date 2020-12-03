	/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2582

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_getinfofromid(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getinfofromid(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
UPSERT FEATURE 
arc no nodes extremals
SELECT SCHEMA_NAME.gw_fct_getinfofromid($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"form":{"editable":"True"},
		"feature":{"tableName":"ve_arc_pipe", "inputGeometry":"0102000020E7640000020000000056560000A083198641000000669A33C041000000E829D880410000D0AE90F0F341" },
		"data":{}}$$)
arc with nodes extremals
SELECT SCHEMA_NAME.gw_fct_getinfofromid($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"form":{"editable":"True"},
		"feature":{"tableName":"ve_arc_pipe", "inputGeometry":"0102000020E764000002000000998B3C512F881941B28315AA7F76514105968D7D748819419FDF72D781765141" },
		"data":{"addSchema":"SCHEMA_NAME"}}$$)
INFO BASIC
SELECT SCHEMA_NAME.gw_fct_getinfofromid($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"form":{"editable":"True"},
		"feature":{"tableName":"ve_arc_pipe", "id":"2001"},
		"data":{}}$$)
SELECT SCHEMA_NAME.gw_fct_getinfofromid($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"form":{"editable":"True"},
		"feature":{"tableName":"ve_node_junction", "id":"1001"},
		"data":{}}$$)
SELECT SCHEMA_NAME.gw_fct_getinfofromid($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"form":{"editable":"True"},
		"feature":{"tableName":"ve_connec_wjoin", "id":"3001"},
		"data":{}}$$)
SELECT SCHEMA_NAME.gw_fct_getinfofromid($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"form":{"editable":"True"},
		"feature":{"tableName":"ve_element", "id":"125101"},
		"data":{}}$$)


INFO EPA
-- epa not defined
SELECT SCHEMA_NAME.gw_fct_getinfofromid($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"form":{"editable":"True"},
		"feature":{"tableName":"ve_arc", "id":"2220"},
		"data":{"toolBar":"epa"}}$$)

-- epa defined
SELECT SCHEMA_NAME.gw_fct_getinfofromid($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"form":{"editable":"True"},
		"feature":{"tableName":"ve_arc", "id":"2001"},
		"data":{"toolBar":"epa"}}$$)
		
SELECT SCHEMA_NAME.gw_fct_getinfofromid($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"tableName":"v_ext_plot", "id":"", "isLayer":true},
"data":{"filterFields":{}, "pageInfo":{}, "infoType":"full"}}$$);	

*/

DECLARE

v_tablename character varying;
v_tablename_original character varying;
v_id character varying;
v_inputgeometry public.geometry;
v_editable boolean = true;
v_device integer;
v_infotype integer;
v_forminfo json;
v_form_tabs_info json;    
v_action_info json;
form_tabs json[];
form_tablabel varchar[];
form_tabtext varchar[];
v_form_actiontooltip varchar[];
v_formactions json;
v_form_actiontooltip_json json;
form_tabs_json json;
form_tablabel_json json;
form_tabtext_json json;
v_fields json;
formid_arg text;
tableparent_id_arg text;
parent_child_relation boolean = false;
link_id_aux text;
v_idname text;
v_featuretype text;
v_linkpath json;
column_type text;
v_schemaname text;
v_version json;
v_geometry json;
v_the_geom text;
v_table_parent varchar;
v_tg_op varchar;
v_project_type text;
v_per boolean;
v_permissions json;
v_configtabledefined boolean;
v_formtype text;
v_vdefault_values text;
v_vdefault_array json;
v_list_parameter text[];
v_aux_parameter text;
list_values character varying[];
v_value character varying;
v_featureinfo json;
v_parent_layer text;
v_message json;
v_maxcanvasmargin double precision;
v_mincanvasmargin double precision;
v_canvasmargin  double precision;
v_canvasmargin_text text ;
v_toolbar text;
v_layermanager json;
v_role text;
v_parentfields text;
v_status text ='Accepted';
v_childtype text;
v_errcontext text;
v_islayer boolean;
v_addschema text;
v_return json;
v_flag boolean = false;
v_isgrafdelimiter boolean  = false;
v_isepatoarc boolean  = false;
v_nodetype text;

BEGIN

	--  Get,check and set parameteres
	----------------------------
	
	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname := 'SCHEMA_NAME';


	-- input parameters
	v_device := (p_data ->> 'client')::json->> 'device';
	v_infotype := (p_data ->> 'client')::json->> 'infoType';
	v_tablename := (p_data ->> 'feature')::json->> 'tableName';
	v_id := (p_data ->> 'feature')::json->> 'id';
	v_inputgeometry := (p_data ->> 'feature')::json->> 'inputGeometry';
	v_toolbar := (p_data ->> 'data')::json->> 'toolBar';
	v_islayer := (p_data ->> 'feature')::json->> 'isLayer';
	v_addschema := (p_data ->> 'data')::json->> 'addSchema';
	v_editable = (p_data ->> 'data')::json->> 'editable';

	-- control strange null
	IF lower(v_addschema) = 'none' or v_addschema = '' THEN 
		v_addschema = null;
	END IF;

	-- looking for additional schema 
	IF v_addschema IS NOT NULL AND v_addschema != v_schemaname AND v_flag IS FALSE THEN
	
		EXECUTE 'SET search_path = '||v_addschema||', public';
		SELECT gw_fct_getinfofromid(p_data) INTO v_return;
		SET search_path = 'SCHEMA_NAME', public;
		RETURN v_return;
	END IF;
	
	if v_toolbar is NULL THEN
		v_toolbar := 'basic';
	END IF;

	v_infotype = 1;

	IF v_id = '' THEN
		v_id = NULL;
	END IF;
	
	-- Get values from config
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;
		
	-- get project type
	SELECT project_type INTO v_project_type FROM sys_version LIMIT 1;

	-- check layer if it's child layer 
    IF (SELECT child_layer FROM cat_feature WHERE child_layer=v_tablename)IS NOT NULL THEN
		v_table_parent := (SELECT parent_layer FROM cat_feature WHERE child_layer=v_tablename);	

		--check if is delimiter
		IF upper(v_project_type) = 'WS' AND v_table_parent='v_edit_node' THEN
			IF (SELECT upper(graf_delimiter) FROM cat_feature_node JOIN cat_feature USING (id)
				WHERE child_layer=v_tablename) IN ('DMA','PRESSZONE') THEN
				v_isgrafdelimiter = TRUE;
			ELSIF (SELECT upper(epa_default) FROM cat_feature_node JOIN cat_feature USING (id)
				WHERE child_layer=v_tablename) IN ('PUMP', 'VALVE', 'SHORTPIPE') THEN
					v_isepatoarc = TRUE;
			END IF;
		END IF;
	ELSE  
		-- tablename is used as table parent.
		v_table_parent = v_tablename;
		--check if is delimiter
		IF upper(v_project_type) = 'WS' AND v_table_parent='v_edit_node' AND v_id IS NOT NULL THEN

			EXECUTE 'SELECT nodetype_id FROM '||v_table_parent||' WHERE node_id = '||quote_literal(v_id)||';'
			INTO v_nodetype;
			
			IF (SELECT upper(graf_delimiter) FROM cat_feature_node WHERE id=v_nodetype) IN ('DMA','PRESSZONE') THEN
				v_isgrafdelimiter = TRUE;
			ELSIF (SELECT upper(epa_type) FROM node WHERE node_id = v_id) IN ('PUMP', 'VALVE', 'SHORTPIPE') THEN
				v_isepatoarc = TRUE;
			END IF;
		END IF;
	END IF;

	-- get tableparent fields
	EXECUTE 'SELECT to_json(array_agg(columnname)) FROM 
		(SELECT a.attname as columnname FROM pg_attribute a JOIN pg_class t on a.attrelid = t.oid JOIN pg_namespace s on t.relnamespace = s.oid
		WHERE a.attnum > 0 AND NOT a.attisdropped AND t.relname = $1 AND s.nspname = $2	ORDER BY a.attnum) a'
		INTO v_parentfields
		USING v_table_parent, v_schemaname; 

	raise notice 'v_parentfields %', v_parentfields;
	v_parentfields = replace (v_parentfields::text, '{', '[');
	v_parentfields = replace (v_parentfields::text, '}', ']');

	--      Get form (if exists) for the layer 
	------------------------------------------
        -- to build json
        EXECUTE 'SELECT row_to_json(row) FROM (SELECT formtemplate AS template, headertext AS "headerText"
            FROM config_info_layer WHERE layer_id = $1 LIMIT 1) row'
            INTO v_forminfo
            USING v_tablename; 

        -- IF v_forminfo is null and it's layer it's child layer --> parent form info is used
        IF v_forminfo IS NULL AND v_table_parent IS NOT NULL THEN

		EXECUTE 'SELECT row_to_json(row) FROM (SELECT formtemplate AS template , headertext AS "headerText"
			FROM config_info_layer WHERE layer_id = $1 LIMIT 1) row'
			INTO v_forminfo
			USING v_table_parent; 
        END IF;
            
	RAISE NOTICE 'Form number: %', v_forminfo;

	-- Get feature type
	EXECUTE 'SELECT lower(feature_type) FROM cat_feature WHERE  (parent_layer = $1 OR child_layer = $1) LIMIT 1'
		INTO v_featuretype
		USING v_tablename;
	v_featuretype := LOWER(v_featuretype); 
	v_featuretype := COALESCE(v_featuretype, ''); 

	-- Get vdefault values
	-- Create List
	list_values = ARRAY['from_date_vdefault','to_date_vdefault','parameter_vdefault','om_param_type_vdefault','edit_doc_type_vdefault'];

	FOREACH v_value IN ARRAY list_values
	LOOP
		EXECUTE 'SELECT value
		FROM config_param_user WHERE parameter = '|| quote_literal(v_value) ||' AND cur_user = current_user'
		INTO v_vdefault_values;
		v_vdefault_array := gw_fct_json_object_set_key(v_vdefault_array, v_value, COALESCE(v_vdefault_values));
	END LOOP;

	-- Control NULL's
	v_vdefault_array := COALESCE(v_vdefault_array, '[]'); 
	
	-- Get id column
	EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
		INTO v_idname
		USING v_tablename;
	
	-- For views it suposse pk is the first column
	IF v_idname ISNULL THEN
		EXECUTE '
		SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
		AND t.relname = $1 
		AND s.nspname = $2
		ORDER BY a.attnum LIMIT 1'
		INTO v_idname
		USING v_tablename, v_schemaname;
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
			USING v_schemaname, v_tablename, v_idname
			INTO column_type;

	-- Get geometry_column
	------------------------------------------
        EXECUTE 'SELECT attname FROM pg_attribute a        
            JOIN pg_class t on a.attrelid = t.oid
            JOIN pg_namespace s on t.relnamespace = s.oid
            WHERE a.attnum > 0 
            AND NOT a.attisdropped
            AND t.relname = $1
            AND s.nspname = $2
            AND left (pg_catalog.format_type(a.atttypid, a.atttypmod), 8)=''geometry''
            ORDER BY a.attnum
			LIMIT 1'
            INTO v_the_geom
            USING v_tablename, v_schemaname;
           
	-- Get geometry (to feature response)
	------------------------------------------
	IF v_the_geom IS NOT NULL AND v_id IS NOT NULL THEN
		EXECUTE 'SELECT row_to_json(row) FROM (SELECT St_AsText('||quote_ident(v_the_geom)||') FROM '||quote_ident(v_tablename)||' WHERE '||quote_ident(v_idname)||' = CAST('||quote_nullable(v_id)||' AS '||(column_type)||'))row'
		INTO v_geometry;
	END IF;
	
	-- Get link (if exists) for the layer
	------------------------------------------
	link_id_aux := (SELECT link_id FROM config_info_layer WHERE layer_id=v_tablename);

	IF  link_id_aux IS NOT NULL THEN 

		-- Get link field value
		EXECUTE 'SELECT row_to_json(row) FROM (SELECT '||quote_ident(link_id_aux)||' FROM '||quote_ident(v_tablename)||' WHERE '||quote_ident(v_idname)||' = CAST('||quote_nullable(v_id)||' AS '||(column_type)||'))row'
		INTO v_linkpath;

		-- IF v_linkpath is null and layer it's child layer --> parent v_linkpath is used
		IF v_linkpath IS NULL AND v_table_parent IS NOT NULL THEN
			-- Get link field value
			EXECUTE 'SELECT row_to_json(row) FROM (SELECT '||quote_ident(link_id_aux)||' FROM '||quote_ident(v_tablename)||' WHERE '||quote_ident(v_idname)||' = CAST('||quote_nullable(v_id)||' AS '||(column_type)||'))row'
			INTO v_linkpath;
		END IF;
	END IF;

	-- Get tabs for form
	--------------------------------
		IF v_isgrafdelimiter OR upper(v_project_type) != 'WS' THEN
	        EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT tabname as "tabName", label as "tabLabel", tooltip as "tooltip", tabfunction as "tabFunction", tabactions as tabActions 
			FROM config_form_tabs WHERE formname = $1) a'
	        INTO form_tabs
	        USING v_tablename;
	    ELSIF v_isepatoarc THEN
	    	EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT tabname as "tabName", label as "tabLabel", tooltip as "tooltip", tabfunction as "tabFunction", 
			b.tab as tabActions  FROM (SELECT json_agg(item_object) as tab FROM config_form_tabs, jsonb_array_elements(tabactions::jsonb) 
			with ordinality arr(item_object, position) where formname =$1
			and item_object->>''actionName'' != ''actionMapZone'' group by tabname) b,
			config_form_tabs WHERE formname =$1)a'
			INTO form_tabs
	        USING v_tablename;
	    ELSE
	    	EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT tabname as "tabName", label as "tabLabel", tooltip as "tooltip", tabfunction as "tabFunction", 
			b.tab as tabActions  FROM (SELECT json_agg(item_object) as tab FROM config_form_tabs, jsonb_array_elements(tabactions::jsonb) 
			with ordinality arr(item_object, position) where formname =$1
			and item_object->>''actionName'' != ''actionSetToArc'' and item_object->>''actionName'' != ''actionMapZone'' group by tabname) b,
			config_form_tabs WHERE formname =$1)a'
			 INTO form_tabs
	         USING v_tablename;
	    END IF;

	-- IF form_tabs is null and layer it's child layer it's child layer --> parent form_tabs is used
        IF v_linkpath IS NULL AND v_table_parent IS NOT NULL THEN
        	
        	IF v_isgrafdelimiter OR upper(v_project_type) != 'WS' THEN
			-- Get form_tabs
				EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT tabname as "tabName", label as "tabLabel", tooltip as "tooltip", tabfunction as "tabFunction", 
				tabactions as tabActions FROM config_form_tabs WHERE formname = $1) a'
				INTO form_tabs
				USING v_table_parent;
			ELSIF v_isepatoarc THEN
				EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT tabname as "tabName", label as "tabLabel", tooltip as "tooltip", tabfunction as "tabFunction", 
				b.tab as tabActions  FROM (SELECT json_agg(item_object) as tab FROM config_form_tabs, jsonb_array_elements(tabactions::jsonb) 
				with ordinality arr(item_object, position) where formname =$1
				and item_object->>''actionName'' != ''actionMapZone'' group by tabname) b,
				config_form_tabs WHERE formname =$1)a'
				INTO form_tabs
		        USING v_table_parent;
			ELSE
		    	EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT tabname as "tabName", label as "tabLabel", tooltip as "tooltip", tabfunction as "tabFunction", 
				b.tab as tabActions  FROM (SELECT json_agg(item_object) as tab FROM config_form_tabs, jsonb_array_elements(tabactions::jsonb) 
				with ordinality arr(item_object, position) where formname =$1
				and item_object->>''actionName'' != ''actionSetToArc'' and item_object->>''actionName'' != ''actionMapZone'' group by tabname) b,
				config_form_tabs WHERE formname =$1)a'
				INTO form_tabs
		        USING v_table_parent;
		    END IF;
	END IF;

	-- Getting actions and layer manager
	------------------------------------------
        EXECUTE 'SELECT actions,  layermanager FROM config_form WHERE formname = $1 AND projecttype='||quote_literal(LOWER(v_project_type))
		INTO v_formactions, v_layermanager
		USING v_tablename;

	-- IF actions and tooltip are null's and layer it's child layer --> parent form_tabs is used
        IF v_formactions IS NULL AND v_table_parent IS NOT NULL THEN
		EXECUTE 'SELECT actions,  layermanager FROM config_form WHERE formname = $1 AND projecttype='||quote_literal(LOWER(v_project_type))
			INTO v_formactions, v_layermanager
			USING v_table_parent;
		END IF;

	-- Check if it is parent table 
	-------------------------------------
        IF v_tablename IN (SELECT layer_id FROM config_info_layer WHERE is_parent IS TRUE) AND v_toolbar !='epa' AND v_id IS NOT NULL THEN

		parent_child_relation:=true;

		-- check parent_view
		EXECUTE 'SELECT tableparent_id from config_info_layer WHERE layer_id=$1'
			INTO tableparent_id_arg
			USING v_tablename;
                
		raise notice'Parent-Child. Table parent: %' , tableparent_id_arg;

		-- Identify tableinfotype_id		
		EXECUTE' SELECT tableinfotype_id FROM cat_feature
			JOIN config_info_layer_x_type ON child_layer=tableinfo_id
			WHERE cat_feature.id= (SELECT custom_type FROM '||quote_ident(tableparent_id_arg)||' WHERE nid::text=$1) 
			AND infotype_id=$2'
			INTO v_tablename
			USING v_id, v_infotype;

		raise notice'Parent-Child. Table child: %, v_infotype: %' , v_tablename, v_infotype;

	-- parent, and epa toolbar
	ELSIF v_tablename IN (SELECT layer_id FROM config_info_layer WHERE is_parent IS TRUE) AND v_toolbar ='epa' THEN

		parent_child_relation:=true;
		v_tablename_original = v_tablename;

		raise notice'Parent-Child. Table child: %, v_infotype: %' , v_tablename, v_infotype;

		-- check parent_epa_view
		EXECUTE 'SELECT tableparentepa_id from config_info_layer WHERE layer_id=$1'
			INTO tableparent_id_arg
			USING v_tablename;
	
		-- Identify tableinfo
		EXECUTE' SELECT epatable FROM '||quote_ident(tableparent_id_arg)||' WHERE nid::text=$1'
			INTO v_tablename
			USING v_id;

			raise notice'Parent-Child with epa table. Table child: %' , v_tablename;

		IF v_tablename IS NULL THEN

			v_message  = '{"level":1, "text":"Epa type is not defined for this feature. Basic values are used"}';

			-- check parent_view
			EXECUTE 'SELECT tableparent_id from config_info_layer WHERE layer_id=$1'
				INTO tableparent_id_arg
				USING v_tablename_original;

			-- Identify tableinfotype_id		
			EXECUTE' SELECT tableinfotype_id FROM cat_feature
				JOIN config_info_layer_x_type ON child_layer.tableinfo_id
				WHERE cat_feature.id= (SELECT custom_type FROM '||quote_ident(tableparent_id_arg)||' WHERE nid::text=$1) 
				AND infotype_id=$2'
				INTO v_tablename
				USING v_id, v_infotype;	
		END IF;
					
	-- not parent, not editable and has tableinfo_id
	ELSIF v_tablename IN (SELECT layer_id FROM config_info_layer WHERE is_parent IS FALSE AND is_editable IS FALSE AND tableinfo_id IS NOT NULL) THEN

		-- Identify tableinfotype_id 
		EXECUTE 'SELECT tableinfotype_id FROM config_info_layer
		JOIN config_info_layer_x_type ON config_info_layer.tableinfo_id=config_info_layer_x_type.tableinfo_id
		WHERE layer_id=$1 AND infotype_id=$2'
			INTO v_tablename
		USING v_tablename, v_infotype;
		raise notice 'NO parent-child, NO editable, Informable: %, v_infotype: %' , v_tablename, v_infotype;

	-- Check if it is not parent, not editable and has not tableinfo_id (is not informable)
	ELSIF v_tablename IN (SELECT layer_id FROM config_info_layer WHERE is_parent IS FALSE AND is_editable IS FALSE AND tableinfo_id IS NULL) THEN 
		v_tablename= null;
		raise notice 'NO parent-child, NO editable NO informable: %' , v_tablename;
        END IF;

	-- Get child type
	EXECUTE 'SELECT id FROM cat_feature WHERE child_layer = $1 LIMIT 1'
		INTO v_childtype
		USING v_tablename;
	v_childtype := COALESCE(v_childtype, ''); 
	
	-- Propierties of info layer's
	------------------------------
	IF v_tablename IS NULL THEN 

		v_message='{"level":2, "text":"The API is bad configured. Please take a look on table config layers (config_info_layer_x_type or config_info_layer)", "results":0}';
	
	ELSIF v_tablename IS NOT NULL THEN 

		-- Check generic
		-------------------
		IF v_forminfo ISNULL THEN
			v_forminfo := json_build_object('formName','Generic','template','info_generic');
			formid_arg := 'F16';
		END IF;

		-- Add default tab
		---------------------
		form_tabs_json := array_to_json(form_tabs);
	
		-- Form info
		v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'actions', v_formactions);
	
		-- Form Tabs info
		v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'visibleTabs', form_tabs_json);

		-- Zoom to feature margin values
		-- get margin values (The goal of this part is pass margin values to client. As bigger is feature less is margin. For point features, maxcanvasmargin configuration is used)
		EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''basic_info_canvasmargin'') row'
			INTO v_canvasmargin_text;
		v_maxcanvasmargin = (((v_canvasmargin_text::json->>'value')::json->>'maxcanvasmargin')::json->>'mts')::numeric(12,2);
		v_mincanvasmargin = (((v_canvasmargin_text::json->>'value')::json->>'mincanvasmargin')::json->>'mts')::numeric(12,2);

		-- control of null values from config
		IF v_maxcanvasmargin IS NULL then v_maxcanvasmargin=50; END IF;
		IF v_mincanvasmargin IS NULL then v_mincanvasmargin=5; END IF;

		-- Margin calulate
		v_canvasmargin = (SELECT max(c) FROM 
		(SELECT (v_maxcanvasmargin*2-(st_xmax(st_envelope((v_geometry->>'st_astext')::geometry))-st_xmin(st_envelope((v_geometry->>'st_astext')::geometry))))/2 AS c 
		UNION SELECT (v_maxcanvasmargin*2-(st_ymax(st_envelope((v_geometry->>'st_astext')::geometry))-st_ymin(st_envelope((v_geometry->>'st_astext')::geometry))))/2)a)::numeric(12,2);
		IF v_canvasmargin <= v_mincanvasmargin THEN 
			v_canvasmargin = v_mincanvasmargin;
		END IF;
	     
		IF v_islayer THEN
			v_tg_op = 'LAYER';
		ELSIF  v_id IS NULL THEN
			v_tg_op = 'INSERT';
		ELSE
			v_tg_op = 'UPDATE';
		END IF;

		-- Get editability
		------------------------
		IF v_editable IS FALSE THEN 
			v_editable := FALSE;
		ELSE
			EXECUTE 'SELECT gw_fct_getpermissions($${"tableName":"'||quote_ident(v_tablename)||'"}$$::json)'
				INTO v_permissions;
				v_editable := v_permissions->>'isEditable';
		END IF;
	
		--  Get if field's table are configured on config_info_layer_field
		------------------------------------------------------------------
		IF (SELECT distinct formname from config_form_fields WHERE formname=v_tablename) IS NOT NULL THEN 
			v_configtabledefined  = TRUE;
		ELSE 
			v_configtabledefined  = FALSE;
		END IF;
	
		-- Get form type
		IF v_editable = TRUE AND v_configtabledefined = TRUE THEN
			v_formtype := 'custom_feature';
		ELSIF v_editable = TRUE AND v_configtabledefined = FALSE THEN
			v_formtype := 'default';
		ELSIF v_editable = FALSE AND v_configtabledefined = TRUE THEN
			v_formtype := 'custom_feature';
		ELSIF v_editable = FALSE AND v_configtabledefined = FALSE THEN
			v_formtype := 'default';
		END IF;



		-- call fields function
		-------------------
		IF v_editable THEN

			-- getting id from URN
			IF v_id IS NULL AND v_islayer is not true THEN
				v_id = (SELECT nextval('SCHEMA_NAME.urn_id_seq'));
			END IF;

			RAISE NOTICE 'User has permissions to edit table % using id %', v_tablename, v_id;
			-- call edit form function
			EXECUTE 'SELECT gw_fct_getfeatureupsert($1, $2, $3, $4, $5, $6, $7, $8, $9)'
			INTO v_fields
			USING v_tablename, v_id, v_inputgeometry, v_device, v_infotype, v_tg_op, v_configtabledefined, v_idname, column_type;
	
			-- in case of insert status must be failed when topocontrol fails
			IF (v_fields->>'status')='Failed' THEN
				v_message = (v_fields->>'message');
				v_status = 'Failed';
			END IF;
						
		ELSIF v_editable = FALSE OR v_islayer THEN 
		
			RAISE NOTICE 'User has NOT permissions to edit table % using id %', v_tablename, v_id;
			-- call info form function
			EXECUTE 'SELECT gw_fct_getfeatureinfo($1, $2, $3, $4, $5, $6, $7, $8)'
			INTO v_fields
			USING v_tablename, v_id, v_device, v_infotype, v_configtabledefined, v_idname, column_type, v_tg_op;
		END IF;


	ELSE
		IF (SELECT distinct formname from config_form_fields WHERE formname=v_table_parent) IS NOT NULL THEN 
			v_configtabledefined  = TRUE;
		ELSE 
			v_configtabledefined  = FALSE;
		END IF;
		
		-- call info form function for parent layer
		EXECUTE 'SELECT gw_fct_getfeatureinfo($1, $2, $3, $4, $5, $6, $7, $8)'
		INTO v_fields
		USING v_table_parent, v_id, v_device, v_infotype, v_configtabledefined, v_idname, column_type, v_tg_op;

		IF v_configtabledefined IS FALSE  THEN
			v_forminfo := json_build_object('formName','F16','template','GENERIC');
		END IF;
        
	END IF;

	-- Feature info
	v_featureinfo := json_build_object('permissions',v_permissions,'tableName',v_tablename,'idName',v_idname,'id',v_id,
		'featureType',v_featuretype, 'childType', v_childtype, 'tableParent',v_table_parent, 'schemaName', v_schemaname,
		'geometry', v_geometry, 'zoomCanvasMargin',concat('{"mts":"',v_canvasmargin,'"}')::json, 'vdefaultValues',v_vdefault_array);


	v_tablename:= (to_json(v_tablename));
	v_table_parent:= (to_json(v_table_parent));

	--    Hydrometer 'id' fix
	------------------------
	IF v_idname = 'sys_hydrometer_id' THEN
		v_idname = 'hydrometer_id';
	END IF;
		
	-- message for null
	IF v_tablename IS NULL THEN
		v_message='{"level":0, "text":"No feature found", "results":0}';
	END IF;

    	--    Control NULL's
	----------------------
	v_forminfo := COALESCE(v_forminfo, '{}');
	v_featureinfo := COALESCE(v_featureinfo, '{}');
	v_linkpath := COALESCE(v_linkpath, '{}');
	v_parentfields := COALESCE(v_parentfields, '{}');
	v_fields := COALESCE(v_fields, '{}');
	v_message := COALESCE(v_message, '{}');

	--    Return
	-----------------------
	RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":'||v_message||', "apiVersion":' || v_version ||
	      ',"body":{"form":' || v_forminfo ||
		     ', "feature":'|| v_featureinfo ||
		      ',"data":{"linkPath":' || v_linkpath ||
		      	      ',"editable":' || v_editable ||
			      ',"parentFields":' || v_parentfields ||
			      ',"fields":' || v_fields || 
			      '}'||
			'}'||
		'}')::json, 2582);

	-- Exception handling
	 EXCEPTION WHEN OTHERS THEN
	 GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;  
	 RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_errcontext) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  