/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2698
--FPROCESSCAT = 55 (single demand)
--FPROCESSCAT = 56 (double demand)
--FPROCESSCAT = 57 (not double demand but single demand)
--FPROCESSCAT = 58 (coupled demand)



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_nodescouplecapacity(p_data json)  
RETURNS json AS 
$BODY$


/*
EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_nodescouplecapacity($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},
"data":{"parameters":{"step":1, "resultId":"test1"}}}$$)


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
*/

DECLARE
	v_step integer;
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
	v_epaunits	double precision;
	v_lpsdemand	double precision;
	v_mcaminpress 	double precision;
	v_mindiameter 	double precision;

      
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- Getting user parameteres
	-- get input data
	v_step := (((p_data ->>'data')::json->>'parameters')::json->>'step');
	v_result := ((p_data ->>'data')::json->>'parameters')::json->>'resultId'::text;

	v_lpsdemand = (SELECT (value::json->>'nodesCoupleCapacity')::json->>'lpsDemand') FROM config_param_user WHERE parameter = 'inp_iterative_param');
	v_mcaminpress = (SELECT (value::json->>'nodesCoupleCapacity')::json->>'mcaMinPress' FROM config_param_user WHERE parameter = 'inp_iterative_param');
	v_mindiameter = (SELECT (value::json->>'nodesCoupleCapacity')::json->>'minDiameter' FROM config_param_user WHERE parameter = 'inp_iterative_param');
	
	EXECUTE 'SELECT (value::json->>'||quote_literal(v_units)||')::float FROM config_param_system WHERE parameter=''epa_units_factor'''
		INTO v_epaunits;

	RAISE NOTICE 'Starting pg2epa hydrant analysis process.';

