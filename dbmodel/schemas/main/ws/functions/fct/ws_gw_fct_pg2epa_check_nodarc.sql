/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3106

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_nodarc(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_nodarc($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":SRID_VALUE}, "data":{"parameters":{"resultId":"test1"}}}$$)
SELECT SCHEMA_NAME.gw_fct_pg2epa_nod2arc('-1', false, true);


--fid: 417

*/

DECLARE

v_networkmode integer = 1;
v_return json;
v_result_info json;
v_result_point json;
v_input json;
v_result text = -1;
v_buildupmode integer;
v_usenetworkgeom boolean;
v_advancedsettings boolean;
v_vdefault boolean;
v_fid integer = 417;
v_error_context text;
v_count integer;
v_version text;
v_response integer;

BEGIN

	-- set search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system data
	SELECT giswater  INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_log_data WHERE fid = v_fid AND cur_user=current_user;

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('CHECK NODARC INCONSISTENCY'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '--------------------------------------------------');

	-- force only state 1 selector
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);

	INSERT INTO rpt_cat_result values (-1)
	ON CONFLICT DO NOTHING;

	-- Upsert on rpt_cat_table and set selectors';
	DELETE FROM selector_inp_result WHERE cur_user=current_user;
	INSERT INTO selector_inp_result (result_id, cur_user) VALUES (v_result, current_user);

	-- Fill inprpt tables';
	PERFORM gw_fct_pg2epa_fill_data(v_result);

	-- Call gw_fct_pg2epa_nod2arc function';
	SELECT gw_fct_pg2epa_nod2arc(v_result, false, true) INTO v_response;

	IF v_response = 0 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result, 1, 'INFO: All nodarcs have been analyzed Check results');

	ELSIF v_response = 1 THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result, 3,'HINT: Read the error message and redraw arc_id. Then execute again this function.');
	END IF;

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=417 order by  id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	--points
	v_result = null;
  	SELECT jsonb_build_object(
	    'type', 'FeatureCollection',
	    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
	) INTO v_result
 	FROM (
	SELECT jsonb_build_object(
	'type',       'Feature',
	'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	'properties', to_jsonb(row) - 'the_geom'
	) AS feature
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript,fid, ST_Transform(the_geom, 4326) as the_geom
	FROM  anl_node WHERE cur_user="current_user"() AND fid=v_fid) row) features;

  	v_result_point = v_result;

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||
			'}}'||
	    '}')::json, 3106, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;