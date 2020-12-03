/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2725

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getfeaturerelation(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getfeaturerelation(p_data json)
RETURNS json AS
$BODY$

/*

SELECT SCHEMA_NAME.gw_fct_getfeaturerelation($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"2076562"}}$$);

SELECT SCHEMA_NAME.gw_fct_getfeaturerelation($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"type":"ARC"},
"data":{"feature_id":"2098" }}$$);

SELECT SCHEMA_NAME.gw_fct_getfeaturerelation($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"type":"NODE"},
"data":{"feature_id":"1051"}}$$);

SELECT SCHEMA_NAME.gw_fct_getfeaturerelation($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"type":"CONNEC"},
"data":{"feature_id":"3254" }}$$);

-- fid: 151

*/
 
DECLARE

v_feature_type text;
v_feature_id text;
v_workcat_id_end text;
v_enddate text;
v_descript text;
v_project_type text;
v_connect_connec text;
v_connect_gully text;
v_connect_node text;
v_element text;
v_visit text;
v_doc text;
v_connect_arc text;
v_version json;
v_result_id text= 'feature relations';
v_result_info text;
v_result text;
v_man_table text;
v_featurecat text;
v_connect_pol text;
v_error_context text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;
	SELECT project_type INTO v_project_type FROM sys_version order by 1 desc limit 1;

	-- manage log (fid: 151)
	DELETE FROM audit_check_data WHERE fid = 151 AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (151, v_result_id, concat('FEATURE RELATIONS'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (151, v_result_id, concat('------------------------------'));

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;
        
	--get information about feature
	v_feature_type = lower(((p_data ->>'feature')::json->>'type'))::text;
	v_feature_id = ((p_data ->>'data')::json->>'feature_id')::text;

	EXECUTE 'SELECT '||v_feature_type||'_type FROM v_edit_'||v_feature_type||' WHERE '||v_feature_type||'_id = '''||v_feature_id||''''
	INTO v_featurecat;

	EXECUTE 'SELECT man_table FROM cat_feature_'||v_feature_type||' WHERE id = '''||v_featurecat||''';'
	INTO v_man_table;

	IF v_feature_type='arc' THEN
		--check connec& gully related to arc
		SELECT string_agg(feature_id,',') INTO v_connect_connec FROM v_ui_arc_x_relations 
		JOIN sys_feature_cat on sys_feature_cat.id=v_ui_arc_x_relations.sys_type WHERE type='CONNEC' AND  arc_id = v_feature_id;

		IF v_connect_connec IS NOT NULL THEN
			INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (151, v_result_id, concat('Connecs connected with the feature :',v_connect_connec ));
		END IF;

		SELECT string_agg(feature_id,',') INTO v_connect_gully FROM v_ui_arc_x_relations 
		JOIN sys_feature_cat on sys_feature_cat.id=v_ui_arc_x_relations.sys_type WHERE type='GULLY' AND  arc_id = v_feature_id;
		
		IF v_connect_gully IS NOT NULL THEN

			INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (151, v_result_id, concat('Gullies connected with the feature :',v_connect_gully ));

		END IF;
		
		--check final nodes related to arc
		SELECT concat(node_1,',',node_2) INTO v_connect_node FROM v_arc 
		LEFT JOIN node a ON a.node_id::text = v_arc.node_1::text
     	LEFT JOIN node b ON b.node_id::text = v_arc.node_2::text 
     	WHERE v_arc.arc_id = v_feature_id;
		
		IF v_connect_node IS NOT NULL THEN
				INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (151, v_result_id, concat('Nodes connected with the feature: ',v_connect_node ));
			END IF;

	ELSIF v_feature_type='node' THEN
		--check nodes childs related to node

		IF v_project_type = 'WS' THEN
		 	SELECT string_agg(child_id,',') INTO v_connect_node FROM v_ui_node_x_relations WHERE node_id = v_feature_id;

			IF v_connect_node IS NOT NULL THEN
				INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (151, v_result_id, concat('Nodes connected with the feature: ',v_connect_node ));
			END IF;
		END IF;

		--check arcs related to node
		SELECT string_agg(v_arc.arc_id,',')  INTO v_connect_arc FROM v_arc 
		LEFT JOIN node a ON a.node_id::text = v_arc.node_1::text
     	LEFT JOIN node b ON b.node_id::text = v_arc.node_2::text 
     	WHERE  (node_1 = v_feature_id OR node_2 = v_feature_id);

		IF v_connect_arc IS NOT NULL THEN
			INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (151, v_result_id, concat('Arcs connected with the feature: ',v_connect_arc ));
		END IF;
		--check related polygon
		IF v_man_table IN ('man_tank', 'man_register', 'man_wwtp', 'man_storage','man_netgully','man_chamber') THEN
		 	EXECUTE 'SELECT pol_id FROM '||v_man_table||' where node_id= '''||v_feature_id||''';'
		 	INTO v_connect_pol;

		 	IF v_connect_pol IS NOT NULL THEN
		 		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (151, v_result_id, concat('Polygon connected with the feature: ',v_connect_pol ));
		 	END IF;
		END IF;

	ELSIF v_feature_type='connec' OR v_feature_type='gully' THEN
		EXECUTE 'SELECT string_agg(link_id::text,'','') FROM link where (exit_type=''CONNEC''  AND  exit_id = '''||v_feature_id||'''::text)
		OR  (feature_type=''CONNEC''  AND  feature_id = '''||v_feature_id||'''::text)'
		INTO v_connect_connec;

		IF v_connect_connec IS NOT NULL THEN
			INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (151, v_result_id, concat('Links connected with the feature :',v_connect_connec ));
		END IF;

		EXECUTE 'SELECT string_agg(link_id::text,'','') FROM link where exit_type=''GULLY''  AND  exit_id = '''||v_feature_id||'''::text
		OR  (feature_type=''GULLY''  AND  feature_id = '''||v_feature_id||'''::text)'
		INTO v_connect_gully;

		IF v_connect_gully IS NOT NULL THEN
			INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (151, v_result_id, concat('Gullies connected with the feature :',v_connect_gully ));
		END IF;
		
		--check related polygon
		IF v_man_table = 'man_fountain' THEN
		 	EXECUTE 'SELECT pol_id FROM '||v_man_table||' where connec_id= '''||v_feature_id||''';'
		 	INTO v_connect_pol;
		ELSIF v_feature_type = 'gully' THEN
			EXECUTE 'SELECT pol_id FROM gully WHERE gully_id = '''||v_feature_id||''';'
		 	INTO v_connect_pol;
		END IF;

		IF v_connect_pol IS NOT NULL THEN
			INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (151, v_result_id, concat('Polygon connected with the feature: ',v_connect_pol ));
		END IF;

	END IF;
	
	--check elements related to feature
	EXECUTE 'SELECT string_agg(element_id,'','') FROM element_x_'||v_feature_type||' where '||v_feature_type||'_id = '''||v_feature_id||'''::text'
	INTO v_element;

	IF v_element IS NOT NULL THEN
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (151, v_result_id, concat('Elements connected with the feature: ',v_element ));
	END IF;
	--check visits related to feature
	EXECUTE 'SELECT string_agg(visit_id::text,'','') FROM om_visit_x_'||v_feature_type||' where '||v_feature_type||'_id = '''||v_feature_id||'''::text'
	INTO v_visit;

	IF v_visit IS NOT NULL THEN
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (151, v_result_id, concat('Visits connected with the feature: ',v_visit ));
	END IF;

	--check visits related to feature
	EXECUTE 'SELECT string_agg(doc_id,'','') FROM doc_x_'||v_feature_type||' where '||v_feature_type||'_id = '''||v_feature_id||'''::text'
	INTO v_doc;

	IF v_doc IS NOT NULL THEN
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (151, v_result_id, concat('Documents connected with the feature: ',v_doc ));
	END IF;

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid = 151) row;

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
