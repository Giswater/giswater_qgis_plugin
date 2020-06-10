/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2698

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_singlenodecapacity(p_data json)  
RETURNS json AS 
$BODY$

/*
EXAMPLE
SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_import_epanet_inp($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},
"data":{"step":0, "resultId":"test1"}$$)

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
      
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;
/*
	-- Getting user parameteres
	-- get input data
	v_step := (((p_data ->>'data')::json->>'parameters')::json->>'step')::boolean;
	v_result := ((p_data ->>'data')::json->>'parameters')::json->>'resultId'::text;

	
	RAISE NOTICE 'Starting pg2epa hydrant analysis process.';

	IF v_step=0 THEN
	
			-- Identifying x0 nodes (dint>73.6)
			INSERT INTO anl_node (fid, node_id)
			SELECT 90, node_1 FROM v_edit_inp_pipe JOIN cat_arc ON id=arccat_id WHERE dint>73.5
			UNION 
			SELECT 90, node_2 FROM v_edit_inp_pipe JOIN cat_arc ON id=arccat_id WHERE dint>73.5;
			
			-- TODO: check connected graf
			
			SET demand=60 else 0, pattern  WHERE (90)
			CREATE patterns
	
	
	ELSIF v_step=1 THEN
			
			-- Identifying x1 nodes (single hydrant)
			INSERT INTO anl_node (fid, node_id)
			SELECT 91, node_id FROM result_node WHERE pressure>1,5 and result_id=v_result;
						
			SET demand=120 else 0 WHERE (91);
			DELETE not used patterns;

			
	ELSIF v_step=2 THEN
	
			-- Identifying x2 nodes (double hydrant)
			INSERT INTO anl_node (fid, node_id)
			SELECT 92, node_id FROM result_node WHERE pressure>1,5 and result_id=v_result;
			
			-- Identifying x3 nodes (single but not double hydrant)
			INSERT INTO anl_node (fid, node_id)
			SELECT 93, node_id FROM result_node WHERE pressure<1,5 and result_id=v_result;
			
			SET demand=60 else 0 , pattern = same two/two WHERE (93)
			
			DELETE not used patterns;
								
	ELSIF v_step=3 THEN
	
			-- Identifying x4 nodes (coupled hydrant)
			INSERT INTO anl_node (fid, node_id)
			SELECT 94, node_id FROM result_node WHERE pressure>1,5 and result_id=v_result;
			
			
	ELSIF v_step=4 THEN
			
			-- upsert dattrib values (node)
			INSERT INTO dattrib
			SELECT 6, node_id, 'NODE', 'H1' FROM anl_node
			WHERE fid = 92
			ON CONFLICT DO UPDATE set idval='H1';
			
			INSERT INTO dattrib
			SELECT 6, node_id, 'NODE', 'H2' FROM anl_node
			WHERE fid = 94 AND NOT IN (SELECT feature_id FROM dattrib WHERE dattrib_type=6 AND feature_type='NODE')
			ON CONFLICT DO UPDATE set idval='H2';
			
			INSERT INTO dattrib
			SELECT 6, node_id, 'NODE', 'H3' FROM anl_node
			WHERE fid = 91 AND NOT IN (SELECT feature_id FROM dattrib WHERE dattrib_type=6 AND feature_type='NODE')
			ON CONFLICT DO UPDATE set idval='H3';
			
			INSERT INTO dattrib
			SELECT 6, node_id, 'NODE', 'H4', FROM v_edit_node
			WHERE node_id NOT IN (SELECT feature_id FROM dattrib WHERE dattrib_type=6 AND feature_type='NODE')
			ON CONFLICT DO UPDATE set idval='H4';
		
		
			-- upsert dattrib values (arc)
			-- TODO
			
	END IF;
	
	v_return = replace(v_return::text, '"message":{"level":1, "text":"Data quality analysis done succesfully"}', '"message":{"level":1, "text":"Hydrant analysis done succesfully"}')::json;
	*/
RETURN v_return;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;