/*
	IF v_step=1 THEN -- single hydrant (55)

		DELETE FROM temp_table WHERE fprocesscat_id=55 AND user_name=current_user;
		DELETE FROM anl_node WHERE fprocesscat_id=55 AND cur_user=current_user;
		DELETE FROM rpt_inp_pattern_value WHERE result_id=v_result AND user_name=current_user;

		-- set inp_options_skipdemandpattern to TRUE
		UPDATE config_param_user SET value=TRUE WHERE parameter='inp_options_skipdemandpattern' AND cur_user=current_user;
	
		-- Identifying x0 nodes (dint>73.6)
		INSERT INTO anl_node (fprocesscat_id, node_id)
		SELECT 55, node_1 FROM v_edit_inp_pipe JOIN cat_arc ON id=arccat_id WHERE dint>v_mindiameter
		UNION 
		SELECT 55, node_2 FROM v_edit_inp_pipe JOIN cat_arc ON id=arccat_id WHERE dint>v_mindiameter;
		
		-- TODO: check connected graf

		-- update demands
		UPDATE rpt_inp_node SET demand=0 , pattern_id=null WHERE result_id=v_result;
		UPDATE rpt_inp_node SET demand=v_lpsdemand*v_epaunits, pattern_id=node_id WHERE result_id=v_result AND node_id IN (SELECT node_id FROM anl_node WHERE fprocesscat_id=55 and cur_user=current_user);

		-- create patterns
		v_totalnodes =  (SELECT count(*) FROM anl_node WHERE fprocesscat_id = 55 and cur_user= current_user);
		v_rownode =  (SELECT id FROM anl_node WHERE fprocesscat_id = 55 and cur_user= current_user order by id LIMIT 1);

		RAISE NOTICE ' %', v_totalnodes;

		-- loop to create the pattern (any patterns as any nodes)
		FOR v_x IN v_rownode..(v_rownode+v_totalnodes) LOOP
			INSERT INTO temp_table (fprocesscat_id, text_column)
			SELECT 55, array_agg(CASE WHEN id=v_x THEN 1 ELSE 0 END) FROM anl_node WHERE fprocesscat_id = 55;
		END LOOP;

		v_rowtemp = (SELECT id FROM temp_table WHERE fprocesscat_id = 55 and user_name= current_user order by id LIMIT 1);

		-- loop to insert patterns created into rpt_inp_pattern_value
		FOR v_z IN v_rowtemp..(v_rowtemp+v_totalnodes) LOOP

			RAISE NOTICE 'v_z % ',v_z;
			v_count = 0;
			
			-- get node_id
			v_node = (SELECT node_id FROM anl_node WHERE fprocesscat_id = 55 and cur_user= current_user AND id=v_rownode);
			v_rownode = v_rownode +1;
	
			EXIT WHEN v_node IS NULL;
						
			FOR v_x IN 1..v_totalnodes/19 LOOP

				--RAISE NOTICE 'v_x % ',v_x;

				-- inserting row
				INSERT INTO rpt_inp_pattern_value (result_id, pattern_id) VALUES (v_result, v_node) RETURNING id INTO v_rid;
			
				FOR v_y IN 1..18 LOOP

					--RAISE NOTICE ' v_y % ', v_y;
			
					v_count = v_count +1;
					
					-- updating row column by column
					v_field = concat('factor_',v_y);
					v_value = (SELECT val[v_count] FROM (SELECT text_column::integer[] as val FROM temp_table WHERE user_name=current_user AND fprocesscat_id=55 AND id=v_z)a);
			
					v_querytext = 'UPDATE rpt_inp_pattern_value SET '||quote_ident(v_field)||'='||v_value||' WHERE id='||(v_rid);

					EXIT WHEN v_value IS NULL;

					--RAISE NOTICE 'v_querytext % v_count % v_field % v_value % ', v_querytext, v_count, v_field, v_value;
					
					EXECUTE v_querytext;
				END LOOP;

				EXIT WHEN v_value IS NULL;
								
			END LOOP;
			
		END LOOP;
		
	ELSIF v_step=2 THEN-- Identifying x2 nodes (double hydrant - 56)

		-- insert into anl_node only that nodes with positive result
		DELETE FROM anl_node WHERE fprocesscat_id=56 AND cur_user=current_user;
		INSERT INTO anl_node (fprocesscat_id, node_id)
		SELECT 56, node_id FROM rpt_node WHERE press > v_mcaminpress and result_id=v_result AND node_id IN (SELECT node_id FROM anl_node WHERE fprocesscat_id=55 and cur_user=current_user ) group by 2;

		-- update demands
		UPDATE rpt_inp_node SET demand=0 , pattern_id=null WHERE result_id=v_result;
		UPDATE rpt_inp_node SET demand=2*v_lpsdemand*v_epaunits, pattern_id=node_id WHERE result_id=v_result AND node_id IN (SELECT node_id FROM anl_node WHERE fprocesscat_id=56 and cur_user=current_user);

		-- delete not used patterns
		DELETE FROM rpt_inp_pattern_value WHERE pattern_id NOT IN (SELECT anl_node FROM anl_node WHERE fprocesscat_id=56 AND cur_user=current_user) AND user_name=current_user AND result_id=v_result;

			
	ELSIF v_step=3 THEN -- identify single but not double hydrant - 57

		DELETE FROM anl_node WHERE fprocesscat_id=57 AND cur_user=current_user;
		INSERT INTO anl_node (fprocesscat_id, node_id)
		SELECT 57, node_id FROM rpt_node WHERE press < v_mcaminpress and result_id=v_result AND node_id IN (SELECT node_id FROM anl_node WHERE fprocesscat_id=56 and cur_user=current_user ) group by 2;

		-- update demands
		UPDATE rpt_inp_node SET demand=0 , pattern_id=null WHERE result_id=v_result;

		-- TODO: pattern must be assigned coupled (dos a dos)
		UPDATE rpt_inp_node SET demand=16,666*v_epaunits, pattern_id=arc_id WHERE result_id=v_result AND node_id IN (SELECT node_id FROM anl_node WHERE fprocesscat_id=57 and cur_user=current_user);
		
		-- delete not used patterns
		DELETE FROM rpt_inp_pattern_value WHERE pattern_id NOT IN (SELECT anl_node FROM anl_node WHERE fprocesscat_id=56 AND cur_user=current_user) AND user_name=current_user AND result_id=v_result;

								
	ELSIF v_step=4 THEN -- Identifying x4 nodes (coupled hydrant - 58)

		-- insert into anl_node only that nodes with positive result
		DELETE FROM anl_node WHERE fprocesscat_id=58 AND cur_user=current_user;
		INSERT INTO anl_node (fprocesscat_id, node_id)
		SELECT 58, node_id FROM rpt_node WHERE press > v_mcaminpress and result_id=v_result AND node_id IN (SELECT node_id FROM anl_node WHERE fprocesscat_id=57 and cur_user=current_user ) group by 2;

		-- delete all patterns
		DELETE FROM rpt_inp_pattern_value WHERE user_name=current_user AND result_id=v_result;
			
	ELSIF v_step=5 THEN
			
			-- upsert dattrib values (node)
			INSERT INTO dattrib
			SELECT 6, node_id, 'NODE', 'H1' FROM anl_node
			WHERE fprocesscat_id=92
			ON CONFLICT DO UPDATE set idval='H1';
			
			INSERT INTO dattrib
			SELECT 6, node_id, 'NODE', 'H2' FROM anl_node
			WHERE fprocesscat_id=94 AND NOT IN (SELECT feature_id FROM dattrib WHERE dattrib_type=6 AND feature_type='NODE')
			ON CONFLICT DO UPDATE set idval='H2';
			
			INSERT INTO dattrib
			SELECT 6, node_id, 'NODE', 'H3' FROM anl_node
			WHERE fprocesscat_id=91 AND NOT IN (SELECT feature_id FROM dattrib WHERE dattrib_type=6 AND feature_type='NODE')
			ON CONFLICT DO UPDATE set idval='H3';
			
			INSERT INTO dattrib
			SELECT 6, node_id, 'NODE', 'H4', FROM v_edit_node
			WHERE node_id NOT IN (SELECT feature_id FROM dattrib WHERE dattrib_type=6 AND feature_type='NODE')
			ON CONFLICT DO UPDATE set idval='H4';

			-- restore skip demand pattern
			UPDATE config_param_user SET value=FALSE WHERE parameter='inp_options_skipdemandpattern' AND cur_user=current_user;
		
		
			-- upsert dattrib values (arc)
			-- TODO

	END IF;

*/
	
	v_return = replace(v_return::text, '"message":{"priority":1, "text":"Data quality analysis done succesfully"}', '"message":{"priority":1, "text":"Hydrant analysis done succesfully"}')::json;

RETURN v_return;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;