/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2622

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_setvisit(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

-- INSERT WITH GEOMETRY (visit notinfra)
  SELECT SCHEMA_NAME.gw_api_setvisit($${"client":{"device":3,"infoType":100,"lang":"es"},"form":{},
  "feature":{"featureType":"visit", "tableName":"ve_visit_noinfra_typea", "id":10373, "idName":"visit_id"},
   "data":{"fields":{"class_id":"8","visit_id":"10373","visitcat_id":"1","startdate":null,"enddate":null},
	   "canvas":{"xcoord":343434, "ycoord":234235235}}}$$) AS result


--INSERT
SELECT SCHEMA_NAME.gw_api_setvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"visit", "tableName":"ve_visit_arc_insp", "id":null, "idName":"visit_id"},
"data":{"fields":{"class_id":6, "arc_id":"2001", "visitcat_id":1, "ext_code":"testcode", "sediments_arc":10, "desperfectes_arc":1, "neteja_arc":3},
	"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}
	}$$)

--UPDATE
SELECT SCHEMA_NAME.gw_api_setvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"visit", "tableName":"ve_visit_arc_insp", "id":1159,"idName":"visit_id"},
"data":{"fields":{"class_id":6, "arc_id":"2001", "visitcat_id":1, "ext_code":"testcode", "sediments_arc":100, "desperfectes_arc":1, "neteja_arc":3},
	"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}
	}$$)
*/

DECLARE
	v_tablename text;
	v_apiversion text;
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
	v_version varchar;
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
	v_parameter_id text;
	

BEGIN

-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
	INTO v_apiversion;

	EXECUTE 'SELECT wsoftware FROM version'
	INTO v_version;
	
