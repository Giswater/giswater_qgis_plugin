/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2608

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_setdelete(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setdelete(p_data json)
  RETURNS json AS
$BODY$

/* example
visit:
SELECT SCHEMA_NAME.gw_fct_setdelete('{"client":{"device":4, "infoType":1, "lang":"ES"},
		"feature":{"featureType":"visit", "tableName":"om_visit", "id":10465, "idName": "id"}}')
connec:
SELECT SCHEMA_NAME.gw_fct_setdelete('{"client":{"device":4, "infoType":1, "lang":"ES"},
		"feature":{"featureType":"connec", "tableName":"ve_connec", "id":3008, "idName": "connec_id"}}')
file:
SELECT SCHEMA_NAME.gw_fct_setdelete('{"client":{"device":4, "infoType":1, "lang":"ES"},
		"feature":{"featureType":"file", "tableName":"om_visit_file", "id":2, "idName": "id"}}')
lot:
SELECT SCHEMA_NAME.gw_fct_setdelete('{"client":{"device":4, "infoType":1, "lang":"ES"},
		"feature":{"featureType":"lot", "tableName":"om_visit_lot", "id":44, "idName": "id"}}')

psector:
  SELECT SCHEMA_NAME.gw_fct_setdelete($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, 
  "feature":{"id":["1"], "featureType":"PSECTOR", "tableName":"v_ui_plan_psector", "idName":"psector_id"}, 
  "data":{"filterFields":{}, "pageInfo":{}}}$$);
*/

DECLARE

v_tablename text;
v_id  character varying;
v_querytext varchar;
v_featuretype text;
v_idname text;
v_psector_array text; 
rec_type record;
rec text;
v_count integer;
v_feature_array text[];

v_version text;
v_schemaname text;
v_message text;
v_result text;
v_feature json;
v_error_context text;
v_message2 json;


BEGIN

	--  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';
	
	--  get api version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;
     
	-- Get input parameters:
	v_feature := (p_data ->> 'feature');
	v_featuretype := (p_data ->> 'feature')::json->> 'featureType';
	v_tablename := (p_data ->> 'feature')::json->> 'tableName';
	v_id := (p_data ->> 'feature')::json->> 'id';
	v_idname := (p_data ->> 'feature')::json->> 'idName';

	IF upper(v_featuretype)='PSECTOR' THEN

		select string_agg(quote_literal(a),',') into v_psector_array from json_array_elements_text(v_id::json) a;

		--loop over distinct feature types
		FOR rec_type IN SELECT * FROM sys_feature_type WHERE classlevel=1 OR classlevel=2 LOOP

			EXECUTE 'SELECT array_agg('||rec_type.id||'_id) FROM plan_psector_x_'||rec_type.id||' 
			WHERE  psector_id::text IN ('||v_psector_array||')'
			INTO v_feature_array;
		
			IF v_feature_array IS NOT NULL THEN
	
					FOREACH rec IN ARRAY(v_feature_array) LOOP
						
						EXECUTE 'SELECT count(psector_id) FROM plan_psector_x_'||rec_type.id||' 
						JOIN '||rec_type.id||' n USING ('||rec_type.id||'_id) 
						WHERE n.state = 2 AND '||rec_type.id||'_id = '||quote_literal(rec)||''
						INTO v_count;
						
						IF v_count = 1 THEN
							EXECUTE 'SELECT gw_fct_setfeaturedelete($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, 
							"feature":{"type":"'||rec_type.id||'"}, 
							"data":{"filterFields":{}, "pageInfo":{}, "feature_id":"'||rec||'"}}$$);';
						END IF;
					 
					END LOOP;
			END IF;
		END LOOP;

		-- check if feature exists
		EXECUTE 'SELECT * FROM ' || quote_ident(v_tablename) ||' WHERE '|| quote_ident(v_idname) ||' IN ('||v_psector_array||')'
		iNTO v_result ;

		v_id=replace(v_psector_array::text,'''','');
		
		IF v_result IS NOT NULL THEN
			EXECUTE 'DELETE FROM ' || quote_ident(v_tablename) ||' WHERE '|| quote_ident(v_idname) ||' IN ('||v_psector_array||')';
			v_message = concat('"Psector ',v_id,' has been deleted."');
		ELSE
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3116", "function":"2608","parameters":{"id":"'||v_id||'"}, "is_process":true}}$$)'
			INTO v_message;
		END IF;

	ELSE

		/* IF don't receive info
		-- Get featureType
		IF v_featuretype IS NULL THEN
			IF v_tablename = 'om_visit_lot' THEN
				v_featuretype ='lot';
			ELSIF v_tablename = 'om_visit_event_photo' THEN
				v_featuretype ='file';
			ELSIF v_tablename = 'om_visit' THEN
				v_featuretype ='visit';	
		END IF;
		*/
			
		-- check if feature exists
		v_querytext := 'SELECT * FROM ' || quote_ident(v_tablename) ||' WHERE '|| quote_ident(v_idname) ||' = '||quote_literal(v_id);
		EXECUTE v_querytext INTO v_result ;

		-- if exists
		IF v_result IS NOT NULL THEN
			
			-- exception for lots with related visits. Show Warning message
			IF v_tablename='om_visit_lot' THEN
				SELECT count(*) INTO v_count FROM om_visit WHERE lot_id=v_id::integer;
				IF v_count > 0 THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3201", "function":"2608","parameters":null, "is_process":true}}$$);'INTO v_message2;
					v_message2 = (((v_message2->>'body')::json->>'data')::json->>'info')::json;
					RETURN ('{"status":"Accepted", "message":'||v_message2||', "apiVersion":'|| v_version ||',
					"body": {}}')::json; 
				END IF;				   
			END IF;
		
			v_querytext := 'DELETE FROM ' || quote_ident(v_tablename) ||' WHERE '|| quote_ident(v_idname) ||' = '||quote_literal(v_id);
			
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3114", "function":"2608","parameters":null, "is_process":true}}$$)'
			INTO v_message;
			EXECUTE v_querytext;
		ELSE
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3116", "function":"2608","parameters":null, "is_process":true}}$$)'
			INTO v_message;
		END IF;
	END IF;
	-- Return
    RETURN ('{"status":"Accepted", "message":'||v_message||', "version":'|| v_version ||
	    ', "body": {"feature":{"tableName":"'||v_tablename||'", "id":"'||v_id||'"}}}')::json;    

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
    RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE)::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

