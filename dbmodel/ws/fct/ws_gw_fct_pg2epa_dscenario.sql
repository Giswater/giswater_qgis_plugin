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

	IF (SELECT count(*) FROM selector_inp_demand WHERE cur_user = current_user) > 0 THEN

		v_demandpriority = (SELECT value::integer FROM config_param_user WHERE parameter='inp_options_dscenario_priority' AND cur_user=current_user);

		-- update demands
		IF v_demandpriority = 1 THEN -- Dscenario overwrites base demand
			-- EPANET stantdard 
			
		ELSIF v_demandpriority = 2 THEN -- Dscenario and base demand are joined

			-- moving to temp_node in order to do not lose base demand (because EPANET does)
			INSERT INTO temp_demand (feature_id, demand, pattern_id)
			SELECT DISTINCT ON (feature_id) feature_id, n.demand, n.pattern_id 
			FROM temp_node n, inp_demand d WHERE n.node_id = d.feature_id AND n.demand > 0 AND dscenario_id IN (SELECT dscenario_id FROM selector_inp_demand where cur_user=current_user);
		END IF;
		
		-- move patterns used demands scenario table
		INSERT INTO rpt_inp_pattern_value (result_id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, 
			factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18)
		SELECT  result_id_var, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, 
			factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
			from inp_pattern_value p 
			WHERE 
			pattern_id IN (SELECT distinct (pattern_id) FROM inp_demand d, selector_inp_demand s WHERE cur_user = current_user AND d.dscenario_id = s.dscenario_id) AND 
			pattern_id NOT IN (SELECT distinct (pattern_id) FROM temp_node WHERE pattern_id IS NOT NULL)
			order by pattern_id, id;	

		-- set cero where null in order to prevent user's null values on demand table
		UPDATE temp_node SET demand=0 WHERE demand IS NULL;

	END IF;

	RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;