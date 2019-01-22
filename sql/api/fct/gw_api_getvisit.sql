/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2604

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getvisit(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
--new call
SELECT SCHEMA_NAME.gw_api_getvisit($${
"client":{"device":3,"infoType":100,"lang":"es"},
"form":{},
"data":{"relatedFeature":{"type":"arc", "id":"2080"},
	"fields":{},"pageInfo":null}}$$)

--insertfile action with insert visit (visit null or visit not existing yet on database)
SELECT SCHEMA_NAME.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"featureType":"visit","tableName":"ve_visit_arc_insp","idName":"visit_id", "id":null},
"form":{"tabData":{"active":true}, "tabFiles":{"active":false}, "navigation":{"currentActiveTab":"tabData"}},
"data":{"relatedFeature":{"type":"arc", "id":"2001"},
    "fields":{"class_id":"1","arc_id":"2001","visitcat_id":"1","desperfectes_arc":"2","neteja_arc":"3"},
    "pageInfo":{"orderBy":"tstamp", "orderType":"DESC", "currentPage":3},
    "newFile": {"fileFields":{"visit_id":null, "hash":"testhash", "url":"urltest", "filetype":"png"},
            "deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}}}$$)

-- change from tab data to tab files (upserting data on tabData)
SELECT SCHEMA_NAME.gw_api_getvisit($${
"client":{"device":3,"infoType":100,"lang":"es"},
"feature":{"featureType":"visit","tableName":"ve_visit_arc_insp","idName":"visit_id","id":1001},
"form":{"tabData":{"active":false}, "tabFiles":{"active":true},"navigation":{"currentActiveTab":"tabData"}},
"data":{"relatedFeature":{"type":"arc", "id":"2080"},
        "fields":{"class_id":"1","arc_id":"2001","visitcat_id":"1","desperfectes_arc":"2","neteja_arc":"3"},
	"pageInfo":null}}$$)

--tab files
SELECT SCHEMA_NAME.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"featureType":"visit","tableName":"ve_visit_arc_insp","idName":"visit_id","id":10002},
"form":{"tabData":{"active":false}, "tabFiles":{"active":true}}, 
"data":{"relatedFeature":{"type":"arc"},
	"filterFields":{"filetype":"doc","limit":10},
	"pageInfo":{"orderBy":"tstamp", "orderType":"DESC", "currentPage":3}
	}}$$)

-- deletefile action
SELECT SCHEMA_NAME.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"id":1135},
"form":{"tabData":{"active":false},"tabFiles":{"active":true}, "},
"data":{"relatedFeature":{"type":"arc"},
    "filterFields":{"filetype":"doc","limit":10},
    "pageInfo":{"orderBy":"tstamp", "orderType":"DESC", "currentPage":3},
    "deleteFile": {"feature":{"id":1127}}}}$$)
*/

