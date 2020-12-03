/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2800

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_buildup_transport(p_result text)
RETURNS integer 
AS $BODY$

DECLARE

rec_node record;
v_count integer;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- transformn on the fly those inlets int tank or reservoir in function of how many sectors they has	
	FOR rec_node IN SELECT * FROM temp_node WHERE epa_type = 'INLET'
	LOOP
		-- get how many sectors are attached
		SELECT count(*) INTO v_count FROM (
				SELECT sector_id FROM temp_arc WHERE node_1 = rec_node.node_id 
				UNION 
				SELECT sector_id FROM temp_arc WHERE node_2 = rec_node.node_id)a;

		IF v_count = 1 THEN
			UPDATE temp_node SET epa_type  = 'RESERVOIR' WHERE node_id =  rec_node.node_id;
		ELSE
			UPDATE temp_node SET epa_type  = 'TANK' WHERE node_id =  rec_node.node_id;
		END IF;
	END LOOP;
	
	RETURN 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
