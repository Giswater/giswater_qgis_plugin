/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2520

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_epanet_rpt(text, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_epanet_rpt(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_import_epanet_rpt($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},
"data":{"parameters":{"resultId":"r1"}}}$$)
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
	v_csv2pgcat_id integer = 11;
	v_result 	json;
	v_result_info 	json;
	v_result_point	json;
	v_result_line 	json;
	v_version	json;
	v_path 		text;
	v_result_id	text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT giswater INTO v_version FROM version order by 1 desc limit 1;

	-- get input data
	v_result_id := (((p_data ->>'data')::json->>'parameters')::json->>'resultId')::text;
	v_path := ((p_data ->>'data')::json->>'parameters')::json->>'path'::text;

	-- delete previous data on log table
	DELETE FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=40;
	-- use the copy function of postgres to import from file in case of file must be provided as a parameter

	IF v_path IS NOT NULL THEN
		DELETE FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=v_csv2pgcat_id;
		EXECUTE 'SELECT gw_fct_utils_csv2pg_import_temp_data('||quote_literal(v_csv2pgcat_id)||','||quote_literal(v_path)||' )';	
	END IF;

	UPDATE temp_csv2pg SET csv2pgcat_id=v_csv2pgcat_id WHERE csv2pgcat_id IS NULL AND user_name=current_user;
	
	--remove data from with the same result_id
	FOR rpt_rec IN SELECT tablename FROM sys_csv2pg_config WHERE pg2csvcat_id=v_csv2pgcat_id EXCEPT SELECT tablename FROM sys_csv2pg_config WHERE tablename='rpt_cat_result' LOOP
		EXECUTE 'DELETE FROM '||rpt_rec.tablename||' WHERE result_id='''||v_result_id||''';';
	END LOOP;
	
	hour_aux=null;
					
	FOR rpt_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=v_csv2pgcat_id order by id
	LOOP
		IF (SELECT tablename FROM sys_csv2pg_config WHERE target=concat(rpt_rec.csv1,' ',rpt_rec.csv2) AND pg2csvcat_id=v_csv2pgcat_id) IS NOT NULL THEN
			type_aux=(SELECT tablename FROM sys_csv2pg_config WHERE target=concat(rpt_rec.csv1,' ',rpt_rec.csv2) AND pg2csvcat_id=v_csv2pgcat_id);
			hour_aux=rpt_rec.csv4;
		END IF;
					
		IF rpt_rec.csv1 IN (SELECT node_id FROM rpt_inp_node) AND hour_aux is not null and type_aux='rpt_node' THEN
			INSERT INTO rpt_node(node_id,result_id,"time",elevation,demand,head,press,other) 
			values (rpt_rec.csv1,v_result_id,hour_aux,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,
			rpt_rec.csv5::numeric,rpt_rec.csv6);

		ELSIF rpt_rec.csv1 IN (SELECT arc_id FROM rpt_inp_arc) AND hour_aux is not null AND type_aux='rpt_arc' THEN
			INSERT INTO rpt_arc(arc_id,result_id,"time",length, diameter, flow, vel, headloss,setting,reaction, ffactor,other)
			values (rpt_rec.csv1,v_result_id,hour_aux,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,
			rpt_rec.csv5::numeric,rpt_rec.csv6::numeric,rpt_rec.csv7::numeric,rpt_rec.csv8::numeric,rpt_rec.csv9::numeric, rpt_rec.csv10);
				
		ELSIF rpt_rec.csv1 IN (SELECT concat(node_id,'_n2a') FROM man_pump) AND type_aux='rpt_energy_usage' and rpt_rec.csv7 is not null THEN
			INSERT INTO rpt_energy_usage(result_id, nodarc_id, usage_fact, avg_effic, kwhr_mgal, avg_kw, peak_kw, cost_day)
			VALUES (v_result_id,rpt_rec.csv1,rpt_rec.csv2::numeric,rpt_rec.csv3::numeric,rpt_rec.csv4::numeric,rpt_rec.csv5::numeric,
			rpt_rec.csv6::numeric,rpt_rec.csv7::numeric);

		ELSIF type_aux='rpt_hydraulic_status' and rpt_rec.csv1 ilike '%:%' then
			INSERT INTO rpt_hydraulic_status(result_id, "time", text)
			VALUES (v_result_id, rpt_rec.csv1,concat(rpt_rec.csv2,' ',rpt_rec.csv3,' ',rpt_rec.csv4,' ',rpt_rec.csv5,' ' ,rpt_rec.csv6,' ',
			rpt_rec.csv7,' ',rpt_rec.csv8,' ',rpt_rec.csv9));

		ELSIF type_aux='rpt_cat_result' THEN
			UPDATE rpt_cat_result set n_junction=rpt_rec.csv4::integer WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Number Junctions%' and result_id=v_result_id;
			UPDATE rpt_cat_result set n_reservoir=rpt_rec.csv4::integer WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Number Reservoirs%' and result_id=v_result_id;
			UPDATE rpt_cat_result set n_tank=rpt_rec.csv5::integer WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Number Tanks%' and result_id=v_result_id;
			UPDATE rpt_cat_result set n_pipe=rpt_rec.csv5::integer WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Number Pipes%' and result_id=v_result_id;
			UPDATE rpt_cat_result set n_pump=rpt_rec.csv5::integer WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Number Pumps%' and result_id=v_result_id;
			UPDATE rpt_cat_result set n_valve=rpt_rec.csv5::integer WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Number Valves%' and result_id=v_result_id;
			UPDATE rpt_cat_result set head_form=rpt_rec.csv4 WHERE rpt_rec.csv1 ilike 'Headloss%' and result_id=v_result_id;
			UPDATE rpt_cat_result set hydra_time=concat(rpt_rec.csv4,rpt_rec.csv5) WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Hydraulic Timestep%' and result_id=v_result_id;
			UPDATE rpt_cat_result set hydra_acc=rpt_rec.csv4::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Hydraulic Accuracy%' and result_id=v_result_id;
			UPDATE rpt_cat_result set st_ch_freq=rpt_rec.csv5::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Status Check%' and result_id=v_result_id;
			UPDATE rpt_cat_result set max_tr_ch=rpt_rec.csv5::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Maximum Check%' and result_id=v_result_id;
			UPDATE rpt_cat_result set dam_li_thr=rpt_rec.csv5::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv3) ilike 'Damping Threshold%' and result_id=v_result_id;
			UPDATE rpt_cat_result set max_trials=rpt_rec.csv4::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2,' ',rpt_rec.csv3) ilike 'Maximum Trials ...................%' and result_id=v_result_id;
			UPDATE rpt_cat_result set q_analysis=rpt_rec.csv4 WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Quality Analysis%' and result_id=v_result_id;
			UPDATE rpt_cat_result set spec_grav=rpt_rec.csv4::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Specific Gravity%' and result_id=v_result_id;
			UPDATE rpt_cat_result set r_kin_visc=rpt_rec.csv5::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Relative Kinematic%' and result_id=v_result_id;
			UPDATE rpt_cat_result set r_che_diff=rpt_rec.csv5::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Relative Chemical%' and result_id=v_result_id;
			UPDATE rpt_cat_result set dem_multi=rpt_rec.csv4::numeric WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Demand Multiplier%' and result_id=v_result_id;
			UPDATE rpt_cat_result set total_dura=concat(rpt_rec.csv4,rpt_rec.csv5) WHERE concat(rpt_rec.csv1,' ',rpt_rec.csv2) ilike 'Total Duration%' and result_id=v_result_id;
		END IF;
	END LOOP;
		
	PERFORM gw_fct_rpt2pg(v_result_id);

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=40  order by id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	--points
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript, the_geom FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=40) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "values":',v_result, '}');

	--lines
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, the_geom FROM anl_arc WHERE cur_user="current_user"() AND (fprocesscat_id=40)) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "values":',v_result, '}');


	--Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 	
	
	v_result_line = concat ('{"geometryType":"LineString", "values":',v_result, '}');


	--Control nulls
	v_version := COALESCE(v_version, '{}'); 
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 	

-- 	Return
	RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "version":"'||v_version||'"'||
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
