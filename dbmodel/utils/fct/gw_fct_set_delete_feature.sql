/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2726

--DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_set_delete_feature(json);


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_set_delete_feature(p_data json)
RETURNS json AS
/*
SELECT SCHEMA_NAME.gw_fct_set_delete_feature($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},"feature":{"type":"NODE"},
"data":{"feature_id":"42"},
"relation":{"node":["1022","1086"],"arc":[],"connec":["3175"],"gully":[],"element":["1897","32"],"visit":["523"]}}$$);

SELECT SCHEMA_NAME.gw_fct_set_delete_feature($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},"feature":{"type":"CONNEC"},
"data":{"feature_id":"3244"},
"relation":{"node":["1022","1086"],"arc":[],"connec":["3175"],"gully":[],"element":["1897","32"],"visit":["523"]}}$$);


SELECT SCHEMA_NAME.gw_fct_set_delete_feature($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},"feature":{"type":"ARC"},"data":{"feature_id":"2002"},
"relation":{"node":[],"arc":["2096"],"connec":[],"gully":[],"element":["522"],"visit":["21"],"document":["Demo document 1"]}}$$);
*/

$BODY$
DECLARE
api_version json;
v_feature_type text;
v_feature_id text;
v_arc_id TEXT;
v_project_type text;
v_version text;
v_result_id text= 'delete feature';
v_result_info text;
v_result text;
v_connec_id text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;
	SELECT wsoftware, giswater  INTO v_project_type, v_version FROM version order by 1 desc limit 1;
 
 	UPDATE config_param_user SET value = 'TRUE' WHERE parameter = 'edit_arc_downgrade_force' AND cur_user=current_user;

	-- manage log (fprocesscat = 52)
	DELETE FROM audit_check_data WHERE fprocesscat_id=52 AND user_name=current_user;
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('DELETE FEATURE'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('------------------------------'));

	v_feature_type = lower(((p_data ->>'feature')::json->>'type'))::text;
	v_feature_id = ((p_data ->>'data')::json->>'feature_id')::text;


	--check elements related to feature
	EXECUTE 'DELETE FROM element_x_'||v_feature_type||' where '||v_feature_type||'_id = '''||v_feature_id||''';';
	EXECUTE 'DELETE FROM om_visit_x_'||v_feature_type||' where '||v_feature_type||'_id = '''||v_feature_id||''';';
	EXECUTE 'DELETE FROM doc_x_'||v_feature_type||' where '||v_feature_type||'_id = '''||v_feature_id||''';';

	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Disconnect elements -> Done' ));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Disconnect visits -> Done' ));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Disconnect documents -> Done' ));

	IF v_feature_type='node' THEN 
		--remove scada and link related to node
		EXECUTE 'DELETE FROM rtc_scada_node where node_id = '''||v_feature_id||''';';
		EXECUTE 'DELETE FROM v_edit_link WHERE exit_type=''NODE'' and exit_id = '''||v_feature_id||''';';
		EXECUTE 'UPDATE node SET parent_id=NULL WHERE node_id = '''||v_feature_id||''';';
		
		INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Remove scada connection -> Done' ));
		INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Remove link -> Done' ));
		INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Disconnect child node -> Done' ));	

		--find if there is an arc related to node
		SELECT arc_id INTO v_arc_id FROM arc WHERE node_1 = v_feature_id OR  node_2 = v_feature_id;
		
		IF v_arc_id IS NULL THEN
			--delete node
			EXECUTE 'DELETE FROM node WHERE node_id='''||v_feature_id||''';';
			
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Delete node -> Done' ));	
		ELSE 
			--set final nodes to NULL and delete node
			EXECUTE'UPDATE arc SET node_1=NULL WHERE node_1='''||v_feature_id||''';';
			EXECUTE'UPDATE arc SET node_2=NULL WHERE node_2='''||v_feature_id||''';';
			EXECUTE 'DELETE FROM node WHERE node_id='''||v_feature_id||''';';

			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Disconnect arcs -> Done' ));	
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Delete node -> Done' ));
		END IF;
	

	ELSIF v_feature_type='arc' THEN 
		--remove links related to arc, set arc_id to null if there are connecs, gullies or nodes related
		EXECUTE 'DELETE FROM v_edit_link WHERE feature_type=''CONNEC'' AND feature_id IN (SELECT connec_id FROM connec  WHERE connec.arc_id='''||v_feature_id||''');';
		EXECUTE 'UPDATE connec SET arc_id=NULL WHERE arc_id='''||v_feature_id||''';';
		EXECUTE 'UPDATE node SET arc_id=NULL WHERE arc_id='''||v_feature_id||''';';

		INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Remove link -> Done' ));
		INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Disconnect node -> Done' ));
		INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Disconnect connecs -> Done' ));

		IF v_project_type='UD' THEN
			EXECUTE'UPDATE gully SET arc_id=NULL WHERE arc_id='''||v_feature_id||''';';
			INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Disconnect gully -> Done' ));
		END IF;
		--delete arc
		EXECUTE 'DELETE FROM arc WHERE arc_id='''||v_feature_id||''';';
		INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Delete arc -> Done' ));

	ELSIF  v_feature_type='connec' OR v_feature_type='gully' THEN
		--remove links related to connec/gully and delete feature
		EXECUTE 'DELETE FROM v_edit_link WHERE feature_type='''||UPPER(v_feature_type)||''' AND feature_id ='''||v_feature_id||''';';
	  	EXECUTE 'DELETE FROM v_edit_link WHERE feature_type='''||UPPER(v_feature_type)||''' AND exit_id ='''||v_feature_id||''';';
	
	  	EXECUTE 'DELETE FROM '||(v_feature_type)||'  WHERE '||(v_feature_type)||'_id='''||v_feature_id||''';';
	
	  	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Remove link -> Done' ));
	  	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (52, v_result_id, concat('Delete ', v_feature_type,' -> Done' ));
	  	
	END IF;
 
 	UPDATE config_param_user SET value = 'FALSE' WHERE parameter = 'edit_arc_downgrade_force' AND cur_user=current_user;

 	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=52) row; 

	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


