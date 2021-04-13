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
form_tabs json[];
form_tablabel varchar[];
form_tabs_json json;
v_fields json;
formid_arg text;
tableparent_id_arg text;
parent_child_relation boolean = false;
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
--v_layermanager json;
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
v_isarcdivide boolean = false;
v_querystring text;
v_debug_vars json;
v_debug json;
v_msgerr json;

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
	IF v_addschema NOT IN (NULL, 'NULL') AND v_addschema != v_schemaname AND v_flag IS FALSE THEN
		v_querystring = concat('SET search_path = ',v_addschema,', public');
		v_debug_vars := json_build_object('v_addschema', v_addschema);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 10);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring;

		SELECT gw_fct_getinfofromid(p_data) INTO v_return;
		SET search_path = 'SCHEMA_NAME', public;
		RETURN v_return;
	END IF;
	
	IF v_toolbar is NULL THEN
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

		IF (SELECT isarcdivide FROM cat_feature_node JOIN cat_feature USING (id) WHERE child_layer=v_tablename) IS TRUE THEN
				v_isarcdivide = TRUE;
		END IF;
	ELSE
		-- tablename is used as table parent.
		v_table_parent = v_tablename;
		IF v_id IS NOT NULL THEN 
	
			IF v_table_parent='v_edit_node' THEN
				
				v_querystring = concat('SELECT node_type FROM ',v_table_parent,' WHERE node_id = ',quote_literal(v_id),';');
				
				v_debug_vars := json_build_object('v_table_parent', v_table_parent, 'v_id', v_id);
				v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 20);
				SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
				EXECUTE v_querystring INTO v_nodetype;
				
				IF (SELECT isarcdivide FROM cat_feature_node WHERE id=v_nodetype) IS TRUE THEN
					v_isarcdivide = TRUE;
				END IF;
				IF upper(v_project_type) = 'WS' THEN
					IF ((SELECT upper(graf_delimiter) FROM cat_feature_node WHERE id=v_nodetype) IN ('DMA','PRESSZONE')) THEN
						v_isgrafdelimiter = TRUE;
					ELSIF (SELECT upper(epa_type) FROM node WHERE node_id = v_id) IN ('PUMP', 'VALVE', 'SHORTPIPE') THEN
						v_isepatoarc = TRUE;
					END IF;
				END IF;
				
			END IF;
		END IF;
	END IF;

	-- get tableparent fields
	v_querystring = concat('SELECT to_json(array_agg(columnname)) FROM 
		(SELECT a.attname as columnname FROM pg_attribute a JOIN pg_class t on a.attrelid = t.oid JOIN pg_namespace s on t.relnamespace = s.oid
		WHERE a.attnum > 0 AND NOT a.attisdropped AND t.relname = ',quote_nullable(v_table_parent),' AND s.nspname = ',quote_nullable(v_schemaname),'	ORDER BY a.attnum) a');
	v_debug_vars := json_build_object('v_table_parent', v_table_parent, 'v_schemaname', v_schemaname);
	v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 30);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
	EXECUTE v_querystring INTO v_parentfields;

	v_parentfields = replace (v_parentfields::text, '{', '[');
	v_parentfields = replace (v_parentfields::text, '}', ']');

	--      Get form (if exists) for the layer 
	------------------------------------------
        -- to build json
	v_querystring = concat('SELECT row_to_json(row) FROM (SELECT formtemplate AS template, headertext AS "headerText"
				FROM config_info_layer WHERE layer_id = ',quote_nullable(v_tablename),' LIMIT 1) row');
	v_debug_vars := json_build_object('v_tablename', v_tablename);
	v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 40);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
	EXECUTE v_querystring INTO v_forminfo;

        -- IF v_forminfo is null and it's layer it's child layer --> parent form info is used
        IF v_forminfo IS NULL AND v_table_parent IS NOT NULL THEN
		v_querystring = concat('SELECT row_to_json(row) FROM (SELECT formtemplate AS template , headertext AS "headerText"
					FROM config_info_layer WHERE layer_id = ',quote_nullable(v_table_parent),' LIMIT 1) row');
		v_debug_vars := json_build_object('v_table_parent', v_table_parent);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 50);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO v_forminfo;
        END IF;
            
	RAISE NOTICE 'Form number: %', v_forminfo;

	-- Get feature type
	v_querystring = concat('SELECT lower(feature_type) FROM cat_feature WHERE  (parent_layer = ',quote_nullable(v_tablename),' OR child_layer = ',quote_nullable(v_tablename),') LIMIT 1');
	v_debug_vars := json_build_object('v_tablename', v_tablename);
	v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 60);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
	EXECUTE v_querystring INTO v_featuretype;
	v_featuretype := LOWER(v_featuretype); 
	v_featuretype := COALESCE(v_featuretype, ''); 

	-- Get vdefault values
	-- Create List
	list_values = ARRAY['from_date_vdefault','to_date_vdefault','parameter_vdefault','om_param_type_vdefault','edit_doc_type_vdefault'];

	FOREACH v_value IN ARRAY list_values
	LOOP
		v_querystring = concat('SELECT value FROM config_param_user WHERE parameter = ',quote_literal(v_value),' AND cur_user = current_user');
		v_debug_vars := json_build_object('v_value', v_value);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 70);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO v_vdefault_values;
		v_vdefault_array := gw_fct_json_object_set_key(v_vdefault_array, v_value, COALESCE(v_vdefault_values));
	END LOOP;

	-- Control NULL's
	v_vdefault_array := COALESCE(v_vdefault_array, '[]'); 
	
	-- Get id column
	v_querystring = concat('SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = ',quote_nullable(v_tablename),'::regclass AND i.indisprimary');
	v_debug_vars := json_build_object('v_tablename', v_tablename);
	v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 80);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
	EXECUTE v_querystring INTO v_idname;
	
	-- For views it suposse pk is the first column
	IF v_idname ISNULL THEN
		v_querystring = concat('
		SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
		AND t.relname = ',quote_nullable(v_tablename),' 
		AND s.nspname = ',quote_nullable(v_schemaname),'
		ORDER BY a.attnum LIMIT 1');
		v_debug_vars := json_build_object('v_tablename', v_tablename, 'v_schemaname', v_schemaname);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 90);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO v_idname;
	END IF;

	-- Get id column type
	v_querystring = concat('SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) FROM pg_attribute a
		JOIN pg_class t on a.attrelid = t.oid
		JOIN pg_namespace s on t.relnamespace = s.oid
		WHERE a.attnum > 0 
		AND NOT a.attisdropped
		AND a.attname = ',quote_nullable(v_idname),'
		AND t.relname = ',quote_nullable(v_tablename),' 
		AND s.nspname = ',quote_nullable(v_schemaname),'
		ORDER BY a.attnum');
	v_debug_vars := json_build_object('v_idname', v_idname, 'v_tablename', v_tablename, 'v_schemaname', v_schemaname);
	v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 100);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
	EXECUTE v_querystring INTO column_type;

	-- Get geometry_column
	------------------------------------------
	v_querystring = concat('SELECT attname FROM pg_attribute a        
            JOIN pg_class t on a.attrelid = t.oid
            JOIN pg_namespace s on t.relnamespace = s.oid
            WHERE a.attnum > 0 
            AND NOT a.attisdropped
            AND t.relname = ',quote_nullable(v_tablename),'
            AND s.nspname = ',quote_nullable(v_schemaname),'
            AND left (pg_catalog.format_type(a.atttypid, a.atttypmod), 8)=''geometry''
            ORDER BY a.attnum
			LIMIT 1');
	v_debug_vars := json_build_object('v_tablename', v_tablename, 'v_schemaname', v_schemaname);
	v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 110);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
	EXECUTE v_querystring INTO v_the_geom;
           
	-- Get geometry (to feature response)
	------------------------------------------
	IF v_the_geom IS NOT NULL AND v_id IS NOT NULL THEN
		v_querystring = concat('SELECT row_to_json(row) FROM (SELECT St_AsText(',quote_ident(v_the_geom),') FROM ',quote_ident(v_tablename),' WHERE ',quote_ident(v_idname),' = CAST(',quote_nullable(v_id),' AS ',(column_type),'))row');
		v_debug_vars := json_build_object('v_the_geom', v_the_geom, 'v_tablename', v_tablename, 'v_idname', v_idname, 'v_id', v_id, 'column_type', column_type);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 120);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO v_geometry;
	END IF;
	
	
	-- Get tabs for form
	--------------------------------
	IF v_isgrafdelimiter THEN 
		v_querystring = concat('SELECT array_agg(row_to_json(a)) FROM (SELECT DISTINCT ON (tabname) tabname as "tabName", label as "tabLabel", tooltip as "tooltip", 
			tabfunction as "tabFunction", b.tab as tabActions 
			FROM (SELECT json_agg(item_object || jsonb_build_object(''actionTooltip'', idval)) as tab 
			FROM config_form_tabs, config_typevalue, jsonb_array_elements(tabactions::jsonb)
			with ordinality arr(item_object, position) where typevalue =''formactions_typevalue'' and formname =',quote_nullable(v_tablename),'
			and item_object->>''actionName'' != ''actionGetArcId'' 
			and item_object->>''actionName''::text = id group by tabname) b,
			config_form_tabs WHERE formname =',quote_nullable(v_tablename),')a');
		v_debug_vars := json_build_object('v_tablename', v_tablename);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 150);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO form_tabs;
	ELSIF v_isepatoarc THEN
		v_querystring = concat('SELECT array_agg(row_to_json(a)) FROM (SELECT DISTINCT ON (tabname) tabname as "tabName", label as "tabLabel", tooltip as "tooltip", 
			tabfunction as "tabFunction", b.tab as tabActions 
			FROM (SELECT json_agg(item_object || jsonb_build_object(''actionTooltip'', idval)) as tab 
			FROM config_form_tabs, config_typevalue, jsonb_array_elements(tabactions::jsonb)
			with ordinality arr(item_object, position) where typevalue =''formactions_typevalue'' and formname =',quote_nullable(v_tablename),'
			and item_object->>''actionName'' != ''actionMapZone'' and item_object->>''actionName'' != ''actionGetArcId'' 
			and item_object->>''actionName''::text = id group by tabname) b,
			config_form_tabs WHERE formname =',quote_nullable(v_tablename),')a');
		v_debug_vars := json_build_object('v_tablename', v_tablename);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 160);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO form_tabs;
	ELSIF v_isarcdivide THEN
		v_querystring = concat('SELECT array_agg(row_to_json(a)) FROM (SELECT DISTINCT ON (tabname) tabname as "tabName", label as "tabLabel", tooltip as "tooltip", tabfunction as "tabFunction", 
			b.tab as tabActions  FROM (SELECT json_agg(item_object || jsonb_build_object(''actionTooltip'', idval)) as tab 
			FROM config_form_tabs, config_typevalue, jsonb_array_elements(tabactions::jsonb)
			with ordinality arr(item_object, position) where typevalue =''formactions_typevalue'' and  formname =',quote_nullable(v_tablename),'
			and item_object->>''actionName'' != ''actionSetToArc'' and item_object->>''actionName'' != ''actionMapZone'' 
			and item_object->>''actionName'' != ''actionGetArcId'' 
			and item_object->>''actionName''::text = id group by tabname) b,
			config_form_tabs WHERE formname =',quote_nullable(v_tablename),')a');
		v_debug_vars := json_build_object('v_tablename', v_tablename);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 170);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO form_tabs;
	ELSE
		v_querystring = concat('SELECT array_agg(row_to_json(a)) FROM (SELECT DISTINCT ON (tabname) tabname as "tabName", label as "tabLabel", tooltip as "tooltip", tabfunction as "tabFunction", 
			b.tab as tabActions  FROM (SELECT json_agg(item_object || jsonb_build_object(''actionTooltip'', idval)) as tab 
			FROM config_form_tabs, config_typevalue, jsonb_array_elements(tabactions::jsonb)
			with ordinality arr(item_object, position) where typevalue =''formactions_typevalue'' and  formname =',quote_nullable(v_tablename),'
			and item_object->>''actionName'' != ''actionSetToArc'' and item_object->>''actionName'' != ''actionMapZone'' 
			and item_object->>''actionName''::text = id group by tabname) b,
			config_form_tabs WHERE formname =',quote_nullable(v_tablename),')a');
		v_debug_vars := json_build_object('v_tablename', v_tablename);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 180);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO form_tabs;
	END IF;

	-- IF form_tabs is null and layer it's child layer it's child layer --> parent form_tabs is used
        IF v_linkpath IS NULL AND v_table_parent IS NOT NULL THEN
        	
        	IF v_isgrafdelimiter THEN 
			-- Get form_tabs
			v_querystring = concat('SELECT array_agg(row_to_json(a)) FROM (SELECT DISTINCT ON (tabname) tabname as "tabName", label as "tabLabel", tooltip as "tooltip",
				tabfunction as "tabFunction", b.tab as tabActions  
				FROM (SELECT json_agg(item_object || jsonb_build_object(''actionTooltip'', idval)) as tab 
				FROM config_form_tabs, config_typevalue, jsonb_array_elements(tabactions::jsonb)
				with ordinality arr(item_object, position) where typevalue =''formactions_typevalue'' and  formname =',quote_nullable(v_table_parent),'
				and item_object->>''actionName'' != ''actionGetArcId'' 
				and item_object->>''actionName''::text = id group by tabname) b,
				config_form_tabs WHERE formname =',quote_nullable(v_table_parent),')a');
			v_debug_vars := json_build_object('v_table_parent', v_table_parent);
			v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 190);
			SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
			EXECUTE v_querystring INTO form_tabs;
		ELSIF v_isepatoarc THEN
			v_querystring = concat('SELECT array_agg(row_to_json(a)) FROM (SELECT DISTINCT ON (tabname) tabname as "tabName", label as "tabLabel", tooltip as "tooltip", 
				tabfunction as "tabFunction", b.tab as tabActions
				FROM (SELECT json_agg(item_object || jsonb_build_object(''actionTooltip'', idval)) as tab 
				FROM config_form_tabs, config_typevalue, jsonb_array_elements(tabactions::jsonb)
				with ordinality arr(item_object, position) where typevalue =''formactions_typevalue'' and  formname =',quote_nullable(v_table_parent),'
				and item_object->>''actionName'' != ''actionMapZone'' and item_object->>''actionName'' != ''actionGetArcId'' 
				and item_object->>''actionName''::text = id group by tabname) b,
				config_form_tabs WHERE formname =',quote_nullable(v_table_parent),')a');
			v_debug_vars := json_build_object('v_table_parent', v_table_parent);
			v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 200);
			SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
			EXECUTE v_querystring INTO form_tabs;
		ELSIF v_isarcdivide THEN
			v_querystring = concat('SELECT array_agg(row_to_json(a)) FROM (SELECT DISTINCT ON (tabname) tabname as "tabName", label as "tabLabel", tooltip as "tooltip", 
		    	tabfunction as "tabFunction", b.tab as tabActions  
		    	FROM (SELECT json_agg(item_object || jsonb_build_object(''actionTooltip'', idval)) as tab 
				FROM config_form_tabs, config_typevalue, jsonb_array_elements(tabactions::jsonb)
				with ordinality arr(item_object, position) where typevalue =''formactions_typevalue'' and  formname =',quote_nullable(v_table_parent),'
				and item_object->>''actionName'' != ''actionSetToArc'' and item_object->>''actionName'' != ''actionMapZone'' 
				and item_object->>''actionName'' != ''actionGetArcId''
				and item_object->>''actionName''::text = id group by tabname) b,
				config_form_tabs WHERE formname =',quote_nullable(v_table_parent),')a');
			v_debug_vars := json_build_object('v_table_parent', v_table_parent);
			v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 210);
			SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
			EXECUTE v_querystring INTO form_tabs;
		ELSE
			v_querystring = concat('SELECT array_agg(row_to_json(a)) FROM (SELECT DISTINCT ON (tabname) tabname as "tabName", label as "tabLabel", tooltip as "tooltip", 
		    	tabfunction as "tabFunction", b.tab as tabActions 
		    	FROM (SELECT json_agg(item_object || jsonb_build_object(''actionTooltip'', idval)) as tab 
				FROM config_form_tabs, config_typevalue, jsonb_array_elements(tabactions::jsonb)
				with ordinality arr(item_object, position) where typevalue =''formactions_typevalue'' and  formname =',quote_nullable(v_table_parent),'
				and item_object->>''actionName'' != ''actionSetToArc'' and item_object->>''actionName'' != ''actionMapZone'' 
				and item_object->>''actionName''::text = id group by tabname) b,
				config_form_tabs WHERE formname =',quote_nullable(v_table_parent),')a');
			v_debug_vars := json_build_object('v_table_parent', v_table_parent);
			v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 220);
			SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
			EXECUTE v_querystring INTO form_tabs;
		END IF;
	END IF;
	
	-- Check if it is parent table 
	-------------------------------------
        IF v_tablename IN (SELECT layer_id FROM config_info_layer WHERE is_parent IS TRUE) AND v_toolbar !='epa' AND v_id IS NOT NULL THEN

		parent_child_relation:=true;

		-- check parent_view
		v_querystring = concat('SELECT tableparent_id from config_info_layer WHERE layer_id=',quote_nullable(v_tablename));
		v_debug_vars := json_build_object('v_tablename', v_tablename);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 250);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO tableparent_id_arg;
                
		-- Identify tableinfotype_id		
		v_querystring = concat(' SELECT tableinfotype_id FROM cat_feature
			JOIN config_info_layer_x_type ON child_layer=tableinfo_id
			WHERE cat_feature.id= (SELECT custom_type FROM ',quote_ident(tableparent_id_arg),' WHERE nid::text=',quote_nullable(v_id),') 
			AND infotype_id=',quote_nullable(v_infotype));
		v_debug_vars := json_build_object('tableparent_id_arg', tableparent_id_arg, 'v_id', v_id, 'v_infotype', v_infotype);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 260);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO v_tablename;

	-- parent, and epa toolbar
	ELSIF v_tablename IN (SELECT layer_id FROM config_info_layer WHERE is_parent IS TRUE) AND v_toolbar ='epa' THEN

		parent_child_relation:=true;
		v_tablename_original = v_tablename;

		-- check parent_epa_view
		v_querystring = concat('SELECT tableparentepa_id from config_info_layer WHERE layer_id=',quote_nullable(v_tablename));
		v_debug_vars := json_build_object('v_tablename', v_tablename);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 270);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO tableparent_id_arg;
	
		-- Identify tableinfo
		v_querystring = concat(' SELECT epatable FROM ',quote_ident(tableparent_id_arg),' WHERE nid::text=',quote_nullable(v_id));
		v_debug_vars := json_build_object('tableparent_id_arg', tableparent_id_arg, 'v_id', v_id);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 280);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO v_tablename;

		IF v_tablename IS NULL THEN

			v_message  = '{"level":1, "text":"Epa type is not defined for this feature. Basic values are used"}';

			-- check parent_view
			v_querystring = concat('SELECT tableparent_id from config_info_layer WHERE layer_id=',quote_nullable(v_tablename_original));
			v_debug_vars := json_build_object('v_tablename_original', v_tablename_original);
			v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 290);
			SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
			EXECUTE v_querystring INTO tableparent_id_arg;

			-- Identify tableinfotype_id		
			v_querystring = concat(' SELECT tableinfotype_id FROM cat_feature
				JOIN config_info_layer_x_type ON child_layer.tableinfo_id
				WHERE cat_feature.id= (SELECT custom_type FROM ',quote_ident(tableparent_id_arg),' WHERE nid::text=',quote_nullable(v_id),') 
				AND infotype_id=',quote_nullable(v_infotype));
			v_debug_vars := json_build_object('tableparent_id_arg', tableparent_id_arg, 'v_id', v_id, 'v_infotype', v_infotype);
			v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 300);
			SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
			EXECUTE v_querystring INTO v_tablename;
		END IF;
					

	-- Check if it is not parent, not editable and has not tableinfo_id (is not informable)
	ELSIF v_tablename IN (SELECT layer_id FROM config_info_layer WHERE is_parent IS FALSE AND is_editable IS FALSE) THEN 
		v_tablename= null;
	END IF;

	-- Get child type
	v_querystring = concat('SELECT id FROM cat_feature WHERE child_layer = ',quote_nullable(v_tablename),' LIMIT 1');
	v_debug_vars := json_build_object('v_tablename', v_tablename);
	v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 320);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
	EXECUTE v_querystring INTO v_childtype;

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
	
		-- Form Tabs info
		v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'visibleTabs', form_tabs_json);
		raise notice 'v_forminfo,%',v_forminfo;
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
			v_querystring = concat('SELECT gw_fct_getpermissions($${"tableName":"',quote_ident(v_tablename),'"}$$::json)');
			v_debug_vars := json_build_object('v_tablename', v_tablename);
			v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 330);
			SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
			EXECUTE v_querystring INTO v_permissions;

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
			v_querystring = concat('SELECT gw_fct_getfeatureupsert(',quote_nullable(v_tablename),', ',quote_nullable(v_id),', ',quote_nullable(v_inputgeometry::text),', ',quote_nullable(v_device),', ',quote_nullable(v_infotype),', ',quote_nullable(v_tg_op),', ',
						quote_nullable(v_configtabledefined),', ',quote_nullable(v_idname),', ',quote_nullable(column_type),');');
			v_debug_vars := json_build_object('v_tablename', v_tablename, 'v_id', v_id, 'v_inputgeometry', v_inputgeometry, 'v_device', v_device, 'v_infotype', v_infotype, 'v_tg_op', v_tg_op, 
							  'v_configtabledefined', v_configtabledefined, 'v_idname', v_idname, 'column_type', column_type);
			v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 340);
			SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
			EXECUTE v_querystring INTO v_fields;
	
			-- in case of insert status must be failed when topocontrol fails
			IF (v_fields->>'status')='Failed' THEN
				v_message = (v_fields->>'message');
				v_status = 'Failed';
			END IF;
						
		ELSIF v_editable = FALSE OR v_islayer THEN 
		
			RAISE NOTICE 'User has NOT permissions to edit table % using id %', v_tablename, v_id;
			-- call info form function
			v_querystring = concat('SELECT gw_fct_getfeatureinfo(',quote_nullable(v_tablename),', ',quote_nullable(v_id),', ',quote_nullable(v_device),', ',quote_nullable(v_infotype),', ',quote_nullable(v_configtabledefined),
						', ',quote_nullable(v_idname),', ',quote_nullable(column_type),', ',quote_nullable(v_tg_op),');');
			v_debug_vars := json_build_object('v_tablename', v_tablename, 'v_id', v_id, 'v_device', v_device, 'v_infotype', v_infotype,
							  'v_configtabledefined', v_configtabledefined, 'v_idname', v_idname, 'column_type', column_type, 'v_tg_op', v_tg_op);
			v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 350);
			SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
			EXECUTE v_querystring INTO v_fields;
		END IF;


	ELSE
		IF (SELECT distinct formname from config_form_fields WHERE formname=v_table_parent) IS NOT NULL THEN 
			v_configtabledefined  = TRUE;
		ELSE 
			v_configtabledefined  = FALSE;
		END IF;
		
		-- call info form function for parent layer
		v_querystring = concat('SELECT gw_fct_getfeatureinfo(',quote_nullable(v_table_parent),', ',quote_nullable(v_id),', ',quote_nullable(v_device),', ',quote_nullable(v_infotype),', ',quote_nullable(v_configtabledefined),', ',
					quote_nullable(v_idname),', ',quote_nullable(column_type),', ',quote_nullable(v_tg_op),');');
		v_debug_vars := json_build_object('v_table_parent', v_table_parent, 'v_id', v_id, 'v_device', v_device, 'v_infotype', v_infotype,
						  'v_configtabledefined', v_configtabledefined, 'v_idname', v_idname, 'column_type', column_type, 'v_tg_op', v_tg_op);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromid', 'flag', 360);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO v_fields;

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
	RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":'||v_message||', "version":' || v_version ||
	      ',"body":{"form":' || v_forminfo ||
		     ', "feature":'|| v_featureinfo ||
		      ',"data":{"linkPath":' || v_linkpath ||
		      	      ',"editable":' || v_editable ||
			      ',"parentFields":' || v_parentfields ||
			      ',"fields":' || v_fields || 
			      '}'||
			'}'||
		'}')::json, 2582, null, null, null);

	-- Exception handling
	 EXCEPTION WHEN OTHERS THEN
	 GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;  
	 RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version || ',"SQLSTATE":' || to_json(SQLSTATE) || ',"MSGERR": '|| to_json(v_msgerr::json ->> 'MSGERR') ||'}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  