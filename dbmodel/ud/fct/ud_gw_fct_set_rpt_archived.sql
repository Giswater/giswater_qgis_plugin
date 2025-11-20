/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3320

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_set_rpt_archived(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE

-- fid: 508
SELECT SCHEMA_NAME.gw_fct_set_rpt_archived($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "result_id":"result1"}}$$);
SELECT SCHEMA_NAME.gw_fct_set_rpt_archived($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "action": "ARCHIVE", "result_id":"result1"}}$$);
SELECT SCHEMA_NAME.gw_fct_set_rpt_archived($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "action": "RESTORE", "result_id":"result1"}}$$);
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
			-- rpt_inp_arc
			result_id, arc_id, node_1, node_2, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, length, n, the_geom, expl_id, addparam, arcparent, q0, qmax, barrels, slope, culvert, kentry, kexit, kavg, flap, seepage, age,
			-- rpt_arcflow_sum
			max_flow, time_days, time_hour, max_veloc, mfull_flow, mfull_depth, max_shear, max_hr, max_slope, day_max, time_max, min_shear, day_min, time_min,
			-- rpt_arcpolload_sum
			poll_id,
			-- rpt_condsurcharge_sum
			both_ends, upstream, dnstream, hour_nflow, hour_limit,
			-- rpt_pumping_sum
			percent, num_startup, min_flow, avg_flow, max_flow_pumping, vol_ltr, powus_kwh, timoff_min, timoff_max,
			-- rpt_flowclass_sum
			length_flowclass, dry, up_dry, down_dry, sub_crit, sub_crit_1, up_crit, down_crit, froud_numb, flow_chang
		) SELECT DISTINCT ON (r.arc_id)
			-- rpt_inp_arc
			r.result_id, r.arc_id, r.node_1, r.node_2, r.elevmax1, r.elevmax2, r.arc_type, r.arccat_id, r.epa_type, r.sector_id, r.state, r.state_type, r.annotation, r.length, r.n, r.the_geom, r.expl_id, r.addparam, r.arcparent, r.q0, r.qmax, r.barrels, r.slope, r.culvert, r.kentry, r.kexit, r.kavg, r.flap, r.seepage, r.age,
			-- rpt_arcflow_sum
			af.max_flow, af.time_days, af.time_hour, af.max_veloc, af.mfull_flow, af.mfull_depth, af.max_shear, af.max_hr, af.max_slope, af.day_max, af.time_max, af.min_shear, af.day_min, af.time_min,
			-- rpt_arcpolload_sum

			ap.poll_id,
			-- rpt_condsurcharge_sum
			cc.both_ends, cc.upstream, cc.dnstream, cc.hour_nflow, cc.hour_limit,
			-- rpt_pumping_sum
			p.percent, p.num_startup, p.min_flow, p.avg_flow, p.max_flow, p.vol_ltr, p.powus_kwh, p.timoff_min, p.timoff_max,
			-- rpt_flowclass_sum
			fc.length, fc.dry, fc.up_dry, fc.down_dry, fc.sub_crit, fc.sub_crit_1, fc.up_crit, fc.down_crit, fc.froud_numb, fc.flow_chang
		FROM rpt_inp_arc r
			LEFT JOIN rpt_arcflow_sum af ON r.arc_id = af.arc_id
			LEFT JOIN rpt_arcpolload_sum ap ON r.arc_id = ap.arc_id
			LEFT JOIN rpt_condsurcharge_sum cc ON r.arc_id = cc.arc_id
			LEFT JOIN rpt_pumping_sum p ON r.arc_id = p.arc_id
			LEFT JOIN rpt_flowclass_sum fc ON r.arc_id = fc.arc_id
		WHERE r.result_id = '||quote_literal(v_result_id)||';';

		-- inserting on archived_rpt_arc
		EXECUTE 'INSERT INTO archived_rpt_arc (
			result_id, arc_id, resultdate, resulttime, flow, velocity, fullpercent
		) SELECT
			result_id, arc_id, resultdate, resulttime, flow, velocity, fullpercent
		FROM rpt_arc
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM rpt_inp_arc WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_arcflow_sum WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_arcpolload_sum WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_condsurcharge_sum WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_pumping_sum WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_flowclass_sum WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_arc WHERE result_id = '||quote_literal(v_result_id)||';';


		-- insert on archived_rpt_inp_node
		EXECUTE 'INSERT INTO archived_rpt_inp_node (
			-- rpt_inp_node
			result_id, node_id, top_elev, ymax, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, y0, ysur, apond, the_geom, expl_id, addparam, parent, arcposition, fusioned_node, age,
			-- rpt_nodeflooding_sum
			hour_flood, max_rate, flooding_time_days, flooding_time_hour, tot_flood, max_ponded,
			-- rpt_nodesurcharge_sum
			hour_surch, max_height, min_depth,
			-- rpt_nodeinflow_sum
			max_latinf, max_totinf, inflow_time_days, inflow_time_hour, latinf_vol, totinf_vol, flow_balance_error, other_info,
			-- rpt_nodedepth_sum
			aver_depth, max_depth, max_hgl, depth_time_days, depth_time_hour,
			-- rpt_outfallflow_sum
			flow_freq, avg_flow, max_flow, total_vol,
			-- rpt_outfallload_sum
			poll_id, value,
			-- rpt_storagevol_sum
			aver_vol, avg_full, ei_loss, max_vol, max_full, storagevol_time_days, storagevol_time_hour, max_out
		) SELECT DISTINCT ON (r.node_id)
			-- rpt_inp_node
			r.result_id, r.node_id, r.top_elev, r.ymax, r.elev, r.node_type, r.nodecat_id, r.epa_type, r.sector_id, r.state, r.state_type, r.annotation, r.y0, r.ysur, r.apond, r.the_geom, r.expl_id, r.addparam, r.parent, r.arcposition, r.fusioned_node, r.age,
			-- rpt_nodeflooding_sum
			nf.hour_flood, nf.max_rate, nf.time_days, nf.time_hour, nf.tot_flood, nf.max_ponded,
			-- rpt_nodesurcharge_sum
			ns.hour_surch, ns.max_height, ns.min_depth, 
			-- rpt_nodeinflow_sum
			ni.max_latinf, ni.max_totinf, ni.time_days, ni.time_hour, ni.latinf_vol, ni.totinf_vol, ni.flow_balance_error, ni.other_info, 
			-- rpt_nodedepth_sum
			nd.aver_depth, nd.max_depth, nd.max_hgl, nd.time_days, nd.time_hour, 
			-- rpt_outfallflow_sum
			of.flow_freq, of.avg_flow, of.max_flow, of.total_vol, 
			-- rpt_outfallload_sum
			ol.poll_id, ol.value, 
			-- rpt_storagevol_sum
			sv.aver_vol, sv.avg_full, sv.ei_loss, sv.max_vol, sv.max_full, sv.time_days, sv.time_hour, sv.max_out
		FROM rpt_inp_node r
			LEFT JOIN rpt_nodeflooding_sum nf ON r.node_id = nf.node_id
			LEFT JOIN rpt_nodesurcharge_sum ns ON r.node_id = ns.node_id
			LEFT JOIN rpt_nodeinflow_sum ni ON r.node_id = ni.node_id
			LEFT JOIN rpt_nodedepth_sum nd ON r.node_id = nd.node_id
			LEFT JOIN rpt_outfallflow_sum of ON r.node_id = of.node_id
			LEFT JOIN rpt_outfallload_sum ol ON r.node_id = ol.node_id
			LEFT JOIN rpt_storagevol_sum sv ON r.node_id = sv.node_id
		WHERE r.result_id = '||quote_literal(v_result_id)||';';

		-- insert on archived_rpt_node
		EXECUTE 'INSERT INTO archived_rpt_node (
			result_id, node_id, resultdate, resulttime, flooding, depth, head, inflow
		) SELECT
			result_id, node_id, resultdate, resulttime, flooding, depth, head, inflow
		FROM rpt_node
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM rpt_inp_node WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_nodeflooding_sum WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_nodesurcharge_sum WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_nodeinflow_sum WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_nodedepth_sum WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_outfallflow_sum WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_outfallload_sum WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_storagevol_sum z WHERE result_id = '||quote_literal(v_result_id)||';';
		EXECUTE 'DELETE FROM rpt_node WHERE result_id = '||quote_literal(v_result_id)||';';


		-- inserting on archived_rpt_inp_raingage
		EXECUTE 'INSERT INTO archived_rpt_inp_raingage (
			result_id, rg_id, form_type, intvl, scf, rgage_type, timser_id, fname, sta, units, the_geom, expl_id, muni_id
		) SELECT 
			result_id, rg_id, form_type, intvl, scf, rgage_type, timser_id, fname, sta, units, the_geom, expl_id, muni_id
		FROM rpt_inp_raingage
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM rpt_inp_raingage WHERE result_id = '||quote_literal(v_result_id)||';';


		-- inserting on archived_rpt_subcatchment
		EXECUTE 'INSERT INTO archived_rpt_subcatchment (
			result_id, subc_id, resultdate, resulttime, precip, losses, runoff
		) SELECT
			result_id, subc_id, resultdate, resulttime, precip, losses, runoff
		FROM rpt_subcatchment
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM rpt_subcatchment WHERE result_id = '||quote_literal(v_result_id)||';';


		-- inserting on archived_rpt_subcatchrunoff_sum
		EXECUTE 'INSERT INTO archived_rpt_subcatchrunoff_sum (
			result_id, subc_id, tot_precip, tot_runon, tot_evap, tot_infil, tot_runoff, tot_runofl, peak_runof, runoff_coe, vxmax, vymax, depth, vel, vhmax
		) SELECT
			result_id, subc_id, tot_precip, tot_runon, tot_evap, tot_infil, tot_runoff, tot_runofl, peak_runof, runoff_coe, vxmax, vymax, depth, vel, vhmax
		FROM rpt_subcatchrunoff_sum
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM rpt_subcatchrunoff_sum WHERE result_id = '||quote_literal(v_result_id)||';';


		-- inserting on archived_rpt_subcatchwashoff_sum
		EXECUTE 'INSERT INTO archived_rpt_subcatchwashoff_sum (
			result_id, subc_id, poll_id, value
		) SELECT
			result_id, subc_id, poll_id, value
		FROM rpt_subcatchwashoff_sum
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM rpt_subcatchwashoff_sum WHERE result_id = '||quote_literal(v_result_id)||';';


		-- inserting on archived_rpt_lidperformance_sum
		EXECUTE 'INSERT INTO archived_rpt_lidperformance_sum (
			result_id, subc_id, lidco_id, tot_inflow, evap_loss, infil_loss, surf_outf, drain_outf, init_stor, final_stor, per_error
		) SELECT
			result_id, subc_id, lidco_id, tot_inflow, evap_loss, infil_loss, surf_outf, drain_outf, init_stor, final_stor, per_error
		FROM rpt_lidperformance_sum
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM rpt_lidperformance_sum WHERE result_id = '||quote_literal(v_result_id)||';';

		-- update status set to ARCHIVED
		EXECUTE 'UPDATE rpt_cat_result set status = 3 WHERE result_id = '||quote_literal(v_result_id)||';';

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Data from rpt_inp and rpt tables has been moved to archived_* tables.'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Selected result status has been set to ARCHIVED.'));

	ELSIF v_action = 'RESTORE' THEN

		-- Recover data for rpt_inp_arc
		EXECUTE 'INSERT INTO rpt_inp_arc (
			result_id, arc_id, node_1, node_2, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, length, n, the_geom, expl_id, addparam, arcparent, q0, qmax, barrels, slope, culvert, kentry, kexit, kavg, flap, seepage, age
		)
		SELECT
			result_id, arc_id, node_1, node_2, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, length, n, the_geom, expl_id, addparam, arcparent, q0, qmax, barrels, slope, culvert, kentry, kexit, kavg, flap, seepage, age
		FROM archived_rpt_inp_arc
		WHERE result_id = '||quote_literal(v_result_id)||';';

		-- Recover data for rpt_arcflow_sum
		EXECUTE 'INSERT INTO rpt_arcflow_sum (
			result_id, arc_id, max_flow, time_days, time_hour, max_veloc, mfull_flow, mfull_depth, max_shear, max_hr, max_slope, day_max, time_max, min_shear, day_min, time_min
		)
		SELECT DISTINCT
			'||quote_literal(v_result_id)||', arc_id, max_flow, time_days, time_hour, max_veloc, mfull_flow, mfull_depth, max_shear, max_hr, max_slope, day_max, time_max, min_shear, day_min, time_min
		FROM archived_rpt_inp_arc
		WHERE result_id = '||quote_literal(v_result_id)||'
		AND max_flow IS NOT NULL;';

		-- Recover data for rpt_arcpolload_sum
		EXECUTE 'INSERT INTO rpt_arcpolload_sum (
			result_id, arc_id, poll_id
		)
		SELECT DISTINCT
			'||quote_literal(v_result_id)||', arc_id, poll_id
		FROM archived_rpt_inp_arc
		WHERE result_id = '||quote_literal(v_result_id)||'
		AND poll_id IS NOT NULL;';

		-- Recover data for rpt_condsurcharge_sum
		EXECUTE 'INSERT INTO rpt_condsurcharge_sum (
			result_id, arc_id, both_ends, upstream, dnstream, hour_nflow, hour_limit
		)
		SELECT DISTINCT
			'||quote_literal(v_result_id)||', arc_id, both_ends, upstream, dnstream, hour_nflow, hour_limit
		FROM archived_rpt_inp_arc
		WHERE result_id = '||quote_literal(v_result_id)||'
		AND both_ends IS NOT NULL;';

		-- Recover data for rpt_pumping_sum
		EXECUTE 'INSERT INTO rpt_pumping_sum (
			result_id, arc_id, percent, num_startup, min_flow, avg_flow, max_flow, vol_ltr, powus_kwh, timoff_min, timoff_max
		)
		SELECT DISTINCT
			'||quote_literal(v_result_id)||', arc_id, percent, num_startup, min_flow, avg_flow, max_flow_pumping, vol_ltr, powus_kwh, timoff_min, timoff_max
		FROM archived_rpt_inp_arc
		WHERE result_id = '||quote_literal(v_result_id)||'
		AND percent IS NOT NULL;';

		-- Recover data for rpt_flowclass_sum
		EXECUTE 'INSERT INTO rpt_flowclass_sum (
			result_id, arc_id, length, dry, up_dry, down_dry, sub_crit, sub_crit_1, up_crit, down_crit, froud_numb, flow_chang
		)
		SELECT DISTINCT
			'||quote_literal(v_result_id)||', arc_id, length_flowclass, dry, up_dry, down_dry, sub_crit, sub_crit_1, up_crit, down_crit, froud_numb, flow_chang
		FROM archived_rpt_inp_arc
		WHERE result_id = '||quote_literal(v_result_id)||'
		AND length_flowclass IS NOT NULL;';

		EXECUTE 'DELETE FROM archived_rpt_inp_arc WHERE result_id = '||quote_literal(v_result_id)||';';


		-- inserting on archived_rpt_arc
		EXECUTE 'INSERT INTO rpt_arc (
			result_id, arc_id, resultdate, resulttime, flow, velocity, fullpercent
		) SELECT
			result_id, arc_id, resultdate, resulttime, flow, velocity, fullpercent
		FROM archived_rpt_arc
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM archived_rpt_arc WHERE result_id = '||quote_literal(v_result_id)||';';


		-- Recover data for rpt_inp_node table
		EXECUTE 'INSERT INTO rpt_inp_node (
			result_id, node_id, top_elev, ymax, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, y0, ysur, apond, the_geom, expl_id, addparam, parent, arcposition, fusioned_node, age
		)
		SELECT
			result_id, node_id, top_elev, ymax, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, y0, ysur, apond, the_geom, expl_id, addparam, parent, arcposition, fusioned_node, age
		FROM archived_rpt_inp_node
		WHERE result_id = '||quote_literal(v_result_id)||';';

		-- Recover data for rpt_nodeflooding_sum table
		EXECUTE 'INSERT INTO rpt_nodeflooding_sum (
			result_id, node_id, hour_flood, max_rate, time_days, time_hour, tot_flood, max_ponded
		)
		SELECT
			'||quote_literal(v_result_id)||', node_id, hour_flood, max_rate, flooding_time_days, flooding_time_hour, tot_flood, max_ponded
		FROM archived_rpt_inp_node
		WHERE result_id = '||quote_literal(v_result_id)||'
		AND hour_flood IS NOT NULL;';

		-- Recover data for rpt_nodesurcharge_sum table
		EXECUTE 'INSERT INTO rpt_nodesurcharge_sum (
			result_id, node_id, hour_surch, max_height, min_depth
		)
		SELECT
			'||quote_literal(v_result_id)||', node_id, hour_surch, max_height, min_depth
		FROM archived_rpt_inp_node
		WHERE result_id = '||quote_literal(v_result_id)||'
		AND hour_surch IS NOT NULL;';

		-- Recover data for rpt_nodeinflow_sum table
		EXECUTE 'INSERT INTO rpt_nodeinflow_sum (
			result_id, node_id, max_latinf, max_totinf, time_days, time_hour, latinf_vol, totinf_vol, flow_balance_error, other_info
		)
		SELECT
			'||quote_literal(v_result_id)||', node_id, max_latinf, max_totinf, inflow_time_days, inflow_time_hour, latinf_vol, totinf_vol, flow_balance_error, other_info
		FROM archived_rpt_inp_node
		WHERE result_id = '||quote_literal(v_result_id)||'
		AND max_latinf IS NOT NULL;';

		-- Recover data for rpt_nodedepth_sum table
		EXECUTE 'INSERT INTO rpt_nodedepth_sum (
			result_id, node_id, aver_depth, max_depth, max_hgl, time_days, time_hour
		)
		SELECT
			'||quote_literal(v_result_id)||', node_id, aver_depth, max_depth, max_hgl, depth_time_days, depth_time_hour
		FROM archived_rpt_inp_node
		WHERE result_id = '||quote_literal(v_result_id)||'
		AND aver_depth IS NOT NULL;';

		-- Recover data for rpt_outfallflow_sum table
		EXECUTE 'INSERT INTO rpt_outfallflow_sum (
			result_id, node_id, flow_freq, avg_flow, max_flow, total_vol
		)
		SELECT
			'||quote_literal(v_result_id)||', node_id, flow_freq, avg_flow, max_flow, total_vol
		FROM archived_rpt_inp_node
		WHERE result_id = '||quote_literal(v_result_id)||'
		AND flow_freq IS NOT NULL;';

		-- Recover data for rpt_outfallload_sum table
		EXECUTE 'INSERT INTO rpt_outfallload_sum (
			result_id, node_id, poll_id, value
		)
		SELECT
			'||quote_literal(v_result_id)||', node_id, poll_id, value
		FROM archived_rpt_inp_node
		WHERE result_id = '||quote_literal(v_result_id)||'
		AND poll_id IS NOT NULL;';

		-- Recover data for rpt_storagevol_sum table
		EXECUTE 'INSERT INTO rpt_storagevol_sum (
			result_id, node_id, aver_vol, avg_full, ei_loss, max_vol, max_full, time_days, time_hour, max_out
		)
		SELECT
			'||quote_literal(v_result_id)||', node_id, aver_vol, avg_full, ei_loss, max_vol, max_full, storagevol_time_days, storagevol_time_hour, max_out
		FROM archived_rpt_inp_node
		WHERE result_id = '||quote_literal(v_result_id)||'
		AND aver_vol IS NOT NULL;';

		EXECUTE 'DELETE FROM archived_rpt_inp_node WHERE result_id = '||quote_literal(v_result_id)||';';


		-- Recover data for rpt_node
		EXECUTE 'INSERT INTO rpt_node (
			result_id, node_id, resultdate, resulttime, flooding, depth, head, inflow
		) SELECT
			result_id, node_id, resultdate, resulttime, flooding, depth, head, inflow
		FROM archived_rpt_node
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM archived_rpt_node WHERE result_id = '||quote_literal(v_result_id)||';';


		-- Recover data for rpt_inp_raingage
		EXECUTE 'INSERT INTO rpt_inp_raingage (
			result_id, rg_id, form_type, intvl, scf, rgage_type, timser_id, fname, sta, units, the_geom, expl_id, muni_id
		) SELECT 
			result_id, rg_id, form_type, intvl, scf, rgage_type, timser_id, fname, sta, units, the_geom, expl_id, muni_id
		FROM archived_rpt_inp_raingage
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM archived_rpt_inp_raingage WHERE result_id = '||quote_literal(v_result_id)||';';


		-- Recover data for rpt_subcatchment
		EXECUTE 'INSERT INTO rpt_subcatchment (
			result_id, subc_id, resultdate, resulttime, precip, losses, runoff
		) SELECT
			result_id, subc_id, resultdate, resulttime, precip, losses, runoff
		FROM archived_rpt_subcatchment
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM archived_rpt_subcatchment WHERE result_id = '||quote_literal(v_result_id)||';';


		-- Recover data for rpt_subcatchrunoff_sum
		EXECUTE 'INSERT INTO rpt_subcatchrunoff_sum (
			result_id, subc_id, tot_precip, tot_runon, tot_evap, tot_infil, tot_runoff, tot_runofl, peak_runof, runoff_coe, vxmax, vymax, depth, vel, vhmax
		) SELECT
			result_id, subc_id, tot_precip, tot_runon, tot_evap, tot_infil, tot_runoff, tot_runofl, peak_runof, runoff_coe, vxmax, vymax, depth, vel, vhmax
		FROM archived_rpt_subcatchrunoff_sum
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM archived_rpt_subcatchrunoff_sum WHERE result_id = '||quote_literal(v_result_id)||';';


		-- Recover data for rpt_subcatchwashoff_sum
		EXECUTE 'INSERT INTO rpt_subcatchwashoff_sum (
			result_id, subc_id, poll_id, value
		) SELECT
			result_id, subc_id, poll_id, value
		FROM archived_rpt_subcatchwashoff_sum
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM archived_rpt_subcatchwashoff_sum WHERE result_id = '||quote_literal(v_result_id)||';';


		-- Recover data for rpt_lidperformance_sum
		EXECUTE 'INSERT INTO rpt_lidperformance_sum (
			result_id, subc_id, lidco_id, tot_inflow, evap_loss, infil_loss, surf_outf, drain_outf, init_stor, final_stor, per_error
		) SELECT
			result_id, subc_id, lidco_id, tot_inflow, evap_loss, infil_loss, surf_outf, drain_outf, init_stor, final_stor, per_error
		FROM archived_rpt_lidperformance_sum
		WHERE result_id = '||quote_literal(v_result_id)||';';

		EXECUTE 'DELETE FROM archived_rpt_lidperformance_sum WHERE result_id = '||quote_literal(v_result_id)||';';

		-- Update rpt_cat_result set status
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
		'}')::json, 3320, null, null, null);

	-- manage exceptions
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
