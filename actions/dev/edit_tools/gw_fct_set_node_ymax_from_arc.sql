/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "swmm_20180131".gw_fct_set_node_ymax_from_arc()  RETURNS void AS
$BODY$
DECLARE 
node_rec record;
arc_rec record;
ymax_var float;
z_var float;


    
BEGIN 

	set search_path='swmm_20180131', public;
	

	-- taking values

	FOR node_rec IN SELECT * FROM anl_node_ymax0_no_outfall JOIN node ON anl_node_ymax0_no_outfall.node_id=node.node_id
	LOOP
		ymax_var=0;
		FOR arc_rec IN SELECT * FROM arc where node_1=node_rec.node_id
		LOOP 
			IF ymax_var<arc_rec.z1 THEN
				ymax_var=arc_rec.z1;
			END IF;
		END LOOP;
		
		FOR arc_rec IN SELECT * FROM arc where node_2=node_rec.node_id
		LOOP 
			IF ymax_var<arc_rec.z2 THEN
				ymax_var=arc_rec.z2;
			END IF;
		END LOOP;

		UPDATE anl_node_ymax0_no_outfall SET ymax=ymax_var WHERE node_id=node_rec.node_id;

	END LOOP;
   
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

