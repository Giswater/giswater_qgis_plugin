/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_plan_anl_topology(fprocesscat_id integer) RETURNS void AS $$
DECLARE


BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;


	
	--fprocesscat_id 20 (plan arc multi-sector)
	IF fprocesscat_id=20 THEN
	
		DELETE FROM anl_arc WHERE cur_user="current_user"() AND anl_arc.fprocesscat_id=20;
	
	
	--fprocesscat_id 21 (plan node multi-sector)
	ELSIF fprocesscat_id=21 THEN
		DELETE FROM anl_node WHERE cur_user="current_user"() AND anl_node.fprocesscat_id=21;

	
	--fprocesscat_id 22 (plan node duplicated)
	ELSIF fprocesscat_id=22 THEN
		DELETE FROM anl_node WHERE cur_user="current_user"() AND anl_node.fprocesscat_id=22;
		
		
	--fprocesscat_id 23 (plan node orphan)
	ELSIF fprocesscat_id=23 THEN
		DELETE FROM anl_node WHERE cur_user="current_user"() AND anl_node.fprocesscat_id=23;
		
		
	--fprocesscat_id 24 (plan arc no start-end node)
	ELSIF fprocesscat_id=24 THEN
		DELETE FROM anl_node WHERE cur_user="current_user"() AND anl_node.fprocesscat_id=24;
	
	
	END IF;
	
	
    RETURN;
        
END;
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 