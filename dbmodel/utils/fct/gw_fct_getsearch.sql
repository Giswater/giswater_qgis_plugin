/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2600

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getsearch(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getsearch(p_data json)
  RETURNS json AS
$BODY$


/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_getsearch($${"client":{"device": 5, "lang": "es_ES", "cur_user": "bgeo", "infoType": 1}, "form":{}, "feature":{}, "data":{"parameters":{"searchText":""}, "pageInfo":{}}}$$);
SELECT SCHEMA_NAME.gw_fct_getsearch($${"client":{"device": 5, "lang": "es_ES", "cur_user": "bgeo", "infoType": 1}, "form":{}, "feature":{}, "data":{"parameters":{"searchText":"calle"}}, "pageInfo":{}}}$$);

*/

DECLARE

formNetwork json;
formHydro json;
formWorkcat json;
editCode json;
editCode1 json;
editCode2 json;
chkContains json;
comboType json;
comboType1 json;
comboType2 json;
comboType3 json;
v_form text;
combo_json json;
fieldsJson json;
formSearch json;
formPsector json;
v_version text;
formAddress json;
formVisit json;

v_firsttab boolean := FALSE;
v_active boolean;
rec_fields record;

--Address
v_search_vdef text;
v_search_muni_table text;
v_search_muni_id_field text;
v_search_muni_search_field text;
v_search_muni_geom_field text;
v_addschema text;
v_singletab text;

rec_order text;

v_querystring text;
v_debug_vars json;
v_debug json;
v_msgerr json;
v_errcontext text;

