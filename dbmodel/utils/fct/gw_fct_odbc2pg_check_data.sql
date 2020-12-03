/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2764

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_odbc2pg_check_data(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_odbc2pg_check_data(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_odbc2pg_check_data($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{"parameters":{"exploitation":"557", "period":"4T", "year":"2019"}}}$$)

-- fid: 173,190,192

*/

DECLARE

v_expl integer;
v_period text;
v_year integer;
v_project_type text;
v_version text;
v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_querytext text;
v_count integer;
v_errcontext text;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_expl := (((p_data ->>'data')::json->>'parameters')::json->>'exploitation')::integer;
	v_year := (((p_data ->>'data')::json->>'parameters')::json->>'year')::integer;
	v_period := (((p_data ->>'data')::json->>'parameters')::json->>'period')::text;
	
	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid = 173 AND cur_user=current_user;
	DELETE FROM anl_arc WHERE fid = 190 and cur_user=current_user;
	DELETE FROM anl_connec WHERE fid = 192 and cur_user=current_user;

	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (173, NULL, 4, concat('DATA ANALYSIS ACORDING ODBC IMPORT-EXPORT RULES'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (173, NULL, 4, '--------------------------------------------------------------');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (173, NULL, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (173, NULL, 2, '--------------');

	-- get arcs with dma=0 (fid:  190)
	v_querytext = 'SELECT arc_id, dma_id, arccat_id, the_geom FROM v_edit_arc WHERE expl_id = '||v_expl||' AND dma_id=0';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	IF v_count > 0 THEN
		DELETE FROM anl_arc WHERE fid = 190 and cur_user=current_user;
		EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom) SELECT 190, arc_id, arccat_id, ''arcs without DMA'', the_geom FROM (', v_querytext,')a');
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (173, 2, concat('WARNING: There is/are ',v_count,' arc(s) that have disconnected some part of network. Please check your data before continue'));
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (173, 2, concat('HINT: SELECT * FROM anl_arc WHERE fid = 190 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (173, 1, 'INFO: No arcs with dma_id=0 have been exported using the ODBC system');
	END IF;

	-- get connecs with dma=0 (fid:  192)
	v_querytext = 'SELECT connec_id, dma_id, connecat_id, the_geom FROM v_edit_connec WHERE expl_id = '||v_expl||' AND dma_id=0';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_connec (fid, connec_id, connecat_id, descript, the_geom) SELECT 192, connec_id, connecat_id, ''Connecs without DMA'', the_geom FROM (', v_querytext,')a');
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (173, 2, concat('WARNING: There is/are ',v_count,' connec(s) NOT exported through the ODBC system. Please check your data before continue'));
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (173, 2, concat('HINT: SELECT * FROM anl_connec WHERE fid = 190 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (173, 1, 'INFO: No connecs with dma_id=0 have been exported using the ODBC system');
	END IF;

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (173, NULL, 4, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (173, NULL, 2, '');

	-- get results (173 odbc process, 145 dma process)
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, message FROM (SELECT id, criticity, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid = 173 UNION
	      SELECT id, criticity, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid = 145 AND criticity = 1 order by criticity desc, id asc)a )row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- points
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT id, connec_id, connecat_id, state, expl_id, descript, the_geom
  	FROM  anl_connec WHERE cur_user="current_user"() AND fid = 192) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point","features":',v_result, '}'); 
	-- lines
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, the_geom
  	FROM  anl_arc WHERE cur_user="current_user"() AND fid = 190) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}'); 

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	raise notice 'result_line %', v_result_line;
	
	--  Return
    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"ODBC connection analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||
		     '}}}')::json;

	--  Exception handling
    EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;  
	RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_errcontext) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
