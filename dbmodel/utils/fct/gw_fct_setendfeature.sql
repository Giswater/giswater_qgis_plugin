/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3022

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_setendfeature(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setendfeature(p_data json)
  RETURNS json AS
$BODY$

/* example
	SELECT SCHEMA_NAME.gw_fct_setendfeature($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
	"form":{}, "feature":{"featureType":"arc", "featureId":["113935", "2076", "2215"]}, 
	"data":{"filterFields":{}, "pageInfo":{}, "state_type":"1", "workcat_id_end":"work1", 
	"enddate":"2020/12/04", "workcat_date":"2017/12/06", "description":"Description work1"}}$$);
*/

DECLARE
v_id  text;
v_version text;
v_featuretype text;
v_error_context text;
v_num_feature integer;
v_psector_list text;
v_psector_id text;
v_id_list text[];
rec_id text;
v_result_info text;
v_projecttype text;
v_state_type integer;
v_workcat_id_end text;
v_enddate date;
v_audit_result text;
v_status text;
v_level integer;
v_message text;
BEGIN

	--  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	
	--  get api version
	EXECUTE 'SELECT value FROM config_param_system WHERE parameter=''admin_version'''
	INTO v_version;
      
    SELECT project_type INTO v_projecttype FROM sys_version LIMIT 1;
    --set current process as users parameter
	DELETE FROM config_param_user  WHERE  parameter = 'utils_cur_trans' AND cur_user =current_user;

	INSERT INTO config_param_user (value, parameter, cur_user)
	VALUES (txid_current(),'utils_cur_trans',current_user );

	-- Get input parameters:
	v_featuretype := lower((p_data ->> 'feature')::json->> 'featureType');
	v_id := (p_data ->> 'feature')::json->> 'featureId';
	v_state_type =  (p_data ->> 'data')::json->> 'state_type';
	v_workcat_id_end =  (p_data ->> 'data')::json->> 'workcat_id_end';
	v_enddate =  ((p_data ->> 'data')::json->> 'enddate')::date;

	select array_agg(quote_literal(a)) into v_id_list from json_array_elements_text(v_id::json) a;

	IF 	v_featuretype = 'arc' THEN 
	
		FOREACH rec_id IN ARRAY(v_id_list)
		LOOP
			--remove links related to arc
			EXECUTE 'DELETE FROM link 
			WHERE link_id IN (SELECT link_id FROM link l JOIN connec c ON c.connec_id = l.feature_id WHERE c.arc_id = '|| rec_id||');';
			
			EXECUTE 'UPDATE connec SET arc_id = NULL WHERE arc_id = '|| rec_id||';';

			IF v_projecttype = 'UD' THEN
				EXECUTE 'UPDATE gully SET arc_id = NULL WHERE arc_id = '|| rec_id||';';
			END IF;
			
		END LOOP;
		
	
	ELSIF v_featuretype = 'node' THEN
	--check if node is involved into psector
		FOREACH rec_id IN ARRAY(v_id_list)
		LOOP
			EXECUTE 'SELECT count(arc.arc_id)  FROM arc WHERE (node_1='|| rec_id||' OR node_2='|| rec_id||') AND arc.state = 2;'
			INTO v_num_feature;

			IF v_num_feature > 0 THEN
				
				EXECUTE 'SELECT string_agg(name::text, '', ''), string_agg(psector_id::text, '', '')
				FROM plan_psector_x_arc JOIN plan_psector USING (psector_id) where arc_id IN 
				(SELECT arc.arc_id FROM arc WHERE (node_1='||rec_id||' OR node_2='|| rec_id||') AND arc.state = 2);'
				INTO v_psector_list, v_psector_id;

				IF v_psector_id IS NOT NULL THEN 
					EXECUTE 'DELETE FROM plan_psector_x_node WHERE node_id = '||rec_id||' AND psector_id IN ('||v_psector_id||');';

					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3142", "function":"3022","debug_msg":"'||v_psector_list||'"}}$$);' INTO v_audit_result;
				END IF;
			END IF;
	
			EXECUTE 'SELECT count(arc.arc_id)  FROM arc WHERE (node_1='|| rec_id||' OR node_2='|| rec_id||') AND arc.state = 1;'
			INTO v_num_feature;
			
			IF v_num_feature > 0 THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1072", "function":"3022","debug_msg":"'||rec_id||'"}}$$);' INTO v_audit_result;
			END IF;
		END LOOP;
	END IF;

	IF v_audit_result is null THEN
		FOREACH rec_id IN ARRAY(v_id_list) LOOP
			EXECUTE 'UPDATE '||v_featuretype||' SET state = 0, state_type='||v_state_type||', workcat_id_end = '||quote_literal(v_workcat_id_end)||',
			enddate = '||quote_literal(v_enddate)||' WHERE '||v_featuretype||'_id ='||rec_id||'';
		END LOOP;
	END IF;


	IF v_audit_result is null THEN
        v_status = 'Accepted';
        v_level = 3;
        v_message = 'Process done successfully';
    ELSE

        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status; 
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

    END IF;

    DELETE FROM config_param_user  WHERE  parameter = 'utils_cur_trans' AND cur_user =current_user;

	v_version := COALESCE(v_version, '[]');
	v_result_info := COALESCE(v_result_info, '[]');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":"'||v_level||'", "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||				
			'}}'||
	    '}')::json, 3022);

	--EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