rec_tab record;
v_tab text;
v_fields json;
v_result json;
v_result_array json[];
v_combo_json json;
v_tab_params json;
v_sql text;
v_filter text := '';
v_filter_column text;
v_filter_list text[];
--i integer;
v_label text;
v_parameter text;
v_sys_query_text text;
v_sys_query_text_add text;
v_tiled boolean;
v_record record;
v_filter_split text;
v_device integer;
v_filter_poly text;
v_geom text;
v_epsg int;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get api values
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

    -- get values from input
    v_addschema = (p_data ->>'data')::json->>'addSchema';
    v_singletab = (p_data ->>'form')::json->>'singleTab';
	v_filter = ((p_data ->>'data')::json->>'parameters')::json->>'searchText';
    v_tiled = ((p_data ->>'client')::json->>'tiled')::boolean;
    v_device = ((p_data ->>'client')::json->>'device');
	v_filter_poly = ((p_data ->>'data')::json->>'filterFields')::json->>'searchPoly';

	-- profilactic control of schema name
	IF lower(v_addschema) = 'none' OR v_addschema = '' OR lower(v_addschema) ='null' THEN v_addschema = null; END IF;

   	if v_device = 5 then
		-- get epsg
		execute 'SELECT epsg FROM sys_version LIMIT 1' into v_epsg;

		-- profilactic control for singletab
	    IF v_singletab IN ('NULL', 'None', '') then v_singletab = null; end if;

		-- profilactic control if table selector_expl is empty
		IF (SELECT count(*) FROM selector_expl WHERE cur_user = current_user) = 0 THEN INSERT INTO selector_expl VALUES(0,current_user); END IF;

        -- Manage apostrophes on v_filter
		v_filter = replace(v_filter, '''', '''''');
		v_filter = coalesce(v_filter, '');

		for rec_tab in SELECT * FROM config_form_tabs WHERE formname='search' order by orderby
		loop
			for v_parameter, v_tab_params, v_label in select parameter, value, label from config_param_system where parameter ilike concat('basic_search_v2_', lower(rec_tab.tabname), '%')
			loop
				if v_parameter = 'basic_search_v2_tab_psector' and v_tiled is true then
					continue;
				end if;

				v_filter_list = string_to_array(v_tab_params->>'sys_display_name', ',');

				if v_parameter = 'basic_search_v2_tab_address' then

					v_sql = concat('SELECT count(*) as count FROM ', quote_ident(v_tab_params->>'sys_tablename_aux'));
					execute concat('SELECT split_part(', quote_literal(v_filter), ', '', '', 1)') into v_filter_split;
			  		-- TODO MANAGE WHERE name
					v_sql = concat(v_sql,' WHERE name::text ILIKE ''%', v_filter_split::text, '%''');

					execute v_sql into v_record;

					if v_record.count = 1 then
						v_sys_query_text_add = v_tab_params->>'sys_query_text_add';
				  		v_sql = concat(v_sys_query_text_add, '''%', v_filter::text, '%'' order by "displayName"');

				  		v_sql = concat('SELECT array_to_json(array_agg(a)) FROM (', v_sql::text, ' LIMIT 10)a');
					  	execute v_sql into v_fields;

						v_result = gw_fct_json_object_set_key (v_result, 'section', v_parameter);
						v_result = gw_fct_json_object_set_key (v_result, 'alias', v_label);
						v_result = gw_fct_json_object_set_key (v_result, 'execFunc', v_tab_params->>'sys_fct');
						v_result = gw_fct_json_object_set_key (v_result, 'tableName', v_tab_params->>'sys_tablename_aux');
						v_result = gw_fct_json_object_set_key (v_result, 'values', v_fields);
						v_result = gw_fct_json_object_set_key (v_result, 'searchAdd', True);

						v_result_array := array_append(v_result_array, v_result);
						continue;
					end if;

				end if;

				if v_tab_params->>'sys_search_name' is not null then
					v_sys_query_text = concat('SELECT ', quote_literal(v_tab_params->>'sys_pk'), ' as key, ', (v_tab_params->>'sys_pk')::text, ' as value, ', (v_tab_params->>'sys_display_name')::text, ' as "displayName" FROM ', (v_tab_params->>'sys_tablename')::text, ' WHERE ', (v_tab_params->>'sys_search_name')::text, ' ILIKE ''%', v_filter::text, '%'' ');
				else
					v_sys_query_text = concat('SELECT ', quote_literal(v_tab_params->>'sys_pk'), ' as key, ', (v_tab_params->>'sys_pk')::text, ' as value, ', (v_tab_params->>'sys_display_name')::text, ' as "displayName" FROM ', (v_tab_params->>'sys_tablename')::text, ' WHERE ', (v_tab_params->>'sys_display_name')::text, ' ILIKE ''%', v_filter::text, '%'' ');
				end if;

				if v_tab_params->>'sys_filter' != '' then
					v_sys_query_text := concat(v_sys_query_text, ' AND (', (v_tab_params->>'sys_filter')::text, ')');
				end if;

				if v_filter_poly is not null then
					v_geom := v_tab_params->>'sys_geom';
					if v_geom is not null and v_geom != '' then
						v_sys_query_text := concat(v_sys_query_text, ' AND ST_Within(', v_geom::text, ', ST_GeomFromText(''', v_filter_poly::text, ''', ', v_epsg, '))');
					end if;
				end if;

				v_sys_query_text := concat(v_sys_query_text, ' ORDER BY regexp_replace(', (v_tab_params->>'sys_display_name')::text, ',''[^0-9a-zA-Z]+'','''',''g'')');

				v_sql = concat('SELECT array_to_json(array_agg(a)) FROM (', v_sys_query_text::text, ' ');

	  			v_sql = concat(v_sql, ' limit 10)a ;');

				execute v_sql into v_fields;

				v_result = gw_fct_json_object_set_key (v_result, 'section', v_parameter);
				v_result = gw_fct_json_object_set_key (v_result, 'alias', v_label);
				v_result = gw_fct_json_object_set_key (v_result, 'execFunc', v_tab_params->>'sys_fct');
				v_result = gw_fct_json_object_set_key (v_result, 'tableName', (v_tab_params->>'sys_tablename')::text);
				v_result = gw_fct_json_object_set_key (v_result, 'values', v_fields);

				v_result_array := array_append(v_result_array, v_result);
			end loop;
		end loop;

		-- Check null
		v_form := COALESCE(v_form, '[]');

		-- Return
		RETURN (concat('{"status":"Accepted", "version":"', v_version, '", "body":{"data":{"searchResults":', to_json(v_result_array), '}}}'))::json;

	else
		-- Set search path to local schema
		SET search_path = "SCHEMA_NAME", public;

		--  get api values
		SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	    -- get values from input
	    v_singletab = (p_data ->>'form')::json->>'singleTab';

		-- profilactic control for singletab
	        IF v_singletab IN ('NULL', 'None', '') then v_singletab = null; end if;


		-- profilactic control of schema name
		IF v_addschema IS NOT NULL THEN
			IF (select schemaname from pg_tables WHERE schemaname = v_addschema LIMIT 1) IS NULL THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3132", "function":"2580","parameters":null, "is_process":true}}$$)';
				-- todo: send message to response
			END IF;
		END IF;

		-- profilactic control if table selector_expl is empty
		IF (SELECT count(*) FROM selector_expl WHERE cur_user = current_user) = 0 THEN INSERT INTO selector_expl VALUES(0,current_user); END IF;

		-- Create tabs array
		v_form := '[';

		FOR rec_order IN (SELECT tabname FROM  config_form_tabs WHERE formname='search' and v_device = ANY(device) order by orderby) LOOP

		IF rec_order ='tab_network' THEN
			-- Network Tab
			-------------------------
			SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_network' ;
			IF (rec_tab.formname IS NOT NULL AND v_singletab IS NULL) OR v_singletab = 'tab_network' THEN

				-- Init combo json
				SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='net_type';

				comboType := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname, 'widgetname', concat('network_',rec_fields.columnname),
				'widgettype','combo','datatype','string','placeholder','','disabled',false);

				-- Get Ids for type combo
				SELECT array_to_json(array_agg(id)) INTO combo_json FROM (SELECT ((value)::json->'sys_table_id') AS id FROM config_param_system
				WHERE parameter like '%basic_search_network%'ORDER BY ((value)::json->>'orderby'))a;
				comboType := gw_fct_json_object_set_key(comboType, 'comboIds', COALESCE(combo_json, '[]'));

				-- Set selectedId
				comboType := gw_fct_json_object_set_key(comboType, 'selectedId', to_json(''::text));

				-- Get Names for type combo
				SELECT array_to_json(array_agg(id)) INTO combo_json FROM (SELECT ((value)::json->'alias') AS id FROM config_param_system
				WHERE parameter like '%basic_search_network%' ORDER BY ((value)::json->>'orderby'))a;
				comboType := gw_fct_json_object_set_key(comboType, 'comboNames', COALESCE(combo_json, '[]'));

				-- Get feature type
				SELECT array_to_json(array_agg(id)) INTO combo_json FROM (SELECT ((value)::json->'search_type') AS id FROM config_param_system
				WHERE parameter like '%basic_search_network%' ORDER BY ((value)::json->>'orderby'))a;
				comboType := gw_fct_json_object_set_key(comboType, 'comboFeature', combo_json);

				-- Add edit box to introduce search text
				SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='net_code';
				editCode := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname, 'widgetname', concat('network_',rec_fields.columnname),'widgettype','typeahead','datatype',
				'string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

				-- Create array with network fields
				fieldsJson := concat('[', comboType, ',', editCode, ']');
				fieldsJson := COALESCE(fieldsJson, '[]');

				-- Create network tab form
				IF v_firsttab THEN
					formNetwork := json_build_object('tabName','network', 'tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active' , v_active);
					formNetwork := gw_fct_json_object_set_key(formNetwork, 'fields', fieldsJson);
					v_form := concat(v_form, ',', formNetwork::text);
				ELSE
					formNetwork := json_build_object('tabName','network', 'tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active' , true);
					formNetwork := gw_fct_json_object_set_key(formNetwork, 'fields', fieldsJson);
					v_form := concat(v_form, formNetwork::text);
				END IF;

				v_firsttab := TRUE;
				v_active := FALSE;

			END IF;

			IF v_addschema IS NOT NULL AND v_singletab IS NULL THEN

				SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_add_network' ;

				-- Init combo json
				v_querystring = concat('SELECT * FROM ',v_addschema,'.config_form_fields WHERE formname=''search'' AND columnname=''net_type''');
				v_debug_vars := json_build_object('v_addschema', v_addschema);
				v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getsearch', 'flag', 10);
				SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
				EXECUTE v_querystring INTO rec_fields;

				comboType := json_build_object('label',rec_fields.label, 'columnname', rec_fields.columnname, 'widgetname', concat('network_',rec_fields.columnname),
				'widgettype','combo','datatype','string','placeholder','','disabled',false);

				-- Get Ids for type combo
				v_querystring = concat('SELECT array_to_json(array_agg(id)) FROM (SELECT ((value)::json->''sys_table_id'') AS id FROM ',v_addschema,'.config_param_system 
							WHERE parameter like ''%basic_search_network%'' ORDER BY ((value)::json->>''orderby'')) a');
				v_debug_vars := json_build_object('v_addschema', v_addschema);
				v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getsearch', 'flag', 20);
				SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
				EXECUTE v_querystring INTO combo_json;

				comboType := gw_fct_json_object_set_key(comboType, 'comboIds', COALESCE(combo_json, '[]'));

				-- Set selectedId
				comboType := gw_fct_json_object_set_key(comboType, 'selectedId', to_json(''::text));

				-- Get Names for type combo
				v_querystring = concat('SELECT array_to_json(array_agg(id)) FROM (SELECT ((value)::json->''alias'') AS id FROM ',v_addschema,'.config_param_system  
							WHERE parameter like ''%basic_search_network%'' ORDER BY ((value)::json->>''orderby''))a');
				v_debug_vars := json_build_object('v_addschema', v_addschema);
				v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getsearch', 'flag', 30);
				SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
				EXECUTE v_querystring INTO combo_json;
				comboType := gw_fct_json_object_set_key(comboType, 'comboNames', COALESCE(combo_json, '[]'));

				-- Add edit box to introduce search text
				v_querystring = concat('SELECT * FROM ',v_addschema,'.config_form_fields WHERE formname=''search'' AND columnname=''net_code''');
				v_debug_vars := json_build_object('v_addschema', v_addschema);
				v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getsearch', 'flag', 40);
				SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
				EXECUTE v_querystring INTO rec_fields;
				editCode := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname, 'widgetname', concat('add_network_',rec_fields.columnname),'widgettype','typeahead','datatype',
				'string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

				-- Create array with network fields
				fieldsJson := '[' || comboType || ',' || editCode || ']';
				fieldsJson := COALESCE(fieldsJson, '[]');

				-- Create network tab form
				IF v_firsttab THEN
					formNetwork := json_build_object('tabName','add_network','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active' , v_active);
					formNetwork := gw_fct_json_object_set_key(formNetwork, 'fields', fieldsJson);
					v_form := v_form || ',' || formNetwork::text;
				ELSE
					formNetwork := json_build_object('tabName','add_network','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active' , true);
					v_form := v_form || formNetwork::text;
				END IF;

				v_firsttab := TRUE;
				v_active :=FALSE;

				SET search_path = 'SCHEMA_NAME', public;

			END IF;
		ELSIF rec_order ='tab_search' THEN
			-- Search tab
			-------------
			SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_search' ;
			IF (rec_tab.formname IS NOT NULL AND v_singletab IS NULL) OR v_singletab = 'tab_search' THEN

				-- Create search field
				SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='generic_search';
				editCode := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('network_',rec_fields.columnname),'widgettype','typeahead', 'searchService', '...');

				fieldsJson := '[' ||  editCode || ']';
				fieldsJson := COALESCE(fieldsJson, '[]');

				-- Create search tab form
				IF v_firsttab THEN
					formSearch := json_build_object('tabName','search','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', v_active );
					formSearch := gw_fct_json_object_set_key(formSearch, 'fields', fieldsJson);
					v_form := concat(v_form, ',', formSearch::text);
				ELSE
					formSearch := json_build_object('tabName','search','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', true );
					formSearch := gw_fct_json_object_set_key(formSearch, 'fields', fieldsJson);
					v_form := concat(v_form, formSearch::text);
				END IF;

				v_firsttab := TRUE;
				v_active :=FALSE;

			END IF;
		ELSIF rec_order ='tab_address' THEN
			-- Address tab
			-------------
			SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_address' ;
			IF (rec_tab.formname IS NOT NULL AND v_singletab IS NULL) OR v_singletab = 'tab_address' THEN

				-- Parameters of the municipality layer
				SELECT ((value::json)->>'sys_table_id') INTO v_search_muni_table FROM config_param_system WHERE parameter='basic_search_muni';
				SELECT ((value::json)->>'sys_id_field') INTO v_search_muni_id_field FROM config_param_system WHERE parameter='basic_search_muni';
				SELECT ((value::json)->>'sys_search_field') INTO v_search_muni_search_field FROM config_param_system WHERE parameter='basic_search_muni';
				SELECT ((value::json)->>'sys_geom_field') INTO v_search_muni_geom_field FROM config_param_system WHERE parameter='basic_search_muni';

				-- get muni default from user variable
				SELECT value INTO v_search_vdef FROM config_param_user WHERE parameter='basic_search_municipality_vdefault' AND cur_user=current_user;

				-- get muni default from user variable or map
				IF v_search_vdef IS NULL THEN
					v_search_vdef = (SELECT m.muni_id FROM ext_municipality m, ve_exploitation e WHERE st_dwithin(st_centroid(e.the_geom), m.the_geom, 0) limit 1);
				END IF;

				-- Init combo json
				SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='add_muni';
				comboType := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('address_',rec_fields.columnname),
				'widgettype','combo','datatype','string','placeholder','','disabled',false);


				-- Get Ids for type combo
				v_querystring = concat('SELECT array_to_json(array_agg(id)) FROM (SELECT ',quote_ident(v_search_muni_id_field),' AS id FROM ',quote_ident(v_search_muni_table) ,
							' WHERE active IS TRUE ORDER BY ',quote_ident(v_search_muni_search_field),') a');
				v_debug_vars := json_build_object('v_search_muni_id_field', v_search_muni_id_field, 'v_search_muni_table', v_search_muni_table, 'v_search_muni_search_field', v_search_muni_search_field);
				v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getsearch', 'flag', 50);
				SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
				EXECUTE v_querystring INTO combo_json;

				comboType := gw_fct_json_object_set_key(comboType, 'comboIds', COALESCE(combo_json, '[]'));

				-- Add default
				IF combo_json IS NOT NULL THEN
					comboType := gw_fct_json_object_set_key(comboType, 'selectedId', v_search_vdef);
				ELSE
					comboType := gw_fct_json_object_set_key(comboType, 'selectedId', to_json(''::text));
				END IF;

				-- Get name for type combo
				v_querystring = concat('SELECT array_to_json(array_agg(idval)) FROM (SELECT ',quote_ident(v_search_muni_search_field),' AS idval FROM ',quote_ident(v_search_muni_table) ,
						' WHERE active IS TRUE ORDER BY ',quote_ident(v_search_muni_search_field),') a');
				v_debug_vars := json_build_object('v_search_muni_search_field', v_search_muni_search_field, 'v_search_muni_table', v_search_muni_table);
				v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getsearch', 'flag', 60);
				SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
				EXECUTE v_querystring INTO combo_json;
				comboType := gw_fct_json_object_set_key(comboType, 'comboNames', COALESCE(combo_json, '[]'));

				-- Get geom for combo
				v_querystring = concat('SELECT array_to_json(array_agg(st_astext(st_envelope(geom)))) FROM (SELECT ',quote_ident(v_search_muni_geom_field),' AS geom FROM ',
						quote_ident(v_search_muni_table) ,' WHERE active IS TRUE ORDER BY ',quote_ident(v_search_muni_search_field),') a');
				v_debug_vars := json_build_object('v_search_muni_geom_field', v_search_muni_geom_field, 'v_search_muni_table', v_search_muni_table, 'v_search_muni_search_field', v_search_muni_search_field);
				v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getsearch', 'flag', 70);
				SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
				EXECUTE v_querystring INTO combo_json;
				comboType := gw_fct_json_object_set_key(comboType, 'comboGeometry', combo_json);

				-- Create street search field
				SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='add_street';
				editCode1 := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('address_',rec_fields.columnname),
				'widgettype','typeahead','datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

				-- Create postnumber search field
				SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='add_postnumber';
				editCode2 := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('address_',rec_fields.columnname),
				'widgettype','typeahead','threshold', 1, 'datatype','integer','placeholder','','disabled',true,'noresultsMsg','No results','loadingMsg','Searching...');

				-- Create array with network fields
				fieldsJson := concat('[', comboType, ',', editCode1, ',', editCode2, ']');
				fieldsJson := COALESCE(fieldsJson, '[]');

				-- Create tabs array
				IF v_firsttab THEN
					formAddress := json_build_object('tabName','address','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', v_active );
					formAddress := gw_fct_json_object_set_key(formAddress, 'fields', fieldsJson);
					v_form := concat(v_form, ',', formAddress::text);
				ELSE
					formAddress := json_build_object('tabName','address','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', true );
					formAddress := gw_fct_json_object_set_key(formAddress, 'fields', fieldsJson);
					v_form := concat(v_form, formAddress::text);
				END IF;

				v_firsttab := TRUE;
				v_active :=FALSE;
			END IF;

		ELSIF rec_order ='tab_hydro' THEN
			-- Hydro tab
			------------
			SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_hydro' ;
			IF (rec_tab.formname IS NOT NULL AND v_singletab IS NULL) OR v_singletab = 'tab_hydro' THEN

				-- Init combo json
				SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='hydro_expl';
				comboType := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('hydro_',rec_fields.columnname),
				'widgettype','combo','datatype','string','placeholder','','disabled',false);

				-- Get exploitation vdefault
				SELECT value::integer INTO v_search_vdef FROM config_param_user WHERE parameter='basic_search_exploitation_vdefault' AND cur_user=current_user
				AND value::integer IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user);
				IF v_search_vdef IS NULL THEN v_search_vdef=(SELECT expl_id FROM selector_expl WHERE cur_user=current_user LIMIT 1); END IF;

				-- Get exploitation id's for type combo
				EXECUTE 'SELECT array_to_json(array_agg(expl_id)) FROM (SELECT expl_id FROM exploitation WHERE expl_id 
				IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user) ORDER BY name) a'
				INTO combo_json;

				-- Add to json
				comboType := gw_fct_json_object_set_key(comboType, 'comboIds', COALESCE(combo_json, '[]'));

				-- Add vdefault
				IF combo_json IS NOT NULL THEN
					comboType := gw_fct_json_object_set_key(comboType, 'selectedId', v_search_vdef);
				ELSE
					comboType := gw_fct_json_object_set_key(comboType, 'selectedId', to_json(''::text));
				END IF;

				-- Get Names for the combo
				EXECUTE 'SELECT array_to_json(array_agg(name)) FROM (SELECT name FROM exploitation WHERE expl_id 
				IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user) ORDER BY name) a'
				INTO combo_json;

				-- Add to json
				comboType := gw_fct_json_object_set_key(comboType, 'comboNames', COALESCE(combo_json, '[]'));

				-- Add edit box to introduce search text
				SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='hydro_search';
				editCode := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('hydro_',rec_fields.columnname),
				'widgettype','typeahead','datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

				SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='hydro_contains';
				chkContains := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('hydro_',rec_fields.columnname),
				'widgettype','check','datatype','boolean','placeholder','','disabled',false,'noresultsMsg','','loadingMsg','', 'tooltip',rec_fields.tooltip);

				-- Create array with hydro fields
				fieldsJson := concat('[', chkContains, ',', comboType, ',', editCode, ']');
				fieldsJson := COALESCE(fieldsJson, '[]');

				-- Create tabs array
				IF v_firsttab THEN
					formHydro := json_build_object('tabName','hydro','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', v_active );
					formHydro := gw_fct_json_object_set_key(formHydro, 'fields', fieldsJson);
					v_form := concat(v_form, ',', formHydro::text);
				ELSE
					formHydro := json_build_object('tabName','hydro','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', true );
					formHydro := gw_fct_json_object_set_key(formHydro, 'fields', fieldsJson);
					v_form := concat(v_form, formHydro::text);
				END IF;

				v_firsttab := TRUE;
				v_active :=FALSE;

			END IF;
		ELSIF rec_order ='tab_workcat' THEN
			-- Workcat tab
			--------------
			SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_workcat' ;
			IF (rec_tab.formname IS NOT NULL AND v_singletab IS NULL) OR v_singletab = 'tab_workcat' THEN

				-- Add edit box to introduce search text
				SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='workcat_search';
				editCode := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('workcat_',rec_fields.columnname),
				'widgettype','typeahead','datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

				-- Create array with workcat fields
				fieldsJson := concat('[', editCode, ']');
				fieldsJson := COALESCE(fieldsJson, '[]');

				-- Create tabs array
				IF v_firsttab THEN
					formWorkcat := json_build_object('tabName','workcat','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', v_active );
					formWorkcat := gw_fct_json_object_set_key(formWorkcat, 'fields', fieldsJson);
					v_form := concat(v_form, ',', formWorkcat::text);
				ELSE
					formWorkcat := json_build_object('tabName','workcat','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', true );
					formWorkcat := gw_fct_json_object_set_key(formWorkcat, 'fields', fieldsJson);
					v_form := concat(v_form, formWorkcat::text);
				END IF;

				v_firsttab := TRUE;
				v_active :=FALSE;

			END IF;

		ELSIF rec_order ='tab_psector' THEN
			-- Psector tab
			--------------
			SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_psector' ;
			IF (rec_tab.formname IS NOT NULL AND v_singletab IS NULL) OR v_singletab = 'tab_psector' THEN

				-- Init combo json
				SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='psector_expl';
				comboType := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('psector_',rec_fields.columnname),
				'widgettype','combo','datatype','string','placeholder','','disabled',false);

				-- Get exploitation vdefault
				SELECT value::integer INTO v_search_vdef FROM config_param_user WHERE parameter='basic_search_exploitation_vdefault' AND cur_user=current_user
				AND value::integer IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user);
				IF v_search_vdef IS NULL THEN v_search_vdef=(SELECT expl_id FROM selector_expl WHERE cur_user=current_user LIMIT 1); END IF;

				-- Get Ids for type combo
				EXECUTE 'SELECT array_to_json(array_agg(expl_id)) FROM (SELECT expl_id FROM exploitation WHERE expl_id 
				IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user) ORDER BY name) a'
				INTO combo_json;

				-- Add to json
				comboType := gw_fct_json_object_set_key(comboType, 'comboIds', COALESCE(combo_json, '[]'));

				-- Add default
				IF combo_json IS NOT NULL THEN
					comboType := gw_fct_json_object_set_key(comboType, 'selectedId', v_search_vdef);
				ELSE
					comboType := gw_fct_json_object_set_key(comboType, 'selectedId', to_json(''::text));
				END IF;

				-- Get Names for the combo
				EXECUTE 'SELECT array_to_json(array_agg(name)) FROM (SELECT name FROM exploitation WHERE expl_id 
				IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user) ORDER BY name) a'
				INTO combo_json;

				-- Add to json
				comboType := gw_fct_json_object_set_key(comboType, 'comboNames', COALESCE(combo_json, '[]'));

				-- Add edit box to introduce search text
				SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='psector_search';
				editCode := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('psector_',rec_fields.columnname),
				'widgettype','typeahead','datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

				-- Create array with hydro fields
				fieldsJson := concat('[', comboType, ',', editCode, ']');
				fieldsJson := COALESCE(fieldsJson, '[]');

				-- Create tabs array
				IF v_firsttab THEN
					formPsector := json_build_object('tabName','psector','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', v_active );
					formPsector := gw_fct_json_object_set_key(formPsector, 'fields', fieldsJson);
					v_form := concat(v_form, ',', formPsector::text);
				ELSE
					formPsector := json_build_object('tabName','psector','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', true );
					formPsector := gw_fct_json_object_set_key(formPsector, 'fields', fieldsJson);
					v_form := concat(v_form, formPsector::text);
				END IF;

			END IF;
		ELSIF rec_order ='tab_visit' THEN
			-- Visit tab
			--------------
			SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='search' AND tabname='tab_visit' ;
			IF (rec_tab.formname IS NOT NULL AND v_singletab IS NULL) OR v_singletab = 'tab_visit' THEN

				-- Add edit box to introduce search text
				SELECT * INTO rec_fields FROM config_form_fields WHERE formname='search' AND columnname='visit_search';
				editCode := json_build_object('label',rec_fields.label,'columnname', rec_fields.columnname,'widgetname', concat('visit_',rec_fields.columnname),
				'widgettype','typeahead','datatype','string','placeholder','','disabled',false,'noresultsMsg','No results','loadingMsg','Searching...');

				-- Create array with workcat fields
				fieldsJson := concat('[', editCode, ']');
				fieldsJson := COALESCE(fieldsJson, '[]');

				-- Create tabs array
				IF v_firsttab THEN
					formVisit := json_build_object('tabName','visit','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', v_active );
					formVisit := gw_fct_json_object_set_key(formVisit, 'fields', fieldsJson);
					v_form := concat(v_form, ',', formVisit::text);
				ELSE
					formVisit := json_build_object('tabName','visit','tabLabel',rec_tab.label, 'tooltip', rec_tab.tooltip,'active', true );
					formVisit := gw_fct_json_object_set_key(formVisit, 'fields', fieldsJson);
					v_form := concat(v_form, formVisit::text);
				END IF;

				v_firsttab := TRUE;
				v_active :=FALSE;

			END IF;
		END IF;
		END LOOP;

		-- Finish the construction of v_form
		v_form := concat(v_form, ']');

		-- Check null
		v_form := COALESCE(v_form, '[]');

		-- Return
		IF v_firsttab IS FALSE THEN
			-- Return not implemented
			RETURN (concat('{"status":"Accepted", "version":"', v_version, '", "enabled":false}'))::json;
		ELSE

			-- Return
			RETURN (concat('{"status":"Accepted", "version":"', v_version, '", "enabled":true,"form":', v_form, '}'))::json;
		END IF;

	end if;


	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;
	RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE, 'MSGERR', (v_msgerr::json ->> 'MSGERR'))::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
