/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 9002

DROP FUNCTION IF EXISTS euc.gw_fct_aya_mapping_ws2euc(p_data json) ;
CREATE OR REPLACE FUNCTION euc.gw_fct_aya_mapping_ws2euc(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE

SELECT euc.gw_fct_aya_mapping_ws2euc($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"v_edit_node", "id":["18","1101"]},
"data":{"nodeIni":"1041,"nodeFin":"1043",selectionMode":"previousSelection", "parameters":{}}}$$)

--fid: 9002
*/

DECLARE

rec_node record;
rec record;

v_version text;
v_result json;
v_id json;
v_result_info json;
v_result_line json;
v_selectionmode text;
v_worklayer text;
v_array text;
v_node_aux record;
v_error_context text;
v_count integer;

v_arc_array text[];
v_node_ini integer;
v_node_fin integer;
v_node_inter integer;
v_geom public.geometry;
v_roughness float;
v_dint float;
v_length float;
BEGIN

	SET search_path = "euc", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND anl_node.fid=9002;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=9002;	
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (9002, null, 4, concat('AYA MAPPING'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (9002, null, 4, '-------------------------------------------------------------');
	
	--update ranc_mapping_arc setting node_1_euc, node_2_euc
	UPDATE ws.ranc_mapping_arc set node_1_euc = node_euc FROM ws.ranc_mapping_node WHERE node_1=node_ws;
	UPDATE ws.ranc_mapping_arc set node_2_euc = node_euc FROM ws.ranc_mapping_node WHERE node_2=node_ws;

	--update arcs
	SELECT count(*) into v_count FROM ws.ranc_mapping_arc rma
	JOIN v_edit_arc a ON a.node_1=rma.node_1_euc AND a.node_2=rma.node_2_euc;

	UPDATE inp_pipe i SET custom_dint=dint, custom_roughness=roughness--, custom_length=length 
	FROM ws.ranc_mapping_arc rma
	JOIN v_edit_arc a ON a.node_1=rmn1.node_1_euc AND a.node_2=rma2.node_2_euc
	WHERE a.arc_id=i.arc_id;

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (9002, null, 4,concat('Updated arcs:',v_count));

	SELECT count(*) into v_count FROM ws.ranc_mapping_node rma
	JOIN euc.v_edit_node a ON a.node_id=rma.node_ws;
	
	--update nodes
	UPDATE v_edit_node SET elevation = n.elevation FROM euc.node n JOIN ws.ranc_mapping_node ON node_ws=n.node_id WHERE v_edit_node.node_id=node_euc;
	
	UPDATE inp_tank SET initlevel=n.initlevel, minlevel=n.minlevel, maxlevel=n.maxlevel, diameter=n.diameter, minvol=n.minvol, 
  curve_id=n.curve_id, overflow=n.overflow FROM euc.inp_tank n JOIN ws.ranc_mapping_node ON node_ws=n.node_id WHERE inp_tank.node_id=node_euc;

  UPDATE inp_junction SET demand=n.demand, pattern_id=n.pattern_id 
  FROM euc.inp_junction n JOIN ws.ranc_mapping_node ON node_ws=n.node_id WHERE inp_junction.node_id=node_euc;

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (9002, null, 4,concat('Updated nodes:',v_count));

	
	-- get results
  	
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=9002 order by  id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json,9051, null, null, null);

	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	--RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

/*
  SELECT euc.gw_fct_aya_mapping_ws2euc($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]}, "data":{"filterFields":{}, "pageInfo":{}, 
  "selectionMode":"wholeSelection","parameters":{}}}$$);

  INSERT INTO euc.sys_function(
            id, function_name, project_type, function_type, input_params, 
            return_type, descript, sys_role, sample_query, source)
    VALUES (9002, 'gw_fct_aya_mapping_ws2euc', 'ws', 'function', 'json', 
            'json', 'Aya mapping from ws to euc', 'role_edit', null, 'ranc');


INSERT INTO euc.config_function(
            id, function_name, style, layermanager, actions)
    VALUES (9002,'gw_fct_aya_mapping_ws2euc', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', null, null);

INSERT INTO euc.config_toolbox(
            id, alias, functionparams, inputparams, observ, active)
    VALUES (9002, 'Aya mapping', '{"featureType":[]}', NULL, null, true);


INSERT INTO euc.sys_fprocess(
            fid, fprocess_name, project_type, parameters, source, isaudit, 
            fprocess_type, addparam)
    VALUES (9002, 'Aya mapping', 'ws', null, 'rand', false,'Function process', null);

*/
