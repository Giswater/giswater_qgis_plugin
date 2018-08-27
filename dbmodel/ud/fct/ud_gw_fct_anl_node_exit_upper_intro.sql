/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2206


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_exit_upper_intro() RETURNS integer AS $BODY$

DECLARE
sys_elev1_var numeric(12,3);
sys_elev2_var numeric(12,3);
rec_node record;
rec_arc record;


BEGIN


    SET search_path = "SCHEMA_NAME", public;

    -- Reset values
    DELETE FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=11;


-- Init variables
	sys_elev1_var=0;
	sys_elev2_var=0;


    -- Comptuing process
	FOR rec_node IN SELECT * FROM v_edit_node
	LOOP
	
		FOR rec_arc IN SELECT * FROM v_edit_arc where node_1=rec_node.node_id
		LOOP
			sys_elev1_var=greatest(sys_elev1_var,rec_arc.sys_elev1);
		END LOOP;

		FOR rec_arc IN SELECT * FROM v_edit_arc where node_2=rec_node.node_id
		LOOP
			sys_elev2_var=greatest(sys_elev2_var,rec_arc.sys_elev2);
		END LOOP;
		
		IF sys_elev1_var > sys_elev2_var THEN
			INSERT INTO anl_node (node_id, expl_id, fprocesscat_id, the_geom) VALUES
			(rec_node.node_id, rec_node.expl_id, 11, rec_node.the_geom);
		END IF;
		
	END LOOP;
	
    DELETE FROM selector_audit WHERE fprocesscat_id=11 AND cur_user=current_user;	
	INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (11, current_user);

RETURN 1;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;