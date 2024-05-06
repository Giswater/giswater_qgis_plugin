/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2698

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_nodescouplecapacity(p_data json)  
RETURNS json AS 
$BODY$


/*
EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_nodescouplecapacity($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},
"data":{"parameters":{"step":1, "resultId":"p2"}}}$$)


PREVIOUS
- ResultId must exists on database with as well calibrated as posible
- First version of function must be called separately (five steps). 
- Advanced versions of function will incorporate recursive epanet calls using:
	- enabling recursive mode setting variable on giswater.config plugin file
	- configuring the defined function to be called (gw_fct_pg2epa_hydrant) on the config_param_user variable (inp_options_other_recursvive)
	
GENERAL ISSUES
- This function must be called 5 times
- It's supposed unlimited number of patterns
step 0: put in order result and check it. Identify water pipes bigger than 73.6 of dint. (parametrized) 
		Result nodes on that network are saved as x0 nodes
step 1: all x0 nodes are setted with demand=60m3/h and with individual patterns using any diferent pattern for each node (1000000, 0100000, 00100000) 
		Result nodes with EPANET result pressure => (1.5 parametrized) are saved as x1
step 2: all x1 nodes are setted with demand=120m3/h and with individual patterns using any diferent pattern for each node (1000000, 0100000, 00100000) 
		Result nodes with EPANET result pressure => 1.5 are saved as x2 nodes
		Result nodes in x1 and not in x2 are saved as x3 nodes
step 3: all x3 nodes are coupled two by two using proximity criteria (as node_1 and node_2) of arc. Both are setted with demand=60m3/h using pattern couple by couple
		Result nodes with EPANET result pressure => 1.5 are saved as x4 nodes
step 4: Materialze results on dattrib table
			
ars within x2 nodes are classified as DOUBLE HYDRANT (H1) arcs
ars within x4 nodes and not within x2 nodes (x3 nodes) and x2 are classified as COUPLED HDYRANT (H2) arcs
ars within x1 nodes and not withn x4 nodes are classified as SINGLE HYDRANT (H3) arcs
Rest of arcs are clasified as NON HYDRANT (H4) arcs

--fid: 155 (single demand)
--fid: 156 (double demand)
--fid: 157 (not double demand but single demand)
--fid: 158 (coupled demand)

*/

DECLARE
v_step text;
v_text text;
v_return text;
v_result text;
v_totalnodes integer;
v_rownode int8;
v_rowtemp int8;
v_rid integer;
v_node text;
v_count integer = 0;
v_field text;
v_value double precision;
v_querytext text;
v_units text;
v_epaunits double precision;
v_lpsdemand double precision;
v_mcaminpress double precision;
v_mindiameter double precision;
v_tsepnumber integer;
v integer[];
v_1 integer;
v_2	integer;
v_record record;
v_steps text;