DECLARE
	v_apiversion text;
	v_schemaname text;
	v_featuretype text;
	v_visitclass integer;
	v_id text;
	v_idname text;
	v_columntype text;
	v_device integer;
	v_formname text;
	v_tablename text;
	v_fields json [];
	v_fields_text text [];
	v_fields_json json;
	v_forminfo json;
	v_formheader text;
	v_formactions text;
	v_formtabs text;
	v_tabaux json;
	v_active boolean;
	v_featureid varchar ;
	aux_json json;
	v_tab record;
	v_projecttype varchar;
	v_list json;
	v_activedatatab boolean;
	v_activefilestab boolean;
	v_client json;
	v_pageinfo json;
	v_layermanager json;
	v_filterfields json;
	v_data json;
	isnewvisit boolean;
	v_feature json;
	v_addfile json;
	v_deletefile json;
	v_filefeature json;
	v_fileid text;
	v_message json;
	v_message1 text;
	v_message2 text;
	v_return json;
	v_currentactivetab text;
	v_values json;
	array_index integer DEFAULT 0;
	v_fieldvalue text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname := 'SCHEMA_NAME';

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO v_apiversion;

	-- get project type
	SELECT wsoftware INTO v_projecttype FROM version LIMIT 1;

	--  get parameters from input
	v_client = (p_data ->>'client')::json;
	v_device = ((p_data ->>'client')::json->>'device')::integer;
	v_id = ((p_data ->>'feature')::json->>'id')::integer;
	v_featureid = (((p_data ->>'data')::json->>'relatedFeature')::json->>'id');
	v_featuretype = (((p_data ->>'data')::json->>'relatedFeature')::json->>'type');
	v_activedatatab = (((p_data ->>'form')::json->>'tabData')::json->>'active')::boolean;
	v_activefilestab = (((p_data ->>'form')::json->>'tabFiles')::json->>'active')::boolean;
	v_addfile = ((p_data ->>'data')::json->>'newFile')::json;
	v_deletefile = ((p_data ->>'data')::json->>'deleteFile')::json;
	v_currentactivetab = (((p_data ->>'form')::json->>'navigation')::json->>'currentActiveTab')::text;
	v_visitclass = ((p_data ->>'data')::json->>'fields')::json->>'class_id';

	--  get visitclass
	IF v_visitclass IS NULL THEN 
		IF v_id IS NULL OR (SELECT id FROM SCHEMA_NAME.om_visit WHERE id=v_id::bigint) IS NULL THEN
	
			v_visitclass := (SELECT value FROM config_param_user WHERE parameter = concat('visitclass_vdefault_', v_featuretype) AND cur_user=current_user)::integer;		
			IF v_visitclass IS NULL THEN
				v_visitclass := (SELECT id FROM om_visit_class WHERE feature_type=upper(v_featuretype) LIMIT 1);
			END IF;
		ELSE 
			v_visitclass := (SELECT class_id FROM SCHEMA_NAME.om_visit WHERE id=v_id::bigint);
			IF v_visitclass IS NULL THEN
				v_visitclass := 0;
			END IF;
		END IF;
	END IF;
	
	-- getting visit id
	IF v_id IS NULL THEN
		v_id := ((SELECT max(id)+1 FROM om_visit)+1);
		isnewvisit = true;
	ELSE
		isnewvisit = false;
	END IF;

	--  get formname and tablename
	v_formname := (SELECT formname FROM config_api_visit WHERE visitclass_id=v_visitclass);
	v_tablename := (SELECT tablename FROM config_api_visit WHERE visitclass_id=v_visitclass);

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
			INTO v_columntype;

	RAISE NOTICE '--- VISIT PARAMETERS: newvisitform: % featuretype: %,  visitclass: %,  v_visit: %,  formname: %,  tablename: %,  idname: %, columntype %, device: % ---',isnewvisit, v_featuretype, v_visitclass, v_id, v_formname, v_tablename, v_idname, v_columntype, v_device;

	-- upserting data on tabData
	IF v_currentactivetab = 'tabData' THEN
					
		SELECT gw_api_setvisit (p_data) INTO v_return;
		v_id = ((v_return->>'body')::json->>'feature')::json->>'id';
		v_message = (v_return->>'message');

		RAISE NOTICE '--- UPSERT VISIT CALLING gw_api_setvisit WITH MESSAGE: % ---', v_message;
		
	END IF;

	-- manage actions
	v_filefeature = '{"featureType":"file", "tableName":"om_visit_file", "idName": "id"}';	

	IF v_addfile IS NOT NULL THEN

		RAISE NOTICE '--- ACTION ADD FILE /PHOTO ---';

		-- setting input for insert files function
		v_fields_json = gw_fct_json_object_set_key((v_addfile->>'fileFields')::json,'visit_id', v_id::text);
		v_addfile = gw_fct_json_object_set_key(v_addfile, 'fileFields', v_fields_json);
		v_addfile = replace (v_addfile::text, 'fileFields', 'fields');
		v_addfile = concat('{"data":',v_addfile::text,'}');
		v_addfile = gw_fct_json_object_set_key(v_addfile, 'feature', v_filefeature);
		v_addfile = gw_fct_json_object_set_key(v_addfile, 'client', v_client);

		RAISE NOTICE '--- CALL gw_api_setfileinsert PASSING (v_addfile): % ---', v_addfile;
	
		-- calling insert files function
		SELECT gw_api_setfileinsert (v_addfile) INTO v_addfile;

		-- building message
		v_message1 = v_message::text;
		v_message = (v_addfile->>'message');
		v_message = gw_fct_json_object_set_key(v_message, 'hint', v_message1);

	ELSIF v_deletefile IS NOT NULL THEN

		-- setting input function
		v_fileid = ((v_deletefile ->>'feature')::json->>'id')::text;
		v_filefeature = gw_fct_json_object_set_key(v_filefeature, 'id', v_fileid);
		v_deletefile = gw_fct_json_object_set_key(v_deletefile, 'feature', v_filefeature);

		RAISE NOTICE '--- CALL gw_api_setdelete PASSING (v_deletefile): % ---', v_deletefile;

		-- calling input function
		SELECT gw_api_setdelete(v_deletefile) INTO v_deletefile;
		v_message = (v_deletefile ->>'message')::json;
		
	END IF;
   
	--  Create tabs array	
	v_formtabs := '[';
       
		-- Data tab
		-----------
		IF v_activedatatab OR (v_activedatatab IS NOT TRUE AND v_visitclass > 0 AND v_activefilestab IS NOT TRUE) THEN

			IF isnewvisit IS TRUE THEN
				
				RAISE NOTICE ' --- GETTING tabData DEFAULT VALUES ON NEW VISIT ---';
				SELECT gw_api_get_formfields( v_formname, 'visit', 'data', null, null, null, null, 'INSERT', null, v_device) INTO v_fields;

				FOREACH aux_json IN ARRAY v_fields
				LOOP

					-- setting feature id value
					IF (aux_json->>'column_id') = 'arc_id' OR (aux_json->>'column_id')='node_id' OR (aux_json->>'column_id')='connec_id' OR (aux_json->>'column_id') ='gully_id' THEN
						v_fields[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(v_fields[(aux_json->>'orderby')::INT], 'value', v_featureid);
						RAISE NOTICE ' --- SETTING feature id VALUE % ---',v_featureid ;

					END IF;

					-- setting visit id value
					IF (aux_json->>'column_id') = 'visit_id' THEN
						v_fields[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(v_fields[(aux_json->>'orderby')::INT], 'value', v_id);
						RAISE NOTICE ' --- SETTING visit id VALUE % ---',v_id ;
					END IF;
					
					-- setting visitclass value
					IF (aux_json->>'column_id') = 'class_id' THEN
						v_fields[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(v_fields[(aux_json->>'orderby')::INT], 'selectedId', v_visitclass::text);
						RAISE NOTICE ' --- SETTING visitclass VALUE % ---',v_visitclass ;
	
					END IF;

					
				END LOOP;
			ELSE 
				
				SELECT gw_api_get_formfields( v_formname, 'visit', 'data', null, null, null, null, 'INSERT', null, v_device) INTO v_fields;

				RAISE NOTICE ' --- GETTING tabData VALUES ON VISIT % ---',v_fields ;

				-- getting values from feature
				EXECUTE 'SELECT (row_to_json(a)) FROM 
					(SELECT * FROM '||v_tablename||' WHERE '||v_idname||' = CAST($1 AS '||v_columntype||'))a'
					INTO v_values
					USING v_id;
	
				raise notice 'v_values %', v_values;
				
				-- setting values
				FOREACH aux_json IN ARRAY v_fields 
				LOOP          
					array_index := array_index + 1;
					v_fieldvalue := (v_values->>(aux_json->>'column_id'));
		
					IF (aux_json->>'widgettype')='combo' THEN 
						v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'selectedId', COALESCE(v_fieldvalue, ''));
					ELSE 
						v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'value', COALESCE(v_fieldvalue, ''));
					END IF;
				END LOOP;			
			END IF;	

			v_fields_json = array_to_json (v_fields);

			v_fields_json := COALESCE(v_fields_json, '{}');	

			RAISE NOTICE ' --- FILLING tabData with v_fields_json % ---', v_fields_json;
	

		END IF;

		SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visit' AND tabname='tabData' and device = v_device LIMIT 1;

		IF v_tab IS NULL THEN 
			SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visit' AND tabname='tabData' LIMIT 1;
		END IF;

		v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.tablabel, 'tabText',v_tab.tabtext, 
			'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active',v_activedatatab);
		v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
		v_formtabs := v_formtabs || v_tabaux::text;

		RAISE NOTICE ' --- BUILDING tabData with v_tabaux % ---', v_tabaux;

		-- Events tab
		-------------
		IF v_visitclass=0 THEN

			v_tabaux := json_build_object('tabName','tabEvent','tabLabel','Events','tabText','Test text for tab','active',false);
			v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
			v_formtabs := v_formtabs || ',' || v_tabaux::text;

			RAISE NOTICE ' --- BUILDING tabFiles with v_tabaux % ---', v_tabaux;

		END IF;


		-- Files tab
		------------
		--show tab only if it is not new visit
		IF isnewvisit IS FALSE THEN

			--filling tab (only if it's active)
			IF v_activefilestab THEN

				-- getting filterfields
				IF v_currentactivetab = 'tabFiles' THEN
					v_filterfields := ((p_data->>'data')::json->>'fields')::json;
				END IF;

				-- setting filterfields
				v_data := (p_data->>'data');
				v_filterfields := gw_fct_json_object_set_key(v_filterfields, 'visit_id', v_id);
				v_data := gw_fct_json_object_set_key(v_data, 'filterFields', v_filterfields);
				p_data := gw_fct_json_object_set_key(p_data, 'data', v_data);

				-- getting feature
				v_feature := '{"tableName":"om_visit_file"}';		
			
				-- setting feature
				p_data := gw_fct_json_object_set_key(p_data, 'feature', v_feature);

				--refactor tabNames
				p_data := replace (p_data::text, 'tabFeature', 'feature');
			
				RAISE NOTICE '--- CALLING gw_api_getlist USING p_data: % ---', p_data;
				SELECT gw_api_getlist (p_data) INTO v_fields_json;

				-- getting pageinfo and list values
				v_pageinfo = ((v_fields_json->>'body')::json->>'data')::json->>'pageInfo';
				v_fields_json = ((v_fields_json->>'body')::json->>'data')::json->>'fields';
			END IF;
	
			v_fields_json := COALESCE(v_fields_json, '{}');

			-- building tab
			SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visit' AND tabname='tabFiles' and device = v_device LIMIT 1;
		
			IF v_tab IS NULL THEN 
				SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visit' AND tabname='tabFiles' LIMIT 1;
			END IF;
		
			v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.tablabel, 'tabText',v_tab.tabtext, 
				'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active', v_activefilestab);
				
			v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);

			RAISE NOTICE ' --- BUILDING tabFiles with v_tabaux % ---', v_tabaux;

	 		-- setting pageInfo
			v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'pageInfo', v_pageinfo);
			v_formtabs := v_formtabs  || ',' || v_tabaux::text;
		END IF; 		

	--closing tabs array
	v_formtabs := (v_formtabs ||']');

	-- header form
	v_formheader :=concat('VISIT - ',v_id);	

	-- actions and layermanager
	EXECUTE 'SELECT actions, layermanager FROM config_api_form WHERE formname = ''visit'' AND projecttype ='||quote_literal(LOWER(v_projecttype))
			INTO v_formactions, v_layermanager;

	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formActions', v_formactions);
		
	-- Create new form
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formId', 'F11'::text);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formName', v_formheader);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formTabs', v_formtabs::json);
	

	--  Control NULL's
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_id := COALESCE(v_id, '{}');
	v_message := COALESCE(v_message, '{}');
	v_forminfo := COALESCE(v_forminfo, '{}');
	v_tablename := COALESCE(v_tablename, '{}');
	v_layermanager := COALESCE(v_layermanager, '{}');
  
	-- Return
	RETURN ('{"status":"Accepted", "message":'||v_message||', "apiVersion":'||v_apiversion||
             ',"body":{"feature":{"featureType":"visit", "tableName":"'||v_tablename||'", "idName":"visit_id", "id":'||v_id||'}'||
		    ', "form":'||v_forminfo||
		    ', "data":{"layerManager":'||v_layermanager||'}}'||
		    '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



