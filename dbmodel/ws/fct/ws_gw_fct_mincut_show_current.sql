/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3236

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_mincut_show_current(p_data json) ;
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_show_current(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_mincut_show_current($${
"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, 
"form":{}, "feature":{}, "data":{"filterFields":{}, 
"pageInfo":{}, "parameters":{"explId":"1"}}}$$);

--fid: 490
*/

DECLARE

rec_node record;
rec record;

v_version text;
v_result json;
v_id json;
v_result_info json;
v_result_line json;
v_expl_id integer;
v_worklayer text;
v_array text;
v_node_aux record;
v_error_context text;
v_count integer;
v_fid integer = 490;
BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND anl_node.fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;	
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('SHOW CURRENTLY EXECUTED MINCUTS'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '-------------------------------------------------------------');

	-- getting input data 	
	v_expl_id := json_extract_path_text(p_data,'data','parameters','explId')::integer;

	-- get results
	--lines
	v_result = null;
  EXECUTE 'SELECT jsonb_agg(features.feature) 
 	FROM (
    SELECT jsonb_build_object(
    ''type'',       ''Feature'',
    ''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
    ''properties'', to_jsonb(row) - ''the_geom''
    ) AS feature
    FROM
		(SELECT
		om_mincut_arc.id,
		om_mincut_arc.result_id,
		m.work_order,
		om_mincut_arc.arc_id,
		om_mincut_arc.the_geom
		FROM om_mincut m
		JOIN om_mincut_arc ON result_id = m.id
		where mincut_state = 1 and expl_id ='||v_expl_id||')row)features'
 		INTO v_result;

  	v_result := COALESCE(v_result, '{}'); 
  	v_result_line = concat ('{"geometryType":"Linestring", "features":',v_result, '}'); 

	SELECT count(*) INTO v_count FROM om_mincut WHERE expl_id =v_expl_id and mincut_state = 1;

	IF v_count = 0 THEN
		INSERT INTO audit_check_data(fid,  error_message, fcount)
		VALUES (v_fid,  'No mincuts are being executed right now.', v_count);
	ELSE
		INSERT INTO audit_check_data(fid,  error_message, fcount)
		VALUES (v_fid,  concat ('There are ',v_count,' mincuts being executed at the moemnt.'), v_count);

		INSERT INTO audit_check_data(fid,  error_message, fcount)
		SELECT v_fid,  concat ('Mincut_id: ',string_agg(id::text, ', '), '.' ), v_count 
		FROM om_mincut WHERE expl_id =v_expl_id and mincut_state = 1;

	END IF;
	
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by  id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"line":'||v_result_line||
			'}}'||
	    '}')::json, 3236, null, null, null);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  