BEGIN
	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- Getting user parameteres
	-- get input data
	v_step := (((p_data ->>'data')::json->>'parameters')::json->>'step');
	v_result := ((p_data ->>'data')::json->>'parameters')::json->>'resultId'::text;

	v_lpsdemand = (SELECT (value::json->>'nodesCoupleCapacity')::json->>'lpsDemand' FROM config_param_user WHERE parameter = 'inp_iterative_parameters');
	v_mcaminpress = (SELECT (value::json->>'nodesCoupleCapacity')::json->>'mcaMinPress' FROM config_param_user WHERE parameter = 'inp_iterative_parameters');
	v_mindiameter = (SELECT (value::json->>'nodesCoupleCapacity')::json->>'minDiameter' FROM config_param_user WHERE parameter = 'inp_iterative_parameters');

	v_units = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_units');

	EXECUTE 'SELECT (value::json->>'||quote_literal(v_units)||')::float FROM config_param_system WHERE parameter=''epa_units_factor'''
		INTO v_epaunits;

	raise notice 'minPress: % lpsdemand: % minDiameter: % units: % conversionUnitsFactor: %',v_mcaminpress, v_lpsdemand, v_mindiameter, v_units, v_epaunits;

	RAISE NOTICE 'Starting pg2epa hydrant analysis process.';

	IF v_step='1' THEN -- save inp user's values

		INSERT INTO config_param_user (value, parameter) VALUES ('temp_inp_times_pattern_timestep', 
		(SELECT value FROM config_param_user WHERE parameter='inp_times_pattern_timestep' AND cur_user=current_user)) ON CONFLICT DO NOTHING;
		INSERT INTO config_param_user (value, parameter) VALUES ('temp_inp_times_report_timestep', 
		(SELECT value config_param_user WHERE parameter='inp_times_report_timestep' AND cur_user=current_user)) ON CONFLICT DO NOTHING;
		INSERT INTO config_param_user (value, parameter) VALUES ('temp_inp_times_statistic', 
		(SELECT value config_param_user WHERE parameter='inp_times_statistic' AND cur_user=current_user)) ON CONFLICT DO NOTHING;
		INSERT INTO config_param_user (value, parameter) VALUES ('temp_inp_options_skipdemandpattern', 
		(SELECT value config_param_user WHERE parameter='inp_options_skipdemandpattern' AND cur_user=current_user)) ON CONFLICT DO NOTHING;
		INSERT INTO config_param_user (value, parameter) VALUES ('temp_inp_times_duration', 
		(SELECT value config_param_user WHERE parameter='inp_times_duration' AND cur_user=current_user)) ON CONFLICT DO NOTHING;	

	END IF;

	-- set epa times
	UPDATE config_param_user SET value=1 WHERE parameter='inp_times_pattern_timestep' AND cur_user=current_user;
	UPDATE config_param_user SET value=1 WHERE parameter='inp_times_report_timestep' AND cur_user=current_user;
	UPDATE config_param_user SET value='MINIMUM' WHERE parameter='inp_times_statistic' AND cur_user=current_user;

	
	IF v_step='1' THEN -- single hydrant (155)

		DELETE FROM temp_table WHERE fid = 155 AND user_name=current_user;
		DELETE FROM anl_node WHERE fid = 155 AND cur_user=current_user;
		DELETE FROM rpt_inp_pattern_value WHERE result_id=v_result AND user_name=current_user;

		-- set inp_options_skipdemandpattern to TRUE
		UPDATE config_param_user SET value=TRUE WHERE parameter='inp_options_skipdemandpattern' AND cur_user=current_user;
	
		-- Identifying x0 nodes (dint>73.6)
		INSERT INTO anl_node (fid, node_id)
		SELECT 155, node_1 FROM v_edit_inp_pipe JOIN cat_arc ON id=arccat_id WHERE dint>v_mindiameter
		UNION 
		SELECT 155, node_2 FROM v_edit_inp_pipe JOIN cat_arc ON id=arccat_id WHERE dint>v_mindiameter;

		-- set epa times
		v_tsepnumber = (SELECT count(*) FROM anl_node WHERE fid = 155 AND  cur_user=current_user);
		UPDATE config_param_user SET value=v_tsepnumber WHERE parameter='inp_times_duration' AND cur_user=current_user;

		-- TODO: check connected graf

		-- update demands
		UPDATE rpt_inp_node SET demand=0 , pattern_id=null WHERE result_id=v_result;
		UPDATE rpt_inp_node SET demand=v_lpsdemand*v_epaunits, pattern_id=node_id 
		WHERE result_id=v_result AND node_id IN (SELECT node_id FROM anl_node WHERE fid = 155 and cur_user=current_user);

		-- create patterns
		v_totalnodes =  (SELECT count(*) FROM anl_node WHERE fid = 155 and cur_user= current_user);
		v_rownode =  (SELECT id FROM anl_node WHERE fid = 155 and cur_user= current_user order by id LIMIT 1);

		-- loop to create the pattern (any patterns as any nodes)
		FOR v_x IN v_rownode..(v_rownode+v_totalnodes) LOOP
			INSERT INTO temp_table (fid, text_column)
			SELECT 155, array_agg(CASE WHEN id=v_x THEN 1 ELSE 0 END) FROM anl_node WHERE fid = 155 AND cur_user=current_user;
		END LOOP;

		v_rowtemp = (SELECT id FROM temp_table WHERE fid = 155 and user_name= current_user order by id LIMIT 1);

		-- loop to insert patterns created into rpt_inp_pattern_value
		FOR v_z IN v_rowtemp..(v_rowtemp+v_totalnodes) LOOP

			v_count = 0;
			
			-- get node_id
			v_node = (SELECT node_id FROM anl_node WHERE fid = 155 and cur_user= current_user AND id=v_rownode);
			v_rownode = v_rownode +1;
	
			EXIT WHEN v_node IS NULL;
						
			FOR v_x IN 1..v_totalnodes/17 LOOP

				SELECT array_agg(col) INTO v::integer[] FROM (SELECT unnest(text_column::integer[]) as col 
				FROM temp_table WHERE user_name=current_user AND fid = 155 AND id=v_z LIMIT 18 offset v_count)a;
				
				-- inserting row
				INSERT INTO rpt_inp_pattern_value (result_id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6,
				factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18)
				VALUES (v_result, v_node, v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9], v[10], v[11], v[12], v[13], v[14], v[15], v[16], v[17],	v[18]);
					
				v_count = v_count + 18;
					
				EXIT WHEN v[18] IS NULL;
								
			END LOOP;
			
		END LOOP;
		
	ELSIF v_step='2' THEN-- Identifying x2 nodes (double hydrant - 156)

		-- insert into anl_node only that nodes with positive result
		DELETE FROM anl_node WHERE fid = 156 AND cur_user=current_user;
		INSERT INTO anl_node (fid, node_id)
		SELECT 156, log_message::json->>'node_id' FROM audit_log_data WHERE (log_message::json->>'press')::float > v_mcaminpress 
		AND fid = 35 and feature_type='rpt_node' AND user_name=current_user
		AND log_message::json->>'node_id' IN (SELECT node_id FROM anl_node WHERE fid = 155 and cur_user=currnt_user ) group by 2;

		-- update demands
		UPDATE rpt_inp_node SET demand=0 , pattern_id=null WHERE result_id=v_result;
		UPDATE rpt_inp_node SET demand=2*v_lpsdemand*v_epaunits, pattern_id=node_id WHERE result_id=v_result AND node_id IN 
		(SELECT node_id FROM anl_node WHERE fid = 156 and cur_user=current_user);

		-- delete not used patterns
		DELETE FROM rpt_inp_pattern_value WHERE pattern_id NOT IN (SELECT node_id FROM anl_node 
		WHERE fid = 156 AND cur_user=current_user) AND user_name=current_user AND result_id=v_result;

		-- set epa times
		v_tsepnumber = (SELECT count(*) FROM anl_node WHERE fid = 156 AND  cur_user=current_user);
		UPDATE config_param_user SET value=v_tsepnumber WHERE parameter='inp_times_duration' AND cur_user=current_user;
			
	ELSIF v_step='3' THEN -- identify single but not double hydrant - 157

		DELETE FROM anl_node WHERE fid = 157 AND cur_user=current_user;
		INSERT INTO anl_node (fid, node_id)
		SELECT 157, log_message::json->>'node_id' FROM audit_log_data WHERE (log_message::json->>'press')::float < v_mcaminpress
		AND fid = 35 and feature_type='rpt_node' AND user_name=current_user
		 AND log_message::json->>'node_id' IN (SELECT node_id FROM anl_node WHERE fid = 156 and cur_user=current_user ) group by 2;

		-- reset demands
		UPDATE rpt_inp_node SET demand=0 , pattern_id=null WHERE result_id=v_result;

		-- update demands
		UPDATE rpt_inp_node SET demand=v_lpsdemand*v_epaunits, pattern_id=node_id WHERE result_id=v_result AND node_id IN 
		(SELECT node_id FROM anl_node WHERE fid = 157 and cur_user=current_user);

		-- delete patterns
		DELETE FROM rpt_inp_pattern_value WHERE user_name=current_user AND result_id=v_result;

		-- create pattern using the number of patterns according of nodes and the timestep of patterns according of arcs

		-- getting timesteps
		DELETE FROM anl_arc WHERE fid = 157 AND cur_user=current_user;
		INSERT INTO anl_arc (fid, arc_id, descript)
		SELECT 157, arc_id, concat ('{"tstep":',row_number() over (order by arc_id),', "node_1":"', node_1,'", "node_2":"',node_2,'"}') FROM (
		SELECT DISTINCT ON (arc.arc_id) arc.arc_id, node_1, node_2 FROM arc JOIN anl_node ON node_id=node_1 or node_id=node_2 
		WHERE fid = 157 AND cur_user=current_user AND node_id
		IN (SELECT node_id FROM anl_node WHERE fid = 157 and cur_user=current_user))a;

		-- getting patterns
		DELETE FROM temp_table WHERE fid = 157 AND user_name=current_user;
		INSERT INTO temp_table (fid, addparam, text_column)
		SELECT DISTINCT ON (node_id) 157, concat('{"node_id":"',node_id,'"}')::json, val FROM (
		SELECT array_agg(0)as val FROM anl_arc a WHERE a.fid = 157 AND a.cur_user=current_user
		) b, anl_node n JOIN arc ON node_id=node_1 OR node_id=node_2
		WHERE n.fid = 157 AND n.cur_user=current_user;

		v_totalnodes =  (SELECT count(*) FROM temp_table WHERE fid = 157 and user_name= current_user);

		--loop for the whole patterns
		FOR v_record IN SELECT * FROM temp_table WHERE fid = 157 and user_name= current_user
		LOOP

			v_count = 0;
			
			-- get node_id (pattern_id)
			v_node = (v_record.addparam->>'node_id');

			-- getting pattern values
			SELECT array_agg(col) INTO v::integer[] FROM (SELECT unnest(v_record.text_column::integer[]) as col FROM temp_table 
			WHERE user_name=current_user AND fid = 157 AND id=v_record.id) a;

			-- getting and setting tsteps with = 1
			FOR v_steps IN SELECT (descript::json->'tstep') FROM anl_arc WHERE fid = 157 AND cur_user=current_user
			AND ((descript::json->'node_1')::text=concat('"',v_node,'"') OR (descript::json->'node_2')::text=concat('"',v_node,'"'))
			LOOP
				raise notice ' steps %', v_steps;
				v[v_steps] = 1;
								
			END LOOP;

			-- inserting on rpt_inp_pattern_value table
			FOR v_x IN 1..v_totalnodes/17 LOOP

				INSERT INTO rpt_inp_pattern_value (result_id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6,
				factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18)
				VALUES (v_result, v_node, v[v_count+1], v[v_count+2], v[v_count+3], v[v_count+4], v[v_count+5], v[v_count+6], v[v_count+7], v[v_count+8], 
				v[v_count+9], v[v_count+10], v[v_count+11], v[v_count+12], v[v_count+13], v[v_count+14], v[v_count+15], 
				v[v_count+16], v[v_count+17], v[v_count+18]);

				EXIT WHEN v[v_count+18] IS NULL;				
				
				v_count = v_count + 18;
			END LOOP;
		END LOOP;

		-- set epa times
		v_tsepnumber = (SELECT count(*) FROM anl_arc WHERE fid = 157 AND  cur_user=current_user);
		UPDATE config_param_user SET value=v_tsepnumber WHERE parameter='inp_times_duration' AND cur_user=current_user;
								
	ELSIF v_step='last' THEN -- positive results for (coupled hydrant - 158)

		-- insert into anl_node only that nodes with positive result
		DELETE FROM anl_node WHERE fid = 158 AND cur_user=current_user;
		INSERT INTO anl_node (fid, node_id)
		SELECT 158, log_message::json->>'node_id' FROM audit_log_data WHERE (log_message::json->>'press')::float > v_mcaminpress
		AND fid = 35 and feature_type='rpt_node' AND user_name=current_user;
		
		-- delete all patterns
		DELETE FROM rpt_inp_pattern_value WHERE user_name=current_user AND result_id=v_result;

		-- restore user's epavalues	
		UPDATE config_param_user SET value= (SELECT value FROM config_param_user WHERE parameter='temp_inp_times_pattern_timestep' AND cur_user=current_user)
 		WHERE parameter='inp_times_pattern_timestep' AND cur_user=current_user;
		UPDATE config_param_user SET value= (SELECT value FROM config_param_user WHERE parameter='temp_inp_times_report_timestep' AND cur_user=current_user)
		WHERE parameter='inp_times_report_timestep' AND cur_user=current_user;
		UPDATE config_param_user SET value= (SELECT value FROM config_param_user WHERE parameter='temp_inp_times_statistic' AND cur_user=current_user)
		WHERE parameter='inp_times_statistic' AND cur_user=current_user;
		UPDATE config_param_user SET value= (SELECT value FROM config_param_user WHERE parameter='temp_inp_options_skipdemandpattern' AND cur_user=current_user)
		WHERE parameter='inp_options_skipdemandpattern' AND cur_user=current_user;
		UPDATE config_param_user SET value= (SELECT value FROM config_param_user WHERE parameter='temp_inp_times_duration' AND cur_user=current_user)
		WHERE parameter='inp_times_duration' AND cur_user=current_user;				

		DELETE FROM config_param_user WHERE parameter='temp_inp_times_pattern_timestep' AND cur_user=current_user;
		DELETE FROM config_param_user WHERE parameter='temp_inp_times_report_timestep' AND cur_user=current_user;
		DELETE FROM config_param_user WHERE parameter='temp_inp_times_statistic' AND cur_user=current_user;
		DELETE FROM config_param_user WHERE parameter='temp_inp_options_skipdemandpattern' AND cur_user=current_user;
		DELETE FROM config_param_user WHERE parameter='temp_inp_times_duration' AND cur_user=current_user;
		
	END IF;

	v_return = replace(v_return::text, '"message":{"level":1, "text":"Data quality analysis done succesfully"}', '"message":{"level":1, "text":"Hydrant analysis done succesfully"}')::json;

RETURN v_return;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;