/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2782

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_rpt2pg_log(text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_rpt2pg_log(p_result text, p_return json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT gw_fct_rpt2pg_log('t1')

-- fid: 103,107,114,139,164,166,170,171,198

*/

DECLARE

v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_project_type text;
v_version text;
v_stats json;
v_error_context text;
v_status text;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;
	
	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid=114 AND cur_user=current_user;
	DELETE FROM anl_arc WHERE fid IN (103, 114, 139) AND cur_user=current_user;
	DELETE FROM anl_node WHERE fid IN (107, 114, 164, 166, 170, 171, 198) AND cur_user=current_user;

	-- select config values
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version order by 1 desc limit 1 ;
	
	-- Header
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 4, concat('IMPORT RPT FILE LOG'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 4, '----------------------------');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 4, concat('Result id: ', p_result));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 4, concat('Imported by: ', current_user, ', on ', to_char(now(),'YYYY-MM-DD HH:MM:SS')));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 4, '');

	v_status  = p_return ->>'status';

	IF v_project_type = 'WS' THEN

		IF (SELECT count(*) FROM rpt_arc WHERE result_id = p_result) < 1 THEN

			-- errors
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 3, 'CRITICAL ERRORS');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 3, '----------------------');
			IF v_status = 'Failed' THEN
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message) 
				VALUES (114, p_result, 3, 'The import function have been failed. This is because some data of rpt file has not values according standard format. PLEASE REVIEW your rpt file and your options data!!!');
			ELSE 
			
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				SELECT 114, p_result, 3, concat(csv1, ' ', csv2,' ', csv3, ' ',csv4, ' ',csv5, ' ',csv6, ' ',csv7, ' ',csv8, ' ',csv9, ' ',csv10, ' ',csv11, ' ',csv12, ' ',csv13, ' ',
				csv14, ' ',csv15, ' ',csv16, ' ',csv17, ' ',csv18, ' ',csv19, ' ',csv20)
				FROM temp_csv WHERE fid=140 and csv1 !='*';
			END IF;

		ELSE		
			-- basic statistics
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 1, 'BASIC STATISTICS');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 1, '-----------------------');

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			SELECT 114, 'stats', 1, concat ('FLOW : Max.(',max(flow)::numeric(12,3), ') , Avg.(', avg(flow)::numeric(12,3), ') , Standard dev.(', stddev(flow)::numeric(12,3)
			, ') , Min.(', min (flow)::numeric(12,3),').') FROM rpt_arc WHERE result_id = p_result;

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			SELECT 114, 'stats', 1, concat ('VELOCITY : Max.(',max(vel)::numeric(12,3), ') , Avg.(', avg(vel)::numeric(12,3), ') , Standard dev.(', stddev(vel)::numeric(12,3)
			, ') , Min.(', min (vel)::numeric(12,3),').') FROM rpt_arc WHERE result_id = p_result;

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			SELECT 114, 'stats', 1, concat ('PRESSURE : Max.(',max(press)::numeric(12,3), ') , Avg.(', avg(press)::numeric(12,3), ') , Standard dev.(', stddev(press)::numeric(12,3)
			, ') , Min.(', min (press)::numeric(12,3),').') FROM rpt_node WHERE result_id = p_result;

			-- warnings
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 2, '');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 2, 'WARNINGS');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 2, '--------------');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			SELECT 114, p_result, 2, concat (time, ' ', text) FROM rpt_hydraulic_status WHERE result_id = p_result AND time = 'WARNING:';
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 2, '');
		END IF;

	ELSIF v_project_type = 'UD' THEN

		IF (SELECT count(*) FROM rpt_arcflow_sum WHERE result_id = p_result) < 1 THEN
		
			-- errors
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 3, 'CRITICAL ERRORS');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 3, '----------------------');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			SELECT 114, p_result, 3, concat(csv1, ' ', csv2,' ', csv3, ' ',csv4, ' ',csv5, ' ',csv6, ' ',csv7, ' ',csv8, ' ',csv9, ' ',csv10, ' ',csv11, ' ',csv12, ' ',csv13, ' ',
			csv14, ' ',csv15, ' ',csv16, ' ',csv17, ' ',csv18, ' ',csv19, ' ',csv20)
			FROM temp_csv WHERE fid=140 and csv1 !='*';

		ELSE
			-- basic statistics
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 1, 'BASIC STATISTICS');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 1, '-----------------------');

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			SELECT 114, p_result, 1, concat ('MAX. FLOW : Max.(',max(max_flow)::numeric(12,3), ') , Avg.(', avg(max_flow)::numeric(12,3), ') , Standard dev.(', stddev(max_flow)::numeric(12,3)
			, ') , Min.(', min (max_flow)::numeric(12,3),').') FROM rpt_arcflow_sum WHERE result_id = p_result;

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			SELECT 114, p_result, 1, concat ('VELOCITY : Max.(',max(max_veloc)::numeric(12,3), ') , Avg.(', avg(max_veloc)::numeric(12,3), ') , Standard dev.(', stddev(max_veloc)::numeric(12,3)
			, ') , Min.(', min (max_veloc)::numeric(12,3),').') FROM rpt_arcflow_sum WHERE result_id = p_result;

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			SELECT 114, p_result, 1, concat ('FULL PERCENT. : Max.(',max(mfull_dept)::numeric(12,3), ') , Avg.(', avg(mfull_dept)::numeric(12,3), ') , Standard dev.(', stddev(mfull_dept)::numeric(12,3)
			, ') , Min.(', min (mfull_dept)::numeric(12,3),').') FROM rpt_arcflow_sum WHERE result_id = p_result;

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			SELECT 114, p_result, 1, concat ('NODE SURCHARGE : Number of nodes (', count(*)::integer,').') 
			FROM rpt_nodesurcharge_sum WHERE result_id = p_result;

			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			SELECT 114, p_result, 1, concat ('NODE FLOODING: Number of nodes (', count(*)::integer,'), Max. rate (',max(max_rate)::numeric(12,3), '), Total flood (' ,sum(tot_flood), 
			'), Max. flood (', max(tot_flood),').')
			FROM rpt_nodeflooding_sum WHERE result_id = p_result;

			-- warnings
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 2, '');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 2, 'WARNINGS');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 2, '-----------------------');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			SELECT 114, p_result, 1, concat(csv1,' ',csv2, ' ',csv3, ' ',csv4, ' ',csv5, ' ',csv6, ' ',csv7, ' ',csv8, ' ',csv9, ' ',csv10, ' ',csv11, ' ',csv12) from temp_csv
			where fid = 11 and source='rpt_warning_summary' and cur_user=current_user;
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
			SELECT 114, p_result, 1, concat(csv1,' ',csv2, ' ',csv3, ' ',csv4, ' ',csv5, ' ',csv6, ' ',csv7, ' ',csv8, ' ',csv9, ' ',csv10, ' ',csv11, ' ',csv12) from temp_csv
			where fid = 11 and source='rpt_warning_summary' and cur_user=current_user;
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 2, '');
		END IF;
	END IF;

	v_stats = (SELECT array_to_json(array_agg(error_message)) FROM audit_check_data WHERE result_id='stats' AND fid=114 AND cur_user=current_user);

	UPDATE rpt_cat_result SET stats = v_stats WHERE result_id=p_result;

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
	SELECT 114, p_result, 1, concat(csv1,' ',csv2, ' ',csv3, ' ',csv4, ' ',csv5, ' ',csv6, ' ',csv7, ' ',csv8, ' ',csv9, ' ',csv10, ' ',csv11, ' ',csv12) from temp_csv
	where fid = 11 and source='rpt_cat_result' and cur_user=current_user;


	-- detalied user inp options
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 1, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 1, 'DETAILED USER INPUT OPTIONS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (114, p_result, 1, '----------------------------------------');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
	SELECT 114, p_result, 1, concat (label, ' : ', value) FROM config_param_user 
	JOIN sys_param_user a ON a.id=parameter WHERE cur_user=current_user AND formname='epaoptions' AND value is not null;
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=114 order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	--points
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript,fid, the_geom
  	FROM  anl_node WHERE cur_user="current_user"() AND  fid IN (107, 114, 164, 166, 170, 171, 198)) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}'); 

	--lines
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, the_geom, fid
  	FROM  anl_arc WHERE cur_user="current_user"() AND fid IN (103, 114, 139)) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}'); 

	--polygons
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT id, pol_id, pol_type, state, expl_id, descript, the_geom, fid
  	FROM  anl_polygon WHERE cur_user="current_user"() AND fid = 114) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"Polygon", "features":',v_result,'}'); 

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}'); 
	
	--  Return
    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Rpt file have been imported"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json;

	--  Exception handling
	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	--RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;