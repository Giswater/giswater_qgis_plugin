/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2520

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_epanet_rpt(text, text);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_epanet_rpt(p_data);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_rpt2pg_import_rpt(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_rpt2pg_import_rpt($${"data":{"resultId":"r1"}}$$)

-- fid: 140

*/

DECLARE
v_hour text;
v_type text;
v_rpt record;
v_fid integer = 140;
v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_version text;
v_path text;
v_result_id text;
v_njunction integer;
v_nreservoir integer;
v_ntanks integer;
v_npipes integer;
v_npumps integer;
v_nvalves integer;
v_headloss text;
v_htstep text;
v_haccuracy numeric;
v_statuscheck numeric;
v_mcheck  numeric;
v_dthreshold numeric;
v_mtrials numeric;
v_qanalysis text;
v_sgravity numeric;
v_rkinematic numeric;
v_rchemical numeric;
v_dmultiplier numeric;
v_tduration text;
v_qtimestep text;
v_qtolerance text;
v_type_2 text;
v_error_context text;
v_ffactor text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT giswater INTO v_version FROM sys_version order by 1 desc limit 1;

	-- get input data
	v_result_id := ((p_data ->>'data')::json->>'resultId')::text;
	v_path := ((p_data ->>'data')::json->>'path')::text;

	-- delete previous data on log table
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid = 140;
		
	-- use the copy function of postgres to import from file in case of file must be provided as a parameter

	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (140, v_result_id, concat('IMPORT RPT FILE'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (140, v_result_id, concat('-----------------------------'));
	
	UPDATE temp_csv SET fid = v_fid;
	
	--remove data from with the same result_id
	FOR v_rpt IN SELECT tablename FROM config_fprocess WHERE fid=v_fid EXCEPT SELECT tablename FROM config_fprocess WHERE tablename='rpt_cat_result' LOOP
		EXECUTE 'DELETE FROM '||v_rpt.tablename||' WHERE result_id='''||v_result_id||''';';
	END LOOP;
	
	v_hour=null;

	v_ffactor = (SELECT value FROM config_param_user WHERE parameter = 'inp_report_f_factor' AND cur_user = current_user);

	IF v_ffactor = 'NO' THEN
		UPDATE temp_csv SET csv10=csv9, csv9=0 WHERE source='rpt_arc' AND fid = 140 AND cur_user=current_user;
	END IF;
	
	-- rpt_node
	DELETE FROM temp_csv WHERE source='rpt_node' AND (csv1='Node' or csv1='Elevation' or csv1='MINIMUM' or csv1='MAXIMUM' or csv1='DIFFERENTIAL' or csv1='AVERAGE');
	UPDATE temp_csv SET csv6=null WHERE source='rpt_node' AND (csv6='Reservoir' OR csv6='Tank'); -- delete Reservoir AND tank word when quality is not enabled
	INSERT INTO rpt_node (node_id, result_id, "time", elevation, demand, head, press, quality) 
	SELECT csv1, v_result_id, csv40, csv2::numeric, csv3::numeric, csv4::numeric, csv5::numeric, csv6::numeric
	FROM temp_csv WHERE source='rpt_node' AND fid = 140 AND cur_user=current_user ORDER BY id;

	-- rpt_arc
	DELETE FROM temp_csv WHERE source='rpt_arc' AND (csv1='Link' or csv1='Length' or csv1='Analysis' or csv1='MINIMUM' or csv1='MAXIMUM' or csv1='DIFFERENTIAL' or csv1='AVERAGE');
	INSERT INTO rpt_arc(arc_id,result_id,"time",length, diameter, flow, vel, headloss,setting,reaction, ffactor,other)
	SELECT csv1,v_result_id, csv40, csv2::numeric, csv3::numeric, csv4::numeric, csv5::numeric, csv6::numeric, csv7::numeric, csv8::numeric, csv9::numeric, csv10
	FROM temp_csv WHERE source='rpt_arc' AND fid = 140 AND cur_user=current_user ORDER BY id;

	-- energy_usage
	INSERT INTO rpt_energy_usage(result_id, nodarc_id, usage_fact, avg_effic, kwhr_mgal, avg_kw, peak_kw, cost_day)
	SELECT v_result_id, csv1, csv2::numeric, csv3::numeric, csv4::numeric, csv5::numeric, csv6::numeric, csv7::numeric
	FROM temp_csv WHERE source='rpt_energy_usage' AND fid = 140 AND cur_user=current_user AND csv1 NOT IN ('Energy', 'Pump', 'Demand', 'Total') ORDER BY id;

	-- hydraulic_status
	INSERT INTO rpt_hydraulic_status (result_id, time, text)
	SELECT v_result_id, csv1, concat (csv2, ' ', csv3,' ', csv4, ' ',csv5, ' ',csv6, ' ',csv7, ' ',csv8, ' ',csv9, ' ',csv10, ' ',csv11,' ', csv12,' ', csv13, ' ',
	csv14, ' ',csv15, ' ',csv16, ' ',csv17, ' ',csv18)
	FROM temp_csv WHERE source='rpt_hydraulic_status' AND fid = 140 AND cur_user=current_user AND csv1 = 'WARNING' ORDER BY id;

	INSERT INTO rpt_hydraulic_status (result_id, time, text)
	SELECT v_result_id, csv1, concat (csv2, ' ', csv3,' ', csv4, ' ',csv5, ' ',csv6, ' ',csv7, ' ',csv8, ' ',csv9, ' ',csv10, ' ',csv11,' ', csv12,' ', csv13, ' ',
	csv14, ' ',csv15, ' ',csv16, ' ',csv17, ' ',csv18)
	FROM temp_csv WHERE source='rpt_hydraulic_status' AND fid = 140 AND cur_user=current_user ORDER BY id;


	-- rpt_cat_result
	v_njunction = (SELECT csv4 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Number Junctions%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_nreservoir = (SELECT csv4 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Number Reservoirs%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_ntanks = (SELECT csv5 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Number Tanks%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_npipes = (SELECT csv5 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Number Pipes%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_npumps = (SELECT csv5 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Number Pumps%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_nvalves = (SELECT csv5 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Number Valves%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_headloss = (SELECT csv4 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Headloss%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_htstep= (SELECT concat(csv4,csv5) FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Hydraulic Timestep%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_haccuracy = (SELECT csv4 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Hydraulic Accuracy%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_statuscheck = (SELECT csv5 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Status Check%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_mcheck = (SELECT csv5 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Maximum Check%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_dthreshold = (SELECT csv5 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Damping Threshold%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_mtrials = (SELECT csv4 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Maximum Trials ...................%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_qanalysis = (SELECT csv4 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Quality Analysis%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_sgravity = (SELECT csv4 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Specific Gravity%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_rkinematic = (SELECT csv5 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Relative Kinematic%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_rchemical = (SELECT csv5 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Relative Chemical%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_dmultiplier= (SELECT csv4 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Demand Multiplier%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);
	v_tduration = (SELECT csv4 FROM temp_csv WHERE concat(csv1,' ',csv3) ilike 'Total Duration%' AND fid = 140 AND source='rpt_cat_result' AND cur_user=current_user);

	-- to do:
	--v_qtimestep text;
	--v_qtolerance text;

	UPDATE rpt_cat_result set n_junction=v_njunction, n_reservoir=v_nreservoir, n_tank=v_ntanks, n_pipe=v_npipes, n_pump=v_npumps, n_valve=v_nvalves, head_form=v_headloss, hydra_time=v_htstep
				, hydra_acc=v_haccuracy, st_ch_freq=v_statuscheck, max_tr_ch=v_mcheck, dam_li_thr=v_dthreshold, max_trials=v_mtrials, q_analysis=v_qanalysis, spec_grav=v_sgravity
				, r_kin_visc=v_rkinematic, r_che_diff=v_rchemical, dem_multi=v_dmultiplier, total_dura=v_tduration, q_timestep=v_qtimestep, q_tolerance=v_qtolerance;

	INSERT INTO audit_check_data (fid, error_message) VALUES (140, 'Rpt file import process -> Finished. Check your data');

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid = 140  order by id) row;
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
  	FROM  anl_node WHERE cur_user="current_user"() AND fid = 140) row) features;

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
  	FROM  anl_arc WHERE cur_user="current_user"() AND fid = 140) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}'); 

	--Control nulls
	v_version := COALESCE(v_version, '{}'); 
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 	

	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Import succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||
		       '}}'||
	    '}')::json;		

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
