/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2530

DROP FUNCTION IF EXISTS  SCHEMA_NAME.gw_fct_utils_csv2pg_import_swmm_rpt(text, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_rpt2pg_import_rpt(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_rpt2pg_import_swmm_rpt($${"data":{"resultId":"r1"}}$$)

--fid:140

*/

DECLARE
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

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT giswater  INTO v_version FROM sys_version order by 1 desc limit 1;

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


	FOR rpt_rec IN SELECT * FROM temp_csv order by id
	LOOP

		IF (SELECT tablename FROM config_fprocess WHERE target=concat(rpt_rec.csv1,' ',rpt_rec.csv2) AND fid=v_fid) IS NOT NULL THEN
			type_aux=(SELECT tablename FROM config_fprocess WHERE target=concat(rpt_rec.csv1,' ',rpt_rec.csv2) AND fid=v_fid);
		ELSIF rpt_rec.csv1 = 'WARNING' THEN
			type_aux = 'rpt_warning_summary';
		END IF;	
						
		IF type_aux='rpt_cat_result' THEN
			UPDATE rpt_cat_result set flow_units=SUBSTRING(rpt_rec.csv4,1,3) WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Flow Units%' and result_id=v_result_id;
			UPDATE rpt_cat_result set rain_runof=SUBSTRING(rpt_rec.csv3,1,3) WHERE rpt_rec.csv1 ilike 'Rainfall/Runoff%' and result_id=v_result_id;
			UPDATE rpt_cat_result set snowmelt=SUBSTRING(rpt_rec.csv3,1,3) WHERE rpt_rec.csv1 ilike 'Snowmelt%' and result_id=v_result_id;
			UPDATE rpt_cat_result set groundw=SUBSTRING(rpt_rec.csv3,1,3) WHERE rpt_rec.csv1 ilike 'Groundwater%' and result_id=v_result_id;
			UPDATE rpt_cat_result set flow_rout=SUBSTRING(rpt_rec.csv4,1,3) WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2,' ',rpt_rec.csv3) ilike 'Flow Routing ...........%' and result_id=v_result_id;
			UPDATE rpt_cat_result set pond_all=SUBSTRING(rpt_rec.csv4,1,3) WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Ponding Allowed%' and result_id=v_result_id;
			UPDATE rpt_cat_result set water_q=SUBSTRING(rpt_rec.csv4,1,3) WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Water Quality%' and result_id=v_result_id;
			UPDATE rpt_cat_result set infil_m=rpt_rec.csv4 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Infiltration Method%' and result_id=v_result_id;
			UPDATE rpt_cat_result set flowrout_m=rpt_rec.csv5 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2,' ',rpt_rec.csv3) ilike 'Flow Routing Method%' and result_id=v_result_id;
			UPDATE rpt_cat_result set start_date=concat(rpt_rec.csv4,' ',rpt_rec.csv5) WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Starting Date%' and result_id=v_result_id;
			UPDATE rpt_cat_result set end_date=concat(rpt_rec.csv4,' ',rpt_rec.csv5) WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Ending Date%' and result_id=v_result_id;
			UPDATE rpt_cat_result set dry_days=rpt_rec.csv5::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Antecedent Dry%' and result_id=v_result_id;
			UPDATE rpt_cat_result set rep_tstep=rpt_rec.csv5 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Report Time%' and result_id=v_result_id;
			UPDATE rpt_cat_result set wet_tstep=rpt_rec.csv5 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Wet Time%' and result_id=v_result_id;
			UPDATE rpt_cat_result set dry_tstep=rpt_rec.csv5 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Dry Time%' and result_id=v_result_id;
			UPDATE rpt_cat_result set rout_tstep=concat(rpt_rec.csv5,rpt_rec.csv6) WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Routing Time%' and result_id=v_result_id;

		ELSIF type_aux='rpt_timestep_subcatchment' THEN

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
				INSERT INTO rpt_node (result_id, node_id, resultdate, resulttime, flooding, depth, head) VALUES (v_result_id, v_id, rpt_rec.csv1, rpt_rec.csv2, rpt_rec.csv3::float, rpt_rec.csv4::float, rpt_rec.csv5::float);
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
			IF v_result_id NOT IN (SELECT result_id FROM rpt_runoff_quant) then
				INSERT INTO rpt_runoff_quant(result_id) VALUES (v_result_id);
			END IF;
			
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

		ELSIF type_aux='rpt_flowrouting_cont' then 			 
			IF v_result_id NOT IN (SELECT result_id FROM rpt_flowrouting_cont) then
				INSERT INTO rpt_flowrouting_cont(result_id) VALUES (v_result_id);
			END IF;
					
			UPDATE rpt_flowrouting_cont set dryw_inf=rpt_rec.csv5::numeric WHERE result_id=v_result_id AND concat(rpt_rec.csv1,' ',rpt_rec.csv2)='Dry Weather';
			UPDATE rpt_flowrouting_cont set wetw_inf=rpt_rec.csv5::numeric WHERE result_id=v_result_id AND concat(rpt_rec.csv1,' ',rpt_rec.csv2)='Wet Weather';
			UPDATE rpt_flowrouting_cont set ground_inf=rpt_rec.csv4::numeric WHERE result_id=v_result_id AND concat(rpt_rec.csv1,' ',rpt_rec.csv2)='Groundwater Inflow';
			UPDATE rpt_flowrouting_cont set rdii_inf=rpt_rec.csv4::numeric WHERE result_id=v_result_id AND rpt_rec.csv1='RDII';
			UPDATE rpt_flowrouting_cont set ext_inf=rpt_rec.csv4::numeric WHERE result_id=v_result_id 
			AND concat(rpt_rec.csv1,' ',rpt_rec.csv2)='External Inflow';
			UPDATE rpt_flowrouting_cont set ext_out=rpt_rec.csv4::numeric WHERE result_id=v_result_id 
			AND concat(rpt_rec.csv1,' ',rpt_rec.csv2)='External Outflow';
			UPDATE rpt_flowrouting_cont set int_out=rpt_rec.csv4::numeric WHERE result_id=v_result_id 
			AND concat(rpt_rec.csv1,' ',rpt_rec.csv2)='Internal Outflow';
			UPDATE rpt_flowrouting_cont set stor_loss=rpt_rec.csv4::numeric WHERE result_id=v_result_id AND rpt_rec.csv1='Storage Losses';
			UPDATE rpt_flowrouting_cont set initst_vol=rpt_rec.csv5::numeric WHERE result_id=v_result_id AND rpt_rec.csv1='Initial';
			UPDATE rpt_flowrouting_cont set finst_vol=rpt_rec.csv5::numeric WHERE result_id=v_result_id AND rpt_rec.csv1='Final';
			UPDATE rpt_flowrouting_cont set cont_error=rpt_rec.csv5::numeric WHERE result_id=v_result_id AND rpt_rec.csv1='Continuity';
			
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

		ELSIF rpt_rec.csv1 IN (SELECT subc_id FROM inp_subcatchment) AND type_aux='rpt_subcathrunoff_sum' then 
			INSERT INTO rpt_subcathrunoff_sum(result_id, subc_id, tot_precip, tot_runon, tot_evap, tot_infil,tot_runoff, tot_runofl, peak_runof, runoff_coe, vxmax, vymax, depth, vel, vhmax) 
			VALUES (v_result_id,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6::numeric,
			rpt_rec.csv7::numeric,rpt_rec.csv8::numeric,rpt_rec.csv9::numeric,rpt_rec.csv10::numeric,rpt_rec.csv11::numeric,rpt_rec.csv12::numeric,
			rpt_rec.csv13::numeric,rpt_rec.csv14::numeric);

		ELSIF rpt_rec.csv1 IN (SELECT node_id FROM rpt_inp_node) AND type_aux='rpt_nodedepth_sum' then
			INSERT INTO rpt_nodedepth_sum(result_id, node_id, swnod_type, aver_depth, max_depth, max_hgl,time_days, time_hour)
			VALUES (v_result_id,rpt_rec.csv1,rpt_rec.csv2,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6,
			rpt_rec.csv7);
			
		ELSIF rpt_rec.csv1 IN (SELECT node_id FROM rpt_inp_node) AND type_aux='rpt_nodeinflow_sum' then
			INSERT INTO rpt_nodeinflow_sum(result_id, node_id, swnod_type, max_latinf, max_totinf, time_days, 
			time_hour, latinf_vol, totinf_vol, flow_balance_error, other_info)
			VALUES (v_result_id,rpt_rec.csv1,rpt_rec.csv2,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5,rpt_rec.csv6,
			rpt_rec.csv7::numeric,rpt_rec.csv8::numeric,rpt_rec.csv9::numeric,rpt_rec.csv10);

		ELSIF rpt_rec.csv1 IN (SELECT node_id FROM rpt_inp_node) AND type_aux='rpt_nodesurcharge_sum' then
			INSERT INTO rpt_nodesurcharge_sum(result_id, node_id, swnod_type, hour_surch, max_height, min_depth)
			VALUES  (v_result_id,rpt_rec.csv1,rpt_rec.csv2,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric);

		ELSIF rpt_rec.csv1 IN (SELECT node_id FROM rpt_inp_node) AND type_aux='rpt_nodeflooding_sum' then
			INSERT INTO rpt_nodeflooding_sum(result_id, node_id, hour_flood, max_rate, time_days, time_hour, tot_flood, max_ponded)
			VALUES  (v_result_id,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4,rpt_rec.csv5,rpt_rec.csv6::numeric,
			rpt_rec.csv7::numeric);

		ELSIF rpt_rec.csv1 IN (SELECT node_id FROM rpt_inp_node WHERE epa_type='OUTFALL') AND type_aux='rpt_outfallflow_sum' then
			INSERT INTO rpt_outfallflow_sum(result_id, node_id, flow_freq, avg_flow, max_flow, total_vol)
			VALUES  (v_result_id,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric);
		
		ELSIF rpt_rec.csv1 IN (SELECT node_id FROM rpt_inp_node WHERE epa_type='STORAGE') AND type_aux='rpt_storagevol_sum' then
			INSERT INTO rpt_storagevol_sum(result_id, node_id, aver_vol, avg_full, ei_loss, max_vol,
			max_full, time_days, time_hour, max_out)
			VALUES (v_result_id,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6::numeric,
			rpt_rec.csv7,rpt_rec.csv8,rpt_rec.csv9::numeric);

		ELSIF rpt_rec.csv1 IN (SELECT arc_id FROM rpt_inp_arc) AND type_aux='rpt_arcflow_sum' then
			CASE WHEN rpt_rec.csv6='>50.00' THEN rpt_rec.csv6='50.00'; else end case;
			INSERT INTO rpt_arcflow_sum(result_id, arc_id, arc_type, max_flow, time_days, time_hour, max_veloc, 
			mfull_flow, mfull_dept, max_shear, max_hr, max_slope, day_max, time_max, min_shear, day_min, time_min)
			VALUES (v_result_id,rpt_rec.csv1,rpt_rec.csv2,rpt_rec.csv3::numeric,rpt_rec.csv4,rpt_rec.csv5,rpt_rec.csv6::numeric,
			rpt_rec.csv7::numeric,rpt_rec.csv8::numeric,rpt_rec.csv9::numeric,rpt_rec.csv10::numeric,rpt_rec.csv11::numeric,rpt_rec.csv12,
			rpt_rec.csv13,rpt_rec.csv14::numeric,rpt_rec.csv15::numeric,rpt_rec.csv16::numeric);

		ELSIF rpt_rec.csv1 IN (SELECT arc_id FROM rpt_inp_arc) AND type_aux='rpt_flowclass_sum' then
			INSERT INTO rpt_flowclass_sum(result_id, arc_id, length, dry, up_dry, down_dry, sub_crit,
			sub_crit_1, up_crit, down_crit, froud_numb, flow_chang)
			VALUES (v_result_id,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6::numeric,
			rpt_rec.csv7::numeric,rpt_rec.csv8::numeric,rpt_rec.csv9::numeric,rpt_rec.csv10::numeric,rpt_rec.csv11::numeric);

		ELSIF rpt_rec.csv1 IN (SELECT arc_id FROM rpt_inp_arc) AND type_aux='rpt_condsurcharge_sum' THEN
			INSERT INTO rpt_condsurcharge_sum(result_id, arc_id, both_ends, upstream, dnstream, hour_nflow, hour_limit)
			VALUES (v_result_id,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,rpt_rec.csv6::numeric);

		ELSIF rpt_rec.csv1 IN (SELECT arc_id FROM rpt_inp_arc WHERE epa_type='PUMP') AND type_aux='rpt_pumping_sum' THEN
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
   		
		ELSIF rpt_rec.csv1 IN (SELECT poll_id FROM inp_pollutant) AND type_aux='rpt_outfallload_sum' THEN
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
  	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript, the_geom
  	FROM  anl_node WHERE cur_user="current_user"() AND fid=140) row) features;

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
  	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, the_geom
  	FROM  anl_arc WHERE cur_user="current_user"() AND fid=140) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result, '}'); 

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

	--  Exception handling
    EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;  
	RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_error_context) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	  
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
