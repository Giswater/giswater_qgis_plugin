/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3266

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_set_rpt_archived(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE

-- fid: 508
SELECT SCHEMA_NAME.gw_fct_set_rpt_archived($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "result_id":"result1"}}$$);
*/

DECLARE

v_version text;
v_result json;
v_result_info json;
v_error_context text;
v_projecttype text;
v_fid integer = 508;
v_result_id text;
v_action text = 'ARCHIVE';


BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_result_id :=  ((p_data ->>'data')::json->>'result_id');
	v_action := ((p_data ->>'data')::json->>'action');

	IF v_action IS NULL THEN v_action = 'ARCHIVE'; END IF;


	-- Reset values
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	-- create log
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('ARCHIVE RPT RESULT'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '------------------------------');


	IF v_action = 'ARCHIVE' THEN
		-- inserting on archived_rpt_inp_arc
		EXECUTE 'INSERT INTO archived_rpt_inp_arc(
			result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation,
			diameter, roughness, length, status, the_geom, expl_id, flw_code, minorloss, addparam, arcparent, dma_id,
			presszone_id, dqa_id, minsector_id, age)
		SELECT
			result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation,
			diameter, roughness, length, status, the_geom, expl_id, flw_code, minorloss, addparam, arcparent, dma_id,
			presszone_id, dqa_id, minsector_id, age
		FROM rpt_inp_arc
		WHERE result_id = '||quote_literal(v_result_id)||';';

		-- inserting on archived_rpt_arc
		EXECUTE 'INSERT INTO archived_rpt_arc(
			result_id, arc_id, length, diameter, flow, vel, headloss, setting, reaction, ffactor, other, time, status)
		SELECT
			result_id, arc_id, length, diameter, flow, vel, headloss, setting, reaction, ffactor, other, time, status
		FROM rpt_arc
		WHERE result_id = '||quote_literal(v_result_id)||';';

		-- inserting on archived_rpt_arc_stats
		EXECUTE 'INSERT INTO archived_rpt_arc_stats(
			arc_id, result_id, arc_type, sector_id, arccat_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg,
			headloss_max, headloss_min, setting_max, setting_min, reaction_max, reaction_min, ffactor_max, ffactor_min, length,
			tot_headloss_max, tot_headloss_min, the_geom)
		SELECT
			arc_id, result_id, arc_type, sector_id, arccat_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg,
			headloss_max, headloss_min, setting_max, setting_min, reaction_max, reaction_min, ffactor_max, ffactor_min, length,
			tot_headloss_max, tot_headloss_min, the_geom
		FROM rpt_arc_stats
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM rpt_inp_arc WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_arc WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_arc_stats WHERE result_id = '||quote_literal(v_result_id)||';';


		-- insert on archived_rpt_inp_node
		EXECUTE 'INSERT INTO archived_rpt_inp_node(
			result_id, node_id, top_elev, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation,
			demand, the_geom, expl_id, pattern_id, addparam, nodeparent, arcposition, dma_id, presszone_id, dqa_id,
			minsector_id, age)
		SELECT
			result_id, node_id, top_elev, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation,
			demand, the_geom, expl_id, pattern_id, addparam, nodeparent, arcposition, dma_id, presszone_id, dqa_id,
			minsector_id, age
		FROM rpt_inp_node
		WHERE result_id = '||quote_literal(v_result_id)||';';

		-- insert on archived_rpt_node
		EXECUTE 'INSERT INTO archived_rpt_node(
			result_id, node_id, top_elev, demand, head, press, other, time, quality)
		SELECT
			result_id, node_id, top_elev, demand, head, press, other, time, quality
		FROM rpt_node
		WHERE result_id = '||quote_literal(v_result_id)||';';

		-- insert on archived_rpt_node_stats
		EXECUTE 'INSERT INTO archived_rpt_node_stats(
			node_id, result_id, node_type, sector_id, nodecat_id, top_elev, demand_max, demand_min, demand_avg, head_max,
			head_min, head_avg, press_max, press_min, press_avg, quality_max, quality_min, quality_avg, the_geom)
		SELECT
			node_id, result_id, node_type, sector_id, nodecat_id, top_elev, demand_max, demand_min, demand_avg, head_max,
			head_min, head_avg, press_max, press_min, press_avg, quality_max, quality_min, quality_avg, the_geom
		FROM rpt_node_stats
		WHERE result_id = '||quote_literal(v_result_id)||';';

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

	ELSIF v_action = 'RESTORE' THEN

		-- inserting on archived_rpt_inp_arc
		EXECUTE 'INSERT INTO rpt_inp_arc(
			result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation,
			diameter, roughness, length, status, the_geom, expl_id, flw_code, minorloss, addparam, arcparent, dma_id,
			presszone_id, dqa_id, minsector_id, age)
		SELECT
			result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation,
			diameter, roughness, length, status, the_geom, expl_id, flw_code, minorloss, addparam, arcparent, dma_id,
			presszone_id, dqa_id, minsector_id, age
		FROM archived_rpt_inp_arc
		WHERE result_id = '||quote_literal(v_result_id)||';';

		-- inserting on archived_rpt_arc
		EXECUTE 'INSERT INTO rpt_arc(
			result_id, arc_id, length, diameter, flow, vel, headloss, setting, reaction, ffactor, other, time, status)
		SELECT
			result_id, arc_id, length, diameter, flow, vel, headloss, setting, reaction, ffactor, other, time, status
		FROM archived_rpt_arc
		WHERE result_id = '||quote_literal(v_result_id)||';';

		-- inserting on archived_rpt_arc_stats
		EXECUTE 'INSERT INTO rpt_arc_stats(
			arc_id, result_id, arc_type, sector_id, arccat_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg,
			headloss_max, headloss_min, setting_max, setting_min, reaction_max, reaction_min, ffactor_max, ffactor_min, length,
			tot_headloss_max, tot_headloss_min, the_geom)
		SELECT
			arc_id, result_id, arc_type, sector_id, arccat_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg,
			headloss_max, headloss_min, setting_max, setting_min, reaction_max, reaction_min, ffactor_max, ffactor_min, length,
			tot_headloss_max, tot_headloss_min, the_geom
		FROM archived_rpt_arc_stats
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM archived_rpt_inp_arc WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM archived_rpt_arc WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM archived_rpt_arc_stats WHERE result_id = '||quote_literal(v_result_id)||';';


		-- insert on archived_rpt_inp_node
		EXECUTE 'INSERT INTO rpt_inp_node(
			result_id, node_id, top_elev, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation,
			demand, the_geom, expl_id, pattern_id, addparam, nodeparent, arcposition, dma_id, presszone_id, dqa_id,
			minsector_id, age)
		SELECT
			result_id, node_id, top_elev, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation,
			demand, the_geom, expl_id, pattern_id, addparam, nodeparent, arcposition, dma_id, presszone_id, dqa_id,
			minsector_id, age
		FROM archived_rpt_inp_node
		WHERE result_id = '||quote_literal(v_result_id)||';';

		-- insert on archived_rpt_node
		EXECUTE 'INSERT INTO rpt_node(
			result_id, node_id, top_elev, demand, head, press, other, time, quality)
		SELECT
			result_id, node_id, top_elev, demand, head, press, other, time, quality
		FROM archived_rpt_node
		WHERE result_id = '||quote_literal(v_result_id)||';';

		-- insert on archived_rpt_node_stats
		EXECUTE 'INSERT INTO rpt_node_stats(
			node_id, result_id, node_type, sector_id, nodecat_id, top_elev, demand_max, demand_min, demand_avg, head_max,
			head_min, head_avg, press_max, press_min, press_avg, quality_max, quality_min, quality_avg, the_geom)
		SELECT
			node_id, result_id, node_type, sector_id, nodecat_id, top_elev, demand_max, demand_min, demand_avg, head_max,
			head_min, head_avg, press_max, press_min, press_avg, quality_max, quality_min, quality_avg, the_geom
		FROM archived_rpt_node_stats
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM archived_rpt_inp_node WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM archived_rpt_node WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM archived_rpt_node_stats WHERE result_id = '||quote_literal(v_result_id)||';';

		-- insert into rpt_energy_usage from archived_rpt_energy_usage
		EXECUTE 'INSERT INTO rpt_energy_usage(
			result_id, nodarc_id, usage_fact, avg_effic, kwhr_mgal, avg_kw, peak_kw, cost_day)
		SELECT 
			result_id, nodarc_id, usage_fact, avg_effic, kwhr_mgal, avg_kw, peak_kw, cost_day 
		FROM archived_rpt_energy_usage
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM archived_rpt_energy_usage WHERE result_id = '||quote_literal(v_result_id)||';';

		-- insert into rpt_hydraulic_status from archived_rpt_hydraulic_status
		EXECUTE 'INSERT INTO rpt_hydraulic_status(
			result_id, "time", text)
		SELECT 
			result_id, "time", text
		FROM archived_rpt_hydraulic_status 
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM archived_rpt_hydraulic_status WHERE result_id = '||quote_literal(v_result_id)||';';

		-- insert into rpt_inp_pattern_value from archived_rpt_inp_pattern_value
		EXECUTE 'INSERT INTO rpt_inp_pattern_value(
			result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
			factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18, user_name)
		SELECT 
			result_id, dma_id, pattern_id, idrow, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, 
			factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18, user_name
		FROM archived_rpt_inp_pattern_value 
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM archived_rpt_inp_pattern_value WHERE result_id = '||quote_literal(v_result_id)||';';

		-- update rpt_cat_result set status
		EXECUTE 'UPDATE rpt_cat_result set status = 2 WHERE result_id = '||quote_literal(v_result_id)||';';

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Data from archived_* tables has been restored to their respective tables.'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Selected result status has been set to COMPLETED.'));


	END IF;
	-- insert spacers
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, concat(''));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, concat(''));

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

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
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
