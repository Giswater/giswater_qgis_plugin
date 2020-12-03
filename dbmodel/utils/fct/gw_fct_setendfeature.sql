/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3004

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_setendfeature(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setendfeature(p_data json)
  RETURNS json AS
$BODY$

/* example

	SELECT SCHEMA_NAME.gw_fct_setendfeature('{"client":{"device":4, "infoType":1, "lang":"ES"},
			"feature":{"featureType":"Node",  "featureId":"1070,1044"}}')

*/

DECLARE

v_id  character varying;
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

BEGIN

	--  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	
	--  get api version
	EXECUTE 'SELECT value FROM config_param_system WHERE parameter=''admin_version'''
	INTO v_version;
      
    SELECT project_type INTO v_projecttype FROM sys_version LIMIT 1;

	-- Get input parameters:
	v_featuretype := lower((p_data ->> 'feature')::json->> 'featureType');
	v_id := (p_data ->> 'feature')::json->> 'featureId';
	v_id_list = string_to_array(v_id,',');		
		
	IF 	v_featuretype = 'arc' THEN 
	
		FOREACH rec_id IN ARRAY(v_id_list)
		LOOP
			--remove links related to arc
			DELETE FROM link 
			WHERE link_id IN (SELECT link_id FROM link l JOIN connec c ON c.connec_id = l.feature_id WHERE c.arc_id = rec_id);
			UPDATE connec SET arc_id = NULL WHERE arc_id = rec_id;

			IF v_projecttype = 'UD' THEN
				UPDATE gully SET arc_id = NULL WHERE arc_id = rec_id;
			END IF;
			
		END LOOP;
		
	
	ELSIF v_featuretype = 'node' THEN
	--check if node is involved into psector
		FOREACH rec_id IN ARRAY(v_id_list)
		LOOP
			SELECT count(arc.arc_id) INTO v_num_feature FROM arc WHERE (node_1=rec_id OR node_2=rec_id) AND arc.state = 2;

			IF v_num_feature > 0 THEN
				
				SELECT string_agg(name::text, ', '), string_agg(psector_id::text, ', ') INTO v_psector_list, v_psector_id
				FROM plan_psector_x_arc JOIN plan_psector USING (psector_id) where arc_id IN 
				(SELECT arc.arc_id FROM arc WHERE (node_1=rec_id OR node_2=rec_id) AND arc.state = 2);

				IF v_psector_id IS NOT NULL THEN 
					EXECUTE 'DELETE FROM plan_psector_x_node WHERE node_id = '||quote_literal(rec_id)||' AND psector_id IN ('||v_psector_id||');';

					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3142", "function":"3004","debug_msg":"'||v_psector_list||'"}}$$);';
				END IF;
			END IF;
		END LOOP;
	END IF;

	v_version := COALESCE(v_version, '[]');
	v_result_info := COALESCE(v_result_info, '[]');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||				
			'}}'||
	    '}')::json, 3004);

	--EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

