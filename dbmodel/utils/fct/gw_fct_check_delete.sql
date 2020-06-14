/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2120

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_check_delete(text, text);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_check_delete(p_data json)
  RETURNS json AS
$BODY$
/*
SELECT SCHEMA_NAME.gw_fct_check_delete($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"id":"1007","featureType":"NODE"},
"data":{}}$$)
*/

DECLARE

rec_node record;
v_num_feature integer;
v_project_type text;
v_error text;
v_feature_type text;
v_feature_id text;

v_result text;
v_result_info text;
v_result_point text;
v_result_line text;
v_result_polygon text;
v_error_context text;
v_level integer;
v_status text;
v_message text;
v_version text;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version LIMIT 1;
	
	v_feature_id = ((p_data ->>'feature')::json->>'id')::text;
	v_feature_type = upper(((p_data ->>'feature')::json->>'featureType')::text);
	
    -- Computing process
    IF v_feature_type='NODE' THEN
	
		IF v_project_type='WS' THEN 
				select count(*) INTO v_num_feature from node join node a on node.parent_id=a.node_id where node.parent_id=v_feature_id;
				IF v_num_feature > 0 THEN
					v_error = concat(v_num_feature,',',v_feature_id);
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"2108", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
				END IF;
		END IF;
		
		SELECT count(arc_id) INTO v_num_feature FROM arc WHERE node_1=v_feature_id OR node_2=v_feature_id ;
			IF v_num_feature > 0 THEN
				v_error = concat(v_num_feature,',',v_feature_id);
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1056", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
			END IF;

		SELECT count(element_id) INTO v_num_feature FROM element_x_node WHERE node_id=v_feature_id ;
			IF v_num_feature > 0 THEN
				v_error = concat(v_num_feature,',',v_feature_id);
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1058", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
			END IF;
			
		SELECT count(doc_id) INTO v_num_feature FROM doc_x_node WHERE node_id=v_feature_id ;
			IF v_num_feature > 0 THEN
				v_error = concat(v_num_feature,',',v_feature_id);
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1060", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
			END IF;
	
		SELECT count(visit_id) INTO v_num_feature FROM om_visit_x_node WHERE node_id=v_feature_id ;
			IF v_num_feature > 0 THEN
				v_error = concat(v_num_feature,',',v_feature_id);
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1062", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
			END IF;
	
		SELECT count(link_id) INTO v_num_feature FROM link WHERE exit_type='NODE' AND exit_id=v_feature_id;
			IF v_num_feature > 0 THEN
				v_error = concat(v_num_feature,',',v_feature_id);
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1064", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
			END IF;	
			
	
	ELSIF v_feature_type='ARC' THEN

		SELECT count(element_id) INTO v_num_feature FROM element_x_arc WHERE arc_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',v_feature_id);
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1058", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
		END IF;
		
		SELECT count(doc_id) INTO v_num_feature FROM doc_x_arc WHERE arc_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',v_feature_id);
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1060", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
		END IF;

		SELECT count(visit_id) INTO v_num_feature FROM om_visit_x_arc WHERE arc_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',v_feature_id);
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1062", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
		END IF;

		SELECT count(arc_id) INTO v_num_feature FROM connec WHERE arc_id=v_feature_id;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',v_feature_id);
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1066", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
		END IF;	
	
	
		IF v_project_type='UD' THEN
			SELECT count(arc_id) INTO v_num_feature FROM gully WHERE arc_id=v_feature_id;
				IF v_num_feature > 0 THEN
					v_error = concat(v_num_feature,',',v_feature_id);
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"1068", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
				END IF;	
		ELSIF v_project_type='WS' THEN 
				SELECT count(arc_id) INTO v_num_feature FROM node WHERE arc_id=v_feature_id;
				IF v_num_feature > 0 THEN
					v_error = concat(v_num_feature,',',v_feature_id);
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"2108", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
				END IF;
		END IF;


    ELSIF v_feature_type='CONNEC' THEN

		SELECT count(element_id) INTO v_num_feature FROM element_x_connec WHERE connec_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',v_feature_id);
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1058", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
		END IF;
		
		SELECT count(doc_id) INTO v_num_feature FROM doc_x_connec WHERE connec_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',v_feature_id);
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1060", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
		END IF;

		SELECT count(visit_id) INTO v_num_feature FROM om_visit_x_connec WHERE connec_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',v_feature_id);
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1062", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
		END IF;

		SELECT count(link_id) INTO v_num_feature FROM link WHERE exit_type='CONNEC' AND exit_id=v_feature_id;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',v_feature_id);
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1064", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
		END IF;	


		ELSIF v_feature_type='GULLY' THEN

		SELECT count(element_id) INTO v_num_feature FROM element_x_gully WHERE gully_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',v_feature_id);
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1058", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
		END IF;
		
		SELECT count(doc_id) INTO v_num_feature FROM doc_x_gully WHERE gully_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',v_feature_id);
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1060", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
		END IF;
	
		SELECT count(visit_id) INTO v_num_feature FROM om_visit_x_gully WHERE gully_id=v_feature_id ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',v_feature_id);
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1062", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
		END IF;

		SELECT count(link_id) INTO v_num_feature FROM link WHERE exit_type='GULLY' AND exit_id=v_feature_id;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',v_feature_id);
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1064", "function":"2120","debug_msg":"'||v_error||'"}}$$);';
		END IF;	
		
    END IF;


	v_result_info := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');

	v_result_point = '{"geometryType":"", "features":[]}';
	v_result_line = '{"geometryType":"", "features":[]}';
	v_result_polygon = '{"geometryType":"", "features":[]}';

	v_status = 'Accepted';
    v_level = 3;
    v_message = 'Process done successfully';

	--  Return
     RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
		     	'"setVisibleLayers":[]'||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

