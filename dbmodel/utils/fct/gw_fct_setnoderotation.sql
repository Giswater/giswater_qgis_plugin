/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3280
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setnoderotation(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

-- Mode chossing node_type
SELECT gw_fct_setnoderotation($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"parameters":{"nodeType": "'TANK'"}}}$$);

-- Mode all
SELECT gw_fct_setnoderotation($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{}}$$);


-- fid: 516
*/

DECLARE
v_result text;
v_version text;
v_result_info json;
v_error_context text;
v_affectedrow integer = 0;
v_curval boolean = false;
v_nodetype text;
v_querytext text;

BEGIN 

	SET search_path= 'SCHEMA_NAME','public';

	-- select config values
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting current value for user
	v_curval = (SELECT value FROM config_param_user where parameter = 'edit_noderotation_update_dsbl' and cur_user = current_user);

	-- getting cat_node_feature
	v_nodetype := (((p_data ->>'data')::json->>'parameters')::json->>'nodeType')::text;

	-- reset tables
	DELETE FROM audit_check_data WHERE fid = 516 and cur_user = current_user;

	-- setting value false
	update config_param_user set value ='false' where parameter = 'edit_noderotation_update_dsbl' and cur_user = current_user;

	-- starting function
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3280", "fid":"516", "is_process":true, "is_header":"true"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3616", "function":"3280", "fid":"516", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3618", "function":"3280", "fid":"516", "is_process":true}}$$)';

	-- dissabling triggers
	-- trigger arc_link_update does not make sense to disable because trigger only is triggered if the_geom changes and this update does not make any change on the_geom!!!
	update config_param_user set value ='true' where parameter = 'edit_disable_arctopocontrol' and cur_user = current_user; -- topocontrol
	update config_param_user set value ='true' where parameter = 'edit_typevalue_fk_disable' and cur_user = current_user; -- typevalue
	update config_param_user set value ='true' where parameter = 'edit_disable_update_nodevalues' and cur_user = current_user; -- node_values

	IF v_nodetype = '' OR v_nodetype IS NULL THEN	
		v_querytext = 'UPDATE arc SET the_geom = arc.the_geom FROM (SELECT arc_id FROM ve_arc) v WHERE v.arc_id = arc.arc_id';
	ELSE
		v_querytext = 'UPDATE arc SET the_geom = arc.the_geom FROM (
		SELECT arc_id FROM ve_arc WHERE (node_1 IN (SELECT node_id FROM ve_node WHERE node_type IN ('||quote_literal(v_nodetype)||')) OR  (node_2 IN (SELECT node_id FROM ve_node WHERE node_type IN ('||quote_literal(v_nodetype)||'))))
		) v WHERE v.arc_id = arc.arc_id';
	END IF;
	EXECUTE v_querytext;

	GET DIAGNOSTICS v_affectedrow = row_count;

	-- insert log message
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3620", "function":"3280", "parameters":{"v_affectedrow":"'||v_affectedrow||'"}, "fid":"516", "is_process":true}}$$)';

	-- enabling triggers
	update config_param_user set value ='false' where parameter = 'edit_disable_arctopocontrol' and cur_user = current_user; -- topocontrol
	update config_param_user set value ='false' where parameter = 'edit_typevalue_fk_disable' and cur_user = current_user; -- typevalue
	update config_param_user set value ='false' where parameter = 'edit_disable_update_nodevalues' and cur_user = current_user; -- node_values

	-- restoring user value
	update config_param_user set value = v_curval where parameter = 'edit_noderotation_update_dsbl' and cur_user = current_user;
	
	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT id, error_message AS message 
	FROM audit_check_data WHERE cur_user="current_user"() AND ( fid=516)) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');


	-- control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	
	-- return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"setVisibleLayers":[]'||
		       '}}'||
	'}')::json;
    
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;