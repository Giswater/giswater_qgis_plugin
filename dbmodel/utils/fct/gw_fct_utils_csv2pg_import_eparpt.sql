/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2520

CREATE OR REPLACE FUNCTION ws_inp.gw_fct_utils_csv2pg_import_eparpt(
    csv2pgcat_id_aux integer,
    label_aux text)
  RETURNS integer AS
$BODY$
DECLARE
	units_rec record;
	element_rec record;
	addfields_rec record;
	id_last int8;
	hour_aux text;
	type_aux text;
	rpt_rec record;
	project_type_aux varchar;

BEGIN

	--  Search path
	SET search_path = "ws_inp", public;

   SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
		
	-- import rpt csv
	IF project_type_aux='WS' THEN

		--remove data from with the same result_id
		FOR rpt_rec IN SELECT * FROM sys_csv2pg_config WHERE pg2csvcat_id=9 EXCEPT SELECT * FROM sys_csv2pg_config WHERE tablename='rpt_cat_result' LOOP
			EXECUTE 'DELETE FROM '||rpt_rec.tablename||' WHERE result_id='''||label_aux||''';';
		END LOOP;
	
		hour_aux=null;
					
		FOR rpt_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=9 order by id
		LOOP
			IF (SELECT tablename FROM sys_csv2pg_config WHERE header_text=concat(rpt_rec.csv1,' ',rpt_rec.csv2) AND pg2csvcat_id=9) 
			IS NOT NULL THEN
				type_aux=(SELECT tablename FROM sys_csv2pg_config WHERE header_text=concat(rpt_rec.csv1,' ',rpt_rec.csv2) AND pg2csvcat_id=9);
				hour_aux=rpt_rec.csv4;
			END IF;
					
			IF rpt_rec.csv1 IN (SELECT node_id FROM rpt_inp_node) AND hour_aux is not null and type_aux='rpt_node' THEN
				INSERT INTO rpt_node(node_id,result_id,"time",elevation,demand,head,press,other) 
				values (rpt_rec.csv1,label_aux,hour_aux,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,
				rpt_rec.csv5::numeric,rpt_rec.csv6);

			ELSIF rpt_rec.csv1 IN (SELECT arc_id FROM rpt_inp_arc) AND hour_aux is not null AND type_aux='rpt_arc' THEN
				INSERT INTO rpt_arc(arc_id,result_id,"time",length, diameter, flow, vel, headloss,setting,reaction, ffactor,other)
				values (rpt_rec.csv1,label_aux,hour_aux,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,
				rpt_rec.csv5::numeric,rpt_rec.csv6::numeric,rpt_rec.csv7::numeric,rpt_rec.csv8::numeric,rpt_rec.csv9::numeric, rpt_rec.csv10);
				
			ELSIF rpt_rec.csv1 IN (SELECT concat(node_id,'_n2a') FROM man_pump) AND type_aux='rpt_energy_usage' and rpt_rec.csv7 is not null THEN
				INSERT INTO rpt_energy_usage(result_id, nodarc_id, usage_fact, avg_effic, kwhr_mgal, avg_kw, peak_kw, cost_day)
				VALUES (label_aux,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,
				rpt_rec.csv6::numeric,rpt_rec.csv7::numeric);

			ELSIF type_aux='rpt_hydraulic_status' and rpt_rec.csv1 ilike '%:%' then
				INSERT INTO rpt_hydraulic_status(result_id, "time", text)
				VALUES (label_aux, rpt_rec.csv1,concat(rpt_rec.csv2,' ',rpt_rec.csv3,' ',rpt_rec.csv4,' ',rpt_rec.csv5,' ' ,rpt_rec.csv6,' ',
				rpt_rec.csv7,' ',rpt_rec.csv8,' ',rpt_rec.csv9));

			ELSIF type_aux='rpt_cat_result' THEN
				UPDATE rpt_cat_result set n_junction=rpt_rec.csv4::integer WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Number Junctions%' and result_id=label_aux;
				UPDATE rpt_cat_result set n_reservoir=rpt_rec.csv4::integer WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Number Reservoirs%' and result_id=label_aux;
				UPDATE rpt_cat_result set n_tank=rpt_rec.csv5::integer WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Number Tanks%' and result_id=label_aux;
				UPDATE rpt_cat_result set n_pipe=rpt_rec.csv5::integer WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Number Pipes%' and result_id=label_aux;
				UPDATE rpt_cat_result set n_pump=rpt_rec.csv5::integer WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Number Pumps%' and result_id=label_aux;
				UPDATE rpt_cat_result set n_valve=rpt_rec.csv5::integer WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Number Valves%' and result_id=label_aux;
				UPDATE rpt_cat_result set head_form=rpt_rec.csv4 WHERE rpt_rec.csv1 ilike 'Headloss%' and result_id=label_aux;
				UPDATE rpt_cat_result set hydra_time=concat(rpt_rec.csv4,rpt_rec.csv5) WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Hydraulic Timestep%' and result_id=label_aux;
				UPDATE rpt_cat_result set hydra_acc=rpt_rec.csv4::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Hydraulic Accuracy%' and result_id=label_aux;
				UPDATE rpt_cat_result set st_ch_freq=rpt_rec.csv5::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Status Check%' and result_id=label_aux;
				UPDATE rpt_cat_result set max_tr_ch=rpt_rec.csv5::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Maximum Check%' and result_id=label_aux;
				UPDATE rpt_cat_result set dam_li_thr=rpt_rec.csv5::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Damping Threshold%' and result_id=label_aux;
				UPDATE rpt_cat_result set max_trials=rpt_rec.csv4::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2,' ',rpt_rec.csv3) ilike 'Maximum Trials ...................%' and result_id=label_aux;
				UPDATE rpt_cat_result set q_analysis=rpt_rec.csv4 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Quality Analysis%' and result_id=label_aux;
				UPDATE rpt_cat_result set spec_grav=rpt_rec.csv4::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Specific Gravity%' and result_id=label_aux;
				UPDATE rpt_cat_result set r_kin_visc=rpt_rec.csv5::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Relative Kinematic%' and result_id=label_aux;
				UPDATE rpt_cat_result set r_che_diff=rpt_rec.csv5::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Relative Chemical%' and result_id=label_aux;
				UPDATE rpt_cat_result set dem_multi=rpt_rec.csv4::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Demand Multiplier%' and result_id=label_aux;
				UPDATE rpt_cat_result set total_dura=concat(rpt_rec.csv4,rpt_rec.csv5) WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Total Duration%' and result_id=label_aux;
			END IF;
		END LOOP;
		
	ELSIF project_type_aux='UD' THEN

		hour_aux=null;
		
		--remove data from with the same result_id
		FOR rpt_rec IN SELECT * FROM sys_csv2pg_config WHERE pg2csvcat_id=9 EXCEPT SELECT * FROM sys_csv2pg_config WHERE tablename='rpt_cat_result' 
		LOOP
			EXECUTE 'DELETE FROM '||rpt_rec.tablename||' WHERE result_id='''||label_aux||''';';
		END LOOP;
	
		FOR rpt_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=9 order by id
		LOOP
			IF (SELECT tablename FROM sys_csv2pg_config WHERE header_text=concat(rpt_rec.csv1,' ',rpt_rec.csv2) AND pg2csvcat_id=9) IS NOT NULL THEN
				type_aux=(SELECT tablename FROM sys_csv2pg_config WHERE header_text=concat(rpt_rec.csv1,' ',rpt_rec.csv2) AND pg2csvcat_id=9);
			END IF;	
							
			IF type_aux='rpt_cat_result' THEN
				UPDATE rpt_cat_result set flow_units=rpt_rec.csv4 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Flow Units%' and result_id=label_aux;
				UPDATE rpt_cat_result set rain_runof=rpt_rec.csv3 WHERE rpt_rec.csv1 ilike 'Rainfall/Runoff%' and result_id=label_aux;
				UPDATE rpt_cat_result set snowmelt=rpt_rec.csv3 WHERE rpt_rec.csv1 ilike 'Snowmelt%' and result_id=label_aux;
				UPDATE rpt_cat_result set groundw=rpt_rec.csv3 WHERE rpt_rec.csv1 ilike 'Groundwater%' and result_id=label_aux;
				UPDATE rpt_cat_result set flow_rout=rpt_rec.csv4 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2,' ',rpt_rec.csv3) ilike 'Flow Routing ...........%' and result_id=label_aux;
				UPDATE rpt_cat_result set pond_all=rpt_rec.csv4 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Ponding Allowed%' and result_id=label_aux;
				UPDATE rpt_cat_result set water_q=rpt_rec.csv4 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Water Quality%' and result_id=label_aux;
				UPDATE rpt_cat_result set infil_m=rpt_rec.csv4 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Infiltration Method%' and result_id=label_aux;
				UPDATE rpt_cat_result set flowrout_m=rpt_rec.csv5 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2,' ',rpt_rec.csv3) ilike 'Flow Routing Method%' and result_id=label_aux;
				UPDATE rpt_cat_result set start_date=concat(rpt_rec.csv4,' ',rpt_rec.csv5) WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Starting Date%' and result_id=label_aux;
				UPDATE rpt_cat_result set end_date=concat(rpt_rec.csv4,' ',rpt_rec.csv5) WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Ending Date%' and result_id=label_aux;
				UPDATE rpt_cat_result set dry_days=rpt_rec.csv5::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Antecedent Dry%' and result_id=label_aux;
				UPDATE rpt_cat_result set rep_tstep=rpt_rec.csv5 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Report Time%' and result_id=label_aux;
				UPDATE rpt_cat_result set wet_tstep=rpt_rec.csv5 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Wet Time%' and result_id=label_aux;
				UPDATE rpt_cat_result set dry_tstep=rpt_rec.csv5 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Dry Time%' and result_id=label_aux;
				UPDATE rpt_cat_result set rout_tstep=concat(rpt_rec.csv5,rpt_rec.csv6) WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Routing Time%' and result_id=label_aux;
				
			--there are still 3 empty fields on rpt_cat_results, where does the data come from? -- ok
			ELSIF type_aux='rpt_runoff_quant' then 					
				IF label_aux NOT IN (SELECT result_id FROM rpt_runoff_quant) then
					INSERT INTO rpt_runoff_quant(result_id) VALUES (label_aux);
				END IF;
	
				UPDATE rpt_runoff_quant set total_prec=rpt_rec.csv4::numeric WHERE result_id=label_aux AND rpt_rec.csv1='Total';
				UPDATE rpt_runoff_quant set evap_loss=rpt_rec.csv4::numeric WHERE result_id=label_aux AND rpt_rec.csv1='Evaporation';
				UPDATE rpt_runoff_quant set infil_loss=rpt_rec.csv4::numeric WHERE result_id=label_aux AND rpt_rec.csv1='Infiltration';
				UPDATE rpt_runoff_quant set surf_runof=rpt_rec.csv4::numeric WHERE result_id=label_aux AND rpt_rec.csv1='Surface';
				UPDATE rpt_runoff_quant set finals_sto=rpt_rec.csv5::numeric WHERE result_id=label_aux AND rpt_rec.csv1='Final';
				UPDATE rpt_runoff_quant set cont_error=rpt_rec.csv5::numeric WHERE result_id=label_aux AND rpt_rec.csv1='Continuity';

			ELSIF type_aux='rpt_flowrouting_cont' then 			 
				IF label_aux NOT IN (SELECT result_id FROM rpt_flowrouting_cont) then
					INSERT INTO rpt_flowrouting_cont(result_id) VALUES (label_aux);
				END IF;
						
				UPDATE rpt_flowrouting_cont set dryw_inf=rpt_rec.csv5::numeric WHERE result_id=label_aux AND concat(rpt_rec.csv1,' ',rpt_rec.csv2)='Dry Weather';
				UPDATE rpt_flowrouting_cont set wetw_inf=rpt_rec.csv5::numeric WHERE result_id=label_aux AND concat(rpt_rec.csv1,' ',rpt_rec.csv2)='Wet Weather';
				UPDATE rpt_flowrouting_cont set ground_inf=rpt_rec.csv4::numeric WHERE result_id=label_aux AND concat(rpt_rec.csv1,' ',rpt_rec.csv2)='Groundwater Inflow';
				UPDATE rpt_flowrouting_cont set rdii_inf=rpt_rec.csv4::numeric WHERE result_id=label_aux AND rpt_rec.csv1='RDII';
				UPDATE rpt_flowrouting_cont set ext_inf=rpt_rec.csv4::numeric WHERE result_id=label_aux 
					AND concat(rpt_rec.csv1,' ',rpt_rec.csv2)='External Inflow';
				UPDATE rpt_flowrouting_cont set ext_out=rpt_rec.csv4::numeric WHERE result_id=label_aux 
					AND concat(rpt_rec.csv1,' ',rpt_rec.csv2)='External Outflow';
				UPDATE rpt_flowrouting_cont set int_out=rpt_rec.csv4::numeric WHERE result_id=label_aux 
					AND concat(rpt_rec.csv1,' ',rpt_rec.csv2)='Internal Outflow';
				UPDATE rpt_flowrouting_cont set stor_loss=rpt_rec.csv4::numeric WHERE result_id=label_aux AND rpt_rec.csv1='Storage Losses';
				UPDATE rpt_flowrouting_cont set initst_vol=rpt_rec.csv5::numeric WHERE result_id=label_aux AND rpt_rec.csv1='Initial';
				UPDATE rpt_flowrouting_cont set finst_vol=rpt_rec.csv5::numeric WHERE result_id=label_aux AND rpt_rec.csv1='Final';
				UPDATE rpt_flowrouting_cont set cont_error=rpt_rec.csv5::numeric WHERE result_id=label_aux AND rpt_rec.csv1='Continuity';
				ELSIF type_aux='rpt_high_conterrors' AND rpt_rec.csv1 = 'Node' then 
				INSERT INTO rpt_high_conterrors(result_id, text)
				VALUES (label_aux,CONCAT(rpt_rec.csv1,' ',rpt_rec.csv2,' ',rpt_rec.csv3));
								
			ELSIF type_aux='rpt_timestep_critelem' AND (rpt_rec.csv1 = 'Node' or rpt_rec.csv1 = 'Link') then 
				INSERT INTO rpt_timestep_critelem(result_id, text)
				VALUES (label_aux,CONCAT(rpt_rec.csv1,' ',rpt_rec.csv2,' ',rpt_rec.csv3));

			ELSIF type_aux='rpt_high_flowinest_ind' AND rpt_rec.csv1 = 'Link' then 
				INSERT INTO rpt_high_flowinest_ind(result_id, text)
				VALUES (label_aux,CONCAT(rpt_rec.csv1,' ',rpt_rec.csv2,' ',rpt_rec.csv3));

			ELSIF type_aux='rpt_routing_timestep' AND (rpt_rec.csv4 = ':' OR rpt_rec.csv5 = ':') then 
				INSERT INTO rpt_routing_timestep(result_id, text)
				VALUES (label_aux,CONCAT(rpt_rec.csv1,' ',rpt_rec.csv2,' ',rpt_rec.csv3,' ',rpt_rec.csv4,' ',rpt_rec.csv5,' ',
				rpt_rec.csv6,' ',rpt_rec.csv7));

			ELSIF rpt_rec.csv1 IN (SELECT subc_id FROM subcatchment) AND type_aux='rpt_subcathrunoff_sum' then 
				INSERT INTO rpt_subcathrunoff_sum(result_id, subc_id, tot_precip, tot_runon, tot_evap, tot_infil,tot_runoff, tot_runofl, peak_runof, runoff_coe, vxmax, vymax, depth, vel, vhmax) 
				VALUES (label_aux,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6::numeric,
				rpt_rec.csv7::numeric,rpt_rec.csv8::numeric,rpt_rec.csv9::numeric,rpt_rec.csv10::numeric,rpt_rec.csv11::numeric,rpt_rec.csv12::numeric,
				rpt_rec.csv13::numeric,rpt_rec.csv14::numeric);

			ELSIF rpt_rec.csv1 IN (SELECT node_id FROM rpt_inp_node) AND type_aux='rpt_nodedepth_sum' then
				INSERT INTO rpt_nodedepth_sum(result_id, node_id, swnod_type, aver_depth, max_depth, max_hgl,time_days, time_hour)
				VALUES (label_aux,rpt_rec.csv1,rpt_rec.csv2,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6,
				rpt_rec.csv7);

			ELSIF rpt_rec.csv1 IN (SELECT node_id FROM rpt_inp_node) AND type_aux='rpt_nodeinflow_sum' then
				INSERT INTO rpt_nodeinflow_sum(result_id, node_id, swnod_type, max_latinf, max_totinf, time_days, 
				time_hour, latinf_vol, totinf_vol, flow_balance_error, other_info)
				VALUES (label_aux,rpt_rec.csv1,rpt_rec.csv2,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5,rpt_rec.csv6,
				rpt_rec.csv7::numeric,rpt_rec.csv8::numeric,rpt_rec.csv9::numeric,rpt_rec.csv10);

			ELSIF rpt_rec.csv1 IN (SELECT node_id FROM rpt_inp_node) AND type_aux='rpt_nodesurcharge_sum' then
				INSERT INTO rpt_nodesurcharge_sum(result_id, node_id, swnod_type, hour_surch, max_height, min_depth)
				VALUES  (label_aux,rpt_rec.csv1,rpt_rec.csv2,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric);

			ELSIF rpt_rec.csv1 IN (SELECT node_id FROM rpt_inp_node) AND type_aux='rpt_nodeflooding_sum' then
				INSERT INTO rpt_nodeflooding_sum(result_id, node_id, hour_flood, max_rate, time_days, time_hour, tot_flood, max_ponded)
				VALUES  (label_aux,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4,rpt_rec.csv5,rpt_rec.csv6::numeric,
				rpt_rec.csv7::numeric);

			ELSIF rpt_rec.csv1 IN (SELECT node_id FROM rpt_inp_node WHERE epa_type='OUTFALL') AND type_aux='rpt_outfallflow_sum' then
				INSERT INTO rpt_outfallflow_sum(result_id, node_id, flow_freq, avg_flow, max_flow, total_vol)
				VALUES  (label_aux,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric);

			ELSIF rpt_rec.csv1 IN (SELECT node_id FROM rpt_inp_node WHERE epa_type='STORAGE') AND type_aux='rpt_storagevol_sum' then
				INSERT INTO rpt_storagevol_sum(result_id, node_id, aver_vol, avg_full, ei_loss, max_vol,
				max_full, time_days, time_hour, max_out)
				VALUES (label_aux,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6::numeric,
				rpt_rec.csv7,rpt_rec.csv8,rpt_rec.csv9::numeric);

			ELSIF rpt_rec.csv1 IN (SELECT arc_id FROM rpt_inp_arc) AND type_aux='rpt_arcflow_sum' then
				CASE WHEN rpt_rec.csv6='>50.00' THEN rpt_rec.csv6='50.00'; else end case;
				INSERT INTO rpt_arcflow_sum(result_id, arc_id, arc_type, max_flow, time_days, time_hour, max_veloc, 
				mfull_flow, mfull_dept, max_shear, max_hr, max_slope, day_max, time_max, min_shear, day_min, time_min)
				VALUES (label_aux,rpt_rec.csv1,rpt_rec.csv2,rpt_rec.csv3::numeric,rpt_rec.csv4,rpt_rec.csv5,rpt_rec.csv6::numeric,
				rpt_rec.csv7::numeric,rpt_rec.csv8::numeric,rpt_rec.csv9::numeric,rpt_rec.csv10::numeric,rpt_rec.csv11::numeric,rpt_rec.csv12,
				rpt_rec.csv13,rpt_rec.csv14::numeric,rpt_rec.csv15::numeric,rpt_rec.csv16::numeric);

			ELSIF rpt_rec.csv1 IN (SELECT arc_id FROM rpt_inp_arc) AND type_aux='rpt_flowclass_sum' then
				INSERT INTO rpt_flowclass_sum(result_id, arc_id, length, dry, up_dry, down_dry, sub_crit,
				sub_crit_1, up_crit, down_crit, froud_numb, flow_chang)
				VALUES (label_aux,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6::numeric,
				rpt_rec.csv7::numeric,rpt_rec.csv8::numeric,rpt_rec.csv9::numeric,rpt_rec.csv10::numeric,rpt_rec.csv11::numeric);

			ELSIF rpt_rec.csv1 IN (SELECT arc_id FROM rpt_inp_arc) AND type_aux='rpt_condsurcharge_sum' THEN
				INSERT INTO rpt_condsurcharge_sum(result_id, arc_id, both_ends, upstream, dnstream, hour_nflow, hour_limit)
				VALUES (label_aux,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6::numeric);

			ELSIF rpt_rec.csv1 IN (SELECT arc_id FROM rpt_inp_arc WHERE epa_type='PUMP') AND type_aux='rpt_pumping_sum' THEN
				INSERT INTO rpt_pumping_sum (result_id, arc_id, percent, num_startup, min_flow, avg_flow, max_flow, vol_ltr,
				powus_kwh, timoff_min, timoff_max)
				VALUES (label_aux,rpt_rec.csv1, rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6::numeric,
				rpt_rec.csv7::numeric,rpt_rec.csv8::numeric,rpt_rec.csv9::numeric,rpt_rec.csv10::numeric);

			ELSIF rpt_rec.csv1='WARNING' THEN
				INSERT INTO ud_sample.rpt_warning_summary(result_id,warning_number, text)
				VALUES (label_aux,concat(rpt_rec.csv1,' ',rpt_rec.csv2), concat(rpt_rec.csv3,' ',rpt_rec.csv4,'',rpt_rec.csv5,' ' ,rpt_rec.csv6,' ',rpt_rec.csv7,' ',
				rpt_rec.csv8,' ',rpt_rec.csv9,' ',rpt_rec.csv10,' ',rpt_rec.csv11,' ',rpt_rec.csv12,' ',rpt_rec.csv13,' ',rpt_rec.csv14,' ',rpt_rec.csv15));
    				
			ELSIF type_aux='rpt_instability_index' THEN
				INSERT INTO ud_sample.rpt_instability_index(result_id, text)
    			VALUES (label_aux,  concat(rpt_rec.csv1,' ',rpt_rec.csv2,'',rpt_rec.csv3));
    		
			ELSIF rpt_rec.csv1 IN (SELECT poll_id FROM inp_pollutant) AND type_aux='rpt_outfallload_sum' THEN
    			INSERT INTO rpt_outfallload_sum(result_id, poll_id, node_id, value)
				VALUES (label_aux, rpt_rec.csv1,null,null);-- update poll_id, que es el value? compare rpt and table
						
			END IF;
		END LOOP;
	END IF;
	
RETURN 0;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
ALTER FUNCTION ws_inp.gw_fct_utils_csv2pg(integer, text)
  OWNER TO postgres;
