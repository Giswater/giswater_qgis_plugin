/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2640

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getvisitmanager(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:

-- calling button from feature
SELECT SCHEMA_NAME.gw_fct_getvisitmanager($${
"client":{"device":4,"infoType":1,"lang":"es"},
"form":{},
"data":{"relatedFeature":{"type":"arc", "idName":"arc_id", "id":"2074"},"fields":{},"pageInfo":null}}$$)


-- calling without previous info
--new call
SELECT SCHEMA_NAME.gw_fct_getvisitmanager($${
"client":{"device":4,"infoType":1,"lang":"es"},
"form":{},
"data":{}}$$)

SELECT SCHEMA_NAME.gw_fct_getvisitmanager($${"client":{"device":4,"infoType":1,"lang":"es"},
     "feature":{"featureType":"visit","tableName":"v_visit_lot_user","idName":"user_id","id":"xtorret"},"form":{"tabData":{"active":false},"tabLots":{"active":true},"navigation":{"currentActiveTab":"tabData"}},
       "data":{"relatedFeature":{"type":"arc", "id":"2079"},"fields":{"user_id":"xtorret","date":"2019-01-28","team_id":"1","vehicle_id":"3"},"pageInfo":null}}$$) AS result


-- change from tab data to tab files (upserting data on tabData)
SELECT SCHEMA_NAME.gw_fct_getvisitmanager($${
"client":{"device":4,"infoType":1,"lang":"es"},
"feature":{"featureType":"visit","tableName":"v_visit_lot_user","idName":"user_id","id":"xtorret"},
"form":{"tabData":{"active":false}, "tabLots":{"active":true},"navigation":{"currentActiveTab":"tabData"}},
"data":{"fields":{"user_id":"xtorret","team_id":1,"vehicle_id":1,"date":"2019-01-01"}}}$$)

--tab activelots
SELECT SCHEMA_NAME.gw_fct_getvisitmanager($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},
"form":{"tabData":{"active":false}, "tabLots":{"active":true}}, "navigation":{"currentActiveTab":"tabLots"},
"data":{"filterFields":{"limit":10},
	"pageInfo":{"currentPage":1}
	}}$$)

*/

DECLARE

