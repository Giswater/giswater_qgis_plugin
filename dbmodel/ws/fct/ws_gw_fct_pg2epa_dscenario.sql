/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2456

--DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_dscenario(character varying );
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_dscenario (result_id_var character varying)  
RETURNS integer AS 
$BODY$

DECLARE
v_demandpriority integer; 
v_querytext text;
v_patternmethod integer;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2epa for filling demand scenario';

	v_demandpriority = (SELECT value::integer FROM config_param_user WHERE parameter='inp_options_demandpriority' AND cur_user=current_user);
	v_demandpriority = (SELECT value::integer FROM config_param_user WHERE parameter='inp_options_patternmethod' AND cur_user=current_user);

	-- building query text for those cases used on inp_demand with connecs
	v_querytext = '(SELECT exit_id, exit_type, pattern_id, sum(demand) as demand FROM inp_demand d JOIN v_edit_link USING (feature_id) WHERE feature_type  = ''CONNEC'' GROUP by 1,2,3)a';

	-- update demands
	IF v_patternmethod = 1 THEN -- Dscenario overwrites base demand
		UPDATE temp_node SET demand=a.demand FROM vi_demands a WHERE a.feature_id=temp_node.node_id AND feature_type = 'NODE';
		EXECUTE 'UPDATE temp_node SET demand=a.demand FROM '||v_querytext||' WHERE a.exit_id = temp_node.node_id';

	ELSIF v_demandpriority = 2 THEN -- Ignore Dscenario when base demand exists
		UPDATE temp_node SET demand=a.demand FROM vi_demands a WHERE a.feature_id=temp_node.node_id AND temp_node.demand = 0 AND feature_type = 'NODE';
		EXECUTE 'UPDATE temp_node SET demand=a.demand FROM '||v_querytext||' WHERE temp_node.demand =0 AND a.exit_id = temp_node.node_id';

	ELSIF v_demandpriority = 3 THEN -- Dscenario and base demand are joined, pattern is not modified
		UPDATE temp_node SET demand=temp_node.demand + a.demand FROM vi_demands a WHERE a.feature_id=temp_node.node_id AND feature_type = 'NODE';
		EXECUTE 'UPDATE temp_node SET demand=demand + a.demand FROM '||v_querytext||' WHERE a.exit_id = temp_node.node_id';
	END IF;
	
	-- update patterns, ONLY IF inp_demand.pattern is not null. NOT ENABLED FOR HYDRO pattern methods
	IF v_patternmethod NOT IN (32, 34, 42, 44, 52, 54) THEN

		UPDATE temp_node SET pattern_id=a.pattern_id FROM
			(SELECT concat('VN',exit_id) as node_id, exit_type, pattern_id, sum(demand) as demand FROM vi_demands d JOIN v_edit_link l USING (feature_id) WHERE d.feature_type  = 'CONNEC' GROUP by 1,2,3
			union
			SELECT feature_id, feature_type, pattern_id, demand FROM vi_demands d WHERE d.feature_type = 'NODE')a
			WHERE a.node_id = temp_node.node_id AND a.pattern_id IS NOT NULL;
	END IF;

	-- set cero where null in orther to prevent user's null values on demand table
	UPDATE temp_node SET demand=0 WHERE demand IS NULL;

	RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;