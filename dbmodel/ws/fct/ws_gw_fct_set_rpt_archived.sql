/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3266

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_set_rpt_archived(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE

-- fid: 508
SELECT SCHEMA_NAME.gw_fct_set_rpt_archived($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "result_id":"result1"}}$$);
*/

DECLARE

v_version text;
v_result json;
v_result_info json;
v_error_context text;
v_projecttype text;
v_fid integer = 508;
v_result_id text;


BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;
	
	-- getting input data	
	v_result_id :=  ((p_data ->>'data')::json->>'result_id');


	-- Reset values
		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	-- create log
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('ARCHIVE RPT RESULT'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '------------------------------');


	-- inserting on catalog table
	EXECUTE 'INSERT INTO archived_rpt_arc(
	result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, diameter, roughness, length, status, the_geom, expl_id, flw_code, minorloss, addparam, arcparent, 
	dma_id, presszone_id, dqa_id, minsector_id, age, rpt_length, rpt_diameter, flow, vel, headloss, setting, reaction, ffactor, other, "time", rpt_status)
	select inp.result_id, inp.arc_id, inp.node_1, inp.node_2, inp.arc_type, inp.arccat_id, inp.epa_type, inp.sector_id, inp.state, inp.state_type, inp.annotation, inp.diameter, inp.roughness, inp.length, 
	inp.status, inp.the_geom, inp.expl_id, inp.flw_code, inp.minorloss, inp.addparam, inp.arcparent, inp.dma_id, inp.presszone_id, inp.dqa_id, inp.minsector_id, inp.age, rpt.length, rpt.diameter, rpt.flow, 
	rpt.vel, rpt.headloss, rpt.setting, rpt.reaction, rpt.ffactor, rpt.other, rpt."time", rpt.status
	FROM rpt_inp_arc inp
	JOIN rpt_arc rpt USING (arc_id)
	WHERE inp.result_id = '||quote_literal(v_result_id)||' AND rpt.result_id='||quote_literal(v_result_id)||';';

	EXECUTE 'DELETE FROM rpt_inp_arc WHERE result_id = '||quote_literal(v_result_id)||';';
	EXECUTE 'DELETE FROM rpt_arc WHERE result_id = '||quote_literal(v_result_id)||';';
	EXECUTE 'DELETE FROM rpt_arc_stats WHERE result_id = '||quote_literal(v_result_id)||';';

	EXECUTE 'INSERT INTO archived_rpt_node(
	result_id, node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, demand, the_geom, 
	expl_id, pattern_id, addparam, nodeparent, arcposition, dma_id, presszone_id, dqa_id, minsector_id, age, rpt_elevation, rpt_demand, head, 
	press, other, "time", quality)
	SELECT inp.result_id, inp.node_id, inp.elevation, inp.elev, inp.node_type, inp.nodecat_id, inp.epa_type, inp.sector_id, inp.state, inp.state_type, inp.annotation, inp.demand, inp.the_geom, inp.expl_id, 
	inp.pattern_id, inp.addparam, inp.nodeparent, inp.arcposition, inp.dma_id, inp.presszone_id, inp.dqa_id, inp.minsector_id, inp.age, rpt.elevation, rpt.demand, rpt.head, rpt.press, rpt.other, rpt."time", rpt.quality
	FROM rpt_inp_node inp
	JOIN rpt_node rpt USING (node_id)
	WHERE inp.result_id = '||quote_literal(v_result_id)||' AND rpt.result_id='||quote_literal(v_result_id)||';';

	EXECUTE 'DELETE FROM rpt_inp_node WHERE result_id = '||quote_literal(v_result_id)||';';
	EXECUTE 'DELETE FROM rpt_node WHERE result_id = '||quote_literal(v_result_id)||';';
	EXECUTE 'DELETE FROM rpt_node_stats WHERE result_id = '||quote_literal(v_result_id)||';';


	EXECUTE 'INSERT INTO archived_rpt_energy_usage(
	result_id, nodarc_id, usage_fact, avg_effic, kwhr_mgal, avg_kw, peak_kw, cost_day)
	SELECT 	result_id, nodarc_id, usage_fact, avg_effic, kwhr_mgal, avg_kw, peak_kw, cost_day 
	FROM rpt_energy_usage
	WHERE result_id = '||quote_literal(v_result_id)||';';

	EXECUTE 'DELETE FROM rpt_energy_usage WHERE result_id = '||quote_literal(v_result_id)||';';


	EXECUTE 'INSERT INTO archived_rpt_hydraulic_status(
	result_id, "time", text)
	SELECT result_id, "time", text
	FROM rpt_hydraulic_status 
	WHERE result_id = '||quote_literal(v_result_id)||';';

	EXECUTE 'DELETE FROM rpt_hydraulic_status WHERE result_id = '||quote_literal(v_result_id)||';';


	EXECUTE 'INSERT INTO archived_rpt_inp_pattern_value(
	result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, 
	factor_16, factor_17, factor_18, user_name)
	SELECT result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, 
	factor_16, factor_17, factor_18, user_name
	FROM rpt_inp_pattern_value 
	WHERE result_id = '||quote_literal(v_result_id)||';';

	EXECUTE 'DELETE FROM rpt_inp_pattern_value WHERE result_id = '||quote_literal(v_result_id)||';';

	EXECUTE 'UPDATE rpt_cat_result set status = 3 WHERE result_id = '||quote_literal(v_result_id)||';';


	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Data from rpt_inp and rpt tables has been moved to archived_* tables.'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Selected result status has been set to ARCHIVED.'));

	-- insert spacers
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, concat(''));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, concat(''));
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3266, null, null, null); 

	-- manage exceptions
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
