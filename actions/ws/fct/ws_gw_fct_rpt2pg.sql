/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2322


DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_rpt2pg(character varying );
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_rpt2pg(result_id_var character varying)  RETURNS integer AS $BODY$
DECLARE
   
rec_var record;
      

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting rpt2pg process.';
	
	
	-- Reverse geometries where flow is negative and updating flow values with absolute value
	UPDATE rpt_inp_arc SET the_geom=st_reverse(the_geom) FROM rpt_arc WHERE rpt_arc.arc_id=rpt_inp_arc.arc_id AND flow<0 AND rpt_inp_arc.result_id=result_id_var;
	UPDATE rpt_arc SET flow=(-1)*flow WHERE flow<0 and result_id=result_id_var;
	
	
	

RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;