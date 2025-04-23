/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2800

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_buildup_transport(p_result text)
RETURNS integer
AS $BODY$

DECLARE

rec_node record;
v_count integer = 0;
v_count_diff integer = 0;
v_inletsector integer;
v_arcsector integer;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- transformn on the fly those inlets int tank or reservoir in function of how many sectors they has
	FOR rec_node IN SELECT * FROM temp_t_node WHERE epa_type = 'INLET'
	LOOP
		-- getting the sector of the inlet
		v_inletsector = (SELECT sector_id FROM node WHERE node_id =  rec_node.node_id);

		-- get how many sectors are attached
		SELECT count(*) INTO v_count FROM (
				SELECT sector_id FROM temp_t_arc WHERE node_1 = rec_node.node_id
				UNION
				SELECT sector_id FROM temp_t_arc WHERE node_2 = rec_node.node_id)a;

		SELECT count(*) INTO v_count_diff FROM (
				SELECT sector_id FROM temp_t_arc WHERE node_1 = rec_node.node_id
				UNION
				SELECT sector_id FROM temp_t_arc WHERE node_2 = rec_node.node_id) a WHERE sector_id <> v_inletsector;

		IF v_count_diff = 0 THEN -- reservoir
			UPDATE temp_t_node SET epa_type  = 'RESERVOIR' WHERE node_id =  rec_node.node_id;

		ELSIF v_count = v_count_diff THEN -- junction

			UPDATE temp_t_node SET epa_type  = 'JUNCTION', pattern_id = addparam::json->>'demand_pattern_id',
			demand = (addparam::json->>'demand')::numeric
			WHERE node_id =  rec_node.node_id;

		ELSE -- tank

			UPDATE temp_t_node SET epa_type  = 'TANK' WHERE node_id =  rec_node.node_id;

			UPDATE temp_t_node SET epa_type  = 'JUNCTION' WHERE node_id =  rec_node.node_id
			AND (addparam::json->>'diameter')::numeric=0 AND (addparam::json->>'maxlevel')::numeric=0;
		END IF;
	END LOOP;

	RETURN 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