--  get input values
	v_client = (p_data ->>'client')::json;
	v_id = ((p_data ->>'feature')::json->>'id');
	v_feature = p_data ->>'feature';
	v_class = ((p_data ->>'data')::json->>'fields')::json->>'class_id';
	v_visitextcode = ((p_data ->>'data')::json->>'fields')::json->>'ext_code';
	v_visitcat = ((p_data ->>'data')::json->>'fields')::json->>'visitcat_id';
	v_addfile = ((p_data ->>'data')::json->>'newFile')::json;
	v_deletefile = ((p_data ->>'data')::json->>'deleteFile')::json;
	v_status = ((p_data ->>'data')::json->>'fields')::json->>'status';
	v_tablename = ((p_data ->>'feature')::json->>'tableName');
	v_xcoord = (((p_data ->>'data')::json->>'deviceTrace')::json->>'xcoord')::float;
	v_ycoord = (((p_data ->>'data')::json->>'deviceTrace')::json->>'ycoord')::float;
	v_thegeom = st_setsrid(st_makepoint(v_xcoord, v_ycoord),SRID_VALUE);
	v_node_id = ((p_data ->>'data')::json->>'fields')::json->>'node_id';
	v_addphotos = (p_data ->>'data')::json->>'photos';
	v_parameter_id = ((p_data ->>'data')::json->>'fields')::json->>'parameter_id';

	
	-- Get new visit id if not exist
	IF v_id IS NULL THEN
		v_id := (SELECT max(id)+1 FROM om_visit);
	END IF;
	
	IF v_id IS NULL AND (SELECT count(id) FROM om_visit) = 0 THEN
		v_id=1;
	END IF;
		
	-- setting output parameter
	v_outputparameter := concat('{"client":',((p_data)->>'client'),', "feature":',((p_data)->>'feature'),', "data":',((p_data)->>'data'),'}')::json;
	
	-- setting users value default
	
	-- visitclass_vdefault
	IF (SELECT id FROM config_param_user WHERE parameter = 'visitclass_vdefault' AND cur_user=current_user) IS NOT NULL THEN
		UPDATE config_param_user SET value = v_class WHERE parameter = 'visitclass_vdefault' AND cur_user=current_user;
	ELSE
		INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('visitclass_vdefault', v_class, current_user);
	END IF;

	-- visitextcode_vdefault
	IF (SELECT id FROM config_param_user WHERE parameter = 'visitextcode_vdefault' AND cur_user=current_user) IS NOT NULL THEN
		UPDATE config_param_user SET value = v_visitextcode WHERE parameter = 'visitextcode_vdefault' AND cur_user=current_user;
	ELSE
		INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('visitextcode_vdefault', v_visitextcode, current_user);
	END IF;

	-- visitcat_vdefault
	IF (SELECT id FROM config_param_user WHERE parameter = 'visitcat_vdefault' AND cur_user=current_user) IS NOT NULL THEN
		UPDATE config_param_user SET value = v_visitcat WHERE parameter = 'visitcat_vdefault' AND cur_user=current_user;
	ELSE
		INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('visitcat_vdefault', v_visitcat, current_user);
	END IF;

	--upsert visit
	
	IF (SELECT id FROM om_visit WHERE id=v_id) IS NULL THEN

		-- setting the insert
		v_id = (SELECT nextval('SCHEMA_NAME.om_visit_id_seq'::regclass));
		v_feature = gw_fct_json_object_set_key (v_feature, 'id', v_id);
		v_outputparameter = gw_fct_json_object_set_key (v_outputparameter, 'feature', v_feature);
		SELECT gw_api_setinsert (v_outputparameter) INTO v_insertresult;
		
		-- getting new id
		IF (((v_insertresult->>'body')::json->>'feature')::json->>'id')::integer IS NOT NULL THEN
		
			v_id=(((v_insertresult->>'body')::json->>'feature')::json->>'id')::integer;
			
		END IF;
		
		-- updating v_feature setting new id
		v_feature =  gw_fct_json_object_set_key (v_feature, 'id', v_id);
		
		-- updating visit
		UPDATE om_visit SET the_geom=v_thegeom WHERE id=v_id;

		-- getting message
		SELECT gw_api_getmessage(v_feature, 40) INTO v_message;

		RAISE NOTICE '--- INSERT NEW VISIT gw_api_setinsert WITH MESSAGE: % ---', v_message;
	
	ELSE 

		-- refactorize om_visit and om_visit_event in case of update of class the change of parameters is need)

		EXECUTE ('SELECT visit_id FROM ' || quote_ident(v_tablename) || ' WHERE visit_id = ' || quote_literal(v_id) || '') INTO v_ckeckchangeclass;
		IF v_ckeckchangeclass IS NULL THEN
			DELETE FROM om_visit_event WHERE visit_id = v_id;
			INSERT INTO om_visit_event (parameter_id, visit_id) SELECT parameter_id, v_id FROM om_visit_class_x_parameter WHERE class_id=v_class;
			UPDATE om_visit SET class_id=v_class WHERE id = v_id;
		END IF;
		
		--setting the update
		PERFORM gw_api_setfields (v_outputparameter);
	
		-- getting message
		SELECT gw_api_getmessage(v_feature, 50) INTO v_message;

		RAISE NOTICE '--- UPDATE VISIT gw_api_setfields USING v_id % WITH MESSAGE: % ---', v_id, v_message;

	END IF;


	-- Getting and manage array photos
	SELECT array_agg(row_to_json(a)) FROM (SELECT json_array_elements(v_addphotos))a into v_addphotos_array;

	IF v_addphotos_array IS NOT NULL THEN
		EXECUTE 'SELECT id FROM om_visit_event WHERE visit_id = ' || v_id || '' into v_event_id;
		FOREACH v_addphotos IN ARRAY v_addphotos_array
		LOOP
			-- Inserting data
			EXECUTE 'INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text) VALUES('''||v_id||''', '''||v_event_id||''', '''||NOW()||''', '''||CONCAT((v_addphotos->>'json_array_elements')::json->>'photo_url'::text, (v_addphotos->>'json_array_elements')::json->>'hash'::text)||''', ''demo image'')';
			
			-- getting message
			SELECT gw_api_getmessage(v_feature, 40) INTO v_message;
			
		END LOOP;

	END IF;
	
/*
	-- Manage ADD FILE / PHOTO
	v_filefeature = '{"featureType":"file", "tableName":"om_visit_event_photo", "idName": "id"}';


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
*/
	-- update event with device parameters
	RAISE NOTICE 'UPDATE EVENT USING deviceTrace %', ((p_data ->>'data')::json->>'deviceTrace');
	UPDATE om_visit_event SET xcoord=(((p_data ->>'data')::json->>'deviceTrace')::json->>'xcoord')::float,
				  ycoord=(((p_data ->>'data')::json->>'deviceTrace')::json->>'ycoord')::float,
				  compass=(((p_data ->>'data')::json->>'deviceTrace')::json->>'compass')::float,
				  tstamp=now() 
				  WHERE visit_id=v_id;

	
	-- Save paramenter_id as vdefault
	IF (SELECT TRUE FROM config_param_user WHERE parameter = 'visitparameter_vdefault' and cur_user = current_user) THEN
		UPDATE config_param_user SET value= v_parameter_id WHERE parameter = 'visitparameter_vdefault' AND cur_user = current_user;
	ELSE
		INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('visitparameter_vdefault', v_parameter_id, current_user);
	END IF;
	
	-- getting geometry
	IF v_id IS NOT NULL THEN
		EXECUTE ('SELECT row_to_json(a) FROM (SELECT St_AsText(St_simplify(the_geom,0)) FROM om_visit WHERE id=' || v_id || ')a')
		    INTO v_geometry;
	END IF;
	
	-- only applied for arbrat viari (nodes).
	IF v_status='4' THEN
	    UPDATE om_visit SET enddate = current_timestamp::timestamp WHERE id = v_id;

	    IF v_version='TM' THEN
		SELECT row_to_json(a) FROM (SELECT gw_fct_om_visit_event_manager(v_id::integer) as "st_astext")a INTO return_event_manager_aux ;
    	END IF;
    	
    END IF;

	--  Control NULL's
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_message := COALESCE(v_message, '{}');
	v_geometry := COALESCE(v_geometry, '{}');
	return_event_manager_aux := COALESCE(return_event_manager_aux, '{}');
				  
--    Return

	RETURN ('{"status":"Accepted", "message":'||v_message||', "apiVersion":'|| v_apiversion ||', 
	"body": {"feature":{"id":"'||v_id||'"}, "data":{"geometry":'|| return_event_manager_aux ||'}}}')::json; 

      
--    Exception handling
   -- EXCEPTION WHEN OTHERS THEN 
    --    RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    

      

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
