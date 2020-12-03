/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2456

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_dscenario (result_id_var character varying)  
RETURNS integer AS 
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_pg2epa_dscenario('calaf_diag')
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"data":{ "resultId":"test_bgeo_b1", "useNetworkGeom":"false"}}$$)

SELECT * FROM SCHEMA_NAME.temp_node WHERE node_id = 'VN257816';
*/

DECLARE
v_demandpriority integer; 
v_querytext text;
v_patternmethod integer;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2epa for filling demand scenario';

	v_demandpriority = (SELECT value::integer FROM config_param_user WHERE parameter='inp_options_dscenario_priority' AND cur_user=current_user);
	v_patternmethod = (SELECT value::integer FROM config_param_user WHERE parameter='inp_options_patternmethod' AND cur_user=current_user);

	-- building query text for those cases used on inp_demand with connecs
	v_querytext = '(SELECT exit_id, exit_type, pattern_id, sum(demand) as demand FROM inp_demand d JOIN v_edit_link USING (feature_id) 
			WHERE d.feature_type  = ''CONNEC'' AND dscenario_id IN (SELECT dscenario_id FROM selector_inp_demand WHERE cur_user = current_user) GROUP by 1,2,3)a';

	-- update demands
	IF v_demandpriority = 1 THEN -- Dscenario overwrites base demand
		UPDATE temp_node SET demand=a.demand FROM vi_demands a WHERE a.feature_id=temp_node.node_id AND a.feature_type = 'NODE';
		EXECUTE 'UPDATE temp_node SET demand=a.demand FROM '||v_querytext||' WHERE concat(''VN'',a.exit_id) = temp_node.node_id';

	ELSIF v_demandpriority = 2 THEN -- Ignore Dscenario when base demand exists
		UPDATE temp_node SET demand=a.demand FROM vi_demands a WHERE a.feature_id=temp_node.node_id AND temp_node.demand = 0 AND a.feature_type = 'NODE';
		EXECUTE 'UPDATE temp_node SET demand=a.demand FROM '||v_querytext||' WHERE temp_node.demand =0 AND concat(''VN'',a.exit_id) = temp_node.node_id';

	ELSIF v_demandpriority = 3 THEN -- Dscenario and base demand are joined, pattern is not modified
		UPDATE temp_node SET demand=temp_node.demand + a.demand FROM vi_demands a WHERE a.feature_id=temp_node.node_id AND a.feature_type = 'NODE';
		EXECUTE 'UPDATE temp_node SET demand=demand + a.demand FROM '||v_querytext||' WHERE concat(''VN'',a.exit_id) = temp_node.node_id';
	END IF;
	
	-- update patterns, ONLY IF inp_demand.pattern is not null. NOT ENABLED FOR HYDRO pattern methods
	IF v_patternmethod NOT IN (32, 34, 42, 44, 52, 54) THEN

		UPDATE temp_node SET pattern_id=a.pattern_id FROM
			(SELECT concat('VN',exit_id) as node_id, exit_type, pattern_id, sum(demand) as demand FROM vi_demands d JOIN v_edit_link l USING (feature_id) WHERE d.feature_type  = 'CONNEC' GROUP by 1,2,3
			union
			SELECT feature_id, feature_type, pattern_id, demand FROM vi_demands d WHERE d.feature_type = 'NODE')a
			WHERE a.node_id = temp_node.node_id AND a.pattern_id IS NOT NULL;

		-- move patterns from inp_pattern_value to rpt_pattern_value
		INSERT INTO rpt_inp_pattern_value (result_id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, 
			factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18)
		SELECT result_id_var, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, 
			factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18
			FROM inp_pattern_value WHERE pattern_id IN (SELECT DISTINCT pattern_id FROM temp_node) AND pattern_id NOT IN (SELECT DISTINCT pattern_id FROM rpt_inp_pattern_value WHERE result_id = result_id_var );
	END IF;

	-- set cero where null in order to prevent user's null values on demand table
	UPDATE temp_node SET demand=0 WHERE demand IS NULL;

	RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;