v_version text;
v_schemaname text;
v_featuretype text;
v_id text;
v_idname text;
v_columntype text;
v_device integer;
v_tablename text;
v_fields json [];
v_fields_json json;
v_forminfo json;
v_formheader text;
v_formtabs text;
v_tabaux json;
v_active boolean;
v_featureid varchar ;
aux_json json;
v_tab record;
v_projecttype varchar;
v_activedatatab boolean;
v_activelotstab boolean;
v_activedonetab boolean;
v_activeteamtab boolean;
v_client json;
v_pageinfo json;
v_filterfields json;
v_data json;
v_feature json;
v_addfile json;
v_deletefile json;
v_message json;
v_return json;
v_currentactivetab text;
v_values json;
array_index integer DEFAULT 0;
v_fieldvalue text;
v_firstcall boolean = false;
v_team text;
v_lot text;
v_vehicle integer;
v_user_id text;
v_featureidname text;
v_filterfeature json;
v_isfeaturemanager boolean;
v_isusermanager boolean;
v_disable_widget_name text[];
v_record record;
v_child_result json;
v_result record;
v_childs_result json;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname := 'SCHEMA_NAME';

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;

	-- fix diferent ways to say null on client
	p_data = REPLACE (p_data::text, '"NULL"', 'null');
	p_data = REPLACE (p_data::text, '"null"', 'null');
	p_data = REPLACE (p_data::text, '""', 'null');
    p_data = REPLACE (p_data::text, '''''', 'null');

	-- get project type
	SELECT project_type INTO v_projecttype FROM sys_version LIMIT 1;

	-- get parameters from input
	v_client = (p_data ->>'client')::json;
	v_device = ((p_data ->>'client')::json->>'device')::integer;
	v_id = ((p_data ->>'feature')::json->>'id')::text;
	v_idname = ((p_data ->>'feature')::json->>'idName')::text;
	v_data = (p_data ->>'data')::text;
	v_featureid = (((p_data ->>'data')::json->>'relatedFeature')::json->>'id');
	v_featureidname = (((p_data ->>'data')::json->>'relatedFeature')::json->>'idName');
	v_featuretype = (((p_data ->>'data')::json->>'relatedFeature')::json->>'type');
	v_activedatatab = (((p_data ->>'form')::json->>'tabData')::json->>'active')::boolean;
	v_activelotstab = (((p_data ->>'form')::json->>'tabLots')::json->>'active')::boolean;
	v_activedonetab = (((p_data ->>'form')::json->>'tabDone')::json->>'active')::boolean;
	v_activeteamtab = (((p_data ->>'form')::json->>'tabTeam')::json->>'active')::boolean;
	v_addfile = ((p_data ->>'data')::json->>'newFile')::json;
	v_deletefile = ((p_data ->>'data')::json->>'deleteFile')::json;
	v_currentactivetab = (((p_data ->>'form')::json->>'navigation')::json->>'currentActiveTab')::text;
	v_team = ((p_data ->>'data')::json->>'fields')::json->>'team_id'::text;
	v_lot = ((p_data ->>'data')::json->>'fields')::json->>'lot_id'::text;
	v_vehicle = ((p_data ->>'data')::json->>'fields')::json->>'vehicle'::text;
	v_message = ((p_data ->>'data')::json->>'message');

	-- forcing idname in case not exists
	IF v_idname IS NULL THEN
		v_idname = concat(v_featuretype, '_id');
	END IF;

	IF v_featureidname IS NULL AND v_featuretype IS NOT NULL THEN
		v_featureidname = concat(v_featuretype, '_id');
	END IF;

	raise notice 'v_featuretype % v_idname % v_team %',v_featuretype, v_featureidname, v_team;

	-- setting values
	v_tablename := 'v_visit_lot_user';
	v_user_id := 'user_id';
	v_columntype := 'varchar(30)';

	-- identify if it's featuremanager or usermanager
	IF v_featureid IS NOT NULL THEN
		v_isfeaturemanager = TRUE;
		v_isusermanager = FALSE;
	ELSE
		v_isfeaturemanager = FALSE;
		v_isusermanager = TRUE;
	END IF;

	-- forcing usermanager
	v_isusermanager = TRUE;

	-- setting tabs in is firstcall
	IF v_currentactivetab IS NULL THEN
		v_firstcall := TRUE;

		-- setting tabs
		IF v_isfeaturemanager THEN
			v_activedatatab := FALSE;
			v_activelotstab := FALSE;
			v_activedonetab := TRUE;
			v_activeteamtab := FALSE;
		ELSIF v_isusermanager THEN
			v_activedatatab := TRUE;
			v_activelotstab := FALSE;
			v_activedonetab := FALSE;
			v_activeteamtab := FALSE;
		END IF;

	END IF;

    raise notice 'v_isusermanager % v_isfeaturemanager % v_currentactivetab % ', v_isusermanager, v_isfeaturemanager, v_currentactivetab;

	-- Set calling visits from feature id

	-- upserting data on tabData
	IF v_currentactivetab = 'tabData' THEN
		--SELECT gw_fct_setvisitmanager (p_data) INTO v_return;
		v_id = ((v_return->>'body')::json->>'feature')::json->>'id';
		v_message = (v_return->>'message');
		RAISE NOTICE '--- UPSERT USER MANAGER CALLING gw_fct_setvisitmnager WITH MESSAGE: % ---', v_message;
	END IF;

	--  Create tabs array
	v_formtabs := '[';

		-- Data tab
		-----------
		IF v_isusermanager THEN

			IF v_activedatatab THEN

				-- Check if exist some other workday opened, and close
				EXECUTE 'SELECT user_id, endtime FROM (SELECT * FROM om_visit_lot_x_user WHERE user_id = current_user ORDER BY id DESC) a LIMIT 1' INTO v_record;

				IF v_record.endtime IS NULL AND v_record.user_id IS NOT NULL THEN
					v_disable_widget_name = '{data_startbutton, data_team_id, data_lot_id}';
				ELSE
					v_disable_widget_name = '{data_endbutton}';
				END IF;

				SELECT gw_fct_getformfields( 'visit_manager', 'form_visit', 'data', null, null, null, null, 'INSERT', null, v_device, null) INTO v_fields;

				-- getting values from feature
				EXECUTE FORMAT ('SELECT (row_to_json(a)) FROM 
					(SELECT * FROM %s WHERE %s = CAST($1 AS %s))a', v_tablename, v_user_id, v_columntype)
					INTO v_values
					USING current_user;

				-- setting values
				FOREACH aux_json IN ARRAY v_fields
				LOOP

					array_index := array_index + 1;
					v_fieldvalue := (v_values->>(aux_json->>'columnname'));

					IF (aux_json->>'widgetname') = v_disable_widget_name[1] OR (aux_json->>'widgetname') = v_disable_widget_name[2] OR (aux_json->>'widgetname') = v_disable_widget_name[3] THEN
						v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'disabled', True);
					END IF;

					-- geting current user if exists
					IF (aux_json->>'columnname')='user_id' AND v_team is NULL THEN
						IF current_user IS NOT NULL THEN
							EXECUTE 'SELECT team_id FROM om_visit_lot_x_user WHERE user_id = ''' || current_user || ''' ORDER BY id DESC LIMIT 1' INTO v_team;
						END IF;

					END IF;

					IF v_team IS NULL THEN
						EXECUTE 'SELECT team_id FROM om_team_x_user WHERE user_id = ''' ||current_user||''' ORDER BY team_id LIMIT 1' INTO v_team;
					END IF;

					IF (aux_json->>'widgettype')='combo' THEN

						IF (aux_json->>'columnname')='team_id' AND v_team IS NOT NULL THEN

							v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'selectedId', COALESCE(v_team, ''));

						ELSIF (aux_json->>'columnname')='lot_id' AND v_team IS NOT NULL THEN

							EXECUTE ('SELECT gw_fct_getchilds($${
							"client":{"device":4, "infoType":1, "lang":"ES"},
							"form":{},
							"feature":{"tableName":"visit_manager"},
							"data":{"comboParent":"team_id", "comboId":' || COALESCE(v_team, '') || '}}$$)') INTO v_child_result;

							-- Convert getchilds result, useing array_to_json
							select array_to_json(array_agg((value))) FROM (select * from json_array_elements_text(((((v_child_result->>'body')::json->>'data')::json->>0)::json->>'comboIds')::json)) a INTO v_childs_result;

							v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'comboIds', v_childs_result);
							select array_to_json(array_agg((value))) FROM (select * from json_array_elements_text(((((v_child_result->>'body')::json->>'data')::json->>0)::json->>'comboNames')::json)) a INTO v_childs_result;

							v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'comboNames', v_childs_result);

							IF v_lot IS NULL THEN
								v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'selectedId', COALESCE(v_fieldvalue, ''));
							ELSE
								v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'selectedId', COALESCE(v_lot, ''));

							END IF;
						ELSE
							v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'selectedId', COALESCE(v_fieldvalue, ''));
						END IF;
					ELSE
						v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'value', COALESCE(v_fieldvalue, ''));
					END IF;
				END LOOP;

				v_fields_json = array_to_json (v_fields);
				v_fields_json := COALESCE(v_fields_json, '{}');
			END IF;

			-- building
			SELECT * INTO v_tab FROM config_form_tabs WHERE formname='visit_manager' AND tabname='tab_data' and device = v_device LIMIT 1;
			IF v_tab IS NULL THEN
				SELECT * INTO v_tab FROM config_form_tabs WHERE formname='visit_manager' AND tabname='tab_data' LIMIT 1;
			END IF;

			v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.label, 'tooltip',v_tab.tooltip,
			'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active',v_activedatatab);
			v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
			v_formtabs := v_formtabs || v_tabaux::text;

			-- Active lots tab
			------------------
			   IF v_activelotstab THEN
				-- setting table feature
				v_feature := '{"tableName":"om_visit_lot"}';

				-- setting feature
				p_data := gw_fct_json_object_set_key(p_data, 'feature', v_feature);

				-- setting filterFields
				v_filterfields := (((p_data->>'data')::json->>'fields')::json)->>'team_id';
				v_data := (p_data->>'data');
				v_data := gw_fct_json_object_set_key(v_data, 'filterFields', '{"team_id":'||v_filterfields||'}');
				p_data := gw_fct_json_object_set_key(p_data, 'data', v_data);

				--refactor tabNames
				p_data := replace (p_data::text, 'tabFeature', 'feature');

				RAISE NOTICE '--- CALLING gw_fct_getlist ON LOTS TAB USING p_data: % ---', p_data;
				SELECT gw_fct_getlist (p_data) INTO v_fields_json;

				-- getting pageinfo and list values
				v_pageinfo = ((v_fields_json->>'body')::json->>'data')::json->>'pageInfo';
				v_fields_json = ((v_fields_json->>'body')::json->>'data')::json->>'fields';
				v_fields_json := COALESCE(v_fields_json, '{}');

			END IF;

			-- building
			SELECT * INTO v_tab FROM config_form_tabs WHERE formname='visit_manager' AND tabname='tab_lot' and device = v_device LIMIT 1;

			IF v_tab IS NULL THEN
				SELECT * INTO v_tab FROM config_form_tabs WHERE formname='visit_manager' AND tabname='tab_lot' LIMIT 1;
			END IF;

			v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.label, 'tooltip',v_tab.tooltip,
			'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active',v_activelotstab);
			v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
			v_formtabs := v_formtabs || ',' || v_tabaux::text;

		END IF;

		-- Done visits tab
		------------------
		IF v_activedonetab THEN

			IF v_isfeaturemanager THEN
				v_featuretype = NULL;
			END IF;

			IF v_featuretype IS NULL THEN
				-- setting table feature
				v_feature := '{"tableName":"om_visit"}';

			ELSIF v_featuretype='arc' THEN
				v_feature := '{"tableName":"v_ui_om_visitman_x_arc"}';

			ELSIF v_featuretype='node' THEN
				v_feature := '{"tableName":"v_ui_om_visitman_x_node"}';

			ELSIF v_featuretype='connec' THEN
				v_feature := '{"tableName":"v_ui_om_visitman_x_connec"}';

			ELSIF v_featuretype='gully' THEN
				v_feature := '{"tableName":"v_ui_om_visitman_x_gully"}';

			END IF;

			-- setting feature
			p_data := gw_fct_json_object_set_key(p_data, 'feature', v_feature);

			-- refactor fields by filterFields
			v_filterfields := ((p_data->>'data')::json->>'fields')::json;
			v_filterfields := gw_fct_json_object_set_key(v_data, 'team_id', v_team);


			-- setting feature
			p_data := gw_fct_json_object_set_key(p_data, 'feature', v_feature);

			-- refactor fields by filterFields
			v_filterfields := ((p_data->>'data')::json->>'fields')::json;
			v_data := (p_data->>'data');
			v_data := gw_fct_json_object_set_key(v_data, 'filterFields', '{"team_id":'||v_team||'}');
			p_data := gw_fct_json_object_set_key(p_data, 'data', v_data);


			-- setting filter fields of feature id
			IF v_featuretype IS NOT NULL THEN

				-- setting filterfeaturefields using feature id
				v_filterfeature = (concat('{"',v_featuretype,'_id":"',v_featureid,'"}'))::json;
				v_data := gw_fct_json_object_set_key(v_data, 'filterFeatureField', v_filterfeature);
				p_data := gw_fct_json_object_set_key(p_data, 'data', v_data);

			END IF;

			--refactor tabNames
			p_data := replace (p_data::text, 'tabFeature', 'feature');

			RAISE NOTICE '--- CALLING gw_fct_getlist - VISITS p_data: % ---', p_data;
			SELECT gw_fct_getlist (p_data) INTO v_fields_json;

			-- getting pageinfo and list values
			v_pageinfo = ((v_fields_json->>'body')::json->>'data')::json->>'pageInfo';
			v_fields_json = ((v_fields_json->>'body')::json->>'data')::json->>'fields';

			v_fields_json := COALESCE(v_fields_json, '{}');
		END IF;

		-- building
		SELECT * INTO v_tab FROM config_form_tabs WHERE formname='visit_manager' AND tabname='tab_done' and device = v_device LIMIT 1;

		IF v_tab IS NULL THEN
			SELECT * INTO v_tab FROM config_form_tabs WHERE formname='visit_manager' AND tabname='tab_done' LIMIT 1;
		END IF;

		v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.label, 'tooltip',v_tab.tooltip,
		'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active',v_activedonetab);
		v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
		IF v_isusermanager THEN
			v_formtabs := v_formtabs || ',' || v_tabaux::text;
		ELSIF v_isfeaturemanager THEN
			v_formtabs := v_formtabs || v_tabaux::text;
		END IF;

		-- Team tab
		------------------
		IF v_activeteamtab THEN

			IF v_isfeaturemanager THEN
				v_featuretype = NULL;
			END IF;

			IF v_featuretype IS NULL THEN
				-- setting table feature
				v_feature := '{"tableName":"om_vehicle_x_parameters"}';

			END IF;

			-- setting feature
			v_filterfields := (((p_data->>'data')::json->>'fields')::json)->>'team_id';
			p_data := gw_fct_json_object_set_key(p_data, 'feature', v_feature);

			-- refactor fields by filterFields
			v_filterfields := ((p_data->>'data')::json->>'fields')::json;
			v_data := (p_data->>'data');
			v_data := gw_fct_json_object_set_key(v_data, 'filterFields', '{"team_id":'||v_team||'}');
			p_data := gw_fct_json_object_set_key(p_data, 'data', v_data);
			-- setting filter fields of feature id
			IF v_featuretype IS NOT NULL THEN

				-- setting filterfeaturefields using feature id
				v_filterfeature = (concat('{"',v_featuretype,'_id":"',v_featureid,'"}'))::json;
				v_data := gw_fct_json_object_set_key(v_data, 'filterFeatureField', v_filterfeature);
				p_data := gw_fct_json_object_set_key(p_data, 'data', v_data);

			END IF;

			--refactor tabNames
			p_data := replace (p_data::text, 'tabFeature', 'feature');

			RAISE NOTICE '--- CALLING gw_fct_getlist - VISITS p_data: % ---', p_data;
			SELECT gw_fct_getlist (p_data) INTO v_fields_json;
			array_index = 0;

			-- getting pageinfo and list values
			v_pageinfo = ((v_fields_json->>'body')::json->>'data')::json->>'pageInfo';
			v_fields_json = ((v_fields_json->>'body')::json->>'data')::json->>'fields';

			v_fields_json := COALESCE(v_fields_json, '{}');

		END IF;

		-- building
		SELECT * INTO v_tab FROM config_form_tabs WHERE formname='visit_manager' AND tabname='tab_team' and device = v_device LIMIT 1;

		IF v_tab IS NULL THEN
			SELECT * INTO v_tab FROM config_form_tabs WHERE formname='visit_manager' AND tabname='tab_team' LIMIT 1;
		END IF;

		v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.label, 'tooltip',v_tab.tooltip,
		'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active',v_activeteamtab);

		v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);

		IF v_isusermanager THEN
			v_formtabs := v_formtabs || ',' || v_tabaux::text;
		ELSIF v_isfeaturemanager THEN
			v_formtabs := v_formtabs || v_tabaux::text;
		END IF;

		--closing tabs array
		v_formtabs := (v_formtabs ||']');

		-- header form
		IF v_isusermanager THEN
			v_formheader :=concat('VISIT MANAGER - ',UPPER(current_user));
		ELSIF v_isfeaturemanager THEN
			v_formheader :=concat('VISIT MANAGER - ', v_featureid);
		END IF;

	-- Create new form
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formId', 'F11'::text);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formName', v_formheader);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formTabs', v_formtabs::json);

	--  Control NULL's
	v_version := COALESCE(v_version, '');
	v_message := COALESCE(v_message, '{}');
	v_forminfo := COALESCE(v_forminfo, '{}');
	v_tablename := COALESCE(v_tablename, '{}');

	-- Return
	RETURN ('{"status":"Accepted", "message":'||v_message||', "version":"'||v_version||'"'||
             ',"body":{"feature":{"featureType":"visit", "tableName":"'||v_tablename||'", "idName":"user_id", "id":"'||current_user||'"}'||
		    ', "form":'||v_forminfo||
		    ', "data":{"layerManager":{}}}'||
		    '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

