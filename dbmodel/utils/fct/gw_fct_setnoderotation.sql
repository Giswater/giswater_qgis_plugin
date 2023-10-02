/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3280
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setnoderotation(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

SELECT gw_fct_setnoderotation($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{}$$);


-- fid: 516
*/

DECLARE
v_result text;
v_version text;
v_result_info json;
v_error_context text;
v_affectedrow integer = 0;
v_curval boolean = false;

BEGIN 

	SET search_path= 'SCHEMA_NAME','public';

	-- select config values
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting current value for user
	v_curval = (SELECT value FROM config_param_user where parameter = 'edit_noderotation_update_dsbl' and cur_user = current_user);

	-- reset tables
	DELETE FROM audit_check_data WHERE fid = 516 and cur_user = current_user;

	-- setting value false
	update config_param_user set value ='false' where parameter = 'edit_noderotation_update_dsbl' and cur_user = current_user;

	-- starting function
	INSERT INTO audit_check_data (fid, error_message) VALUES (516, concat('MASSIVE NODE ROTATION VALUES UPDATE'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (516, concat('-----------------------------------------------------'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (516, 'This process works capturing compass values from arc in order to propagate to nodes.');
	INSERT INTO audit_check_data (fid, error_message) VALUES (516, 'In case of arcs with different compass an average value is calculated.');

	-- dissabling triggers
	-- trigger arc_link_update does not make sense to disable because trigger only is triggered if the_geom changes and this update does not make any change on the_geom!!!
	update config_param_user set value ='true' where parameter = 'edit_disable_arctopocontrol' and cur_user = current_user; -- topocontrol
	update config_param_user set value ='true' where parameter = 'edit_typevalue_fk_disable' and cur_user = current_user; -- typevalue
	update config_param_user set value ='true' where parameter = 'edit_disable_update_nodevalues' and cur_user = current_user; -- node_values
	
	-- update process
	UPDATE arc SET the_geom = arc.the_geom FROM v_edit_arc e WHERE e.arc_id = arc.arc_id; 
	GET DIAGNOSTICS v_affectedrow = row_count;

	-- insert log message
	INSERT INTO audit_check_data (fid, error_message) VALUES (516, concat(v_affectedrow, ' arcs have been analized and their compass values have been progagated to node rotation'));

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

	--EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

    
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;