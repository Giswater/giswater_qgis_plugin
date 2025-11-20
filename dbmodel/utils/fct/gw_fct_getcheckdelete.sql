/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2120

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getcheckdelete(text, text);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getcheckdelete(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getcheckdelete(p_data json)
  RETURNS json AS
$BODY$
/*
SELECT SCHEMA_NAME.gw_fct_getcheckdelete($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"id":"1007","featureType":"NODE"},
"data":{}}$$)

SELECT SCHEMA_NAME.gw_fct_getcheckdelete($${
"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},
"feature":{"id":["1"], "featureType":"PSECTOR", "tableName":"v_ui_plan_psector",
"idName":"psector_id"}, "data":{"filterFields":{}, "pageInfo":{}}}$$);
*/

DECLARE

rec_node record;
v_num_feature integer;
v_project_type text;
v_error text;
v_feature_type text;
v_feature_id text;
v_psector_array text;
v_count integer;
v_feature_array text[];
rec text;
rec_type record;

v_result text;
v_result_info text;
v_error_context text;
v_level integer;
v_status text;
v_message text;
v_version text;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	v_feature_id = ((p_data ->>'feature')::json->>'id')::text;
	v_feature_type = upper(((p_data ->>'feature')::json->>'featureType')::text);

    -- Computing process
    IF v_feature_type='NODE' THEN

		IF v_project_type='WS' THEN
				select count(*) INTO v_num_feature from node join node a on node.parent_id=a.node_id where node.parent_id=v_feature_id;
				IF v_num_feature > 0 THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"2108", "function":"2120","parameters":{"num_node":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
				END IF;
		END IF;

		SELECT count(arc_id) INTO v_num_feature FROM arc WHERE node_1=v_feature_id OR node_2=v_feature_id ;
			IF v_num_feature > 0 THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1056", "function":"2120","parameters":{"num_arc":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
			END IF;

		SELECT count(element_id) INTO v_num_feature FROM element_x_node WHERE node_id=v_feature_id ;
			IF v_num_feature > 0 THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1058", "function":"2120","parameters":{"num_element":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
			END IF;

		SELECT count(doc_id) INTO v_num_feature FROM doc_x_node WHERE node_id=v_feature_id ;
			IF v_num_feature > 0 THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1060", "function":"2120","parameters":{"num_document":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
			END IF;

		SELECT count(visit_id) INTO v_num_feature FROM om_visit_x_node WHERE node_id=v_feature_id ;
			IF v_num_feature > 0 THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1062", "function":"2120","parameters":{"num_visit":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
			END IF;

		SELECT count(link_id) INTO v_num_feature FROM link WHERE exit_type='NODE' AND exit_id=v_feature_id;
			IF v_num_feature > 0 THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1064", "function":"2120","parameters":{"num_link":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
			END IF;


	ELSIF v_feature_type='ARC' THEN

		SELECT count(element_id) INTO v_num_feature FROM element_x_arc WHERE arc_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1058", "function":"2120","parameters":{"num_element":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
		END IF;

		SELECT count(doc_id) INTO v_num_feature FROM doc_x_arc WHERE arc_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1060", "function":"2120","parameters":{"num_document":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
		END IF;

		SELECT count(visit_id) INTO v_num_feature FROM om_visit_x_arc WHERE arc_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1062", "function":"2120","parameters":{"num_visit":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
		END IF;

		SELECT count(arc_id) INTO v_num_feature FROM connec WHERE arc_id=v_feature_id;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',v_feature_id);
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1066", "function":"2120","parameters":{"num_connec":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
		END IF;


		IF v_project_type='UD' THEN
			SELECT count(arc_id) INTO v_num_feature FROM gully WHERE arc_id=v_feature_id;
				IF v_num_feature > 0 THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"1068", "function":"2120","parameters":{"num_gully":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
				END IF;
		ELSIF v_project_type='WS' THEN
				SELECT count(arc_id) INTO v_num_feature FROM node WHERE arc_id=v_feature_id;
				IF v_num_feature > 0 THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"2108", "function":"2120","parameters":{"num_node":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
				END IF;
		END IF;


    ELSIF v_feature_type='CONNEC' THEN

		SELECT count(element_id) INTO v_num_feature FROM element_x_connec WHERE connec_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1058", "function":"2120","parameters":{"num_element":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
		END IF;

		SELECT count(doc_id) INTO v_num_feature FROM doc_x_connec WHERE connec_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1060", "function":"2120","parameters":{"num_document":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
		END IF;

		SELECT count(visit_id) INTO v_num_feature FROM om_visit_x_connec WHERE connec_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1062", "function":"2120","parameters":{"num_visit":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
		END IF;

		SELECT count(link_id) INTO v_num_feature FROM link WHERE exit_type='CONNEC' AND exit_id=v_feature_id;
		IF v_num_feature > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1064", "function":"2120","parameters":{"num_link":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
		END IF;

	ELSIF v_feature_type='LINK' THEN

		SELECT count(element_id) INTO v_num_feature FROM element_x_link WHERE link_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1058", "function":"2120","parameters":{"num_element":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
		END IF;

		SELECT count(link_id) INTO v_num_feature FROM doc_x_link WHERE link_id=v_feature_id;
		IF v_num_feature > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1064", "function":"2120","parameters":{"num_document":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
		END IF;

		SELECT count(visit_id) INTO v_num_feature FROM om_visit_x_link WHERE link_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1062", "function":"2120","parameters":{"num_visit":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
		END IF;


	ELSIF v_feature_type='GULLY' THEN

		SELECT count(element_id) INTO v_num_feature FROM element_x_gully WHERE gully_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1058", "function":"2120","parameters":{"num_element":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
		END IF;

		SELECT count(doc_id) INTO v_num_feature FROM doc_x_gully WHERE gully_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1060", "function":"2120","parameters":{"num_document":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
		END IF;

		SELECT count(visit_id) INTO v_num_feature FROM om_visit_x_gully WHERE gully_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1062", "function":"2120","parameters":{"num_visit":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
		END IF;

		SELECT count(link_id) INTO v_num_feature FROM link WHERE exit_type='GULLY' AND exit_id=v_feature_id;
		IF v_num_feature > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1064", "function":"2120","parameters":{"num_link":"'||v_num_feature||'", "feature_id":"'||v_feature_id||'"}, "is_process":true}}$$);';
		END IF;

	ELSIF v_feature_type='PSECTOR' THEN

		DELETE FROM audit_check_data WHERE fid= 360 AND cur_user=current_user;

		select string_agg(quote_literal(a),', ') into v_psector_array from json_array_elements_text(v_feature_id::json) a;

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

							IF (SELECT result_id FROM audit_check_data WHERE fid=360 limit 1)is null then
								EXECUTE 'INSERT INTO audit_check_data (fid, error_message, result_id)
								VALUES (360, CONCAT(''Features that will be removed from the inventory:''),'||quote_literal(rec_type.id)||');';
							END IF;

							EXECUTE 'INSERT INTO audit_check_data (fid, error_message, result_id)
							SELECT DISTINCT 360,concat('||quote_literal(initcap(rec_type.id))||','' '','||rec||',
							'' - psector '',psector_id, ''.''),'''||rec_type.id||'''
							FROM plan_psector_x_'||rec_type.id||' JOIN '||rec_type.id||' n
							USING ('||rec_type.id||'_id) 
							WHERE n.state = 2 AND n.'||rec_type.id||'_id = '||quote_literal(rec)||';';
						END IF;

					END LOOP;
			END IF;
		END LOOP;


    END IF;


	v_result_info := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result_info, '}');

	v_status = 'Accepted';

	IF v_feature_type='PSECTOR' THEN

		SELECT string_agg(error_message,' \n') INTO v_message FROM audit_check_data
		WHERE cur_user="current_user"() AND fid=360;

		IF v_message IS NOT NULL THEN
			v_level = 1;
		ELSE
			v_level = 3;
			v_message = concat('Are you sure you want to delete psector: ',replace(v_psector_array,'''',''),'?');
		END IF;

	ELSE
		v_level = 3;
		v_message = 'Process done successfully';
	END IF;

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 2120, null, null, null);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
