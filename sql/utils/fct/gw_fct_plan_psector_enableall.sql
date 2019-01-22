/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_plan_psector_enableall(p_enable boolean , p_psector_id integer) 
RETURNS void AS $$
DECLARE


BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

	IF p_enable IS TRUE THEN
		UPDATE plan_psector_x_arc SET state=1 WHERE state=0 AND psector_id=p_psector_id;
		UPDATE plan_psector_x_node SET state=1 WHERE state=0 AND psector_id=p_psector_id;
	ELSE 
		UPDATE plan_psector_x_arc SET state=0 FROM arc a WHERE a.arc_id=plan_psector_x_arc.arc_id AND a.state=1 AND psector_id=p_psector_id;
		UPDATE plan_psector_x_node SET state=0 FROM node n WHERE n.node_id=plan_psector_x_node.node_id AND n.state=1 AND psector_id=p_psector_id;
	END IF;
	
    RETURN;
        
END;
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 