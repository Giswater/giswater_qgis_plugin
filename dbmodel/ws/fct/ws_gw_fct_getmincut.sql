/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3010

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getmincut(p_data json)
RETURNS json AS
$BODY$

/*
-- Button networkMincut on mincut dialog
SELECT gw_fct_getmincut('{"data":{"mincutId":"3"}}');

fid = 216

*/

DECLARE

v_mincut integer;
v_version text;
v_error_context text;
v_mincutrec record;
v_result json;
v_result_info json;


BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	
	SELECT giswater INTO v_version FROM sys_version order by id desc limit 1;

	-- delete previous
	DELETE FROM audit_check_data WHERE fid = 216 and cur_user=current_user;

	-- get input parameters
	v_mincut := ((p_data ->>'data')::json->>'mincutId')::integer;	
	
	-- mincut details
	SELECT * INTO v_mincutrec FROM om_mincut WHERE id = v_mincut;
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, '');
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, 'Mincut stats');
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, '-----------------');
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Number of arcs: ', (v_mincutrec.output->>'arcs')::json->>'number'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Length of affected network: ', (v_mincutrec.output->>'arcs')::json->>'length', ' mts'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Total water volume: ', (v_mincutrec.output->>'arcs')::json->>'volume', ' m3'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Number of connecs affected: ', (v_mincutrec.output->>'connecs')::json->>'number'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Total of hydrometers affected: ', ((v_mincutrec.output->>'connecs')::json->>'hydrometers')::json->>'total'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (216, concat('Hydrometers classification: ', ((v_mincutrec.output->>'connecs')::json->>'hydrometers')::json->>'classified'));

	-- info
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=216 order by id) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	v_result_info := COALESCE(v_result_info, '{}'); 

	-- return
	RETURN ('{"status":"Accepted", "version":"'||v_version||'","body":{"form":{}'||
			',"data":{ "info":'||v_result_info||'}'||
			'}}')::json;

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;  
	RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_error_context) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;