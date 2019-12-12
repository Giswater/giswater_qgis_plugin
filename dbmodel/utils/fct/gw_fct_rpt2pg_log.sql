/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2782

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_rpt2pg_log(text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_rpt2pg_log(p_result text)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT gw_fct_rpt2pg_log('test')
*/

DECLARE

v_result		json;
v_result_info 		json;
v_result_point		json;
v_result_line 		json;
v_result_polygon	json;
v_qmlpointpath		text;
v_qmllinepath		text;
v_qmlpolpath		text;
v_project_type		text;
v_version		text;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;
	
	
	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fprocesscat_id=14 AND user_name=current_user;
	DELETE FROM anl_arc WHERE fprocesscat_id IN (3, 14, 39) AND cur_user=current_user;
	DELETE FROM anl_node WHERE fprocesscat_id IN (7, 14, 64, 66, 70, 71, 98) AND cur_user=current_user;


	-- select config values
	SELECT wsoftware, giswater  INTO v_project_type, v_version FROM version order by 1 desc limit 1 ;
	
	-- Header
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, p_result, 4, concat('IMPORT RPT FILE LOG'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, p_result, 4, '-------------------------------------------');

	-- TODO:
	--INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, p_result, 3, 'CRITICAL ERRORS');	
	--INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, p_result, 3, '----------------------');	

	--INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, p_result, 2, 'WARNINGS');	
	--INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, p_result, 2, '--------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, p_result, 1, 'INFO');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, p_result, 1, '-------');	
	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, p_result, 4, concat('Result id: ', p_result));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, p_result, 4, concat('Imported by: ', current_user, ', on ', to_char(now(),'YYYY-MM-DD HH:MM:SS')));


	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message)
	SELECT 14, p_result, 1, concat('INFO: ', csv1,' ',csv2, ' ',csv3, ' ',csv4, ' ',csv5, ' ',csv6, ' ',csv7, ' ',csv8, ' ',csv9, ' ',csv10, ' ',csv11, ' ',csv12) from temp_csv2pg 
	where csv2pgcat_id=11 and source='rpt_cat_result' and user_name=current_user;

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, p_result, 4, '');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, p_result, 1, '');
	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, p_result, 0, 'See the full input data file for more details....');

		
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=14 order by criticity desc, id asc) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	--points
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript, the_geom FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id IN (7, 14, 64, 66, 70, 71, 98)) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "qmlPath":"',v_qmlpointpath,'", "values":',v_result, '}');

	--lines
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, the_geom FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id IN (3, 14, 39)) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "qmlPath":"',v_qmllinepath,'", "values":',v_result, '}');

	--polygons
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, pol_id, pol_type, state, expl_id, descript, the_geom FROM anl_polygon WHERE cur_user="current_user"() AND fprocesscat_id=14) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_polygon = concat ('{"geometryType":"Polygon","qmlPath":"',v_qmlpolpath,'", "values":',v_result, '}');


	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}'); 
	
--  Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;