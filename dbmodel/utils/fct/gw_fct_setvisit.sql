/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2622

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setvisit(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_setvisit($${"client":{"device":5, "lang":"es_ES", "cur_user": "bgeo", "infoType":1}, "form":{}, "feature":{"visitId": "None"}, "data":{"filterFields":{}, "pageInfo":{}, "fields": {"parameter_id": "clean_arc", "status": "1", "enddate": "", "startdate": "", "descript": "", "position_value": "aaa", "position_id": "1001", "visitcat_id": "1", "event_code": "321", "ext_code": "123", "class_id": "1", "user_name": "bgeo", "visit_id": "971"}}}$$);
*/

declare
v_fields json;
v_visit_id integer;
v_tablename text;
v_version text;
v_id integer;
v_outputparameter json;
v_insertresult json;
v_message json;
v_feature json;
v_geometry json;
v_thegeom public.geometry;
v_class integer;
v_ckeckchangeclass int8;
v_xcoord float;
v_ycoord float;
v_visitextcode text;
v_visitcat int2;
v_status int2;
return_event_manager_aux json;
v_event_manager json;
v_node_id integer;
v_addfile json;
v_deletefile json;
v_fields_json json;
v_message1 text;
v_message2 text;
v_fileid text;
v_filefeature json;
v_client json;
v_addphotos json;
v_addphotos_array json[];
v_list_photos text[];
v_event_id bigint;
v_errcontext text;
v_project_type text;
v_querystring text;
v_debug_vars json;
v_debug json;
v_msgerr json;
v_lot integer;
v_unit_id integer;
v_arc_id integer;
v_gully_id integer;
rec_node record;
rec_arc record;
rec_gully record;
rec_link record;
id_last integer;
v_parent_id integer;
v_visitclass_arc integer;
v_visitclass_node integer;
v_visitclass_gully integer;
v_feature_id integer;
v_schemaname text;
v_idname text;
v_client_epsg integer;
v_epsg integer;
v_visitclass_link integer;


BEGIN

	-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
   v_schemaname := 'SCHEMA_NAME';

	--  get api version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	EXECUTE 'SELECT project_type FROM sys_version'
	INTO v_project_type;


	--  get input values
	v_fields := ((p_data ->> 'data')::json->> 'fields');
	v_visit_id := ((p_data ->> 'feature')::json->> 'visitId');
	v_xcoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'xcoord';
	v_ycoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'ycoord';
	v_client_epsg := (p_data ->> 'client')::json->> 'epsg';
	v_addphotos := ((p_data ->> 'data')::json->> 'files');
	v_epsg := (SELECT epsg FROM sys_version ORDER BY id DESC LIMIT 1);

	-- Get table_name

	EXECUTE 'SELECT tablename FROM config_visit_class WHERE id = '||(v_fields->>'class_id')::integer||''
	INTO v_tablename;

	-- Get id_name
	v_querystring = concat('SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
	AND t.relname = ''',v_tablename,'''
	AND s.nspname = ''',v_schemaname,'''
	ORDER BY a.attnum LIMIT 1');
	EXECUTE v_querystring INTO v_idname;

	-- setting sequences of related visit tables
	PERFORM setval('"SCHEMA_NAME".om_visit_id_seq', (SELECT max(id) FROM om_visit), true);
	PERFORM setval('"SCHEMA_NAME".om_visit_event_id_seq', (SELECT max(id) FROM om_visit_event), true);
	PERFORM setval('"SCHEMA_NAME".om_visit_x_arc_id_seq', (SELECT max(id) FROM om_visit_x_arc), true);
	PERFORM setval('"SCHEMA_NAME".om_visit_x_node_id_seq', (SELECT max(id) FROM om_visit_x_node), true);
	PERFORM setval('"SCHEMA_NAME".om_visit_x_connec_id_seq', (SELECT max(id) FROM om_visit_x_connec), true);
	PERFORM setval('"SCHEMA_NAME".om_visit_x_link_id_seq', (SELECT max(id) FROM om_visit_x_link), true);
	PERFORM setval('"SCHEMA_NAME".doc_x_visit_id_seq', (SELECT max(id) FROM doc_x_visit), true);

	IF v_project_type ='UD' THEN
		PERFORM setval('"SCHEMA_NAME".om_visit_x_gully_id_seq', (SELECT max(id) FROM om_visit_x_gully), true);
	END IF;


	-- setting output parameter
	v_outputparameter := concat('{"client":',((p_data)->>'client'),', "feature":',((p_data)->>'feature'),', "data":',((p_data)->>'data'),'}')::json;

	-- setting users value default
	-- om_visit_class_vdefault
	IF (SELECT parameter FROM config_param_user WHERE parameter = 'om_visit_class_vdefault' AND cur_user=current_user) IS NOT NULL THEN
		UPDATE config_param_user SET value = v_class WHERE parameter = 'om_visit_class_vdefault' AND cur_user=current_user;
	ELSE
		INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('om_visit_class_vdefault', v_class, current_user);
	END IF;

	-- om_visit_extcode_vdefault
	IF (SELECT parameter FROM config_param_user WHERE parameter = 'om_visit_extcode_vdefault' AND cur_user=current_user) IS NOT NULL THEN
		UPDATE config_param_user SET value = v_visitextcode WHERE parameter = 'om_visit_extcode_vdefault' AND cur_user=current_user;
	ELSE
		INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('om_visit_extcode_vdefault', v_visitextcode, current_user);
	END IF;

	-- om_visit_cat_vdefault
	IF (SELECT parameter FROM config_param_user WHERE parameter = 'om_visit_cat_vdefault' AND cur_user=current_user) IS NOT NULL THEN
		UPDATE config_param_user SET value = v_visitcat WHERE parameter = 'om_visit_cat_vdefault' AND cur_user=current_user;
	ELSE
		INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('om_visit_cat_vdefault', v_visitcat, current_user);
	END IF;

	--upsert visit

	IF v_visit_id IS NULL THEN

		-- setting the insert
		v_id = (SELECT nextval('SCHEMA_NAME.om_visit_id_seq'::regclass));
		v_feature = gw_fct_json_object_set_key (v_feature, 'visitId', v_id);
		-- CHECK THIS
		v_feature = gw_fct_json_object_set_key (v_feature, 'tableName',v_tablename);
		v_feature = gw_fct_json_object_set_key (v_feature, 'idName', 'visit_id'::text);

		v_outputparameter = gw_fct_json_object_set_key (v_outputparameter, 'feature', v_feature);

		SELECT gw_fct_setinsert (v_outputparameter) INTO v_insertresult;
		if v_insertresult->>'status' = 'Failed' then
			return v_insertresult;
		end if;

		-- updating v_feature setting new id
		v_feature =  gw_fct_json_object_set_key (v_feature, 'id', v_id);

		-- Make point
		if v_xcoord is not null THEN
			SELECT ST_Transform(ST_SetSRID(ST_MakePoint(v_xcoord,v_ycoord),v_client_epsg),v_epsg) INTO v_thegeom;

			-- updating visit
			UPDATE om_visit SET the_geom=v_thegeom WHERE id=v_id;
		end if;

		-- message
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3118", "function":"2622","parameters":null, "is_process":true}}$$);'INTO v_message;

		RAISE NOTICE '--- INSERT NEW VISIT gw_fct_setinsert WITH MESSAGE: % ---', v_message;

	ELSE
		v_id = v_visit_id;
		-- refactorize om_visit and om_visit_event in case of update of class the change of parameters is need)
		v_querystring = concat('SELECT visit_id FROM ',quote_ident(v_tablename),' WHERE visit_id = ',quote_literal(v_id));
		v_debug_vars := json_build_object('v_tablename', v_tablename, 'v_id', v_id);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_setvisit', 'flag', 10);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO v_ckeckchangeclass;
		IF v_ckeckchangeclass IS NULL THEN
			DELETE FROM om_visit_event WHERE visit_id = v_id;
			INSERT INTO om_visit_event (parameter_id, visit_id) SELECT parameter_id, v_id
			FROM config_visit_class_x_parameter WHERE class_id=v_class and active IS TRUE;
			UPDATE om_visit SET class_id=v_class WHERE id = v_id;
		END IF;
		--setting the update

		-- CHECK THIS
		v_feature = gw_fct_json_object_set_key (v_feature, 'tableName',v_tablename);
		v_feature = gw_fct_json_object_set_key (v_feature, 'id', v_id);
		v_feature = gw_fct_json_object_set_key (v_feature, 'idName', 'visit_id'::text);

		v_outputparameter = gw_fct_json_object_set_key (v_outputparameter, 'feature', v_feature);
		PERFORM gw_fct_setfields (v_outputparameter);

		-- message
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3120", "function":"2662","parameters":null, "is_process":true}}$$);'INTO v_message;

		RAISE NOTICE '--- UPDATE VISIT gw_fct_setfields USING v_id % WITH MESSAGE: % ---', v_id, v_message;

	END IF;

	-- Getting and manage array photos
	SELECT array_agg(row_to_json(a)) FROM (SELECT json_array_elements(v_addphotos))a into v_addphotos_array;

	IF v_addphotos_array IS NOT NULL THEN
		v_querystring = concat('SELECT id FROM om_visit_event WHERE visit_id = ',v_id);
		v_debug_vars := json_build_object('v_id', v_id);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_setvisit', 'flag', 20);

		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO v_event_id;

		FOREACH v_addphotos IN ARRAY v_addphotos_array
		loop
			-- Inserting data
			v_querystring = concat('INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value)
			 VALUES(',quote_nullable(v_id),', ',quote_nullable(v_event_id),', ',quote_nullable(NOW()),',', quote_nullable(v_addphotos::json->>'json_array_elements'), ')');

			v_debug_vars := json_build_object('v_id', v_id, 'v_event_id', v_event_id, 'v_addphotos', v_addphotos, 'v_addphotos', v_addphotos);
			v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_setvisit', 'flag', 30);
			SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;

			EXECUTE v_querystring;

			-- message
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3118", "function":"2622","parameters":null, "is_process":true}}$$);'INTO v_message;

		END LOOP;
		v_querystring = concat('UPDATE om_visit_event SET value = ''true'' WHERE visit_id = ',quote_nullable(v_id),' AND parameter_id = ''photo''');
		v_debug_vars := json_build_object('v_id', v_id);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_setvisit', 'flag', 40);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring;
	ELSE
		v_querystring = concat('UPDATE om_visit_event SET value = ''false'' WHERE visit_id = ',quote_nullable(v_id),' AND parameter_id = ''photo''');
		v_debug_vars := json_build_object('v_id', v_id);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_setvisit', 'flag', 50);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring;

	END IF;

	-- update event with device parameters
	RAISE NOTICE 'UPDATE EVENT USING deviceTrace %', ((p_data ->>'data')::json->>'deviceTrace');
	UPDATE om_visit_event SET xcoord=(((p_data ->>'data')::json->>'deviceTrace')::json->>'xcoord')::float,
				  ycoord=(((p_data ->>'data')::json->>'deviceTrace')::json->>'ycoord')::float,
				  compass=(((p_data ->>'data')::json->>'deviceTrace')::json->>'compass')::float,
				  tstamp=now()
				  WHERE visit_id=v_id;


	-- LOTS MANAGE UNITS (um_visitclass)
	-- only for visitclass which has parent_id
	SELECT parent_id INTO v_parent_id FROM config_visit_class WHERE id=v_class;
	IF v_parent_id IS NOT NULL THEN
		-- select unit_id from the om_visit_lot_x_* table
		IF (SELECT lower(feature_type) FROM config_visit_class WHERE id=v_class) = 'arc' THEN
			SELECT unit_id INTO v_unit_id FROM om_visit_lot_x_arc WHERE arc_id=v_arc_id::text AND lot_id=v_lot;
		ELSIF (SELECT lower(feature_type) FROM config_visit_class WHERE id=v_class) = 'node' THEN
			SELECT unit_id INTO v_unit_id FROM om_visit_lot_x_node WHERE node_id=v_node_id::text AND lot_id=v_lot;
		ELSIF (SELECT lower(feature_type) FROM config_visit_class WHERE id=v_class) = 'gully' THEN
			SELECT unit_id INTO v_unit_id FROM om_visit_lot_x_gully WHERE gully_id=v_gully_id::text AND lot_id=v_lot;
		END IF;

		UPDATE om_visit_lot_x_unit SET status=v_status WHERE unit_id=v_unit_id AND lot_id=v_lot;

		-- set visit to every feature of the related unit
		-- get generic v_feature_id whenever is arc or node
		IF v_arc_id IS NOT NULL THEN
			v_feature_id=v_arc_id;
		ELSIF v_node_id IS NOT NULL THEN
			v_feature_id=v_node_id;
		ELSE
			v_feature_id=v_gully_id;
		END IF;

		-- select visitclass for arc and loop for every arc on om_visit_lot_x_arc. Then insert visit and events with same values of the one triggered by this setvisit
		SELECT id INTO v_visitclass_arc FROM config_visit_class WHERE parent_id=v_parent_id AND lower(feature_type)='arc';
		FOR rec_arc IN SELECT * FROM om_visit_lot_x_arc WHERE unit_id=v_unit_id AND lot_id=v_lot AND arc_id::integer <> v_feature_id::integer
		LOOP
			INSERT INTO om_visit (startdate, enddate, expl_id, user_name, lot_id, class_id, status, visit_type, the_geom, unit_id)
			SELECT startdate, enddate, expl_id, user_name, lot_id, v_visitclass_arc, status, visit_type, the_geom, unit_id FROM om_visit WHERE id=v_id RETURNING id INTO id_last;
			INSERT INTO om_visit_x_arc (visit_id, arc_id) VALUES(id_last, rec_arc.arc_id);
	        INSERT INTO om_visit_event (visit_id, parameter_id, value, xcoord, ycoord) SELECT id_last, parameter_id, value, xcoord, ycoord FROM om_visit_event WHERE visit_id=v_id;
		END LOOP;

		-- select visitclass for node and loop for every node on om_visit_lot_x_node. Then insert visit and events with same values of the one triggered by this setvisit
		SELECT id INTO v_visitclass_node FROM config_visit_class WHERE parent_id=v_parent_id AND lower(feature_type)='node';
		FOR rec_node IN SELECT * FROM om_visit_lot_x_node WHERE unit_id=v_unit_id AND lot_id=v_lot AND node_id::integer <> v_feature_id::integer
		LOOP
			INSERT INTO om_visit (startdate, enddate, expl_id, user_name, lot_id, class_id, status, visit_type, the_geom, unit_id)
			SELECT startdate, enddate, expl_id, user_name, lot_id, v_visitclass_node, status, visit_type, the_geom, unit_id FROM om_visit WHERE id=v_id RETURNING id INTO id_last;
			INSERT INTO om_visit_x_node (visit_id, node_id) VALUES(id_last, rec_node.node_id);
	        INSERT INTO om_visit_event (visit_id, parameter_id, value, xcoord, ycoord) SELECT id_last, parameter_id, value, xcoord, ycoord FROM om_visit_event WHERE visit_id=v_id;
		END LOOP;

		-- select visitclass for link and loop for every link on om_visit_lot_x_link. Then insert visit and events with same values of the one triggered by this setvisit
		SELECT id INTO v_visitclass_link FROM config_visit_class WHERE parent_id=v_parent_id AND lower(feature_type)='link';
		FOR rec_link IN SELECT * FROM om_visit_lot_x_link WHERE unit_id=v_unit_id AND lot_id=v_lot AND link_id::integer <> v_feature_id::integer
		LOOP
			INSERT INTO om_visit (startdate, enddate, expl_id, user_name, lot_id, class_id, status, visit_type, the_geom, unit_id)
			SELECT startdate, enddate, expl_id, user_name, lot_id, v_visitclass_link, status, visit_type, the_geom, unit_id FROM om_visit WHERE id=v_id RETURNING id INTO id_last;
			INSERT INTO om_visit_x_link (visit_id, link_id) VALUES(id_last, rec_link.link_id);
	        INSERT INTO om_visit_event (visit_id, parameter_id, value, xcoord, ycoord) SELECT id_last, parameter_id, value, xcoord, ycoord FROM om_visit_event WHERE visit_id=v_id;
		END LOOP;

		-- select visitclass for gully and loop for every gully on om_visit_lot_x_gully. Then insert visit and events with same values of the one triggered by this setvisit
		SELECT id INTO v_visitclass_gully FROM config_visit_class WHERE parent_id=v_parent_id AND lower(feature_type)='gully';
		FOR rec_gully IN SELECT * FROM om_visit_lot_x_gully WHERE unit_id=v_unit_id AND lot_id=v_lot AND gully_id::integer <> v_feature_id::integer
		LOOP
			INSERT INTO om_visit (startdate, enddate, expl_id, user_name, lot_id, class_id, status, visit_type, the_geom, unit_id)
			SELECT startdate, enddate, expl_id, user_name, lot_id, v_visitclass_gully, status, visit_type, the_geom, unit_id FROM om_visit WHERE id=v_id RETURNING id INTO id_last;
			INSERT INTO om_visit_x_gully (visit_id, gully_id) VALUES(id_last, rec_gully.gully_id);
	        INSERT INTO om_visit_event (visit_id, parameter_id, value, xcoord, ycoord) SELECT id_last, parameter_id, value, xcoord, ycoord FROM om_visit_event WHERE visit_id=v_id;
		END LOOP;

	END IF;


	-- getting geometry
	IF v_id IS NOT NULL THEN
		v_querystring = concat('SELECT row_to_json(a) FROM (SELECT St_AsText(St_simplify(the_geom,0)) FROM om_visit WHERE id=',quote_nullable(v_id),')a');
		v_debug_vars := json_build_object('v_id', v_id);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_setvisit', 'flag', 60);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
		EXECUTE v_querystring INTO v_geometry;
	END IF;

	-- only applied for arbrat viari (nodes).
	IF v_status='4' AND v_project_type='TM' THEN
	    UPDATE om_visit SET enddate = current_timestamp::timestamp WHERE id = v_id;
		SELECT row_to_json(a) FROM (SELECT gw_fct_om_visit_event_manager(v_id::integer) as "st_astext")a INTO return_event_manager_aux ;
    END IF;

	--  Control NULL's
	v_version := COALESCE(v_version, '');
	v_message := COALESCE(v_message, '{}');
	v_geometry := COALESCE(v_geometry, '{}');
	return_event_manager_aux := COALESCE(return_event_manager_aux, '{}');

	-- Return
	RETURN ('{"status":"Accepted", "message":'||v_message||', "version":"'|| v_version ||'",'||
	'"body": {"feature":{"id":"'||v_id||'"}, "data":{"geometry":'|| return_event_manager_aux ||'}}}')::json;

END;
$function$
;
