/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_flow_exit(node_id_arg character varying) RETURNS int2 AS $BODY$
DECLARE
 
BEGIN

	-- Compute the tributary area using DFS
	PERFORM "SCHEMA_NAME".gw_fct_flow_exit_recursive(node_id_arg);

	RETURN 0;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;




CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_flow_exit_recursive(node_id_arg character varying) RETURNS void AS $BODY$
DECLARE
	exists_id character varying;
	rec_table record;

BEGIN

	-- Check if the node is already computed
	SELECT node_id INTO exists_id FROM "SCHEMA_NAME".anl_flow_exit_node WHERE node_id = node_id_arg;

	-- Compute proceed
	IF NOT FOUND THEN
	
		-- Update value
		INSERT INTO "SCHEMA_NAME".anl_flow_exit_node VALUES(node_id_arg);
		
		-- Loop for all the upstream nodes
		FOR rec_table IN SELECT arc_id, node_2 FROM "SCHEMA_NAME".arc WHERE node_1 = node_id_arg
		LOOP

			-- Insert into tables
			INSERT INTO "SCHEMA_NAME".anl_flow_exit_arc VALUES(rec_table.arc_id);

			-- Call recursive function weighting with the pipe capacity
			PERFORM "SCHEMA_NAME".gw_fct_flow_exit_recursive(rec_table.node_2);

		END LOOP;
	
	END IF;

	RETURN;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

