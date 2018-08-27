/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_anl_node_proximity(p_table_id varchar, p_tolerance float)
  RETURNS void AS
$BODY$
DECLARE
    rec_node record;
    rec record;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Get data from config table
    SELECT * INTO rec FROM config; 

    -- Reset values
    DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=32;
		
		
    -- Computing process
    EXECUTE 'INSERT INTO anl_node (node_id, nodecat_id, state, node_id_aux, nodecat_id_aux, state_aux, expl_id, fprocesscat_id, the_geom)
		SELECT DISTINCT t1.node_id, t1.nodecat_id, t1.state, t2.node_id, t2.nodecat_id, t2.state, t1.expl_id, 32, t1.the_geom
		FROM '||p_table_id||' AS t1 JOIN '||p_table_id||' AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom,'||p_tolerance||') 
		WHERE t1.node_id != t2.node_id 
		ORDER BY t1.node_id';

    DELETE FROM selector_audit WHERE fprocesscat_id=32 AND cur_user=current_user;    
	INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (32, current_user);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
