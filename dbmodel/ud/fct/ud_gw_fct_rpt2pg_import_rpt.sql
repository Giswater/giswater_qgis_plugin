/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:2530

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_swmm_rpt(text, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_rpt2pg_import_rpt(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_rpt2pg_import_rpt($${"data":{"resultId":"test"}}$$)

--fid:140


*/

DECLARE
i integer = 0;
units_rec record;
element_rec record;
addfields_rec record;
id_last int8;
hour_aux text;
type_aux text;
rpt_rec record;
project_type_aux varchar;
v_fid integer = 140;
v_target text;
v_id text;
v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_version text;
v_path text;
v_result_id text;
v_error_context text;
v_epaversion text;
v_count1 integer;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT giswater  INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get user parameters
	SELECT value INTO v_epaversion FROM config_param_user WHERE cur_user = current_user AND parameter = 'inp_options_epaversion';

	-- get input data
	v_result_id := ((p_data ->>'data')::json->>'resultId')::text;
	v_path := ((p_data ->>'data')::json->>'path')::text;

	-- delete previous data on log table
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=140;


	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (140, v_result_id, concat('IMPORT RPT FILE'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (140, v_result_id, concat('-----------------------------'));

	--remove data from with the same result_id
	FOR rpt_rec IN SELECT tablename FROM config_fprocess WHERE fid=v_fid EXCEPT SELECT tablename FROM config_fprocess WHERE tablename='rpt_cat_result'
	LOOP
		EXECUTE 'DELETE FROM '||rpt_rec.tablename||' WHERE result_id='''||v_result_id||''';';
	END LOOP;

	-- setting rpt_subcatchrunoff_sum
	SELECT id into v_count1 FROM temp_t_csv WHERE source ='rpt_subcatchrunoff_sum' and csv1 = 'LID';
	IF v_count1 > 0 THEN
		UPDATE temp_t_csv SET source ='rpt_lidperformance_sum' WHERE source ='rpt_subcatchrunoff_sum' and id > v_count1;
	END IF;

	-- setting rpt_flowrouting_cont
	SELECT id into v_count1 FROM temp_t_csv WHERE source ='rpt_runoff_quant' and csv1 = 'Continuity';
	IF v_count1 > 0 THEN
		UPDATE temp_t_csv SET source ='rpt_flowrouting_cont' WHERE source ='rpt_runoff_quant ' and id > v_count1;
	END IF;

	-- delete trash rows
	DELETE FROM temp_t_csv WHERE source ='rpt_controls_actions_taken' and csv1='Control' and csv2='Actions';

	DELETE FROM temp_t_csv WHERE csv1='Analysis' and csv2='begun';
	DELETE FROM temp_t_csv WHERE csv1='Analysis' and csv2='ended';
	DELETE FROM temp_t_csv WHERE csv1='Total' and csv2='elapsed';

	DELETE FROM temp_t_csv WHERE source ='rpt_node' and csv1='Analysis' and csv2='begun';
	DELETE FROM temp_t_csv WHERE source ='rpt_node' and csv1='Analysis' and csv2='ended';
	DELETE FROM temp_t_csv WHERE source ='rpt_node' and csv1='Total' and csv2='elapsed';

	DELETE FROM temp_t_csv WHERE source ='rpt_subcatchrunoff_sum' and csv1='Subcatchment' and csv2='Runoff';
	DELETE FROM temp_t_csv WHERE source ='rpt_subcatchrunoff_sum' and csv1='Total' and csv2='Total';
	DELETE FROM temp_t_csv WHERE source ='rpt_subcatchrunoff_sum' and csv1='Precip' and csv2='Runon';
	DELETE FROM temp_t_csv WHERE source ='rpt_subcatchrunoff_sum' and csv1='Subcatchment' and csv2='mm';
	DELETE FROM temp_t_csv WHERE source ='rpt_subcatchrunoff_sum' and csv1='LID';

	DELETE FROM temp_t_csv WHERE source ='rpt_lidperformance_sum' and csv1='Total';
	DELETE FROM temp_t_csv WHERE source ='rpt_lidperformance_sum' and csv1='Inflow';
	DELETE FROM temp_t_csv WHERE source ='rpt_lidperformance_sum' and csv1='Subcatchment';

	DELETE FROM temp_t_csv WHERE source ='rpt_subcatchwashoff_sum' and csv1='Subcatchment' and csv2='Washoff';
	DELETE FROM temp_t_csv WHERE source ='rpt_subcatchwashoff_sum' and csv1='Subcatchment' and csv2='kg';

	DELETE FROM temp_t_csv WHERE source ='rpt_nodedepth_sum' and csv1='Node' and csv2='Depth';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodedepth_sum' and csv1='Average' and csv2='Maximum';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodedepth_sum' and csv1='Depth' and csv2='Depth';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodedepth_sum' and csv1='Node' and csv2='Type';

	DELETE FROM temp_t_csv WHERE source ='rpt_nodeinflow_sum' and csv1='Node' and csv2='Inflow';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodeinflow_sum' and csv1='Maximum' and csv2='Maximum';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodeinflow_sum' and csv1='Lateral' and csv2='Total';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodeinflow_sum' and csv1='Inflow' and csv2='Inflow';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodeinflow_sum' and csv1='Node' and csv2='Type';

	DELETE FROM temp_t_csv WHERE source ='rpt_nodesurcharge_sum' and csv1='Node' and csv2='Surcharge';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodesurcharge_sum' and csv1='Surcharging' and csv2='occurs';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodesurcharge_sum' and csv1='Max.' and csv2='Height';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodesurcharge_sum' and csv1='Hours' and csv2='Above';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodesurcharge_sum' and csv1='Node' and csv2='Type';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodesurcharge_sum'  and csv1='nodes' or csv2='nodes';
	DELETE FROM temp_t_csv WHERE source ='rpt_condsurcharge_sum' and csv1='No' and csv2='nodes';

	DELETE FROM temp_t_csv WHERE source ='rpt_nodeflooding_sum' and csv1='Node' and csv2='Flooding';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodeflooding_sum' and csv1='Flooding' and csv2='refers';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodeflooding_sum' and csv1='Maximum' and csv2='Time';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodeflooding_sum' and csv1='Hours' and csv2='Rate';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodeflooding_sum' and csv1='Node' and csv2='Flooded';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodeflooding_sum' and csv1='Total' and csv2='Maximum';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodeflooding_sum' and csv1='nodes' or csv2='nodes';
	DELETE FROM temp_t_csv WHERE source ='rpt_nodeflooding_sum' and csv1='No' and csv2='nodes';

	DELETE FROM temp_t_csv WHERE source ='rpt_storagevol_sum' and csv1='Storage' and csv2='Volume';
	DELETE FROM temp_t_csv WHERE source ='rpt_storagevol_sum' and csv1='Average' and csv2='Avg';
	DELETE FROM temp_t_csv WHERE source ='rpt_storagevol_sum' and csv1='Volume' and csv2='Pcnt';
	DELETE FROM temp_t_csv WHERE source ='rpt_storagevol_sum' and csv1='Storage' and csv2='Unit';

	DELETE FROM temp_t_csv WHERE source ='rpt_storagevol_sum' and csv1='Storage' and csv2='Volume';
	DELETE FROM temp_t_csv WHERE source ='rpt_storagevol_sum' and csv1='Average' and csv2='Avg';
	DELETE FROM temp_t_csv WHERE source ='rpt_storagevol_sum' and csv1='Volume' and csv2='Pcnt';
	DELETE FROM temp_t_csv WHERE source ='rpt_storagevol_sum' and csv1='Storage' and csv2='Unit';

	DELETE FROM temp_t_csv WHERE source ='rpt_outfallflow_sum' and csv1='Outfall' and csv2='Loading';
	DELETE FROM temp_t_csv WHERE source ='rpt_outfallflow_sum' and csv1 like 'Flow%' and csv2 like 'Avg%';
	DELETE FROM temp_t_csv WHERE source ='rpt_outfallflow_sum' and csv1 like 'Freq%' and csv2 like 'Flow%';
	DELETE FROM temp_t_csv WHERE source ='rpt_outfallflow_sum' and csv1='Outfall' and csv2='Node';

	DELETE FROM temp_t_csv WHERE source ='rpt_arcflow_sum' and csv1='Link' and csv2='Flow';
	DELETE FROM temp_t_csv WHERE source ='rpt_arcflow_sum' and csv1='Maximum' and csv2='Occurrence';
	DELETE FROM temp_t_csv WHERE source ='rpt_arcflow_sum' and csv1='|Flow|' and csv2='Occurrence';
	DELETE FROM temp_t_csv WHERE source ='rpt_arcflow_sum' and csv1='Link' and csv2='Type';
	DELETE FROM temp_t_csv WHERE source ='rpt_arcflow_sum' and csv1='Maximum' and csv2='Time';

	DELETE FROM temp_t_csv WHERE source ='rpt_flowclass_sum' and csv1='Flow' and csv2='Classification';
	DELETE FROM temp_t_csv WHERE source ='rpt_flowclass_sum' and csv1='/Actual' and csv2='Up';
	DELETE FROM temp_t_csv WHERE source ='rpt_flowclass_sum' and csv1='Conduit' and csv2='Length';

	DELETE FROM temp_t_csv WHERE source ='rpt_condsurcharge_sum' and csv1='Conduit' and csv2='Surcharge';
	DELETE FROM temp_csv WHERE source ='rpt_condsurcharge_sum' and csv2='conduits';
	DELETE FROM temp_t_csv WHERE source ='rpt_condsurcharge_sum' and csv1='Hours' and csv2='Hours';
	DELETE FROM temp_t_csv WHERE source ='rpt_condsurcharge_sum' and csv1='Conduit' and csv2='Both';
	DELETE FROM temp_t_csv WHERE source ='rpt_condsurcharge_sum' and csv1='Pollutant';
	DELETE FROM temp_t_csv WHERE source ='rpt_condsurcharge_sum' and csv1='No' and csv2='conduits';
	DELETE FROM temp_t_csv WHERE id >= (SELECT id FROM temp_t_csv WHERE source ='rpt_condsurcharge_sum' and csv2='Pollutant'and csv3='Load')
				AND id <= (SELECT id FROM temp_t_csv WHERE source ='rpt_condsurcharge_sum' and csv1='Link'and csv2='kg');

	DELETE FROM temp_t_csv WHERE id >= (SELECT id FROM temp_t_csv WHERE source ='rpt_arcpollutant_sum' and csv2='Pollutant'and csv3='Load')
				AND id <= (SELECT id FROM temp_t_csv WHERE source ='rpt_arcpollutant_sum' and csv1='Link'and csv2='kg');

	DELETE FROM temp_t_csv WHERE source ='rpt_pumping_sum' and csv1='Pumping' and csv2='Summary';
	DELETE FROM temp_t_csv WHERE source ='rpt_pumping_sum' and csv1='Min' and csv2='Avg';
	DELETE FROM temp_t_csv WHERE source ='rpt_pumping_sum' and csv1='Percent' and csv2='Number';
	DELETE FROM temp_t_csv WHERE source ='rpt_pumping_sum' and csv1='Pump' and csv2='Utilized';



	FOR rpt_rec IN SELECT * FROM temp_t_csv order by id
	LOOP
		i = 0;
		IF rpt_rec.csv1 = 'WARNING' THEN
			type_aux = 'rpt_warning_summary';

		--ELSIF rpt_rec.csv1 = 'LID' THEN
			--type_aux = 'rpt_lidperformance_sum';
		ELSE
			type_aux = rpt_rec.source;
		END IF;

		IF type_aux='rpt_timestep_subcatchment' THEN

			IF rpt_rec.csv1 ='<<<' THEN
				v_id= rpt_rec.csv3;
			END IF;

			IF rpt_rec.csv1 IS NOT NULL AND rpt_rec.csv1='<<<' or rpt_rec.csv1='Date' or rpt_rec.csv1='mm/hr' THEN
			ELSE
				INSERT INTO rpt_subcatchment (result_id, subc_id, resultdate, resulttime, precip, losses, runoff) VALUES (v_result_id, v_id, rpt_rec.csv1, rpt_rec.csv2, rpt_rec.csv3::float, rpt_rec.csv4::float, rpt_rec.csv5::float);
			END IF;

		ELSIF type_aux='rpt_node' THEN

			IF rpt_rec.csv1 ='<<<' THEN
				v_id= rpt_rec.csv3;
			END IF;
			IF rpt_rec.csv1 IS NOT NULL AND rpt_rec.csv1='<<<' or rpt_rec.csv1='Date' or rpt_rec.csv1='Inflow' or  rpt_rec.csv2='Node' or rpt_rec.csv1='Node' THEN
			ELSE
				INSERT INTO rpt_node (result_id, node_id, resultdate, resulttime, flooding, depth, head, inflow)
				VALUES (v_result_id, v_id, rpt_rec.csv1, rpt_rec.csv2, rpt_rec.csv4::float, rpt_rec.csv5::float, rpt_rec.csv6::float, rpt_rec.csv3::float);
			END IF;

		ELSIF type_aux='rpt_arc' THEN

			IF rpt_rec.csv1 ='<<<' THEN
				v_id= rpt_rec.csv3;
			END IF;
			IF rpt_rec.csv1 IS NOT NULL AND rpt_rec.csv1='<<<' or rpt_rec.csv1='Date' or rpt_rec.csv1='Flow' or rpt_rec.csv1='Analysis' or rpt_rec.csv1='Total' or rpt_rec.csv1='Link'  THEN
			ELSE
				INSERT INTO rpt_arc (result_id, arc_id, resultdate, resulttime, flow, velocity, fullpercent) VALUES (v_result_id, v_id, rpt_rec.csv1, rpt_rec.csv2, rpt_rec.csv3::float, rpt_rec.csv4::float, rpt_rec.csv5::float);
			END IF;

		--there are still 3 empty fields on rpt_cat_results, where does the data come from? -- ok
		ELSIF type_aux='rpt_runoff_quant' then
			INSERT INTO rpt_runoff_quant(result_id) VALUES (v_result_id)
			ON CONFLICT (result_id) DO NOTHING;

			IF (rpt_rec.csv4 ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$') THEN
				UPDATE rpt_runoff_quant set total_prec=rpt_rec.csv4::numeric WHERE result_id=v_result_id AND rpt_rec.csv1='Total';
				UPDATE rpt_runoff_quant set evap_loss=rpt_rec.csv4::numeric WHERE result_id=v_result_id AND rpt_rec.csv1='Evaporation';
				UPDATE rpt_runoff_quant set infil_loss=rpt_rec.csv4::numeric WHERE result_id=v_result_id AND rpt_rec.csv1='Infiltration';
				UPDATE rpt_runoff_quant set surf_runof=rpt_rec.csv4::numeric WHERE result_id=v_result_id AND rpt_rec.csv1='Surface';
			END IF;
			IF (rpt_rec.csv5 ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$') THEN
				UPDATE rpt_runoff_quant set finals_sto=rpt_rec.csv5::numeric WHERE result_id=v_result_id AND rpt_rec.csv1='Final';
				UPDATE rpt_runoff_quant set cont_error=rpt_rec.csv5::numeric WHERE result_id=v_result_id AND rpt_rec.csv1='Continuity';
			END IF;

			INSERT INTO rpt_flowrouting_cont(result_id) VALUES (v_result_id)
			ON CONFLICT (result_id) DO NOTHING;

			IF rpt_rec.csv1 ='Dry'THEN UPDATE rpt_flowrouting_cont set dryw_inf=rpt_rec.csv5::numeric WHERE result_id=v_result_id; END IF;
			IF rpt_rec.csv1 ='Wet'THEN UPDATE rpt_flowrouting_cont set wetw_inf=rpt_rec.csv5::numeric WHERE result_id=v_result_id; END IF;
			IF rpt_rec.csv1 ='Groundwater'THEN UPDATE rpt_flowrouting_cont set ground_inf=rpt_rec.csv4::numeric WHERE result_id=v_result_id; END IF;
			IF rpt_rec.csv1 ='RDII'THEN UPDATE rpt_flowrouting_cont set rdii_inf=rpt_rec.csv4::numeric WHERE result_id=v_result_id ; END IF;
			IF concat(rpt_rec.csv1,' ',rpt_rec.csv2)='External Inflow' THEN UPDATE rpt_flowrouting_cont set ext_inf=rpt_rec.csv4::numeric WHERE result_id=v_result_id; END IF;
			IF concat(rpt_rec.csv1,' ',rpt_rec.csv2)='External Outflow' THEN UPDATE rpt_flowrouting_cont set ext_out=rpt_rec.csv4::numeric WHERE result_id=v_result_id; END IF;
			IF concat(rpt_rec.csv1,' ',rpt_rec.csv2)='Internal Outflow' THEN UPDATE rpt_flowrouting_cont set int_out=rpt_rec.csv4::numeric WHERE result_id=v_result_id; END IF;
			IF rpt_rec.csv1 ='Flooding'THEN UPDATE rpt_flowrouting_cont set int_out=rpt_rec.csv4::numeric WHERE result_id=v_result_id; END IF;
			IF rpt_rec.csv1 ='Initial'THEN UPDATE rpt_flowrouting_cont set initst_vol=rpt_rec.csv5::numeric WHERE result_id=v_result_id; END IF;
			IF rpt_rec.csv1 ='Final'THEN UPDATE rpt_flowrouting_cont set finst_vol=rpt_rec.csv5::numeric WHERE result_id=v_result_id; END IF;


		ELSIF type_aux='rpt_high_conterrors' AND rpt_rec.csv1 = 'Node' then
			INSERT INTO rpt_high_conterrors(result_id, text)
			VALUES (v_result_id,CONCAT(rpt_rec.csv1,' ',rpt_rec.csv2,' ',rpt_rec.csv3));

		ELSIF type_aux='rpt_timestep_critelem' AND (rpt_rec.csv1 = 'Node' or rpt_rec.csv1 = 'Link') then
			INSERT INTO rpt_timestep_critelem(result_id, text)
			VALUES (v_result_id,CONCAT(rpt_rec.csv1,' ',rpt_rec.csv2,' ',rpt_rec.csv3));

		ELSIF type_aux='rpt_high_flowinest_ind' AND rpt_rec.csv1 = 'Link' then
			INSERT INTO rpt_high_flowinest_ind(result_id, text)
			VALUES (v_result_id,CONCAT(rpt_rec.csv1,' ',rpt_rec.csv2,' ',rpt_rec.csv3));

		ELSIF type_aux='rpt_routing_timestep' AND (rpt_rec.csv4 = ':' OR rpt_rec.csv5 = ':') then
			INSERT INTO rpt_routing_timestep(result_id, text)
			VALUES (v_result_id,CONCAT(rpt_rec.csv1,' ',rpt_rec.csv2,' ',rpt_rec.csv3,' ',rpt_rec.csv4,' ',rpt_rec.csv5,' ',
			rpt_rec.csv6,' ',rpt_rec.csv7));

		ELSIF type_aux='rpt_subcatchrunoff_sum' then

			IF v_epaversion = '5.1' then

				INSERT INTO rpt_subcatchrunoff_sum(result_id, subc_id, tot_precip, tot_runon, tot_evap, tot_infil, tot_runoff, tot_runofl, peak_runof, runoff_coe, vxmax, vymax, depth, vel, vhmax)
				VALUES (v_result_id, rpt_rec.csv1, rpt_rec.csv2::numeric, rpt_rec.csv3::numeric, rpt_rec.csv4::numeric, rpt_rec.csv5::numeric, rpt_rec.csv8::numeric,
				rpt_rec.csv9::numeric,rpt_rec.csv10::numeric,rpt_rec.csv11::numeric,rpt_rec.csv12::numeric,rpt_rec.csv13::numeric,rpt_rec.csv14::numeric,
				rpt_rec.csv15::numeric,rpt_rec.csv16::numeric);
			ELSE
				INSERT INTO rpt_subcatchrunoff_sum(result_id, subc_id, tot_precip, tot_runon, tot_evap, tot_infil,tot_runoff, tot_runofl, peak_runof, runoff_coe, vxmax, vymax, depth, vel, vhmax)
				VALUES (v_result_id,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6::numeric,
				rpt_rec.csv7::numeric,rpt_rec.csv8::numeric,rpt_rec.csv9::numeric,rpt_rec.csv10::numeric,rpt_rec.csv11::numeric,rpt_rec.csv12::numeric,
				rpt_rec.csv13::numeric,rpt_rec.csv14::numeric);
			END IF;

		ELSIF type_aux='rpt_lidperformance_sum' then

			INSERT INTO rpt_lidperformance_sum(result_id, subc_id, lidco_id, tot_inflow, evap_loss, infil_loss, surf_outf, drain_outf, init_stor, final_stor, per_error)
			VALUES  (v_result_id,rpt_rec.csv1,rpt_rec.csv2,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6::numeric,rpt_rec.csv7::numeric,
			rpt_rec.csv8::numeric,rpt_rec.csv9::numeric,rpt_rec.csv10::numeric);

		ELSIF  type_aux='rpt_subcatchwashoff_sum' then


		ELSIF type_aux='rpt_arcpollutant_sum' then


		ELSIF type_aux='rpt_nodedepth_sum' then
			INSERT INTO rpt_nodedepth_sum(result_id, node_id, swnod_type, aver_depth, max_depth, max_hgl,time_days, time_hour)
			VALUES (v_result_id,rpt_rec.csv1,rpt_rec.csv2,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6,
			rpt_rec.csv7);

		ELSIF type_aux='rpt_nodeinflow_sum' then
			INSERT INTO rpt_nodeinflow_sum(result_id, node_id, swnod_type, max_latinf, max_totinf, time_days,
			time_hour, flow_balance_error, other_info)
			VALUES (v_result_id,rpt_rec.csv1,rpt_rec.csv2,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5,rpt_rec.csv6,
			rpt_rec.csv9::numeric,rpt_rec.csv10);

		ELSIF type_aux='rpt_nodesurcharge_sum' then
			INSERT INTO rpt_nodesurcharge_sum(result_id, node_id, swnod_type, hour_surch, max_height, min_depth)
			VALUES  (v_result_id,rpt_rec.csv1,rpt_rec.csv2,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric);

		ELSIF type_aux='rpt_nodeflooding_sum' then
			INSERT INTO rpt_nodeflooding_sum(result_id, node_id, hour_flood, max_rate, time_days, time_hour, tot_flood, max_ponded)
			VALUES  (v_result_id,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4,rpt_rec.csv5,rpt_rec.csv6::numeric,
			rpt_rec.csv7::numeric);

		ELSIF type_aux='rpt_outfallflow_sum' then

			INSERT INTO rpt_outfallflow_sum(result_id, node_id, flow_freq, avg_flow, max_flow, total_vol)
			VALUES  (v_result_id,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric);

		ELSIF type_aux='rpt_storagevol_sum' then

			IF v_epaversion = '5.1' then

				INSERT INTO rpt_storagevol_sum(result_id, node_id, aver_vol, avg_full, ei_loss, max_vol,
				max_full, time_days, time_hour, max_out)
				VALUES (v_result_id, rpt_rec.csv1, rpt_rec.csv2::numeric, rpt_rec.csv3::numeric, (rpt_rec.csv4::numeric + rpt_rec.csv5::numeric), rpt_rec.csv6::numeric,
				rpt_rec.csv7::numeric, rpt_rec.csv8, rpt_rec.csv9, rpt_rec.csv10::numeric);

			ELSE
				INSERT INTO rpt_storagevol_sum(result_id, node_id, aver_vol, avg_full, ei_loss, max_vol,
				max_full, time_days, time_hour, max_out)
				VALUES (v_result_id,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6::numeric,
				rpt_rec.csv7,rpt_rec.csv8,rpt_rec.csv9::numeric);

			END IF;

		ELSIF type_aux='rpt_arcflow_sum' then
			CASE WHEN rpt_rec.csv6='>50.00' THEN rpt_rec.csv6='50.00'; else end case;
			INSERT INTO rpt_arcflow_sum(result_id, arc_id, arc_type, max_flow, time_days, time_hour, max_veloc,
			mfull_flow, mfull_depth, max_shear, max_hr, max_slope, day_max, time_max, min_shear, day_min, time_min)
			VALUES (v_result_id,rpt_rec.csv1,rpt_rec.csv2,rpt_rec.csv3::numeric,rpt_rec.csv4,rpt_rec.csv5,rpt_rec.csv6::numeric,
			rpt_rec.csv7::numeric,rpt_rec.csv8::numeric,rpt_rec.csv9::numeric,rpt_rec.csv10::numeric,rpt_rec.csv11::numeric,rpt_rec.csv12,
			rpt_rec.csv13,rpt_rec.csv14::numeric,rpt_rec.csv15::numeric,rpt_rec.csv16::numeric);

		ELSIF type_aux='rpt_flowclass_sum' then
			INSERT INTO rpt_flowclass_sum(result_id, arc_id, length, dry, up_dry, down_dry, sub_crit,
			sub_crit_1, up_crit, down_crit, froud_numb, flow_chang)
			VALUES (v_result_id,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6::numeric,
			rpt_rec.csv7::numeric,rpt_rec.csv8::numeric,rpt_rec.csv9::numeric,rpt_rec.csv10::numeric,rpt_rec.csv11::numeric);

		ELSIF type_aux='rpt_condsurcharge_sum' THEN
			INSERT INTO rpt_condsurcharge_sum(result_id, arc_id, both_ends, upstream, dnstream, hour_nflow, hour_limit)
			VALUES (v_result_id,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6::numeric);

		ELSIF type_aux='rpt_pumping_sum' THEN
			INSERT INTO rpt_pumping_sum (result_id, arc_id, percent, num_startup, min_flow, avg_flow, max_flow, vol_ltr,
			powus_kwh, timoff_min, timoff_max)
			VALUES (v_result_id,rpt_rec.csv1, rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6::numeric,
			rpt_rec.csv7::numeric,rpt_rec.csv8::numeric,rpt_rec.csv9::numeric,rpt_rec.csv10::numeric);

		ELSIF type_aux LIKE 'rpt_warning_summary' THEN
			INSERT INTO rpt_warning_summary(result_id, warning_number, text)
			VALUES (v_result_id,concat(rpt_rec.csv1,' ',rpt_rec.csv2), concat(rpt_rec.csv3,' ',rpt_rec.csv4,'',rpt_rec.csv5,' ' ,rpt_rec.csv6,' ',rpt_rec.csv7,' ',
			rpt_rec.csv8,' ',rpt_rec.csv9,' ',rpt_rec.csv10,' ',rpt_rec.csv11,' ',rpt_rec.csv12,' ',rpt_rec.csv13,' ',rpt_rec.csv14,' ',rpt_rec.csv15));

		ELSIF type_aux LIKE 'rpt_control_actions_taken' THEN
			INSERT INTO rpt_warning_summary(result_id, warning_number, text)
			VALUES (v_result_id,concat(rpt_rec.csv1,' ',rpt_rec.csv2), concat(rpt_rec.csv3,' ',rpt_rec.csv4,'',rpt_rec.csv5,' ' ,rpt_rec.csv6,' ',rpt_rec.csv7,' ',
			rpt_rec.csv8,' ',rpt_rec.csv9,' ',rpt_rec.csv10,' ',rpt_rec.csv11,' ',rpt_rec.csv12,' ',rpt_rec.csv13,' ',rpt_rec.csv14,' ',rpt_rec.csv15));

		ELSIF type_aux='rpt_instability_index' THEN
			INSERT INTO rpt_instability_index(result_id, text)
   			VALUES (v_result_id,  concat(rpt_rec.csv1,' ',rpt_rec.csv2,'',rpt_rec.csv3));

		ELSIF type_aux='rpt_outfallload_sum' THEN
   			INSERT INTO rpt_outfallload_sum(result_id, poll_id, node_id, value)
			VALUES (v_result_id, rpt_rec.csv1,null,null);-- update poll_id, que es el value? compare rpt and table
		END IF;
	END LOOP;

	INSERT INTO audit_check_data (fid, error_message) VALUES (140, 'Rpt file import process -> Finished. Check your data');

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=140  order by id) row;
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
			'geometry',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
			'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript, ST_Transform(the_geom, 4326) as the_geom
		FROM  anl_node WHERE cur_user="current_user"() AND fid=140) row) features;

	v_result := COALESCE(v_result, '{}');
	v_result_point = v_result::text;

	--lines
	v_result = null;
	SELECT jsonb_build_object(
		'type', 'FeatureCollection',
		'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
	) INTO v_result
	FROM (
		SELECT jsonb_build_object(
			'type',       'Feature',
			'geometry',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
			'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, ST_Transform(the_geom, 4326) as the_geom
		FROM  anl_arc WHERE cur_user="current_user"() AND fid=140) row) features;

	v_result := COALESCE(v_result, '{}');
	v_result_line = v_result::text;

	--Control nulls
	v_version := COALESCE(v_version, '{}');
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');
	v_result_line := COALESCE(v_result_line, '{}');

	-- 	Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Import rpt done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||
		       '}}'||
	    '}')::json;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
