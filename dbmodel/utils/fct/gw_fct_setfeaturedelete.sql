/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2736

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_set_delete_feature(json);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_feature_delete(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setfeaturedelete(p_data json)
RETURNS json AS

$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_setfeaturedelete($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},"feature":{"type":"NODE"},
"data":{"feature_id":"42"}}$$);

SELECT SCHEMA_NAME.gw_fct_setfeaturedelete($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},"feature":{"type":"CONNEC"},
"data":{"feature_id":"3244"}}$$);


SELECT SCHEMA_NAME.gw_fct_setfeaturedelete($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},"feature":{"type":"ARC"},"data":{"feature_id":"2002"}}$$);

-- fid: 152

*/

DECLARE

v_version json;
v_feature_type text;
v_feature_id text;
v_arc_id TEXT;
v_project_type text;
v_result_id text= 'delete feature';
v_result_info text;
v_result text;
v_connec_id text;
v_featurecat text;
v_man_table text;
v_error_context text;
v_count integer;
v_related_id text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	SELECT project_type INTO v_project_type FROM sys_version order by 1 desc limit 1;
	
		--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

 	UPDATE config_param_user SET value = 'TRUE' WHERE parameter = 'edit_arc_downgrade_force' AND cur_user=current_user;

	-- manage log (fid: 152)
	DELETE FROM audit_check_data WHERE fid = 152 AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('DELETE FEATURE'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('------------------------------'));
 	--get information about feature
	v_feature_type = lower(((p_data ->>'feature')::json->>'type'))::text;
	v_feature_id = ((p_data ->>'data')::json->>'feature_id')::text;

	EXECUTE 'SELECT '||v_feature_type||'_type FROM v_edit_'||v_feature_type||' WHERE '||v_feature_type||'_id = '''||v_feature_id||''''
	INTO v_featurecat;

	EXECUTE 'SELECT man_table FROM cat_feature_'||v_feature_type||' WHERE id = '''||v_featurecat||''';'
	INTO v_man_table;

	--check and remove elements related to feature
	EXECUTE 'SELECT count(*) FROM element_x_'||v_feature_type||' where '||v_feature_type||'_id = '''||v_feature_id||''''
	INTO v_count;

	IF v_count > 0 THEN
		EXECUTE 'DELETE FROM element_x_'||v_feature_type||' where '||v_feature_type||'_id = '''||v_feature_id||''';';
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('Number of disconnected elements:',v_count));
	END IF;

	--check and remove visits related to feature
	EXECUTE 'SELECT count(*) FROM om_visit_x_'||v_feature_type||' where '||v_feature_type||'_id = '''||v_feature_id||''''
	INTO v_count;

	IF v_count > 0 THEN
		EXECUTE 'DELETE FROM om_visit_x_'||v_feature_type||' where '||v_feature_type||'_id = '''||v_feature_id||''';';
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('Number of disconnected visits: ',v_count));
	END IF;

	--check and remove docs related to feature
	EXECUTE 'SELECT count(*) FROM doc_x_'||v_feature_type||' where '||v_feature_type||'_id = '''||v_feature_id||''''
	INTO v_count;

	IF v_count > 0 THEN
		EXECUTE 'DELETE FROM doc_x_'||v_feature_type||' where '||v_feature_type||'_id = '''||v_feature_id||''';';
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('Number of disconnected documents: ',v_count));
	END IF;

	IF v_feature_type='node' THEN 

		--remove scada related to node
		EXECUTE 'SELECT count(*) FROM rtc_scada_node where node_id = '''||v_feature_id||''''
		INTO v_count;

		IF v_count > 0 THEN
			EXECUTE 'DELETE FROM rtc_scada_node where node_id = '''||v_feature_id||''';';
			INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('Number of removed scada connections: ',v_count));
		END IF;

		--remove link related to node
		EXECUTE 'SELECT count(*) FROM v_edit_link where exit_type=''NODE'' and exit_id = '''||v_feature_id||''''
		INTO v_count;

		IF v_count > 0 THEN
			EXECUTE 'DELETE FROM v_edit_link WHERE exit_type=''NODE'' and exit_id = '''||v_feature_id||''';';
			INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('Number of removed links:', v_count ));
		END IF;

		--remove parent related to node 
		IF v_project_type = 'WS' THEN
			EXECUTE 'SELECT parent_id FROM node where parent_id IS NOT NULL AND node_id = '''||v_feature_id||''''
			into v_related_id;

			IF v_related_id IS NOT NULL THEN
				EXECUTE 'UPDATE node SET parent_id=NULL WHERE node_id = '''||v_feature_id||''';';
				INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('Disconnected parent node:',v_related_id ));
			END IF;
		END IF;

		--delete related polygon
		IF v_man_table IN ('man_tank', 'man_register', 'man_wwtp', 'man_storage','man_netgully','man_chamber') THEN
			EXECUTE 'SELECT pol_id FROM polygon where pol_id IN (SELECT pol_id FROM '||v_man_table||' 
			WHERE node_id = '''||v_feature_id||''')'
			into v_related_id;

			IF v_related_id IS NOT NULL THEN
			 	EXECUTE 'DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM '||v_man_table||' 
				WHERE node_id = '''||v_feature_id||'''); ';

				INSERT INTO audit_check_data (fid, result_id, error_message)
				VALUES (152, v_result_id, concat('Removed polygon:', v_related_id ));
			END IF;

		END IF;

		--find if there is an arc related to node
		SELECT string_agg(v_arc.arc_id,',')  INTO v_arc_id FROM v_arc 
		LEFT JOIN node a ON a.node_id::text = v_arc.node_1::text
     	LEFT JOIN node b ON b.node_id::text = v_arc.node_2::text 
     	WHERE  (node_1 = v_feature_id OR node_2 = v_feature_id);

		IF v_arc_id IS NULL THEN
			--delete node
			EXECUTE 'DELETE FROM v_edit_node WHERE node_id='''||v_feature_id||''';';
			
			INSERT INTO audit_check_data (fid, result_id, error_message)
			VALUES (152, v_result_id, concat('Delete node: ', v_feature_id));	
		ELSE 
			--set final nodes to NULL and delete node
			EXECUTE'UPDATE arc SET node_1=NULL WHERE node_1='''||v_feature_id||''';';
			EXECUTE'UPDATE arc SET node_2=NULL WHERE node_2='''||v_feature_id||''';';
			EXECUTE 'DELETE FROM node WHERE node_id='''||v_feature_id||''';';

			INSERT INTO audit_check_data (fid, result_id, error_message)
			VALUES (152, v_result_id, concat('Disconnected arcs: ',v_arc_id));	
			INSERT INTO audit_check_data (fid, result_id, error_message)
			VALUES (152, v_result_id, concat('Delete node: ', v_feature_id));
		END IF;
	

	ELSIF v_feature_type='arc' THEN 
		--remove links related to arc
		EXECUTE 'SELECT count(*) FROM v_edit_link WHERE feature_type=''CONNEC'' AND feature_id IN 
		(SELECT connec_id FROM connec  WHERE connec.arc_id='''||v_feature_id||''');'
		INTO v_count;

		IF v_count > 0 THEN
			EXECUTE 'DELETE FROM v_edit_link WHERE feature_type=''CONNEC'' AND feature_id IN (SELECT connec_id FROM connec  WHERE connec.arc_id='''||v_feature_id||''');';
			INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('Number of removed links: ',v_count ));
		END IF;
		
		--set arc_id to null if there are connecs related
		EXECUTE 'SELECT string_agg(connec_id,'','') FROM connec WHERE arc_id='''||v_feature_id||''''
		INTO v_related_id;

		IF v_related_id IS NOT NULL THEN
			EXECUTE 'UPDATE connec SET arc_id=NULL WHERE arc_id='''||v_feature_id||''';';
			INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('Disconnected connecs:',v_related_id ));
		END IF;

		--set arc_id to null if there are nodes related
		EXECUTE 'SELECT string_agg(node_id,'','') FROM node WHERE arc_id='''||v_feature_id||''''
		INTO v_related_id;

		IF v_related_id IS NOT NULL THEN
			EXECUTE 'UPDATE node SET arc_id=NULL WHERE arc_id='''||v_feature_id||''';';
			INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('Disconnected nodes:',v_related_id ));
		END IF;

		--set arc_id to null if there are gullies related
		IF v_project_type='UD' THEN
			EXECUTE 'SELECT string_agg(gully_id,'','') FROM gully WHERE arc_id='''||v_feature_id||''''
			INTO v_related_id;

			EXECUTE'UPDATE gully SET arc_id=NULL WHERE arc_id='''||v_feature_id||''';';
			INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('Disconnected gullies: ', v_related_id ));
		END IF;

		--delete arc
		EXECUTE 'DELETE FROM v_edit_arc WHERE arc_id='''||v_feature_id||''';';
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('Delete arc: ',v_feature_id ));

	ELSIF  v_feature_type='connec' OR v_feature_type='gully' THEN

		--check related polygon
		IF v_man_table = 'man_fountain' THEN
			EXECUTE 'SELECT pol_id FROM '||v_man_table||' where connec_id= '''||v_feature_id||''''
			INTO v_related_id;

			IF v_related_id IS NOT NULL THEN
		 		EXECUTE 'DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM '||v_man_table||' where 
		 		connec_id= '''||v_feature_id||''');';
		 		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('Removed polygon: ',v_related_id ));
		 	END IF;
		ELSIF v_feature_type='gully' THEN
			EXECUTE 'SELECT pol_id FROM gully where gully_id= '''||v_feature_id||''''
			INTO v_related_id;
			
			IF v_related_id IS NOT NULL THEN 
				EXECUTE 'DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM gully where 
		 		gully_id= '''||v_feature_id||''');';
		 		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('Removed polygon: ',v_related_id ));
			END IF;
		END IF;

		--remove links related to connec/gully 
		IF v_feature_type='connec' THEN
			EXECUTE 'SELECT string_agg(link_id::text,'','') FROM link where (exit_type=''CONNEC''  AND  exit_id = '''||v_feature_id||'''::text)
			OR  (feature_type=''CONNEC''  AND  feature_id = '''||v_feature_id||'''::text)'
			INTO v_related_id;
		ELSIF v_feature_type = 'gully' THEN
			EXECUTE 'SELECT string_agg(link_id::text,'','') FROM link where exit_type=''GULLY''  AND  exit_id = '''||v_feature_id||'''::text
			OR  (feature_type=''GULLY''  AND  feature_id = '''||v_feature_id||'''::text)'
			INTO v_related_id;
		END IF;

		IF v_related_id IS NOT NULL THEN
			EXECUTE 'DELETE FROM v_edit_link WHERE feature_type='''||UPPER(v_feature_type)||''' AND feature_id ='''||v_feature_id||''';';
	  		EXECUTE 'DELETE FROM v_edit_link WHERE feature_type='''||UPPER(v_feature_type)||''' AND exit_id ='''||v_feature_id||''';';

	  		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('Removed link: ',v_related_id ));
		END IF;

		--delete feature
	  	EXECUTE 'DELETE FROM v_edit_'||(v_feature_type)||'  WHERE '||(v_feature_type)||'_id='''||v_feature_id||''';';
	  	
	  	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (152, v_result_id, concat('Delete ',v_feature_type,': ',v_feature_id ));
	  	
	END IF;

 	--delete addfields values
 	EXECUTE 'DELETE FROM man_addfields_value WHERE feature_id ='''||v_feature_id||'''and parameter_id in (SELECT id FROM sys_addfields
 	WHERE cat_feature_id IS NULL OR cat_feature_id = '''||v_featurecat||''' )';

 	UPDATE config_param_user SET value = 'FALSE' WHERE parameter = 'edit_arc_downgrade_force' AND cur_user=current_user;

 	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid = 152)
	row; 

	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- Control nulls
	v_version := COALESCE(v_version, '{}'); 
	v_result_info := COALESCE(v_result_info, '{}'); 

    RETURN ('{"status":"Accepted", "version":'||v_version||
             ',"message":{"level":1, "text":""},"body":{"data": {"info":'||v_result_info||'}}}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


